import React, { useEffect, useState, useRef } from 'react';
import { FiX, FiLoader, FiTrash2, FiAlertCircle } from 'react-icons/fi';
import { Pool } from '../../types';
import api from '../../api'; // Ensure this path matches your API utility file

interface Invite {
  invite: any;
  status: null | { response: boolean; metadata: any };
}

interface Invites {
  [pid: string]: Invite;
}

const InvitesTab = () => {
  const [incomingInvites, setIncomingInvites] = useState<Invites>({});
  const [activeTab, setActiveTab] = useState<'pending' | 'resolved'>('pending');
  const [isLoading, setIsLoading] = useState(true);
  const [isDeleting, setIsDeleting] = useState<{ [key: string]: boolean }>({});
  const [processingInvites, setProcessingInvites] = useState<{ [key: string]: boolean }>({});
  const [errorMessage, setErrorMessage] = useState('');
  const [refresh, setRefresh] = useState(true);

  useEffect(() => {
    setIsLoading(true);
    const fetch = async () => {
      try {
        const invites = await api.getIncomingInvites();
        console.log("incoming invites");
        console.log(invites);
        setIncomingInvites(invites);
      } catch (error) {
        console.error("Error fetching incoming invites:", error);
        setErrorMessage("Failed to fetch incoming invites.");
      } finally {
        setIsLoading(false);
      }
    };
    fetch();
  }, [refresh]);

  const handleAcceptInvite = async (pid: string) => {
    setProcessingInvites({ ...processingInvites, [pid]: true });
    try {
      await api.acceptInvite(pid);
      setProcessingInvites({ ...processingInvites, [pid]: false });
      setRefresh(!refresh);
      // Optionally refresh the list of invites here
    } catch (error) {
      console.error("Error accepting invite:", error);
      setErrorMessage(`Failed to accept invite for pool ${pid}.`);
      setProcessingInvites({ ...processingInvites, [pid]: false });
    }
  };

  const handleRejectInvite = async (pid: string) => {
    setProcessingInvites({ ...processingInvites, [pid]: true });
    try {
      await api.rejectInvite(pid);
      setProcessingInvites({ ...processingInvites, [pid]: false });
      setRefresh(!refresh);
      // Optionally refresh the list of invites here
    } catch (error) {
      console.error("Error rejecting invite:", error);
      setErrorMessage(`Failed to reject invite for pool ${pid}.`);
      setProcessingInvites({ ...processingInvites, [pid]: false });
    }
  };

  const handleDeleteInvite = async (pid: string) => {
    const isConfirmed = window.confirm('Are you sure you want to delete this invite?');
    if (isConfirmed) {
      setIsDeleting({ ...isDeleting, [pid]: true });
      try {
        await api.deleteInvite(pid);
        setRefresh(!refresh);
        // Optionally refresh the list of invites here
      } catch (error) {
        console.error("Error deleting invite:", error);
        setErrorMessage(`Failed to delete invite for pool ${pid}.`);
      } finally {
        setIsDeleting({ ...isDeleting, [pid]: false });
      }
    }
  };

  const renderInviteActionButtons = (pid: string) => (
    <div className="flex space-x-2">
      <button
        onClick={() => handleAcceptInvite(pid)}
        disabled={processingInvites[pid]}
        className="px-2 py-1 text-sm text-white bg-green-500 rounded hover:bg-green-600 focus:outline-none"
      >
        Accept
      </button>
      <button
        onClick={() => handleRejectInvite(pid)}
        disabled={processingInvites[pid]}
        className="px-2 py-1 text-sm text-white bg-red-500 rounded hover:bg-red-600 focus:outline-none"
      >
        Reject
      </button>
    </div>
  );

  const renderInvites = () => {
    // Filter invites based on the activeTab
    const filteredInvites = Object.entries(incomingInvites).filter(([_, invite]) =>
      activeTab === 'pending' ? invite.status === null : invite.status !== null
    );
  
    return filteredInvites.length > 0 ? (
        filteredInvites.map(([pid, invite]) => (
          <div key={pid} className="flex justify-between items-center p-3 bg-gray-100 rounded-lg mb-2">
            <div>
              <p className="text-sm font-bold">{invite.invite.title}</p>
              <p className="px-2 text-xs text-gray-600">From: {invite.invite.from}</p>
            </div>
            {activeTab === 'pending' ? (
              renderInviteActionButtons(pid)
            ) : (
              <>
                <span className={`text-sm font-bold ${invite.status?.response ? 'text-green-500' : 'text-red-500'}`}>
                {invite.status?.response ? 'Accepted' : 'Rejected'}
                </span>
                <button
                  onClick={() => handleDeleteInvite(pid)}
                  className="ml-2 text-red-500 hover:text-red-600"
                  disabled={isDeleting[pid]}
                >
                  <FiTrash2 />
                </button>
              </>
            )}
          </div>
        ))) : (
        <div>No pending invites.</div>
      );
  };

  return (
    <div className="px-4 pt-5 pb-4 bg-white sm:p-6 sm:pb-4">
      <div className="sm:flex sm:items-start">
        <div className="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left w-full">
          <h3 className="text-lg font-medium leading-6 text-gray-900" id="modal-headline">
            Incoming Pool Invites
          </h3>
          <div className="mt-2">
            {errorMessage && (
              <div className="p-2 mb-4 text-sm text-red-700 bg-red-100 rounded-lg">
                <FiAlertCircle className="inline mr-2 text-lg"/> {errorMessage}
              </div>
            )}
            <div className="my-5">
              <div className="mb-2">
                <button
                  className={`px-4 py-2 font-bold text-white rounded ${activeTab === 'pending' ? 'bg-blue-700' : 'bg-blue-200'}`}
                  onClick={() => setActiveTab('pending')}
                >
                  Pending
                </button>
                <button
                  className={`px-4 py-2 ml-2 font-bold text-white rounded ${activeTab === 'resolved' ? 'bg-green-700' : 'bg-green-200'}`}
                  onClick={() => setActiveTab('resolved')}
                >
                  Resolved
                </button>
              </div>
              {isLoading ? (
                <div className="flex justify-center">
                  <FiLoader className="text-4xl text-blue-500 animate-spin"/>
                </div>
              ) : renderInvites()}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

interface Request {
  request: any;
  status: null | { response: boolean; metadata: any };
}

interface Requests {
  [pid: string]: Request;
}

const RequestsTab = () => {
  const [outgoingRequests, setOutgoingRequests] = useState<Requests>({});
  const [activeTab, setActiveTab] = useState<'pending' | 'resolved'>('pending');
  const [isLoading, setIsLoading] = useState(true);
  const [isRequesting, setIsRequesting] = useState(false);
  const [isCancelling, setIsCancelling] = useState<{ [key: string]: boolean }>({});
  const [poolToRequest, setPoolToRequest] = useState('');
  const [errorMessage, setErrorMessage] = useState('');
  const [refresh, setRefresh] = useState(true);

  useEffect(() => {
    const fetch = async () => {
      setIsLoading(true);
      try {
        const requests = await api.getOutgoingRequests();
        console.log("outgoing requests");
        console.log(requests);
        setOutgoingRequests(requests);
      } catch (error) {
        console.error("Error fetching outgoing requests:", error);
        setErrorMessage("Failed to fetch outgoing requests.");
      } finally {
        setIsLoading(false);
      }
    };
    fetch();
  }, [refresh]);

  const handleExtendRequest = async () => {
    setIsRequesting(true);
    try {
      await api.extendRequest(poolToRequest);
      console.log('Requesting to join pool:', poolToRequest);
      setPoolToRequest('');
    } catch (error) {
      console.error("Error requesting to join pool:", error);
      setErrorMessage('Failed to request to join the pool. Please try again.');
    } finally {
      setRefresh(!refresh);
      setIsRequesting(false);
    }
  };

  const handleCancelRequest = async (pid: string) => {
    const confirmation = window.confirm(`Are you sure you want to cancel the request for ${pid}?`);
    if (!confirmation) {
      return;
    }
    setIsCancelling({ ...isCancelling, [pid]: true });
    try {
      await api.cancelRequest(pid);
    } catch (error) {
      console.error(`Error cancelling request for ${pid}:`, error);
    } finally {
      setIsCancelling({ ...isCancelling, [pid]: false });
      setRefresh(!refresh);
    }
  };

  const renderRequests = () => {
    const pendingRequests = Object.entries(outgoingRequests || {}).filter(
      ([_, request]) => request.status === null
    );

    const resolvedRequests = Object.entries(outgoingRequests || {}).filter(
      ([_, request]) => request.status !== null
    );

    const requestsToShow = activeTab === 'pending' ? pendingRequests : resolvedRequests;

    return requestsToShow.length > 0 ? (
      requestsToShow.map(([pid, { status }], index) => (
        <div key={index} className="flex justify-between items-center p-3 bg-gray-100 rounded-lg mb-2">
          <span>{pid}</span>
          <div className="flex items-center">
            {activeTab === 'pending' ? (
              <>
                <button
                  onClick={() => handleCancelRequest(pid)}
                  className="px-2 py-1 text-sm text-white bg-red-500 rounded hover:bg-red-600 focus:outline-none"
                  disabled={isCancelling[pid]}
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
                  onClick={() => handleCancelRequest(pid)}
                  className="ml-2 text-red-500 hover:text-red-600"
                  disabled={isCancelling[pid]}
                >
                  <FiTrash2 />
                </button>
              </>
            )}
          </div>
        </div>
      ))
    ) : (
      <div>No {activeTab} requests.</div>
    );
  };

  return (
    <div>
      <div className="mb-4 mx-4">
        <div className="my-5">
          <div className="mb-2">
            <button
              className={`px-4 py-2 font-bold text-white rounded ${activeTab === 'pending' ? 'bg-blue-700' : 'bg-blue-200'}`}
              onClick={() => setActiveTab('pending')}
            >
              Pending
            </button>
            <button
              className={`px-4 py-2 ml-2 font-bold text-white rounded ${activeTab === 'resolved' ? 'bg-green-700' : 'bg-green-200'}`}
              onClick={() => setActiveTab('resolved')}
            >
              Resolved
            </button>
          </div>
        </div>
        <div className="flex space-x-2 mt-2">
          <input
            type="text"
            placeholder="Enter a pool id to request to join..."
            className="p-2 border rounded w-full"
            value={poolToRequest}
            onChange={(e) => setPoolToRequest(e.target.value)}
            disabled={isRequesting} // Disable input during invite process
          />
          <button
            onClick={handleExtendRequest}
            className={`p-2 text-white rounded ${isRequesting ? 'bg-blue-300' : 'bg-blue-500'} relative`}
            disabled={isRequesting} // Disable button during invite process
          >
            {isRequesting ? (
              <FiLoader className="animate-spin h-5 w-5 mx-auto text-white" />
            ) : (
              'Request'
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
      {isLoading ? (
        <div className="flex justify-center">
          <FiLoader className="text-4xl text-blue-500 animate-spin"/>
        </div>
      ) : renderRequests()}
    </div>
  );
}

const BlockedTab = () => {
  const [blockedHosts, setBlockedHosts] = useState<string[]>([]);
  const [blockedPools, setBlockedPools] = useState<string[]>([]);
  const [activeTab, setActiveTab] = useState<'hosts' | 'pools'>('hosts');
  const [isLoading, setIsLoading] = useState(true);
  const [errorMessage, setErrorMessage] = useState('');
  const [refresh, setRefresh] = useState(true);
  const [blockId, setBlockId] = useState('');
  const [isBlocking, setIsBlocking] = useState(false);

  useEffect(() => {
    const fetch = async () => {
      setIsLoading(true);
      try {
        const blocked = await api.getLocalBlocked();
        console.log("blocked");
        console.log(blocked);
        setBlockedHosts(blocked.hosts);
        setBlockedPools(blocked.pools);
      } catch (error) {
        console.error("Error fetching blocked info:", error);
        setErrorMessage("Failed to fetch blocked info.");
      } finally {
        setIsLoading(false);
      }
    };
    fetch();
  }, [refresh]);

  const handleBlock = async () => {
    setIsBlocking(true);
    try {
      if (activeTab === 'hosts') {
        await api.blockHost(blockId);
        setBlockedHosts([...blockedHosts, blockId]);
      } else {
        await api.blockPool(blockId);
        setBlockedPools([...blockedPools, blockId]);
      }
      setBlockId(''); // Clear the input field
    } catch (error) {
      console.error(`Error blocking ${activeTab === 'hosts' ? 'host' : 'pool'}:`, error);
      setErrorMessage(`Failed to block ${activeTab === 'hosts' ? 'host' : 'pool'}.`);
    } finally {
      setIsBlocking(false);
      setRefresh(!refresh);
    }
  };

  const handleUnblock = async (id: string) => {
    const type = activeTab === 'hosts' ? 'host' : 'pool';
    try {
      // Assuming the API provides methods to unblock hosts and pools
      if (type === 'host') {
        await api.unblockHost(id);
        setBlockedHosts(blockedHosts.filter(host => host !== id));
      } else {
        await api.unblockPool(id);
        setBlockedPools(blockedPools.filter(pool => pool !== id));
      }
    } catch (error) {
      console.error(`Error unblocking ${type}:`, error);
      setErrorMessage(`Failed to unblock ${type}.`);
    } finally {
      setRefresh(!refresh);
    }
  };

  const renderBlockedItems = () => {
    const items = activeTab === 'hosts' ? blockedHosts : blockedPools;
    if (items.length === 0) {
      return <div>No blocked {activeTab}.</div>;
    }

    return items.map((item, index) => (
      <div key={index} className="flex justify-between items-center p-3 bg-gray-100 rounded-lg mb-2">
        <span>{item}</span>
        <button
          onClick={() => handleUnblock(item)}
          className="px-2 py-1 text-sm text-white bg-red-500 rounded hover:bg-red-600 focus:outline-none"
        >
          Unblock
        </button>
      </div>
    ));
  };

  return (
    <div className="my-4 mx-4">
      <div className="mb-4 flex justify-center">
        <button
          className={`px-4 py-2 font-bold text-white rounded ${activeTab === 'hosts' ? 'bg-blue-700' : 'bg-blue-200'}`}
          onClick={() => setActiveTab('hosts')}
        >
          Hosts
        </button>
        <button
          className={`px-4 py-2 ml-2 font-bold text-white rounded ${activeTab === 'pools' ? 'bg-green-700' : 'bg-green-200'}`}
          onClick={() => setActiveTab('pools')}
        >
          Pools
        </button>
      </div>
      <div className="flex space-x-2 my-4">
        <input
          type="text"
          placeholder={`Enter ${activeTab === 'hosts' ? 'host' : 'pool'} ID to block`}
          className="flex-grow p-2 border rounded"
          value={blockId}
          onChange={(e) => setBlockId(e.target.value)}
          disabled={isBlocking}
        />
        <button
          onClick={handleBlock}
          className={`px-4 py-2 text-white bg-red-600 rounded hover:bg-red-700 ${isBlocking ? 'opacity-50 cursor-not-allowed' : ''}`}
          disabled={isBlocking}
        >
          Block
        </button>
      </div>
      {isLoading ? (
        <div className="flex justify-center">
          <FiLoader className="text-4xl text-blue-500 animate-spin"/>
        </div>
      ) : (
        <div>
          {errorMessage && (
            <div className="flex items-center justify-between bg-red-100 text-red-700 p-2 rounded mt-2">
              <div className="flex items-center">
                <FiAlertCircle className="mr-2" />
                {errorMessage}
              </div>
              <FiX className="cursor-pointer" onClick={() => setErrorMessage('')} />
            </div>
          )}
          {renderBlockedItems()}
        </div>
      )}
    </div>
  );
}

const DiscoverTab = () => {
  const [activeTab, setActiveTab] = useState<'pals' | 'search'>('pals');
  const [isShipSearching, setIsShipSearching] = useState(false);
  const [isPalsSearching, setIsPalsSearching] = useState<{ [target: string]: boolean }>({});
  const [isRequesting, setIsRequesting] = useState<{ [pid: string]: boolean }>({});
  const [shipPools, setShipPools] = useState<{ [pid: string]: Pool }>({});
  const [palsPools, setPalsPools] = useState<{ [target: string]: { pools: Pool[] | null, error: boolean } }>({});
  const [shipToSearch, setShipToSearch] = useState('');
  const [searchedShip, setSearchedShip] = useState('');
  const [errorMessage, setErrorMessage] = useState('');

  useEffect(() => {
    const fetch = async () => {
      try {
        const targets: string[] = await api.palsTargets();
        if (targets.length === 0) {
          return;
        }

        // Initialize state for each target
        setPalsPools(targets.reduce((acc, target) => {
          acc[target] = { pools: [], error: false };
          return acc;
        }, {} as { [target: string]: { pools: Pool[] | null, error: boolean } }));

        targets.forEach(async (target: string) => {
          setIsPalsSearching(prev => ({ ...prev, [target]: true }));
          try {
            const pools: Pool[] = await api.discover(target.substring(1));
            setPalsPools(prev => ({
              ...prev,
              [target]: { pools: pools, error: false }
            }));
          } catch (error) {
            console.error(`Error discovering pools for target ${target}:`, error);
            setPalsPools(prev => ({
              ...prev,
              [target]: { pools: null, error: true }
            }));
          } finally {
            setIsPalsSearching(prev => ({ ...prev, [target]: false }));
          }
        });
      } catch (error) {
        console.error("Error fetching pals targets:", error);
      }
    };

    fetch();
  }, []);

  const sortedTargets = Object.keys(palsPools).sort();

  const handleShipSearch = async () => {
    setIsShipSearching(true);
    try {
      const pools = await api.discover(shipToSearch);
      console.log("ship pools");
      console.log(pools);
      setShipPools(pools);
      console.log('Discovering pools from:', shipToSearch);
      setSearchedShip(shipToSearch);
    } catch (error) {
      console.error("Error discovering pools from:", error);
      setErrorMessage('Failed to discover pools. Please try again.');
    } finally {
      setIsShipSearching(false);
      setShipToSearch('');
    }
  };

  const handleExtendRequest = async (pid: string) => {
    setIsRequesting(prev => ({ ...prev, [pid]: true }));
    try {
      await api.extendRequest(pid);
      console.log('Requesting to join pool:', pid);
    } catch (error) {
      console.error("Error requesting to join pool:", error);
      setErrorMessage('Failed to request to join the pool. Please try again.');
    } finally {
      setIsRequesting(prev => ({ ...prev, [pid]: false }));
    }
  };

  const renderSearchResults = () => {
    return (
      !searchedShip ? (
       <div>Enter a ship name to begin your search.</div>
      ) : (
      <div>
        <h3 className="text-lg leading-6 font-medium text-gray-900">Pools From:</h3>
        <h3 className="text-lg leading-6 font-medium text-gray-900">{searchedShip}</h3>
        {(Object.keys(shipPools).length > 0) ? (
            <div>
              <ul>
              {Object.keys(shipPools).map((pid, index) => (
                  <li key={pid} className="text-gray-700 py-1 flex justify-between items-center">
                  {shipPools[pid].title}
                  {!shipPools[pid].requested && (
                    <button
                      className="ml-4 px-2 py-1 bg-blue-500 text-white rounded hover:bg-blue-600"
                      onClick={() => handleExtendRequest(pid)}
                    >
                      Request
                    </button>
                  )}
                </li>
              ))}
              </ul>
            </div>
        ) : (
          <div>No pools found.</div>
        )}
      </div>
    ));
  };

  const renderPools = () => {
    return (
      <div className="my-4 mx-4">
        <h4 className="text-lg leading-6 font-medium text-gray-900">Pals' Pools:</h4>
        {sortedTargets.length === 0 ? (
              <div>No pals found.</div>
        ) : sortedTargets.map(target => (
          <div key={target}>
            <h5 className="font-bold">{target}</h5>
            {isPalsSearching[target] ? (
              <div className="flex justify-center">
                <FiLoader className="animate-spin h-5 w-5 text-blue-500" />
              </div>
            ) : palsPools[target].error ? (
              <p className="text-red-500"><FiAlertCircle className="inline mr-2" />Failed to discover pools.</p>
            ) : palsPools[target].pools && (palsPools[target].pools as Pool[]).length > 0 ? (
              <ul>
                {palsPools[target].pools ? palsPools[target].pools?.map(pool => (
                  <li key={pool.pid} className="text-gray-700 py-1 flex justify-between items-center">
                      {pool.title}
                      {!pool.requested && (
                        <button
                          className="ml-4 px-2 py-1 bg-blue-500 text-white rounded hover:bg-blue-600"
                          onClick={() => handleExtendRequest(pool.pid)}
                        >
                          Request
                        </button>
                      )}
                    </li>
                )) : <p className="text-gray-500">Loading...</p>}
              </ul>
            ) : (
              <div>No pools found.</div>
            )}
          </div>
        ))}
      </div>
    );
  };
  
  return (
    <div className="my-4 mx-4">
      <div className="mb-4 flex justify-center">
        <button
          className={`px-4 py-2 font-bold text-white rounded ${activeTab === 'pals' ? 'bg-blue-700' : 'bg-blue-200'}`}
          onClick={() => setActiveTab('pals')}
        >
          Pals
        </button>
        <button
          className={`px-4 py-2 ml-2 font-bold text-white rounded ${activeTab === 'search' ? 'bg-green-700' : 'bg-green-200'}`}
          onClick={() => setActiveTab('search')}
        >
          Search
        </button>
      </div>
      {activeTab === 'pals' && (
        <div>
          {renderPools()}
        </div>
      )}
      {activeTab === 'search' && (
        <div>
          <div className="flex space-x-2 mt-2">
            <input
              type="text"
              placeholder="Enter a ship name to search..."
              className="p-2 border rounded w-full"
              value={shipToSearch}
              onChange={(e) => setShipToSearch(e.target.value)}
              disabled={isShipSearching} // Disable input during invite process
            />
            <button
              onClick={handleShipSearch}
              className={`p-2 text-white rounded ${isShipSearching ? 'bg-blue-300' : 'bg-blue-500'} relative`}
              disabled={isShipSearching} // Disable button during invite process
            >
              {isShipSearching ? (
                <FiLoader className="animate-spin h-5 w-5 mx-auto text-white" />
              ) : (
                'Search'
              )}
            </button>
          </div>
          {renderSearchResults()}
        </div>
      )}
      {errorMessage && <div className="error text-red-500">{errorMessage}</div>}
    </div>
  );
}

const LocalMembershipPanel = ({
  exit,
} : {
  exit: () => void,
}) => {
  const [activeTab, setActiveTab] = useState<'invites' | 'requests' | 'blocked' | 'discover'>('invites');

  const handleTabClick = (tabName: 'invites' | 'requests' | 'blocked' | 'discover') => {
    setActiveTab(tabName);
  };

  return (
    <div className="fixed inset-0 z-10 overflow-y-auto">
      <div className="flex items-end justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0">
        <div className="fixed inset-0 transition-opacity">
          <div className="absolute inset-0 bg-gray-500 opacity-75"></div>
        </div>
        <span className="hidden sm:inline-block sm:align-middle sm:h-screen">&#8203;</span>
        <div className="inline-block overflow-hidden text-left align-bottom transition-all transform bg-white rounded-lg shadow-xl sm:my-8 sm:align-middle sm:max-w-lg sm:w-full" role="dialog" aria-modal="true" aria-labelledby="modal-headline">
          <div className="border-b mb-4">
            <nav className="flex space-x-4" aria-label="Tabs">
              <button
                className={`px-3 py-2 font-medium text-sm ${activeTab === 'invites' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
                onClick={() => handleTabClick('invites')}
              >
                Invites
              </button>
              <button
                className={`px-3 py-2 font-medium text-sm ${activeTab === 'requests' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
                onClick={() => handleTabClick('requests')}
              >
                Requests
              </button>
              <button
                className={`px-3 py-2 font-medium text-sm ${activeTab === 'blocked' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
                onClick={() => handleTabClick('blocked')}
              >
                Blocked
              </button>
              <button
                className={`px-3 py-2 font-medium text-sm ${activeTab === 'discover' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
                onClick={() => handleTabClick('discover')}
              >
                Discover
              </button>
            </nav>
          </div>
          {activeTab === 'invites' && (
            <InvitesTab/>
          )}
          {activeTab === 'requests' && (
            <RequestsTab/>
          )}
          {activeTab === 'blocked' && (
            <BlockedTab/>
          )}
          {activeTab === 'discover' && (
            <DiscoverTab/>
          )}
          <div className="px-4 py-3 bg-gray-50 sm:px-6 sm:flex sm:flex-row-reverse">
            <button onClick={exit} className="w-full px-4 py-2 mt-3 font-medium text-white bg-red-600 rounded-md shadow-sm hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
              Close
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LocalMembershipPanel;