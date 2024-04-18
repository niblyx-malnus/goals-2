import React, { useEffect, useState } from 'react';
import { FiX, FiAlertCircle, FiLoader, FiTrash2 } from 'react-icons/fi';
import api from '../../api';

const MembersTab = ({
  pid,
} : {
  pid: string,
}) => {
  const [members, setMembers] = useState<{ [key: string]: string }>({});
  const [refresh, setRefresh] = useState(true);
  const [isLoading, setIsLoading] = useState(false);
  const [editingRole, setEditingRole] = useState<{ [member: string]: string }>({});

  useEffect(() => {
    const fetch = async () => {
      setIsLoading(true);
      try {
        // Replace `api.getPoolPerms` with the actual API call to fetch permissions
        const members = await api.getPoolPerms(pid);
        setMembers(members);
      } catch (error) {
        console.error("Error fetching pool members:", error);
      } finally {
        setIsLoading(false);
      }
    };
    fetch();
  }, [pid, refresh]);

  const handleKickMember = async (member: string) => {
    const confirmation = window.confirm('Are you sure you want to proceed?');
    if (!confirmation) {
      return; // Early return if the action is not confirmed
    }
    try {
      // Assuming api.kickMember is a function that kicks a member from the pool
      await api.kickMember(pid, member);
      setRefresh(!refresh); // Refresh the list to reflect the change
    } catch (error) {
      console.error(`Error kicking member ${member}:`, error);
    }
  };

  const handleUpdateRole = async (member: string, newRole: string) => {
    try {
      await api.setPoolRole(pid, member, newRole);
      setRefresh(!refresh); // Trigger a refresh of the member list
      setEditingRole(prevState => {
        const newState = { ...prevState };
        delete newState[member];
        return newState;
      });
    } catch (error) {
      console.error(`Error updating role for member ${member}:`, error);
    }
  };

  const cancelUpdateRole = (member: string) => {
    setEditingRole(prevState => {
      const newState = { ...prevState };
      delete newState[member];
      return newState;
    });
  }

  return (
    <div>
      <div className="mb-4 overflow-auto" style={{ maxHeight: '60vh' }}>
        <div className="sticky top-0 bg-white py-2 grid grid-cols-[1fr_1fr_1fr]">
          <div className="font-semibold text-center">Member</div>
          <div className="font-semibold text-center">Role</div>
          <div className="font-semibold text-center"></div>
        </div>
        {isLoading ? (
          <div>Loading...</div>
        ) : Object.keys(members).length > 0 ? (
          Object.entries(members).map(([member, role], index) => (
            <div key={index} className="grid grid-cols-[1fr_1fr_auto_auto_auto] gap-4 items-center p-3 border-b">
              <div className="p-2 bg-gray-100 text-gray-700 text-center">{member}</div>
              {editingRole[member] ? (
                <select
                  value={editingRole[member]}
                  onChange={(e) => setEditingRole({ ...editingRole, [member]: e.target.value })}
                  className="p-2 bg-gray-100 text-gray-700 text-center"
                >
                  <option value="admin">admin</option>
                  <option value="creator">creator</option>
                  <option value="viewer">viewer</option>
                </select>
              ) : (
                <div className="p-2 bg-gray-100 text-gray-700 text-center">{role}</div>
              )}
              {editingRole[member] ? (
                <>
                  <button
                    onClick={() => handleUpdateRole(member, editingRole[member])}
                    className="px-2 py-1 text-sm text-white bg-blue-500 rounded hover:bg-blue-600 focus:outline-none"
                  >
                    Save
                  </button>
                  <button
                    onClick={() => cancelUpdateRole(member)}
                    className="px-2 py-1 text-sm text-gray-700 bg-gray-100 rounded hover:bg-gray-200 focus:outline-none"
                  >
                    <FiX />
                  </button>
                </>
              ) : (
                <button
                  onClick={() => setEditingRole({ ...editingRole, [member]: role })}
                  className="px-2 py-1 text-sm text-white bg-green-500 rounded hover:bg-green-600 focus:outline-none"
                >
                  Edit Role
                </button>
              )}
              <button
                onClick={() => handleKickMember(member)}
                className="px-2 py-1 text-sm text-white bg-red-500 rounded hover:bg-red-600 focus:outline-none"
              >
                Kick
              </button>
            </div>
          ))
        ) : (
          <div className="text-center py-4">No pool members.</div>
        )}
      </div>
    </div>
  );
}

