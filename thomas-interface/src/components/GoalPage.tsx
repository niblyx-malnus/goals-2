import React, { useState, useEffect } from 'react';
import MarkdownEditor from './MarkdownEditor';
import GoalList from './GoalList';
import Harvest from './Harvest';
import PoolTagSearch from './TagSearchBar';
import api from '../api';
import '../global.css';
import { useNavigate } from 'react-router-dom';
import { FiX, FiSave, FiEdit2, FiEye, FiEyeOff } from 'react-icons/fi';

type Tag = {
  tag: string;
  isPublic: boolean;
};

function GoalPage({ host, name, goalKey }: { host: any; name: any; goalKey: any; }) {
  const poolId = `/${host}/${name}`;
  const goalId = `/${host}/${name}/${goalKey}`;
  const [parent, setParent] = useState<string | null>(null);
  const [goalDescription, setGoalDescription] = useState<string>('');
  const [goalNote, setGoalNote] = useState<string>('');
  const [newDescription, setNewDescription] = useState<string>('');
  const [refreshKids, setRefreshKids] = useState(false);
  const [refreshHarvest, setRefreshHarvest] = useState(false);
  const [actionType, setActionType] = useState('move');
  const [goalId1, setGoalId1] = useState<string>('');
  const [goalId2, setGoalId2] = useState<string>('');
  const [activeTab, setActiveTab] = useState('Sub-goals');
  const [harvestTags, setHarvestTags] = useState<Tag[]>([]);
  const [selectedOperation, setSelectedOperation] = useState('some');
  const [goalTags, setGoalTags] = useState<Tag[]>([]);
  const [allTags, setAllTags] = useState<Tag[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [filteredTags, setFilteredTags] = useState<Tag[]>([]);
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const [isCollapsed, setIsCollapsed] = useState(true);
  const [isEditingSummary, setIsEditingSummary] = useState(false);
  const [editableSummary, setEditableSummary] = useState(goalDescription);
  const [completed, setCompleted] = useState(false);
  const [actionable, setActionable] = useState(false);
  const [harvestTagIsPublic, setHarvestTagIsPublic] = useState(false);
  const [newTagIsPublic, setNewTagIsPublic] = useState(true);

  const handleSummaryEdit = () => {
    setIsEditingSummary(true);
  };

  const handleSummaryChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setEditableSummary(e.target.value);
  };
  
  const handleSummarySave = () => {
    setIsEditingSummary(false);
    setGoalDescription(editableSummary);
    api.setGoalSummary(goalId, editableSummary);
  };

  const handleSummaryCancel = () => {
    setIsEditingSummary(false);
    setEditableSummary(goalDescription); // Revert to the original description
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      e.preventDefault(); // Prevent default Enter key behavior
      handleSummarySave();
    }
  };

  const toggleCollapse = () => {
    setIsCollapsed(!isCollapsed);
  };

  const navigate = useNavigate();

  const fetchTags = async () => {
    try {
      const fetchedTags = await api.getPoolTags(`/${host}/${name}`);
      setAllTags(fetchedTags);
      setFilteredTags(fetchedTags); // Initialize with all tags
    } catch (error) {
      console.error("Error fetching tags: ", error);
    }
  };

  const fetchCompleted = async () => {
    try {
      const fetchedCompleted = await api.getGoalComplete(goalId);
      setCompleted(fetchedCompleted);
    } catch (error) {
      console.error("Error fetching tags: ", error);
    }
  };

  const fetchActionable = async () => {
    try {
      const fetchedActionable = await api.getGoalActionable(goalId);
      setActionable(fetchedActionable);
    } catch (error) {
      console.error("Error fetching tags: ", error);
    }
  };

  const toggleActionable = async () => {
    try {
      await api.setGoalActionable(goalId, !actionable);
      const temp = await api.getGoalActionable(goalId);
      setActionable(temp);
    } catch (error) {
      console.error(error);
    }
  };
  
  const toggleComplete = async () => {
    try {
      await api.setGoalComplete(goalId, !completed);
      const temp = await api.getGoalComplete(goalId);
      setCompleted(temp);
    } catch (error) {
      console.error(error);
    }
  };

  useEffect(() => {
    fetchTags();
    fetchCompleted();
    fetchActionable();
  }, [host, name]);

  // Ensure editableSummary is updated when goalDescription changes
  useEffect(() => {
    setEditableSummary(goalDescription);
  }, [goalDescription]);

  // Fetch goal data (make sure to include dependencies in the array)
  useEffect(() => {
    const fetchGoalData = async () => {
      try {
        const fetchedDesc = await api.getGoalSummary(goalId);
        setGoalDescription(fetchedDesc);
        // ... other fetch calls
      } catch (error) {
        console.error("Error fetching data: ", error);
      }
    };
    fetchGoalData();
  }, [goalId]);

  useEffect(() => {
    const filtered = allTags.filter(tag => tag.tag.toLowerCase().includes(searchTerm.toLowerCase()));
    setFilteredTags(filtered);
  }, [searchTerm, allTags]);

  const navigateToTagPage = (tag: string) => {
    setDropdownOpen(false);
    navigate(`/pool-tag/${host}/${name}/${tag}`);
  };

  const navigateToAllPools = () => {
    setDropdownOpen(false);
    navigate(`/pools`);
  };

  const navigateToPoolPage = (poolId: string) => {
    setDropdownOpen(false);
    navigate(`/pool${poolId}`);
  };

  const navigateToGoalPage = (goalId: string) => {
    setDropdownOpen(false);
    navigate(`/goal${goalId}`);
  };

  const handleInputFocus = async () => {
    fetchTags();
    setDropdownOpen(true);
  };

  const handleInputBlur = () => {
    setTimeout(() => {
      setDropdownOpen(false);
    }, 100);
  };
  // Function to toggle refreshFlag
  const triggerRefreshKids = () => {
    setRefreshKids(!refreshKids);
  };

  // Function to toggle refreshFlag
  const triggerRefreshHarvest = () => {
    setRefreshHarvest(!refreshHarvest);
  };

  // Fetch pools on mount
  useEffect(() => {
    const fetch = async () => {
      try {
        const fetchedDesc = await api.getGoalSummary(goalId);
        setGoalDescription(fetchedDesc);
        const fetchedNote = await api.getGoalNote(goalId);
        setGoalNote(fetchedNote);
        const fetchedParent = await api.getGoalParent(goalId);
        setParent(fetchedParent);
        const fetchedTags = await api.getGoalTags(goalId);
        setGoalTags(fetchedTags);
      } catch (error) {
        console.error("Error fetching pools: ", error);
      }
    };
    fetch();
  }, [goalId]);

  const handleAddTitle = async () => {
    if (newDescription.trim() !== '') {
      try {
        await api.createGoal(poolId, goalId, newDescription, true);
      } catch (error) {
        console.error(error);
      }
      setNewDescription('');
    }
  };

  const saveMarkdown = async (markdown: string) => {
    try {
      await api.editGoalNote(goalId, markdown);
      const fetchedNote = await api.getGoalNote(goalId);
      setGoalNote(fetchedNote);
    } catch (error) {
      console.error(error);
    }
  }

  const handleGoClick = async () => {
    try {
      const id2 = goalId2 === '' ? null : goalId2;
      if (actionType === 'move') {
        await api.move(goalId1, id2);
      } else if (actionType === 'nest') {
        await api.move(goalId1, id2);
      }
      triggerRefreshKids();
    } catch (error) {
      console.error(error);
    }
  };

  // Function to handle adding tags
  const addHarvestTag = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && e.currentTarget.value.trim() !== '') {
      setHarvestTags([...harvestTags, { isPublic: false, tag: e.currentTarget.value.trim() }]);
      e.currentTarget.value = ''; // Clear the input
    }
  };

  // Function to handle removing tags
  const removeHarvestTag = (index: number) => {
    setHarvestTags(harvestTags.filter((_, i) => i !== index));
  };
  // Function to handle adding tags
  const addGoalTag = async (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && e.currentTarget.value.trim() !== '') {
      try {
        await api.addGoalTag(goalId, newTagIsPublic, e.currentTarget.value.trim()); // Assuming such a function exists in your API
        const fetchedTags = await api.getGoalTags(goalId);
        setGoalTags(fetchedTags);
        e.currentTarget.value = ''; // Clear the input
      } catch (error) {
        console.error("Error adding goal tag: ", error);
      }
    }
  };

  // Function to handle removing tags from a goal
  const removeGoalTag = async (index: number) => {
    const tagToRemove = goalTags[index];
    try {
      await api.delGoalTag(goalId, tagToRemove.isPublic, tagToRemove.tag); // Assuming such a function exists in your API
      const fetchedTags = await api.getGoalTags(goalId);
      setGoalTags(fetchedTags);
    } catch (error) {
      console.error("Error removing goal tag: ", error);
    }
  };

  return (
    <div className="bg-gray-200 h-full flex justify-center items-center h-screen">
      <div className="bg-blue-300 p-6 rounded shadow-md w-full h-screen overflow-y-auto">
        <div className="flex justify-between items-center mb-4">
          <PoolTagSearch host={host} name={name}/>
        </div>
        <div className="flex justify-between pb-2">
          {parent && (
            <div
              className="cursor-pointer"
              onClick={() => navigateToGoalPage(parent)}
            >
              <h2 className="text-blue-800">Parent Goal</h2>
            </div>
          )}
          <div
            className="cursor-pointer"
            onClick={() => navigateToPoolPage(poolId)}
          >
            <h2 className="text-blue-800">Parent Pool</h2>
          </div>
          <div
            className="cursor-pointer"
            onClick={() => navigateToAllPools()}
          >
            <h2 className="text-blue-800">All Pools</h2>
          </div>
        </div>
        <h1 className="text-2xl font-semibold text-blue-600 text-center mb-4 flex items-center justify-center">
          {isEditingSummary ? (
            <div>
              <input
                type="text"
                value={editableSummary}
                onChange={handleSummaryChange}
                onKeyDown={handleKeyDown}
                className="bg-white shadow rounded cursor-pointer p-2 flex-grow"
                style={{ width: '30%' }}
              />
              <button
                onClick={handleSummarySave}
                className="ml-2 p-1 text-teal-500 hover:text-teal-700"
              >
                <FiSave />
              </button>
              <button
                onClick={handleSummaryCancel}
                className="ml-2 p-1 text-red-500 hover:text-red-700"
              >
                <FiX />
              </button>
            </div>
          ) : (
            <>
              {goalDescription}
              <FiEdit2 
                onClick={handleSummaryEdit}
                className="ml-2 cursor-pointer text-blue-500 hover:text-blue-700"
              />
            </>
          )}
        </h1>
        <div className="flex justify-center space-x-4 mb-4">
          <label className="flex items-center space-x-2">
            <input 
              type="checkbox" 
              checked={completed} 
              onChange={toggleComplete} 
              className="form-checkbox rounded"
            />
            <span>Complete</span>
          </label>
          <label className="flex items-center space-x-2">
            <input 
              type="checkbox" 
              checked={actionable} 
              onChange={toggleActionable} 
              className="form-checkbox rounded"
            />
            <span>Actionable</span>
          </label>
        </div>
        <div className="flex flex-row justify-center items-center w-full mb-4 h-auto">
          <button
            onClick={() => setNewTagIsPublic(!newTagIsPublic)}
            className="p-2 mr-2 border border-gray-300 bg-gray-100 rounded hover:bg-gray-200 flex items-center justify-center"
            style={{ height: '2rem', width: '2rem' }} // Adjust the size as needed
          >
            {newTagIsPublic ? <FiEye /> : <FiEyeOff />}
          </button>
          <input
            type="text"
            placeholder="Enter tags..."
            className="p-2 w-1/3 border box-border rounded"
            onKeyDown={addGoalTag}
          />
        </div>
        <div className="flex flex-wrap justify-center mb-4">
          {goalTags.map((tag, index) => (
            <div key={index} className="flex items-center bg-gray-200 rounded px-2 py-1 m-1">
              { tag.isPublic
                ? <FiEye className="mr-2"/>
                : <FiEyeOff className="mr-2"/>
              }
              <div
                key={index}
                className="flex items-center bg-gray-200 rounded cursor-pointer"
                onClick={() => navigateToTagPage(tag.tag)}
              >
                {tag.tag}
              </div>
              <button 
                className="ml-2 rounded-full bg-gray-300 hover:bg-gray-400"
                onClick={(e) => {
                  e.preventDefault(); // Prevent link navigation when clicking the button
                  removeGoalTag(index);
                }}
              >
                ×
              </button>
            </div>
          ))}
        </div>
        <div className="w-full px-1">
          <div 
            className="flex items-center justify-between cursor-pointer p-2 border-b"
            onClick={toggleCollapse}
          >
            <span>Yoke Action</span>
            {/* Optional: Replace the following span with an icon component */}
            <span>{isCollapsed ? '▼' : '▲'}</span> 
            {/* <FiChevronDown /> for down arrow and <FiChevronUp /> for up arrow */}
          </div>

          {!isCollapsed && (
            <div className="flex flex-col items-center justify-center mb-4">
              <div className="w-full p-1">
                <select 
                  onChange={(e) => setActionType(e.target.value)} 
                  value={actionType}
                  className="w-full p-2 border box-border rounded text-sm"
                >
                  <option value="move">Move</option>
                  <option value="nest">Nest</option>
                </select>
              </div>
              <div className="w-full p-1">
                <input 
                  type="text" 
                  placeholder="Goal ID 1" 
                  value={goalId1} 
                  onChange={(e) => setGoalId1(e.target.value)}
                  className="w-full p-2 border box-border rounded text-sm"
                />
              </div>
              <div className="w-full p-1">
                <input 
                  type="text" 
                  placeholder="Goal ID 2 (optional)" 
                  value={goalId2} 
                  onChange={(e) => setGoalId2(e.target.value)}
                  className="w-full p-2 border box-border rounded text-sm"
                />
              </div>
              <button
                className="p-2 bg-gray-100 rounded flex items-center justify-center"
                onClick={handleGoClick}
              >
                Go
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
          </ul>
        </div>
        {activeTab === 'Sub-goals' && (
          <div>
            <div className="pt-6 flex items-center mb-4">
              <input
                type="text"
                value={newDescription}
                onChange={(e) => setNewDescription(e.target.value)}
                onKeyDown={(e) => {
                    if (e.key === 'Enter') handleAddTitle();
                }}
                placeholder="Enter new title..."
                className="p-2 flex-grow border box-border rounded mr-2 w-full" // <-- Notice the flex-grow and w-full here
              />
              <button 
                onClick={handleAddTitle} 
                className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 focus:outline-none"
                style={{maxWidth: '100px'}} // This ensures button never grows beyond 100px.
              >
                Add
              </button>
            </div>
            <GoalList host={host} name={name} goalKey={goalKey} refresh={triggerRefreshKids}/>
            <div className="items-center mt-2 rounded">
              <MarkdownEditor
                initialMarkdown={goalNote}
                onSave={saveMarkdown}
              />
            </div>
          </div>
        )}
        {activeTab === 'Harvest' && (
          <>
            <div className="flex flex-col items-center h-auto">
              <div className="flex justify-center items-center w-full mb-4">
                <div className="flex flex-row justify-center items-center">
                  <select
                    className="p-2 border rounded mr-2"
                    value={selectedOperation}
                    onChange={(e) => setSelectedOperation(e.target.value)}
                  >
                    <option value="some">Some</option>
                    <option value="every">Every</option>
                  </select>
                  <button
                    onClick={() => setHarvestTagIsPublic(!harvestTagIsPublic)}
                    className="p-2 mr-2 border border-gray-300 bg-gray-200 rounded hover:bg-gray-200 flex items-center justify-center"
                    style={{ height: '2rem', width: '2rem' }} // Adjust the size as needed
                  >
                    {harvestTagIsPublic ? <FiEye /> : <FiEyeOff />}
                  </button>
                  <input
                    type="text"
                    placeholder="Enter tags..."
                    className="p-2 flex-grow border box-border rounded"
                    onKeyDown={addHarvestTag}
                  />
                </div>
              </div>
              <div className="flex flex-wrap justify-center mb-4">
                {harvestTags.map((tag, index) => (
                  <div key={index} className="flex items-center bg-gray-200 rounded px-2 py-1 m-1">
                    { tag.isPublic
                      ? <FiEye className="mr-2"/>
                      : <FiEyeOff className="mr-2"/>
                    }
                    <div
                      key={index}
                      className="flex items-center bg-gray-200 rounded cursor-pointer"
                      onClick={() => navigateToTagPage(tag.tag)}
                    >
                      {tag.tag}
                    </div>
                    <button 
                      className="ml-2 rounded-full bg-gray-300 hover:bg-gray-400"
                      onClick={(e) => {
                        e.preventDefault(); // Prevent link navigation when clicking the button
                        removeHarvestTag(index);
                      }}
                    >
                      ×
                    </button>
                  </div>
                ))}
              </div>
            </div>
            <Harvest host={host} name={name} goalKey={goalKey} method={selectedOperation} tags={harvestTags} refresh={triggerRefreshHarvest}/>
          </>
        )}
      </div>
    </div>
  );
}

export default GoalPage;
