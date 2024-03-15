import React, { useState, useEffect } from 'react';
import useStore from '../store';
import MarkdownEditor from './MarkdownEditor';
import GoalList from './GoalList';
import ArchiveGoalList from './ArchiveGoalList';
import GoalPageActionBar from './GoalPageActionBar';
import AttributeModal from './Panels/AttributeModal';
import TagSearchBar from './TagSearchBar';
import api from '../api';
import { FiX, FiSave, FiEdit } from 'react-icons/fi';
import { FaListUl } from 'react-icons/fa';
import { CompleteIcon, ActiveIcon, AttributeIcon } from './CustomIcons';
import useCustomNavigation from './useCustomNavigation';
import { Goal } from '../types';
import { goalKeyToPidGid, gidFromKey } from '../utils';

function Subgoals({ goal }: { goal: Goal }) {
  const { pid, gid } = goalKeyToPidGid(goal.key);

  const [activeNewGoal, setActiveNewGoal] = useState(true);
  const [newSummary, setNewSummary] = useState<string>('');
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
        const fetchedChildren = await api.getGoalChildren(pid, gid);
        setChildren(fetchedChildren);
        setChildrenLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchChildren();
  }, [gid, pid, refreshChildren]);

  useEffect(() => {
    const fetchBorrowed = async () => {
      try {
        setBorrowedLoading(true);
        const fetchedBorrowed = await api.getGoalBorrowed(pid, gid);
        setBorrowed(fetchedBorrowed);
        setBorrowedLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchBorrowed();
  }, [gid, pid, refreshBorrowed]);

  const triggerRefreshChildren = () => {
    setRefreshChildren(!refreshChildren);
  };

  const triggerRefreshBorrowed = () => {
    setRefreshBorrowed(!refreshBorrowed);
  };

  const handleAddSummary = async () => {
    if (newSummary.trim() !== '') {
      try {
        await api.createGoal(pid, gid, newSummary, true, activeNewGoal);
      } catch (error) {
        console.error(error);
      }
      setNewSummary('');
      setRefreshChildren(!refreshChildren)
    }
  };

  const moveGoal = (selectedGoalKey: string, aboveGoalKey: string | null, belowGoalKey: string | null) => {
    if (selectedGoalKey !== null) {
      let keys = children.map(goal => goal.key);
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

      api.reorderChildren(goal.key, keys.map(key => gidFromKey(key)))
        .then(() => {
          triggerRefreshChildren();
        })
        .catch(error => console.error("Failed to reorder children:", error));
    }
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
              placeholder="Create a sub-goal..."
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
            goals={children}
            moveGoal={moveGoal}
            isLoading={childrenLoading}
            completeTab={true}
            defaultCompleteTab={goal?.complete ? 'Complete' : 'Incomplete'}
            refresh={triggerRefreshChildren}
          />
        </div>
      )}
      { activeTab === 'Borrowed' && (
        <div>
          <div className="text-center mt-2 text-lg text-gray-600">
            Sub-goals of other goals which could also be considered sub-goals of this goal.
          </div>
          <GoalList
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

function Archive({ goal }: { goal: Goal }) {
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
  
      api.reorderArchive(pid, gid, keys.map(key => gidFromKey(key)))
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
        goals={archive}
        moveGoal={moveGoal}
        isLoading={isLoading}
        refresh={triggerRefresh}
      />
    </div>
  );
}

function Harvest({ goal }: { goal: Goal }) {
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
        const fetchedHarvest = await api.goalHarvest(goal.key);
        setHarvest(fetchedHarvest);
        setHarvestLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchHarvest();
  }, [goal.key, refreshHarvest]);

  useEffect(() => {
    const fetchEmptyGoals = async () => {
      try {
        setEmptyGoalsLoading(true);
        const fetchedEmptyGoals = await api.goalEmptyGoals(goal.key);
        setEmptyGoals(fetchedEmptyGoals);
        setEmptyGoalsLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchEmptyGoals();
  }, [goal.key, refreshEmptyGoals]);

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

function GoalPage({ host, name, goalId }: { host: string, name: string, goalId: string }) {
  const key = `/${host}/${name}/${goalId}`;
  const pid = `/${host}/${name}`;
  const [goal, setGoal] = useState<Goal | null>(null);
  const [refreshGoal, setRefreshGoal] = useState(false);
  const [activeTab, setActiveTab] = useState<'Sub-goals' | 'Archive' | 'Harvest' | 'Note'>('Sub-goals');
  const [isEditingSummary, setIsEditingSummary] = useState(false);
  const [summary, setSummary] = useState('');
  const [goalLoading, setGoalLoading] = useState(true);
  const { navigateToPeriod, navigateToGoal, navigateToPool, navigateToPools } = useCustomNavigation();
  const { currentPeriodType, getCurrentPeriod, setCurrentTreePage } = useStore(state => state);

  const [isAttributeModalOpen, setIsAttributeModalOpen] = useState(false);

  const toggleAttributeModal = () => {
    setIsAttributeModalOpen(!isAttributeModalOpen);
  };

  useEffect(() => {
    const fetchGoal = async () => {
      try {
        setGoalLoading(true);
        const goal: Goal | null = await api.getSingleGoal(key);
        setGoal(goal);
        setSummary(goal ? goal.summary : '');
        setGoalLoading(false);
      } catch (error) {
        console.error("Error fetching tags: ", error);
      }
    };
    fetchGoal();
  }, [key, refreshGoal]);

  const handleSummaryEdit = () => {
    setSummary(goal?.summary as string);
    setIsEditingSummary(true);
  };
  
  const handleSummarySave = async () => {
    setIsEditingSummary(false);
    await api.setGoalSummary(goal?.key as string, summary);
  };

  const handleSummaryCancel = () => {
    setIsEditingSummary(false);
    setSummary(goal?.summary as string);
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      e.preventDefault(); // Prevent default Enter key behavior
      handleSummarySave();
    }
  };
  
  const toggleComplete = async () => {
    try {
      await api.setGoalComplete(goal?.key as string, !goal?.complete);
      setRefreshGoal(!refreshGoal);
    } catch (error) {
      console.error(error);
    }
  };

  const saveMarkdown = async (markdown: string) => {
    try {
      await api.editGoalNote(key, markdown);
      setRefreshGoal(!refreshGoal);
    } catch (error) {
      console.error(error);
    }
  }

  return (
    <div className="bg-blue-300 h-full flex justify-center items-center h-screen">
      { goalLoading && (
        <div className="flex justify-center m-20">
          <div className="animate-spin rounded-full h-16 w-16 border-b-8 border-t-transparent border-blue-500"></div>
        </div>
      )}
      { !goalLoading && goal && (
        <div className="bg-blue-300 p-6 rounded shadow-md w-full h-screen overflow-y-auto">
          <div className="flex justify-between items-center mb-4">
            <TagSearchBar poolId={pid} />
            <button
              onClick={toggleAttributeModal}
              className="p-2 mr-2 border border-gray-300 bg-gray-100 rounded hover:bg-gray-200 flex items-center justify-center"
              style={{ height: '2rem', width: '2rem' }}
            >
              <AttributeIcon />
            </button>

            { isAttributeModalOpen &&
              <div className="m-2">
                <AttributeModal isOpen={isAttributeModalOpen} toggleModal={toggleAttributeModal} />
              </div>
            }

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
            <button
              className="mr-1 p-2 rounded bg-gray-100 text-white"
              onClick={toggleComplete}
            >
              <div className="text-white">
                <CompleteIcon
                  complete={goal?.complete as boolean}
                  style={ { color: goal?.complete ? 'black' : goal?.active ? 'black' : 'gray' } }
                />
              </div>
            </button>
            {isEditingSummary ? (
              <input
                type="text"
                value={summary}
                onChange={(e) => setSummary(e.target.value)}
                className="truncate text-center mr-1 text-3xl font-bold bg-white shadow rounded cursor-pointer flex-grow px-1"
                onKeyDown={handleKeyDown}
              />
            ) : (
              <div
                className={`mr-1 text-center text-3xl font-bold bg-gray-100 rounded flex-grow p-1 ${goal?.complete ? 'line-through' : ''}`}
                onDoubleClick={handleSummaryEdit}
              >
                {goal?.summary}
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
          <div className="mt-2 flex justify-center">
            <GoalPageActionBar goal={goal as Goal} refresh={() => setRefreshGoal(!refreshGoal)} />
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
                onSave={saveMarkdown}
              />
            </div>
          )}
          {activeTab === 'Archive' && (
            <Archive goal={goal} />
          )}
          {activeTab === 'Sub-goals' && (
            <Subgoals goal={goal} />
          )}
          {activeTab === 'Harvest' && (
            <Harvest goal={goal} />
          )}
        </div>
      )}
    </div>
  );
}

export default GoalPage;