interface Invite {
  invite: any;
  status: null | { response: boolean; metadata: any };
}

interface Invites {
  [invitee: string]: Invite;
}

const InvitesTab = ({
  pid,
} : {
  pid: string,
}) => {
  const [outgoingInvites, setOutgoingInvites] = useState<Invites>({}); 
  const [refresh, setRefresh] = useState(true);
  const [isLoading, setIsLoading] = useState(false);
  const [isInviting, setIsInviting] = useState(false);
  const [isCancelling, setIsCancelling] = useState<{ [key: string]: boolean }>({});
  const [invitee, setInvitee] = useState('');
  const [errorMessage, setErrorMessage] = useState('');
  const [activeTab, setActiveTab] = useState<'pending' | 'resolved'>('pending');

  useEffect(() => {
    const fetch = async () => {
      setIsLoading(true);
      try {
        const invites = await api.getOutgoingInvites(pid);
        console.log("outgoingInvites");
        console.log(invites);
        setOutgoingInvites(invites);
      } catch (error) {
        console.error("Error fetching outgoing invites:", error);
      } finally {
        setIsLoading(false);
      }
    };
    fetch();
  }, [pid, refresh]);

  const extendInvite = () => {
    return (
      <div className="mb-4">
        <div className="flex space-x-2 mt-2">
          <input
            type="text"
            placeholder="Enter name to invite"
            className="p-2 border rounded w-full"
            value={invitee}
            onChange={(e) => setInvitee(e.target.value)}
            disabled={isInviting} // Disable input during invite process
          />
          <button
            onClick={handleInvite}
            className={`p-2 text-white rounded ${isInviting ? 'bg-blue-300' : 'bg-blue-500'} relative`}
            disabled={isInviting} // Disable button during invite process
          >
            {isInviting ? (
              <FiLoader className="animate-spin h-5 w-5 mx-auto text-white" />
            ) : (
              'Invite'
            )}
          </button>
        </div>
        {errorMessage && (
          <div className="flex items-center justify-between bg-red-100 text-red-700 p-2 rounded mt-2">
            <div className="flex items-center">
              <FiAlertCircle className="mr-2" />
              {errorMessage}
            </div>
            <FiX className="cursor-pointer" onClick={() => setErrorMessage('')} />
          </div>
        )}
      </div>
    );
  }

  const handleInvite = async () => {
    setErrorMessage('');

    if (invitee.trim() === '') {
      setErrorMessage('Please enter a name to invite.'); // Set error message instead of using alert
      return;
    }
    setIsInviting(true);
    try {
      const response = await api.extendInvite(pid, invitee);
      if (response && response.error && response.error.type === 'invite-timeout') {
        setErrorMessage(`Inviting ${invitee} timed out after 30 seconds.`);
      } else {
        // Handle successful invitation case
        setInvitee('');
        setErrorMessage('');
      }
    } catch (error) {
      console.error("Error inviting to pool:", error);
      setErrorMessage('Failed to invite to the pool.'); // Set error message
    } finally {
      setRefresh(!refresh);
      setIsInviting(false);
    }
  };

  const handleCancelInvite = async (invitee: string) => {
    const confirmation = window.confirm(`Are you sure you want to cancel the invite for ${invitee}?`);
    if (!confirmation) {
      return; // Early return if not confirmed
    }
    setIsCancelling({ ...isCancelling, [invitee]: true });
    try {
      await api.cancelInvite(pid, invitee);
    } catch (error) {
      console.error(`Error cancelling invite for ${invitee}:`, error);
    } finally {
      setIsCancelling({ ...isCancelling, [invitee]: false });
      setRefresh(!refresh);
    }
  };

  const renderInvites = () => {
    const pendingInvites = Object.entries(outgoingInvites || {}).filter(
      ([_, invite]) => invite.status === null
    );

    const resolvedInvites = Object.entries(outgoingInvites || {}).filter(
      ([_, invite]) => invite.status !== null
    );

    const invitesToShow = activeTab === 'pending' ? pendingInvites : resolvedInvites;

    return invitesToShow.length > 0 ? (
      invitesToShow.map(([invitee, { status }], index) => (
        <div key={index} className="flex justify-between items-center p-3 bg-gray-100 rounded-lg mb-2">
          <span>{invitee}</span>
          <div className="flex items-center">
            {activeTab === 'pending' ? (
              <>
                <button
                  onClick={() => handleCancelInvite(invitee)}
                  className="px-2 py-1 text-sm text-white bg-red-500 rounded hover:bg-red-600 focus:outline-none"
                  disabled={isCancelling[invitee]}
                >
                  Cancel
                </button>
              </>
            ) : (
              <>
                <span className={`text-sm font-bold ${status?.response ? 'text-green-500' : 'text-red-500'}`}>
                  {status?.response ? 'Accepted' : 'Rejected'}
                </span>
                <button
                  onClick={() => handleCancelInvite(invitee)}
                  className="ml-2 text-red-500 hover:text-red-600"
                  disabled={isCancelling[invitee]}
                >
                  <FiTrash2 />
                </button>
              </>
            )}
          </div>
        </div>
      ))
    ) : (
      <div>No {activeTab} invites.</div>
    );
  };

  return (
    <div>
      <div className="mb-4">
        <nav className="flex space-x-4" aria-label="Tabs">
          <button
            className={`px-3 py-2 font-medium text-sm ${activeTab === 'pending' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
            onClick={() => setActiveTab('pending')}
          >
            Pending
          </button>
          <button
            className={`px-3 py-2 font-medium text-sm ${activeTab === 'resolved' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
            onClick={() => setActiveTab('resolved')}
          >
            Resolved
          </button>
        </nav>
      </div>                                                                                                                                                                
      {extendInvite()}
      {isLoading ? (
          <div>Loading...</div>
      ) : (
        renderInvites()
      )}
    </div>
  );
}

interface Request {
  invite: any;
  status: null | { response: boolean; metadata: any };
}

interface Requests {
  [requester: string]: Request;
}

const RequestsTab = ({
  pid,
} : {
  pid: string,
}) => {
  const [incomingRequests, setIncomingRequests] = useState<Requests>({});
  const [refresh, setRefresh] = useState(true);
  const [isLoading, setIsLoading] = useState(false);
  const [isDeleting, setIsDeleting] = useState<{ [key: string]: boolean }>({});
  const [errorMessage, setErrorMessage] = useState('');
  const [processingRequest, setProcessingRequest] = useState<{ [requester: string]: 'accepting' | 'rejecting' }>({});
  const [activeTab, setActiveTab] = useState<'pending' | 'resolved'>('pending');

  useEffect(() => {
    const fetch = async () => {
      setIsLoading(true);
      try {
        const requests = await api.getIncomingRequests(pid);
        console.log("incomingRequests");
        console.log(requests);
        setIncomingRequests(requests);
      } catch (error) {
        console.error("Error fetching incoming requests:", error);
      } finally {
       setIsLoading(false);
      }
    };

    fetch();
  }, [pid, refresh]);

  const handleAcceptRequest = async (requester: string) => {
    setProcessingRequest(prev => ({ ...prev, [requester]: 'accepting' }));
    try {
      await api.acceptRequest(pid, requester);
      setRefresh(!refresh);
    } catch (error) {
      console.error(`Error accepting request from ${requester}:`, error);
      setErrorMessage(`Failed to accept request from ${requester}.`);
    } finally {
      setProcessingRequest(prev => {
        const newState = { ...prev };
        delete newState[requester];
        return newState;
      });
    }
  };
  
  const handleRejectRequest = async (requester: string) => {
    setProcessingRequest(prev => ({ ...prev, [requester]: 'rejecting' }));
    try {
      await api.rejectRequest(pid, requester);
      setRefresh(!refresh);
    } catch (error) {
      console.error(`Error rejecting request from ${requester}:`, error);
      setErrorMessage(`Failed to reject request from ${requester}.`);
    } finally {
      setProcessingRequest(prev => {
        const newState = { ...prev };
        delete newState[requester];
        return newState;
      });
    }
  };

  const handleDeleteRequest = async (requester: string) => {
    const isConfirmed = window.confirm('Are you sure you want to delete this request?');
    if (isConfirmed) {
      setIsDeleting({ ...isDeleting, [requester]: true });
      try {
        await api.deleteRequest(pid, requester);
        setRefresh(!refresh);
        // Optionally refresh the list of invites here
      } catch (error) {
        console.error("Error deleting request:", error);
        setErrorMessage(`Failed to delete request for pool ${pid} from ${requester}.`);
      } finally {
        setIsDeleting({ ...isDeleting, [pid]: false });
      }
    }
  };

  const renderRequests = () => {
    const pendingRequests = Object.entries(incomingRequests || {}).filter(
      ([_, request]) => request.status === null
    );

    const resolvedRequests = Object.entries(incomingRequests || {}).filter(
      ([_, request]) => request.status !== null
    );

    const requestsToShow = activeTab === 'pending' ? pendingRequests : resolvedRequests;

    return requestsToShow.length > 0 ? (
      requestsToShow.map(([requester, { status }], index) => (
        <div key={index} className="flex justify-between items-center p-3 bg-gray-100 rounded-lg mb-2">
          <span>{requester}</span>
          {activeTab === 'pending' ? (
            <div className="flex items-center">
              <button
                onClick={() => handleAcceptRequest(requester)}
                disabled={requester in processingRequest}
                className="px-2 py-1 text-sm text-white bg-green-500 rounded hover:bg-green-600 focus:outline-none mr-2 cursor-pointer"
              >
                {processingRequest[requester] === 'accepting' ? <FiLoader className="animate-spin" /> : 'Accept'}
              </button>
              <button
                onClick={() => handleRejectRequest(requester)}
                disabled={requester in processingRequest}
                className="px-2 py-1 text-sm text-white bg-red-500 rounded hover:bg-red-600 focus:outline-none cursor-pointer"
              >
                {processingRequest[requester] === 'rejecting' ? <FiLoader className="animate-spin" /> : 'Reject'}
              </button>
            </div>
          ) : (
            <>
              <span className={`text-sm font-bold ${status?.response ? 'text-green-500' : 'text-red-500'}`}>
                {status?.response ? 'Accepted' : 'Rejected'}
              </span>
              <button
                onClick={() => handleDeleteRequest(requester)}
                className="ml-2 text-red-500 hover:text-red-600"
                disabled={isDeleting[pid]}
              >
                <FiTrash2 />
              </button>
            </>
          )}
        </div>
      ))
    ) : (
      <div>No {activeTab} requests.</div>
    );
  };

  return (
    <div>
      <div className="mb-4">
        <nav className="flex space-x-4" aria-label="Tabs">
          <button
            className={`px-3 py-2 font-medium text-sm ${activeTab === 'pending' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
            onClick={() => setActiveTab('pending')}
          >
            Pending
          </button>
          <button
            className={`px-3 py-2 font-medium text-sm ${activeTab === 'resolved' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
            onClick={() => setActiveTab('resolved')}
          >
            Resolved
          </button>
        </nav>
      </div>                                                                                                                                                                
      {isLoading ? (
        <div>Loading...</div>
        ) : ( renderRequests() )
      }
    </div>
  );
}

const ShipGraylist = ({
  pid
} : {
  pid: string
}) => {
  const [newShip, setNewShip] = useState<string>('');
  const [whitelist, setWhitelist] = useState<string[]>([]);
  const [blacklist, setBlacklist] = useState<string[]>([]);
  const [refresh, setRefresh] = useState(true);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');
  const [activeTab, setActiveTab] = useState<'whitelist' | 'blacklist'>('blacklist');

  useEffect(() => {
    const fetch = async () => {
      setIsLoading(true);
      try {
        const graylist = await api.getPoolGraylist(pid);
        console.log("graylist");
        console.log(graylist);
        setWhitelist(Object.keys(graylist.ship).filter((key) => graylist.ship[key].response === true));
        setBlacklist(Object.keys(graylist.ship).filter((key) => graylist.ship[key].response === false));
      } catch (error) {
        console.error("Error fetching graylist:", error);
      } finally {
       setIsLoading(false);
      }
    };
    fetch();
  }, [pid, refresh]);

  const handleAddShip = async (ship: string) => {
    try {
      if (activeTab === 'whitelist') {
        await api.whitelistShip(pid, ship);
      } else {
        await api.blacklistShip(pid, ship);
      }
      setRefresh(!refresh);
      setNewShip('');
    } catch (error) {
      console.error(`Error updating ship list:`, error);
      setErrorMessage(`Failed to ${activeTab} ship.`);
    }
  };

  const handleRemoveShip = async (ship: string) => {
    try {
      await api.unlistShip(pid, ship);
      setRefresh(!refresh);
    } catch (error) {
      console.error("Error removing ship from list:", error);
      setErrorMessage('Failed to remove ship.');
    }
  };

  return (
    <div>
      <div>
        <nav className="flex space-x-4" aria-label="Tabs">
          <button
            className={`px-3 py-2 font-medium text-sm ${activeTab === 'whitelist' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
            onClick={() => setActiveTab('whitelist')}
          >
            Whitelist
          </button>
          <button
            className={`px-3 py-2 font-medium text-sm ${activeTab === 'blacklist' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
            onClick={() => setActiveTab('blacklist')}
          >
            Blacklist
          </button>
        </nav>
      </div>                                                                                                                                                                
      {activeTab === 'whitelist' && (
        isLoading ? (
           <div>Loading...</div>
        ) : (
          <div>
            <div className="mb-2">
              <input
                type="text"
                placeholder="Enter ship name"
                value={newShip}
                onChange={(e) => setNewShip(e.target.value)}
                className="border p-2 rounded mr-2"
              />
              <button onClick={() => handleAddShip(newShip)} className="bg-blue-500 text-white p-2 rounded">
                Add to {activeTab}
              </button>
            </div>
            {whitelist.length === 0 ? (
              <p>No ships in the {activeTab}.</p>
            ) : (
              whitelist.map((ship) => (
                <div key={ship} className="flex justify-between items-center mb-2">
                  <span>{ship}</span>
                  <button onClick={() => handleRemoveShip(ship)} className="bg-red-500 text-white p-1 rounded">
                    Remove
                  </button>
                </div>
              ))
            )}
            {errorMessage && <p className="text-red-500 mt-2">{errorMessage}</p>}
          </div>
        )
      )}
      {activeTab === 'blacklist' && (
        isLoading ? (
           <div>Loading...</div>
        ) : (
          <div>
            <div className="mb-2">
              <input
                type="text"
                placeholder="Enter ship name"
                value={newShip}
                onChange={(e) => setNewShip(e.target.value)}
                className="border p-2 rounded mr-2"
              />
              <button onClick={() => handleAddShip(newShip)} className="bg-blue-500 text-white p-2 rounded">
                Add to {activeTab}
              </button>
            </div>
            {blacklist.length === 0 ? (
              <p>No ships in the {activeTab}.</p>
            ) : (
              blacklist.map((ship) => (
                <div key={ship} className="flex justify-between items-center mb-2">
                  <span>{ship}</span>
                  <button onClick={() => handleRemoveShip(ship)} className="bg-red-500 text-white p-1 rounded">
                    Remove
                  </button>
                </div>
              ))
            )}
            {errorMessage && <p className="text-red-500 mt-2">{errorMessage}</p>}
          </div>
        )
      )}
    </div>
  );
}

const RankGraylist = ({
  pid
} : {
  pid: string
}) => {
  const [newRank, setNewRank] = useState<string>('');
  const [whitelist, setWhitelist] = useState<string[]>([]);
  const [blacklist, setBlacklist] = useState<string[]>([]);
  const [refresh, setRefresh] = useState(true);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');
  const [activeTab, setActiveTab] = useState<'whitelist' | 'blacklist'>('blacklist');

  type rank = 'czar' | 'duke' | 'earl' | 'king' | 'pawn';

  const rankMapping = {
    czar: 'Galaxies',
    duke: 'Stars',
    earl: 'Planets',
    king: 'Moons',
    pawn: 'Comets',
  };

  useEffect(() => {
    const fetch = async () => {
      setIsLoading(true);
      try {
        const graylist = await api.getPoolGraylist(pid);
        setWhitelist(Object.keys(graylist.rank).filter((key) => graylist.rank[key].response === true));
        setBlacklist(Object.keys(graylist.rank).filter((key) => graylist.rank[key].response === false));
      } catch (error) {
        console.error("Error fetching graylist:", error);
      } finally {
       setIsLoading(false);
      }
    };
    fetch();
  }, [pid, refresh]);

  const handleAddRank = async (rank: string) => {
    try {
      if (activeTab === 'whitelist') {
        await api.whitelistRank(pid, rank);
      } else {
        await api.blacklistRank(pid, rank);
      }
      setRefresh(!refresh);
      setNewRank('');
    } catch (error) {
      console.error(`Error updating rank list:`, error);
      setErrorMessage(`Failed to ${activeTab} rank.`);
    }
  };

  const handleRemoveRank = async (rank: string) => {
    try {
      await api.unlistRank(pid, rank);
      setRefresh(!refresh);
    } catch (error) {
      console.error("Error removing rank from list:", error);
      setErrorMessage('Failed to remove rank.');
    }
  };

  return (
    <div>
      <div>
        <nav className="flex space-x-4" aria-label="Tabs">
          <button
            className={`px-3 py-2 font-medium text-sm ${activeTab === 'whitelist' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
            onClick={() => setActiveTab('whitelist')}
          >
            Whitelist
          </button>
          <button
            className={`px-3 py-2 font-medium text-sm ${activeTab === 'blacklist' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
            onClick={() => setActiveTab('blacklist')}
          >
            Blacklist
          </button>
        </nav>
      </div>                                                                                                                                                                
      {activeTab === 'whitelist' && (
        isLoading ? (
           <div>Loading...</div>
        ) : (
          <div>
            <div className="mb-2">
              <select
                value={newRank}
                onChange={(e) => setNewRank(e.target.value)}
                className="border p-2 rounded mr-2"
              >
                <option value="">Select Rank</option>
                <option value="czar">Galaxies</option>
                <option value="duke">Stars</option>
                <option value="earl">Planets</option>
                <option value="king">Moons</option>
                <option value="pawn">Comets</option>
              </select>
              <button onClick={() => handleAddRank(newRank)} className="bg-blue-500 text-white p-2 rounded">
                Add to {activeTab}
              </button>
            </div>  
            {whitelist.length === 0 ? (
              <p>No ranks in the {activeTab}.</p>
            ) : (
              whitelist.map((rank) => (
                <div key={rank} className="flex justify-between items-center mb-2">
                  <span>{rankMapping[rank as rank]}</span>
                  <button onClick={() => handleRemoveRank(rank)} className="bg-red-500 text-white p-1 rounded">
                    Remove
                  </button>
                </div>
              ))
            )}
            {errorMessage && <p className="text-red-500 mt-2">{errorMessage}</p>}
          </div>
        )
      )}
      {activeTab === 'blacklist' && (
        isLoading ? (
           <div>Loading...</div>
        ) : (
          <div>
            <div className="mb-2">
              <select
                value={newRank}
                onChange={(e) => setNewRank(e.target.value)}
                className="border p-2 rounded mr-2"
              >
                <option value="">Select Rank</option>
                <option value="czar">Galaxies</option>
                <option value="duke">Stars</option>
                <option value="earl">Planets</option>
                <option value="king">Moons</option>
                <option value="pawn">Comets</option>
              </select>
              <button onClick={() => handleAddRank(newRank)} className="bg-blue-500 text-white p-2 rounded">
                Add to {activeTab}
              </button>
            </div>  
            {blacklist.length === 0 ? (
              <p>No ranks in the {activeTab}.</p>
            ) : (
              blacklist.map((rank) => (
                <div key={rank} className="flex justify-between items-center mb-2">
                  <span>{rankMapping[rank as rank]}</span>
                  <button onClick={() => handleRemoveRank(rank)} className="bg-red-500 text-white p-1 rounded">
                    Remove
                  </button>
                </div>
              ))
            )}
            {errorMessage && <p className="text-red-500 mt-2">{errorMessage}</p>}
          </div>
        )
      )}
    </div>
  );
}

const GraylistTab = ({
  pid,
} : {
  pid: string,
}) => {
  const [poolType, setPoolType] = useState<'public' | 'private' | 'secret' | ''>('');
  const [refresh, setRefresh] = useState(true);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');
  const [activeTab, setActiveTab] = useState<'ship' | 'rank'>('ship');

  useEffect(() => {
    const fetch = async () => {
      setIsLoading(true);
      try {
        const graylist = await api.getPoolGraylist(pid);
        console.log("graylist");
        console.log(graylist);
        if (graylist.rest === null) {
          setPoolType('private');
        } if (graylist.rest.response) {
          setPoolType('public');
        } else {
          setPoolType('secret');
        }
      } catch (error) {
        console.error("Error fetching graylist:", error);
      } finally {
       setIsLoading(false);
      }
    };

    fetch();
  }, [pid, refresh]);

  const handlePoolTypeChange = async (newPoolType: 'public' | 'private' | 'secret') => {
    setIsLoading(true);
    try {
      if (newPoolType === 'public') {
        await api.setPoolPublic(pid);
      } else if (newPoolType === 'private') {
        await api.setPoolPrivate(pid);
      } else {
        await api.setPoolSecret(pid);
      }
      setPoolType(newPoolType);
      setRefresh(!refresh);
    } catch (error) {
      console.error("Error updating pool visibility:", error);
      setErrorMessage("Failed to update pool visibility.");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div>
      <div>
        <label>
          <input
            type="radio"
            name="poolType"
            className="mx-2"
            checked={poolType === 'public'}
            onChange={() => handlePoolTypeChange('public')}
          />
          Public
        </label>
        <label>
          <input
            type="radio"
            name="poolType"
            className="mx-2"
            checked={poolType === 'private'}
            onChange={() => handlePoolTypeChange('private')}
          />
          Private
        </label>
        <label>
          <input
            type="radio"
            name="poolType"
            className="mx-2"
            checked={poolType === 'secret'}
            onChange={() => handlePoolTypeChange('secret')}
          />
          Secret
        </label>
      </div>
      <div>
        <nav className="flex space-x-4" aria-label="Tabs">
          <button
            className={`px-3 py-2 font-medium text-sm ${activeTab === 'ship' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
            onClick={() => setActiveTab('ship')}
          >
            Ship
          </button>
          <button
            className={`px-3 py-2 font-medium text-sm ${activeTab === 'rank' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
            onClick={() => setActiveTab('rank')}
          >
            Rank
          </button>
        </nav>
      </div>                                                                                                                                                                
      {activeTab === 'ship' && (
        <ShipGraylist pid={pid} />
      )}
      {activeTab === 'rank' && (
        <RankGraylist pid={pid} />
      )}
    </div>
  );
}

const PoolUsersPanel = ({
  destination,
  pid,
  exit
} : {
  destination: string,
  pid: string,
  exit: () => void
}) => {
  const poolHost = pid.split('/')[1];
  const [isLoading, setIsLoading] = useState(false);
  const [yourRole, setYourRole] = useState('');
  const [activeTab, setActiveTab] = useState<'members' | 'invites' | 'requests' | 'graylist'>('members');

  useEffect(() => {
    const fetch = async () => {
      setIsLoading(true);
      try {
        // Replace `api.getPoolPerms` with the actual API call to fetch permissions
        const members = await api.getPoolPerms(pid);
        setYourRole(members['~' + destination]);
      } catch (error) {
        console.error("Error fetching pool members:", error);
      } finally {
        setIsLoading(false);
      }
    };
    fetch();
  }, [pid]);

  // Function to toggle active tab
  const handleTabClick = (tabName: 'members' | 'invites' | 'requests' | 'graylist') => {
    setActiveTab(tabName);
  };

  const handleLeavePool = async () => {
    const isConfirmed = window.confirm('Are you sure you want to leave this pool?');
    if (isConfirmed) {
      try {
        await api.leavePool(pid);
        // Post-leave logic here, e.g., refresh or navigate
      } catch (error) {
        console.error("Error leaving pool:", error);
        // Optionally, handle error feedback
      }
    }
  };

  return (
    <div className="z-10 fixed inset-0 bg-black bg-opacity-30 backdrop-blur-sm flex justify-center items-center p-4">
      <div className="bg-white shadow rounded-lg w-full max-w-md mx-auto overflow-hidden">
        <div className="flex justify-between items-center border-b p-4">
          <h2 className="text-lg font-semibold">Pool Membership and Permissions</h2>
          <button onClick={exit} className="text-gray-400 hover:text-gray-600">
            <FiX />
          </button>
        </div>
        <div className="p-4">
          <div className="my-4">
            <button
              onClick={handleLeavePool}
              className="px-4 py-2 text-sm text-white bg-blue-600 hover:bg-blue-700 rounded mr-2"
            >
              Leave Pool
            </button>
          </div>
          <div className="mb-4 flex justify-between items-center">
            <h3 className="text-md font-semibold">Pool Host:</h3>
            <div className="p-2 bg-blue-100 text-blue-500 rounded">
              {poolHost}
            </div>
          </div>
          <div className="mb-4 flex justify-between items-center">
            <h3 className="text-md font-semibold">Your Pool Role:</h3>
            <div className="p-2 bg-green-100 text-green-500 rounded">
              {yourRole || 'Fetching...'}
            </div>
          </div>
          <div className="border-b mb-4 overflow-x-auto">
            <nav className="flex space-x-1 sm:space-x-4 whitespace-nowrap py-2" aria-label="Tabs">
              <button
                className={`px-2 sm:px-3 py-2 font-medium text-sm ${activeTab === 'members' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'} rounded-t-lg`}
                onClick={() => handleTabClick('members')}
              >
                Members
              </button>
              <button
                className={`px-2 sm:px-3 py-2 font-medium text-sm ${activeTab === 'invites' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'} rounded-t-lg`}
                onClick={() => handleTabClick('invites')}
              >
                Invites
              </button>
              <button
                className={`px-2 sm:px-3 py-2 font-medium text-sm ${activeTab === 'requests' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'} rounded-t-lg`}
                onClick={() => handleTabClick('requests')}
              >
                Requests
              </button>
              <button
                className={`px-2 sm:px-3 py-2 font-medium text-sm ${activeTab === 'graylist' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'} rounded-t-lg`}
                onClick={() => handleTabClick('graylist')}
              >
                Graylist
              </button>
            </nav>
          </div>

          {activeTab === 'members' && (
            <MembersTab pid={pid}/>
          )}
          {activeTab === 'invites' && (
            <InvitesTab pid={pid}/>
          )}
          {activeTab === 'requests' && (
            <RequestsTab pid={pid}/>
          )}
          {activeTab === 'graylist' && (
            <GraylistTab pid={pid}/>
          )}
        </div>
      </div>
    </div>
  );
};

export default PoolUsersPanel;
