import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import _ from 'lodash';
import { FiCopy, FiTag, FiX, FiEdit, FiTrash, FiSave, FiMenu } from 'react-icons/fi';
import useStore from '../store';

type Goal = {
  id: string,
  tags: string[],
  description: string,
  complete: boolean,
  actionable: boolean
}; // Type for pool object

const GoalRow: React.FC<{
    host: string,
    poolName: string,
    name: string,
    id: string,
    complete: boolean,
    actionable: boolean,
    showButtons: boolean,
    refresh: () => void,
    tags: string[],
    moveGoalUp: (id: string) => void,
    moveGoalDown: (id: string) => void
  }> = ({
    host,
    poolName,
    name,
    id,
    complete,
    actionable,
    showButtons,
    moveGoalUp,
    moveGoalDown,
    refresh,
    tags
  }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [newDescription, setNewDescription] = useState(name);
  const [isActionable, setIsActionable] = useState(actionable);
  const [isComplete, setIsComplete] = useState(complete);
  const [showTagDropdown, setShowTagDropdown] = useState(false);
  const [newTag, setNewTag] = useState('');

  // Use Zustand store
  const { placeholderTag, setPlaceholderTag } = useStore(state => ({ 
      placeholderTag: state.placeholderTag, 
      setPlaceholderTag: state.setPlaceholderTag 
    }));

  // Fetch the placeholder tag when the component mounts
  useEffect(() => {
    const fetchPlaceholderTag = async () => {
      const fetchedTag = await api.getSetting("placeholder-tag");
      setPlaceholderTag(fetchedTag || 'today');
    };

    fetchPlaceholderTag();
  }, [setPlaceholderTag]);

  const deleteGoal = async () => {
    // Show confirmation dialog
    const isConfirmed = window.confirm("Deleting a goal is irreversible. Are you sure you want to delete this goal?");
  
    // Only proceed if the user confirms
    if (isConfirmed) {
      try {
        await api.deleteGoal(id);
        refresh();
      } catch (error) {
        console.error(error);
      }
    }
  };

  const updateGoal = async () => {
    try {
      console.log("updating goal...");
      await api.setGoalSummary(id, newDescription);
      refresh();
      setIsEditing(false);
    } catch (error) {
      console.error(error);
    }
  };

  const cancelUpdateGoal = async () => {
    try {
      setNewDescription(name);
      refresh();
      setIsEditing(false);
    } catch (error) {
      console.error(error);
    }
  };

  const handleKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'Enter') {
      updateGoal();
    }
    if (event.key === 'Escape') {
      cancelUpdateGoal();
    }
  };

  const navigate = useNavigate();

  const navigateToGoal = (id: string) => {
    navigate(`/goal${id}`);
  };

  const toggleActionable = async () => {
    try {
      await api.setGoalActionable(id, !isActionable);
      const actionable = await api.getGoalActionable(id);
      setIsActionable(actionable);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };
  
  const toggleComplete = async () => {
    try {
      await api.setGoalComplete(id, !isComplete);
      const complete = await api.getGoalComplete(id);
      setIsComplete(complete);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };
  
  const copyToClipboard = () => {
    navigator.clipboard.writeText(id);
  }

  const handleTagButtonClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    if (event.shiftKey) {
      // Shift+Click: Add placeholder tag directly
      addNewTag();
    } else if (event.ctrlKey || event.metaKey) {
      removeTag(placeholderTag);
    } else {
      // Regular Click: Toggle dropdown
      toggleTagDropdown();
    }
  };

  const removeTag = async (tagToRemove: string) => {
    try {
      // Logic to remove the tag from the goal
      // For example, update the tags array and send a request to the backend
      await api.delGoalTag(id, tagToRemove);
      refresh();
    } catch (error) {
      console.error("Error removing tag: ", error);
    }
  };

  const addNewTag = async () => {
    try {
      // Logic to add the new tag to the goal
      // For example, update the tags array and send a request to the backend
      if (newTag.trim() !== '') {
        await api.addGoalTag(id, newTag);
        setNewTag(''); // Reset input field
        await api.updateSetting('put', 'placeholder-tag', newTag);
        const fetchedTag = await api.getSetting("placeholder-tag");
        setPlaceholderTag(fetchedTag || 'today');
        refresh();
      } else {
        await api.addGoalTag(id, placeholderTag);
        const fetchedTag = await api.getSetting("placeholder-tag");
        setPlaceholderTag(fetchedTag || 'today');
        refresh();
      }
    } catch (error) {
      console.error("Error adding new tag: ", error);
    }
  };

  const navigateToTag = (tag: string) => {
    navigate(`/tag/${host}/${poolName}/${tag}`);
  };

  // Toggle dropdown visibility
  const toggleTagDropdown = () => {
    setShowTagDropdown(!showTagDropdown);
  };

  const handleNewTagKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'Enter') {
      addNewTag();
    }
  };

  return (
    <div className={`flex justify-between items-center p-1 mt-2 rounded ${isActionable ? 'hover:bg-blue-500 bg-blue-400' : 'hover:bg-gray-300 bg-gray-200'}`}>
      {
        showButtons && (
          <>
            <div className="flex flex-col space-y-1">
              <input type="checkbox" checked={isActionable} onChange={toggleActionable} />
              <input type="checkbox" checked={isComplete} onChange={toggleComplete} />
            </div>
            <button
              className="p-2 rounded bg-gray-100 hover:bg-gray-200"
              onClick={copyToClipboard}
            >
              <FiCopy />
            </button>
            <button onClick={() => moveGoalUp(id)} className="p-2 rounded bg-gray-100 hover:bg-gray-200">
              ↑
            </button>
            <button onClick={() => moveGoalDown(id)} className="p-2 rounded bg-gray-100 hover:bg-gray-200">
              ↓
            </button>
          </>
        )
      }
      {isEditing ? (
        <input 
          type="text" 
          value={newDescription}
          onChange={(e) => setNewDescription(e.target.value)}
          className="bg-white shadow rounded cursor-pointer flex-grow p-2"
          onKeyDown={handleKeyDown}
        />
      ) : (
        <div
          className={`truncate bg-gray-100 rounded cursor-pointer flex-grow p-2 ${isComplete ? 'line-through' : ''}`}
          onClick={() => navigateToGoal(id)}
          onDoubleClick={() => setIsEditing(true)}
        >
          {name}
        </div>

      )}
      {
        showButtons && (
          <div className="relative group">
            <button
              className="p-2 rounded bg-gray-100 hover:bg-gray-200 relative justify-center flex items-center"
              onClick={handleTagButtonClick}
            >
              <FiTag />
              {tags.length > 0 && (
                <span className="absolute bottom-0 right-0 bg-gray-300 rounded-full text-xs px-1">
                  {tags.length}
                </span>
              )}
            </button>
            {showTagDropdown && (
              <div className="absolute right-full bottom-0 ml-1 w-40 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2">
                <ul>
                  {tags.map((tag, index) => (
                    <li key={index} className="flex justify-between items-center p-1 hover:bg-gray-200">
                      <span onClick={() => navigateToTag(tag)} className="cursor-pointer">
                        {tag}
                      </span>
                      <button onClick={() => removeTag(tag)} className="text-xs p-1">
                        <FiX />
                      </button>
                    </li>
                  ))}
                </ul>
                <input
                  type="text"
                  value={newTag}
                  onChange={(e) => setNewTag(e.target.value)}
                  onKeyDown={handleNewTagKeyDown}
                  className="w-full p-1 mt-2 border rounded"
                  placeholder={"Add tag: " + placeholderTag}
                />
              </div>
            )}
          </div>
        )
      }
      {showButtons && !isEditing && (
        <>
          <button
            className="p-2 rounded bg-gray-100 hover:bg-gray-200"
            onClick={() => setIsEditing(!isEditing)}
          >
            <FiEdit />
          </button>
          <button
            className="p-2 rounded bg-gray-100 hover:bg-gray-200"
            onClick={deleteGoal}
          >
            <FiTrash />
          </button>
        </>
      )}
      {showButtons && isEditing && (
        <>
          <button
            className="p-2 rounded bg-teal-100 hover:bg-teal-200"
            onClick={updateGoal}
          >
            <FiSave />
          </button>
          <button
            className="p-2 rounded bg-red-100 hover:bg-red-200"
            onClick={cancelUpdateGoal}
          >
            <FiX />
          </button>
        </>
      )}
      <button
        className="p-2 rounded bg-gray-100 hover:bg-gray-200"
        onClick={() => console.log("menu")}
      >
        <FiMenu />
      </button>
    </div>
  );
};

