import React, { useState, useEffect } from 'react';
import useStore from '../store';
import MarkdownEditor from './MarkdownEditor';
import ArchiveGoalList from './ArchiveGoalList';
import RestorePanel from './Panels/RestorePanel';
import ArchiveInfoPanel from './Panels/ArchiveInfoPanel';
import TagSearchBar from './TagSearchBar';
import api from '../api';
import { FiInfo, FiCopy, FiRotateCcw, FiTrash } from 'react-icons/fi';
import { FaListUl } from 'react-icons/fa';
import useCustomNavigation from './useCustomNavigation';
import { Goal } from '../types';
import { goalKeyToPidGid } from '../utils';

function Subgoals({ goal, rid }: { goal: Goal, rid: string }) {
  const { pid, gid } = goalKeyToPidGid(goal.key);

  const [refreshChildren, setRefreshChildren] = useState(false);
  const [refreshBorrowed, setRefreshBorrowed] = useState(false);
  const [children, setChildren] = useState<Goal[]>([]);
  const [borrowed, setBorrowed] = useState<Goal[]>([]);
  const [childrenLoading, setChildrenLoading] = useState(true);
  const [borrowedLoading, setBorrowedLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<'Owned' | 'Borrowed'>('Owned');

  useEffect(() => {
    const fetchChildren = async () => {
      try {
        setChildrenLoading(true);
        const fetchedChildren = await api.getArchiveGoalChildren(pid, rid, gid);
        setChildren(fetchedChildren);
        setChildrenLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchChildren();
  }, [gid, rid, pid, refreshChildren]);

  useEffect(() => {
    const fetchBorrowed = async () => {
      try {
        setBorrowedLoading(true);
        const fetchedBorrowed = await api.getArchiveGoalBorrowed(pid, rid, gid);
        setBorrowed(fetchedBorrowed);
        setBorrowedLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchBorrowed();
  }, [gid, rid, pid, refreshBorrowed]);

  const triggerRefreshChildren = () => {
    setRefreshChildren(!refreshChildren);
  };

  const triggerRefreshBorrowed = () => {
    setRefreshBorrowed(!refreshBorrowed);
  };

  return (
    <div>
      <div className="border-b">
        <ul className="flex justify-center -mb-px">
          <li className={`${activeTab === 'Owned' ? 'border-blue-500' : ''}`}>
            <button 
              className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                activeTab === 'Owned' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
              }`} 
              onClick={() => setActiveTab('Owned')}
            >
              Owned
            </button>
          </li>
          <li className={`${activeTab === 'Borrowed' ? 'border-blue-500' : ''}`}>
            <button 
              className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                activeTab === 'Borrowed' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
              }`} 
              onClick={() => setActiveTab('Borrowed')}
            >
              Borrowed
            </button>
          </li>
        </ul>
      </div>
      { activeTab === 'Owned' && (
        <div>
          <div className="text-center mt-2 text-lg text-gray-600">
            Sub-goals which are owned and managed by this goal.
          </div>
          <ArchiveGoalList
            rid={rid}
            goals={children}
            isLoading={childrenLoading}
            completeTab={true}
            defaultCompleteTab={goal.complete ? 'Complete' : 'Incomplete'}
            refresh={triggerRefreshChildren}
          />
        </div>
      )}
      { activeTab === 'Borrowed' && (
        <div>
          <div className="text-center mt-2 text-lg text-gray-600">
            Sub-goals of other goals which could also be considered sub-goals of this goal.
          </div>
          <ArchiveGoalList
            rid={rid}
            goals={borrowed}
            isLoading={borrowedLoading}
            completeTab={true}
            refresh={triggerRefreshBorrowed}
          />
        </div>
      )}
    </div>
  );
}

function Archive({ goal, rid }: { goal: Goal, rid: string }) {
  const { pid, gid } = goalKeyToPidGid(goal.key);

  const [refresh, setRefresh] = useState(false);
  const [archive, setArchive] = useState<Goal[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchArchive = async () => {
      try {
        setIsLoading(true);
        const fetchedArchive = await api.getGoalArchive(pid, gid);
        setArchive(fetchedArchive);
        setIsLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchArchive();
  }, [gid, pid, refresh]);

  const triggerRefresh = () => {
    setRefresh(!refresh);
  };

  return (
    <div>
      <div className="text-center mt-2 text-lg text-gray-600">
        Sub-goals which have been archived.
      </div>
      <ArchiveGoalList
        rid={rid}
        goals={archive}
        isLoading={isLoading}
        refresh={triggerRefresh}
      />
    </div>
  );
}

function Harvest({ goal, rid }: { goal: Goal, rid: string }) {
  const { pid, gid } = goalKeyToPidGid(goal.key);

  const [refreshHarvest, setRefreshHarvest] = useState(false);
  const [refreshEmptyGoals, setRefreshEmptyGoals] = useState(false);
  const [harvest, setHarvest] = useState<Goal[]>([]);
  const [emptyGoals, setEmptyGoals] = useState<Goal[]>([]);
  const [harvestLoading, setHarvestLoading] = useState(true);
  const [emptyGoalsLoading, setEmptyGoalsLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<'Frontier' | 'Empty'>('Frontier');

  useEffect(() => {
    const fetchHarvest = async () => {
      try {
        setHarvestLoading(true);
        const fetchedHarvest = await api.getArchiveGoalHarvest(pid, rid, gid);
        setHarvest(fetchedHarvest);
        setHarvestLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchHarvest();
  }, [pid, rid, gid, refreshHarvest]);

  useEffect(() => {
    const fetchEmptyGoals = async () => {
      try {
        setEmptyGoalsLoading(true);
        const fetchedEmptyGoals = await api.getArchiveGoalEmptyGoals(pid, rid, gid);
        setEmptyGoals(fetchedEmptyGoals);
        setEmptyGoalsLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchEmptyGoals();
  }, [pid, rid, gid, refreshEmptyGoals]);

  const triggerRefreshHarvest = () => {
    setRefreshHarvest(!refreshHarvest);
  };

  const triggerRefreshEmptyGoals = () => {
    setRefreshEmptyGoals(!refreshEmptyGoals);
  };

  return (
    <div>
      <div className="border-b">
        <ul className="flex justify-center -mb-px">
          <li className={`${activeTab === 'Frontier' ? 'border-blue-500' : ''}`}>
            <button 
              className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                activeTab === 'Frontier' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
              }`} 
              onClick={() => setActiveTab('Frontier')}
            >
              Frontier
            </button>
          </li>
          <li className={`${activeTab === 'Empty' ? 'border-blue-500' : ''}`}>
            <button 
              className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                activeTab === 'Empty' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
              }`} 
              onClick={() => setActiveTab('Empty')}
            >
              Empty
            </button>
          </li>
        </ul>
      </div>
      { activeTab === 'Frontier' && (
        <div>
          <div className="text-center mt-2 text-lg text-gray-600">
            The Frontier constitutes goals leading to this one which can be tackled immediately.
          </div>
          <ArchiveGoalList 
            rid={rid}
            goals={harvest}
            isLoading={harvestLoading}
            refresh={triggerRefreshHarvest}
          />
        </div>
      )}
      { activeTab === 'Empty' && (
        <div>
          <div className="text-center mt-2 text-lg text-gray-600">
            Non-actionable goals with no children;
            goals which require elaboration.
          </div>
          <ArchiveGoalList
            rid={rid}
            goals={emptyGoals}
            isLoading={emptyGoalsLoading}
            refresh={triggerRefreshEmptyGoals}
          />
        </div>
      )}
    </div>
  );
}

function ArchiveGoalPage({ host, name, rootId, goalId }: { host: string, name: string, rootId: string, goalId: string }) {
  const key = `/${host}/${name}/${goalId}`;
  const pid = `/${host}/${name}`;
  const rid = `/${rootId}`;
  const gid = `/${goalId}`;
  const [panel, setPanel] = useState('');
  const [goal, setGoal] = useState<Goal | null>(null);
  const [context, setContext] = useState<string | null>(null);
  const [refreshGoal, setRefreshGoal] = useState(false);
  const [activeTab, setActiveTab] = useState<'Sub-goals' | 'Archive' | 'Harvest' | 'Note'>('Sub-goals');
  const [goalLoading, setGoalLoading] = useState(true);
  const { navigateToPeriod, navigateToGoal, navigateToPool, navigateToPools } = useCustomNavigation();
  const { currentPeriodType, getCurrentPeriod, setCurrentTreePage } = useStore(state => state);

  useEffect(() => {
    const fetchGoal = async () => {
      try {
        setGoalLoading(true);
        const response = await api.getSingleArchiveGoal(pid, rid, gid);
        const goal: Goal | null = response.goal;
        const context: string | null = response.context;
        setGoal(goal);
        setContext(context);
        setGoalLoading(false);
      } catch (error) {
        console.error("Error fetching tags: ", error);
      }
    };
    fetchGoal();
  }, [pid, rid, gid, refreshGoal]);

  const copyToClipboard = () => {
    navigator.clipboard.writeText(key);
  }

  const toggleRestorePanel = () => {
    console.log("setting panel to restore");
    if (panel === 'restore') {
      setPanel('');
    } else {
      setPanel('restore');
    }
    console.log(panel);
  };

  const toggleArchiveInfoPanel = () => {
    if (panel === 'info') {
      setPanel('');
    } else {
      setPanel('info');
    }
  };

  const handleRestoreClick = async () => {
    if (context === null) {
      try {
        await api.restoreGoal(key);
        navigateToPool(pid);
      } catch (error) {
        console.error("Error processing restore to root: ", error);
      }
    } else {
      // TODO: should go to context page
      toggleRestorePanel();
    }
  }

  const deleteGoal = async () => {
    // Show confirmation dialog
    const isConfirmed = window.confirm("Deleting a goal is irreversible. Are you sure you want to delete this goal?");
  
    // Only proceed if the user confirms
    if (isConfirmed && (rid === gid)) {
      try {
        await api.deleteFromArchive(key);
        // TODO: should go to context page
        navigateToPool(pid);
      } catch (error) {
        console.error(error);
      }
    }
  };

  return (
    <div className="bg-[#C4a484] h-full flex justify-center items-center h-screen">
      { goalLoading && (
        <div className="flex justify-center m-20">
          <div className="animate-spin rounded-full h-16 w-16 border-b-8 border-t-transparent border-blue-500"></div>
        </div>
      )}
      { !goalLoading && goal && (
        <div className="bg-[#C4a484] p-6 rounded shadow-md w-full h-screen overflow-y-auto">
          <div className="flex justify-between items-center mb-4">
            <TagSearchBar poolId={pid} />
            <button
              onClick={
                () => {
                  setCurrentTreePage(`/goal${key}`);
                  navigateToPeriod(currentPeriodType, getCurrentPeriod());
                }
              }
              className="p-2 mr-2 border border-gray-300 bg-gray-100 rounded hover:bg-gray-200 flex items-center justify-center"
              style={{ height: '2rem', width: '2rem' }} // Adjust the size as needed
            >
              <FaListUl />
            </button>
          </div>
          <div className="flex justify-between pb-2">
            { (context !== null) && (
              <div
                className="cursor-pointer"
                onClick={() => navigateToGoal(`${pid}/${context}`)}
              >
                <h2 className="text-blue-800">Context Goal</h2>
              </div>
            )}
            { (context === null) && (
              <div
                className="cursor-pointer"
                onClick={() => navigateToPool(pid)}
              >
                <h2 className="text-blue-800">Context Pool</h2>
              </div>
            )}
            {goal?.parent && (
              <div
                className="cursor-pointer"
                onClick={() => navigateToGoal(`${goal.parent as string}`)}
              >
                <h2 className="text-blue-800">Parent Goal</h2>
              </div>
            )}
            <div
              className="cursor-pointer"
              onClick={() => navigateToPool(pid)}
            >
              <h2 className="text-blue-800">Parent Pool</h2>
            </div>
            <div
              className="cursor-pointer"
              onClick={() => navigateToPools()}
            >
              <h2 className="text-blue-800">All Pools</h2>
            </div>
          </div>
          <div className={`p-1 rounded flex justify-between items-center bg-gray-200 ${goal.actionable ? 'border-4 border-gray-400 box-border' : 'p-1' } m-2 ${goal.active ? 'hover:bg-gray-300 bg-gray-200' : 'opacity-50 bg-gray-200'}`}>
            <div className="relative group">
              <button
                className="mr-1 p-2 rounded bg-gray-100"
                onClick={toggleArchiveInfoPanel}
              >
                <FiInfo />
              </button>
              {
                panel === 'info' && (
                  <div className="absolute left-0 top-full mt-2 w-64 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2">
                    <ArchiveInfoPanel goal={goal} rid={ rid ? rid : gid } />
                  </div>
                )
              }
            </div>
            <button
              className="mr-1 p-2 rounded bg-gray-100"
              onClick={copyToClipboard}
            >
              <FiCopy />
            </button>
            <div
              className={`mr-1 text-center text-3xl font-bold bg-gray-100 rounded flex-grow p-1 ${goal?.complete ? 'line-through' : ''}`}
            >
              {goal?.summary}
            </div>
          { (rid === gid) && (
            <div className="flex items-center">
              <div className="relative group">
                <button
                  className="mr-1 p-2 rounded bg-gray-100"
                  onClick={handleRestoreClick}
                >
                  <FiRotateCcw />
                </button>
                {
                  (panel === 'restore') && (
                    <div className="absolute right-0 top-full mt-2 w-44 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2">
                      <RestorePanel goalKey={goal.key} refresh={() => navigateToPool(pid)} />
                    </div>
                  )
                }
              </div>
              <button
                className="p-2 rounded bg-gray-100"
                onClick={deleteGoal}
              >
                <FiTrash />
              </button>
            </div>
          )}
          </div>
          <div className="border-b">
            <ul className="flex justify-center -mb-px">
              <li className={`${activeTab === 'Sub-goals' ? 'border-blue-500' : ''}`}>
                <button 
                  className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                    activeTab === 'Sub-goals' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
                  }`} 
                  onClick={() => setActiveTab('Sub-goals')}
                >
                  Sub-goals
                </button>
              </li>
              <li className={`${activeTab === 'Archive' ? 'border-blue-500' : ''}`}>
                <button 
                  className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                    activeTab === 'Archive' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
                  }`} 
                  onClick={() => setActiveTab('Archive')}
                >
                  Archive
                </button>
              </li>
              <li className={`${activeTab === 'Harvest' ? 'border-blue-500' : ''}`}>
                <button 
                  className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                    activeTab === 'Harvest' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
                  }`} 
                  onClick={() => setActiveTab('Harvest')}
                >
                  Harvest
                </button>
              </li>
              <li className={`${activeTab === 'Note' ? 'border-blue-500' : ''}`}>
                <button 
                  className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                    activeTab === 'Note' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
                  }`} 
                  onClick={() => setActiveTab('Note')}
                >
                  Note
                </button>
              </li>
            </ul>
          </div>
          {activeTab === 'Note' && (
            <div className="items-center mt-2 rounded">
              <MarkdownEditor
                initialMarkdown={goal?.note as string}
              />
            </div>
          )}
          {activeTab === 'Archive' && (
            <Archive goal={goal} rid={rid} />
          )}
          {activeTab === 'Sub-goals' && (
            <Subgoals goal={goal} rid={rid} />
          )}
          {activeTab === 'Harvest' && (
            <Harvest goal={goal} rid={rid}/>
          )}
        </div>
      )}
    </div>
  );
}

export default ArchiveGoalPage;
