import React, { useState, useEffect } from 'react';
import MarkdownEditor from './MarkdownEditor';
import useStore from '../store';
import { useNavigate } from 'react-router-dom';
import GoalList from './GoalList';
import ArchiveGoalList from './ArchiveGoalList';
import TagSearchBar from './TagSearchBar';
import api from '../api';
import { FiX, FiSave, FiEdit, FiTrash } from 'react-icons/fi';
import { ActiveIcon } from './CustomIcons';
import { FaListUl } from 'react-icons/fa';
import { Goal } from '../types';
import { gidFromKey, goalKeyToPidGid } from '../utils';
import useCustomNavigation from './useCustomNavigation';

function Archive({ pid, refreshRoots }: { pid: string, refreshRoots: () => void }) {
  const [refresh, setRefresh] = useState(false);
  const [archive, setArchive] = useState<Goal[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchArchive = async () => {
      try {
        setIsLoading(true);
        const fetchedArchive = await api.getPoolArchive(pid);
        setArchive(fetchedArchive);
        setIsLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchArchive();
  }, [pid, refresh]);

  const triggerRefresh = () => {
    refreshRoots();
    setRefresh(!refresh);
  };
  
  const moveGoal = (selectedGoalKey: string, aboveGoalKey: string | null, belowGoalKey: string | null) => {
    if (selectedGoalKey !== null) {
      let keys = archive.map(goal => goal.key);
      const currentIndex = keys.indexOf(selectedGoalKey);
  
      // Early exit if the goal isn't found
      if (currentIndex === -1) return;
  
      // if the below goal is above me, I'm moving up
      const isMovingUp = (belowGoalKey && keys.indexOf(belowGoalKey) < currentIndex);
      // if the above goal is below me, I'm moving down
      const isMovingDown = (aboveGoalKey && keys.indexOf(aboveGoalKey) > currentIndex);
  
      const isMovingToSamePosition = 
        (aboveGoalKey && currentIndex - 1 === keys.indexOf(aboveGoalKey)) ||
        (aboveGoalKey && currentIndex === keys.indexOf(aboveGoalKey)) ||
        (belowGoalKey && currentIndex + 1 === keys.indexOf(belowGoalKey)) ||
        (belowGoalKey && currentIndex === keys.indexOf(belowGoalKey));
      if (isMovingToSamePosition) { return; }
  
      // Remove the selected goal from its current position
      keys.splice(currentIndex, 1);
  
      let newIndex = 0;
      // If we're moving up, we go above the belowGoalKey
      if (isMovingUp) {
        newIndex = keys.indexOf(belowGoalKey);
      // If we're moving down, we go below the aboveGoalKey
      } else if (isMovingDown) {
        newIndex = keys.indexOf(aboveGoalKey) + 1;
      }
  
      // Insert the selected goal at the new position
      keys.splice(newIndex, 0, selectedGoalKey);
  
      api.reorderArchive(pid, null, keys.map(key => gidFromKey(key)))
        .then(() => {
          triggerRefresh();
        })
        .catch(error => console.error("Failed to reorder children:", error));
    }
  };

  return (
    <div>
      <div className="text-center mt-2 text-lg text-gray-600">
        Sub-goals which have been archived.
      </div>
      <ArchiveGoalList
        atPoolRoot={true}
        goals={archive}
        moveGoal={moveGoal}
        isLoading={isLoading}
        refresh={triggerRefresh}
      />
    </div>
  );
}

function Harvest({ host, name }: { host: string, name: string }) {
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
        const fetchedHarvest = await api.poolHarvest(`/${host}/${name}`);
        setHarvest(fetchedHarvest);
        setHarvestLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchHarvest();
  }, [host, name, refreshHarvest]);

  useEffect(() => {
    const fetchEmptyGoals = async () => {
      try {
        setEmptyGoalsLoading(true);
        const fetchedEmptyGoals = await api.poolEmptyGoals(`/${host}/${name}`);
        setEmptyGoals(fetchedEmptyGoals);
        setEmptyGoalsLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchEmptyGoals();
  }, [host, name, refreshEmptyGoals]);

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
            The Frontier constitutes goals from this pool which can be tackled immediately.
          </div>
          <GoalList 
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
          <GoalList
            goals={emptyGoals}
            isLoading={emptyGoalsLoading}
            refresh={triggerRefreshEmptyGoals}
          />
        </div>
      )}
    </div>
  );
}