function Harvest({
  host,
  name,
  goalKey,
  method,
  tags,
  refresh,
}: {
  host: any;
  name: any;
  goalKey: any;
  method: string;
  tags: string[];
  refresh: () => void;
}) {
  const isPool = goalKey == null;
  const [goals, setGoals] = useState<Goal[]>([]);
  const [filteredGoals, setFilteredGoals] = useState<Goal[]>(goals); // State for filtered goals

  const { showButtons, setShowButtons } = useStore(state => ({ 
      showButtons: state.showButtons, 
      setShowButtons: state.setShowButtons 
    }));

  useEffect(() => {
    console.log("host: " + host);
    console.log("name: " + name);
    console.log("goalKey: " + goalKey);
    const fetchGoals = async () => {
      try {
        let fetchedGoals;
        const isMain = host === null && name === null && goalKey === null;
        if (isMain) {
          fetchedGoals = await api.mainHarvest(method, tags);
        } else if (host && name && goalKey != null) {
          fetchedGoals = await api.goalHarvest(`/${host}/${name}/${goalKey}`, method, tags);
        } else {
          fetchedGoals = await api.poolHarvest(`/${host}/${name}`, method, tags);
        }
        setGoals(fetchedGoals);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
  
    fetchGoals();
  }, [refresh, host, name, goalKey, method, tags]);

  // Function to filter goals by selected tags
  useEffect(() => {
    if (tags.length === 0) {
      // If no tags are selected, show all goals
      setFilteredGoals(goals);
    } else {
      // Filter goals based on selected tags and method
      const filtered = goals.filter((goal) => {
        if (goal.tags) {
          if (method === 'every') {
            // Filter goals that have ALL of the selected tags
            return tags.every((tag) => goal.tags?.includes(tag));
          } else if (method === 'some') {
            // Filter goals that have ANY of the selected tags
            return tags.some((tag) => goal.tags?.includes(tag));
          }
        }
        return false;
      });
      setFilteredGoals(filtered);
    }
  }, [refresh, goals, method, tags]);

  const moveGoalUp = async (id: string) => {
    const index = _.findIndex(goals, { id });
    if (index > 0) {
      try {
        const aboveGoalId = goals[index - 1].id;
        if (isPool) {
          await api.rootsSlotAbove(id, aboveGoalId);
        } else {
          await api.youngSlotAbove(`/${host}/${name}/${goalKey}`, id, aboveGoalId);
        }
        refresh();
      } catch (error) {
        console.error("Error reordering", error);
      }
    }
  };
  
  const moveGoalDown = async (id: string) => {
    const index = _.findIndex(goals, { id });
    if (index >= 0 && index < goals.length - 1) {
      const belowGoalId = goals[index + 1].id;
      try {
        if (isPool) {
          await api.rootsSlotBelow(id, belowGoalId);
        } else {
          await api.youngSlotBelow(`/${host}/${name}/${goalKey}`, id, belowGoalId);
        }
        refresh();
      } catch (error) {
        console.error("Error reordering", error);
      }
    }
  };

  return (
    <>
      <label className="flex items-center space-x-2">
        <input 
          type="checkbox" 
          checked={showButtons} 
          onChange={() => setShowButtons(!showButtons)} 
          className="form-checkbox rounded"
        />
        <span>Show Buttons</span>
      </label>
      <ul>
        {filteredGoals.map((goal, index) => (
          <div
            key={goal.id}
            className="block text-current no-underline hover:no-underline"
          >
            <GoalRow
              host={host}
              poolName={name}
              name={goal.description}
              id={goal.id}
              complete={goal.complete}
              actionable={goal.actionable}
              showButtons={showButtons}
              refresh={refresh}
              tags={goal.tags}
              moveGoalUp={moveGoalUp}
              moveGoalDown={moveGoalDown}
            />
          </div>
        ))}
      </ul>
    </>
  );
};

export default Harvest;