function Pool({ host, name }: { host: any; name: any; }) {
  const pid = `/${host}/${name}`;
  const [poolSummary, setPoolTitle] = useState<string>('');
  const [poolNote, setPoolNote] = useState<string>('');
  const [newSummary, setNewSummary] = useState<string>('');
  const [refreshPool, setRefreshPool] = useState(false);
  const [refreshRoots, setRefreshRoots] = useState(false);
  const [activeTab, setActiveTab] = useState<'Roots' | 'Archive' | 'Harvest' | 'Note'>('Roots');
  const [isEditingSummary, setIsEditingSummary] = useState(false);
  const [editableSummary, setEditableTitle] = useState(poolSummary);
  const [allTags, setAllTags] = useState<string[]>([]);
  const [roots, setRoots] = useState<Goal[]>([]);
  const [rootsLoading, setRootsLoading] = useState(true);
  const [poolLoading, setPoolLoading] = useState(true);
  const [activeNewGoal, setActiveNewGoal] = useState(true);
  const { navigateToPeriod, navigateToLabel } = useCustomNavigation();
  const { currentPeriodType, getCurrentPeriod, setCurrentTreePage } = useStore(state => state);

  useEffect(() => {
    const fetchTags = async () => {
      try {
        const fetchedTags = await api.getPoolLabels(pid);
        setAllTags(fetchedTags);
      } catch (error) {
        console.error("Error fetching tags: ", error);
      }
    };
    fetchTags();
  }, [pid, refreshPool]);

  // Function to enable editing mode
  const handleSummaryEdit = () => {
    setIsEditingSummary(true);
    setEditableTitle(poolSummary);
  };

  // Function to save edited title
  const handleSummarySave = async () => {
    setIsEditingSummary(false);
    setPoolTitle(editableSummary);
    await api.setPoolTitle(pid, editableSummary); // Assuming this is the correct API call
  };

  // Function to cancel editing
  const handleSummaryCancel = () => {
    setIsEditingSummary(false);
    setEditableTitle(poolSummary);
  };

  // Function to handle key down events in the input field
  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      handleSummarySave();
    }
  };
  
  const navigate = useNavigate();

  const navigateToAllPools = () => {
    navigate(`/pools`);
  };

  // Function to toggle refreshFlag
  const triggerRefreshRoots = () => {
    setRefreshRoots(!refreshRoots);
  };

  // Fetch pools on mount
  useEffect(() => {
    const fetch = async () => {
      try {
        setPoolLoading(true);
        const fetchedTitle = await api.getPoolTitle(pid);
        setPoolTitle(fetchedTitle);
        setEditableTitle(fetchedTitle);
        const fetchedNote = await api.getPoolNote(pid);
        setPoolNote(fetchedNote);
        setPoolLoading(false);
      } catch (error) {
        console.error("Error fetching pools: ", error);
      }
    };
    fetch();
  }, [pid, refreshPool]);

  useEffect(() => {
    const fetchRoots = async () => {
      try {
        setRootsLoading(true);
        const fetchedRoots = await api.getPoolRoots(pid);
        setRoots(fetchedRoots);
        setRootsLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchRoots();
  }, [pid, refreshRoots]);

  const deletePool = async () => {
    // Show confirmation dialog
    const isConfirmed = window.confirm("Deleting a pool is irreversible. Are you sure you want to delete this pool?");
  
    // Only proceed if the user confirms
    if (isConfirmed) {
      try {
        await api.deletePool(pid);
        setRefreshPool(!refreshPool);
      } catch (error) {
        console.error(error);
      }
    }
  };

  const handleAddSummary = async () => {
    if (newSummary.trim() !== '') {
      try {
        await api.createGoal(`/${host}/${name}`, null, newSummary, true, activeNewGoal);
      } catch (error) {
        console.error(error);
      }
      setNewSummary('');
      setRefreshRoots(!refreshRoots);
    }
  };

  const saveMarkdown = async (markdown: string) => {
    try {
      await api.editPoolNote(pid, markdown);
      const fetchedNote = await api.getPoolNote(pid);
      setPoolNote(fetchedNote);
    } catch (error) {
      console.error(error);
    }
  }

  const moveGoal = (selectedGoalKey: string, aboveGoalKey: string | null, belowGoalKey: string | null) => {
    if (selectedGoalKey !== null) {
      let keys = roots.map(goal => goal.key);
      const currentIndex = keys.indexOf(selectedGoalKey);

      // Early exit if the goal isn't found
      if (currentIndex === -1) return;

      // if the below goal is above me, I'm moving up
      const isMovingUp = (belowGoalKey && keys.indexOf(belowGoalKey) < currentIndex);
      // if the above goal is below me, I'm moving down
      const isMovingDown = (aboveGoalKey && keys.indexOf(aboveGoalKey) > currentIndex);
  
      const isMovingToSamePosition = 
        (aboveGoalKey && currentIndex - 1 === keys.indexOf(aboveGoalKey)) ||
        (aboveGoalKey && currentIndex === keys.indexOf(aboveGoalKey)) ||
        (belowGoalKey && currentIndex + 1 === keys.indexOf(belowGoalKey)) ||
        (belowGoalKey && currentIndex === keys.indexOf(belowGoalKey));
      if (isMovingToSamePosition) { return; }

      // Remove the selected goal from its current position
      keys.splice(currentIndex, 1);

      let newIndex = 0;
      // If we're moving up, we go above the belowGoalKey
      if (isMovingUp) {
        newIndex = keys.indexOf(belowGoalKey);
      // If we're moving down, we go below the aboveGoalKey
      } else if (isMovingDown) {
        newIndex = keys.indexOf(aboveGoalKey) + 1;
      }
  
      // Insert the selected goal at the new position
      keys.splice(newIndex, 0, selectedGoalKey);

      api.reorderRoots(pid, keys.map(key => gidFromKey(key)))
        .then(() => {
          triggerRefreshRoots();
        })
        .catch(error => console.error("Failed to reorder children:", error));
    }
  };


  return (
    <div className="bg-[#FAF3DD] flex justify-center items-center h-screen">
      { poolLoading && (
        <div className="flex justify-center m-20">
          <div className="animate-spin rounded-full h-16 w-16 border-b-8 border-t-transparent border-blue-500"></div>
        </div>
      )}
      { !poolLoading && (
        <div className="bg-[#FAF3DD] p-6 rounded shadow-md w-full h-screen overflow-y-auto">
          <div className="flex justify-between items-center mb-4">
            <TagSearchBar poolId={pid} />
            <button
              onClick={
                () => {
                  setCurrentTreePage(`/pool${pid}`);
                  navigateToPeriod(currentPeriodType, getCurrentPeriod());
                }
              }
              className="p-2 mr-2 border border-gray-300 bg-gray-100 rounded hover:bg-gray-200 flex items-center justify-center"
              style={{ height: '2rem', width: '2rem' }} // Adjust the size as needed
            >
              <FaListUl />
            </button>
          </div>
          <div
            className="cursor-pointer"
            onClick={() => navigateToAllPools()}
          >
            <h2 className="text-blue-800">All Pools</h2>
          </div>
          <div className={`p-1 rounded flex justify-between items-center bg-gray-200 p-1 m-2`}>
            {isEditingSummary ? (
              <input
                type="text"
                value={editableSummary}
                onChange={(e) => setNewSummary(e.target.value)}
                className="truncate text-center mr-1 text-3xl font-bold bg-white shadow rounded cursor-pointer flex-grow px-1"
                onKeyDown={handleKeyDown}
              />
            ) : (
              <div
                className={"mr-1 text-center text-3xl font-bold bg-gray-100 rounded flex-grow p-1"}
                onDoubleClick={handleSummaryEdit}
              >
                {poolSummary}
              </div>
            )}
            { !isEditingSummary && (
              <>
                <button
                  className="p-2 rounded bg-gray-100"
                  onClick={() => setIsEditingSummary(!isEditingSummary)}
                >
                  <FiEdit />
                </button>
                <button
                  className="p-2 rounded bg-gray-100"
                  onClick={deletePool}
                >
                  <FiTrash />
                </button>
              </>
            )}
            { isEditingSummary && (
              <>
                <button
                  className="p-2 rounded bg-gray-100 hover:bg-gray-200"
                  onClick={handleSummarySave}
                >
                  <FiSave />
                </button>
                <button
                  className="p-2 rounded bg-gray-100 hover:bg-gray-200"
                  onClick={handleSummaryCancel}
                >
                  <FiX />
                </button>
              </>
            )}
          </div>
          <div className="flex flex-wrap justify-center">
            {allTags.map((label, index) => (
              <div
                key={index}
                className="flex items-center bg-gray-200 rounded px-2 py-1 m-1 cursor-pointer"
                onClick={() => navigateToLabel(pid, label)}
              >
                {label}
              </div>
            ))}
          </div>
          <div className="border-b">
            <ul className="flex justify-center -mb-px">
              <li className={`${activeTab === 'Roots' ? 'border-blue-500' : ''}`}>
                <button 
                  className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                    activeTab === 'Roots' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
                  }`} 
                  onClick={() => setActiveTab('Roots')}
                >
                  Roots
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
                initialMarkdown={poolNote}
                onSave={saveMarkdown}
              />
            </div>
          )}
          {activeTab === 'Roots' && (
            <>
              <div className="pt-6 flex items-center mb-4">
                <button
                  className="mr-2 bg-blue-500 text-white px-2 py-2 rounded hover:bg-blue-600 focus:outline-none"
                  onClick={() => setActiveNewGoal(!activeNewGoal)} 
                >
                  {ActiveIcon(activeNewGoal)}
                </button>
                <input
                  type="text"
                  value={newSummary}
                  onChange={(e) => setNewSummary(e.target.value)}
                  onKeyDown={(e) => {
                      if (e.key === 'Enter') handleAddSummary();
                  }}
                  placeholder="Create a goal..."
                  className="p-2 flex-grow border box-border rounded mr-2 w-full" // <-- Notice the flex-grow and w-full here
                />
                <button 
                  onClick={handleAddSummary} 
                  className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 focus:outline-none"
                  style={{maxWidth: '100px'}} // This ensures button never grows beyond 100px.
                >
                  Add
                </button>
              </div>
              <GoalList
                goals={roots}
                moveGoal={moveGoal}
                isLoading={rootsLoading}
                completeTab={true}
                refresh={triggerRefreshRoots}
              />
            </>
          )}
          {activeTab === 'Archive' && (
            <Archive pid={pid} refreshRoots={() => setRefreshRoots(!refreshRoots)}/>
          )}
          {activeTab === 'Harvest' && (
            <Harvest host={host} name={name} />
           )}
        </div>
      )}
    </div>
  );
}

export default Pool;