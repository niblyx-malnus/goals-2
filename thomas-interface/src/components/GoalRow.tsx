import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import { FiCopy, FiTag, FiX, FiEdit, FiTrash, FiSave, FiMenu, FiInfo, FiEye, FiEyeOff, FiCheck, FiPlay, FiSquare, FiPlus } from 'react-icons/fi';
import { getWeekDay, getMonday, addDays, formatDate } from './dateUtils';
import useStore from '../store';
import { Tag, Goal } from '../types';

const GoalRow: React.FC<{
    host: string,
    poolName: string,
    goal: Goal,
    showButtons: boolean,
    tags: Tag[],
    refresh: () => void,
    moveGoalUp: (goalId: string) => void,
    moveGoalDown: (goalId: string) => void
  }> = ({
    host,
    poolName,
    goal,
    showButtons,
    tags,
    refresh,
    moveGoalUp,
    moveGoalDown
  }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [newDescription, setNewDescription] = useState(goal.summary);
  const [isActionable, setIsActionable] = useState(goal.actionable);
  const [isComplete, setisComplete] = useState(goal.complete);
  const [panel, setPanel] = useState('');
  const [newTag, setNewTag] = useState('');
  const rowRef = useRef<HTMLDivElement>(null);
  const [newTagIsPublic, setNewTagIsPublic] = useState(true);
  const [isActive, setIsActive] = useState(goal.active);
  const [listType, setListType] = useState<'day' | 'week'>('day');
  const [selectedDate, setSelectedDate] = useState(new Date());

  const pid = `/${host}/${poolName}`;

  const toggleInfoPanel = () => {
    if (panel === 'info') {
      setPanel('');
    } else {
      setPanel('info');
    }
  };

  const toggleAddPanel = () => {
    if (panel === 'add') {
      setPanel('');
    } else {
      setPanel('add');
    }
  };

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
  
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (rowRef.current && !rowRef.current.contains(event.target as Node)) {
        setPanel('');
      }
    };

    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [rowRef]);

  const deleteGoal = async () => {
    // Show confirmation dialog
    const isConfirmed = window.confirm("Deleting a goal is irreversible. Are you sure you want to delete this goal?");
  
    // Only proceed if the user confirms
    if (isConfirmed) {
      try {
        await api.deleteGoal(pid, goal.key);
        refresh();
      } catch (error) {
        console.error(error);
      }
    }
  };


  const updateGoal = async () => {
    try {
      console.log("updating goal...");
      await api.setGoalSummary(pid, goal.key, newDescription);
      refresh();
      setIsEditing(false);
    } catch (error) {
      console.error(error);
    }
  };

  const cancelUpdateGoal = async () => {
    try {
      setNewDescription(goal.summary);
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

  const navigateToGoal = (gid: string) => {
    navigate(`/goal${pid}${gid}`);
  };

  const navigateToPoolTag = (tag: string) => {
    navigate(`/pool-tag/${host}/${poolName}/${tag}`);
  };

  const navigateToLocalTag = (tag: string) => {
    navigate(`/local-tag/${tag}`);
  };

  const toggleActionable = async () => {
    try {
      await api.setGoalActionable(goal.key, !isActionable);
      const actionable = await api.getGoalActionable(pid, goal.key);
      setIsActionable(actionable);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };
  
  const toggleComplete = async () => {
    try {
      await api.setGoalComplete(pid, goal.key, !isComplete);
      const complete = await api.getGoalComplete(pid, goal.key);
      setisComplete(complete);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };
  
  const copyToClipboard = () => {
    navigator.clipboard.writeText(goal.key);
  }

  // Toggle dropdown visibility
  const toggleTagDropdown = () => {
    if (panel === 'tag') {
      setPanel('');
    } else {
      setPanel('tag');
    }
  };

  const addNewTag = async () => {
    try {
      // Logic to add the new tag to the goal
      // For example, update the tags array and send a request to the backend
      if (newTag.trim() !== '') {
        await api.addGoalTag(`${pid}${goal.key}`, newTagIsPublic, newTag);
        setNewTag(''); // Reset input field
        await api.updateSetting('put', 'placeholder-tag', newTag);
        const fetchedTag = await api.getSetting("placeholder-tag");
        setPlaceholderTag(fetchedTag || 'today');
        refresh();
      } else {
        await api.addGoalTag(`${pid}${goal.key}`, newTagIsPublic, placeholderTag);
        const fetchedTag = await api.getSetting("placeholder-tag");
        setPlaceholderTag(fetchedTag || 'today');
        refresh();
      }
    } catch (error) {
      console.error("Error adding new tag: ", error);
    }
  };

  const handleNewTagKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'Enter') {
      addNewTag();
    }
  };

  const handleTagButtonClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    if (event.shiftKey) {
      // Shift+Click: Add placeholder tag directly
      addNewTag();
    } else {
      // Regular Click: Toggle dropdown
      toggleTagDropdown();
    }
  };

  const removeTag = async (tagToRemove: Tag) => {
    try {
      // Logic to remove the tag from the goal
      // For example, update the tags array and send a request to the backend
      await api.delGoalTag(`${goal.key}`, tagToRemove.isPublic, tagToRemove.tag);
      refresh();
    } catch (error) {
      console.error("Error removing tag: ", error);
    }
  };

  const toggleActive = async () => {
    const newActiveState = !isActive;
    try {
      await api.setGoalActive(pid, goal.key, newActiveState);
      setIsActive(newActiveState); // Update the local state to reflect the change
      refresh(); // Call refresh to update the UI based on the new state
    } catch (error) {
      console.error("Error toggling goal active state:", error);
    }
  };

  const StatusIcon = () => {
    if (goal.complete) {
      return <FiCheck />;
    } else if (isActive) {
      return <button onClick={toggleActive} className="icon-button"><FiSquare /></button>;
    } else {
      return <button onClick={toggleActive} className="icon-button"><FiPlay /></button>;
    }
  };

  const AddPanel = () => {
    const navigateDate = (direction: 'prev' | 'next') => {
      const adjustment = listType === 'day' ? 1 : 7;
      const newDate = addDays(selectedDate, direction === 'next' ? adjustment : -adjustment);
      setSelectedDate(newDate);
    };
  
    // Check if the selected date is today for the "Now" button
    const isTodaySelected = formatDate(new Date()) === formatDate(selectedDate);
    
    return (
      <div className="z-10 absolute right-0 bottom-full mt-2 w-64 bg-white p-4 shadow-lg rounded-lg">
        <div className="flex justify-between mb-4">
          <button 
            className={`px-3 py-1 text-sm font-medium rounded-md ${listType === 'day' ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-800'} mr-1`} 
            onClick={() => setListType('day')}>
            Day
          </button>
          <button 
            className={`px-3 py-1 text-sm font-medium rounded-md ${isTodaySelected ? 'bg-gray-400 text-white' : 'bg-blue-500 text-white'} mr-1`} 
            onClick={() => !isTodaySelected && setSelectedDate(new Date())}
            disabled={isTodaySelected}>
            Now
          </button>
          <button 
            className={`px-3 py-1 text-sm font-medium rounded-md ${listType === 'week' ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-800'}`} 
            onClick={() => setListType('week')}>
            Week
          </button>
        </div>
        <div className="flex items-center justify-between mb-4">
          <button 
            className="p-2 rounded-md bg-gray-200 text-gray-800" 
            onClick={() => navigateDate('prev')}>
            ←
          </button>
          <span className="text-sm text-center font-medium">
            {listType === 'day' ? `${getWeekDay(selectedDate)}, ${formatDate(selectedDate)}` : `Week of ${formatDate(getMonday(selectedDate))}`}
          </span>
          <button 
            className="p-2 rounded-md bg-gray-200 text-gray-800" 
            onClick={() => navigateDate('next')}>
            →
          </button>
        </div>
        <button 
          className="w-full px-4 py-2 bg-blue-500 text-white rounded-md text-sm font-medium hover:bg-blue-600" 
          onClick={addGoalToTodoList}>
          Add to {listType} list
        </button>
      </div>
    );
  };

  const addGoalToTodoList = async () => {
    const formattedDate = formatDate(selectedDate);
    const dateKey = listType === 'day' ? formattedDate : formatDate(getMonday(selectedDate));
    const path = `/period/${listType}/${dateKey}.json`;
  
    let data = { keys:[], themes: [] };
  
    try {
      try {
        // Try reading existing data
        const existingData = await api.jsonRead(path);
        if (existingData) data = existingData;
      } catch (error) {
        console.log(`Creating new ${listType} list for ${dateKey}.`);
      }
  
      const updatedKeys = [`${pid}${goal.key}`, ...data.keys];
      await api.jsonPut(path, { ...data, keys: updatedKeys });
      alert('Goal added to TodoList successfully');
      refresh();
    } catch (error) {
      console.error('Failed to add goal to TodoList:', error);
      alert('Failed to add goal to TodoList');
    }
  };
  
  return (
    <div ref={rowRef} className={`flex justify-between items-center mt-2 rounded ${isActionable ? 'border-4 border-gray-400 box-border' : 'p-1' } hover:bg-gray-300 bg-gray-200`}>
      {
        showButtons && (
          <>
            <button
              className="p-2 rounded bg-gray-100 hover:bg-gray-200"
            >
              <StatusIcon />
            </button>
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
            <button onClick={() => moveGoalUp(goal.key)} className="p-2 rounded bg-gray-100 hover:bg-gray-200">
              ↑
            </button>
            <button onClick={() => moveGoalDown(goal.key)} className="p-2 rounded bg-gray-100 hover:bg-gray-200">
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
          onClick={() => navigateToGoal(goal.key)}
          onDoubleClick={() => setIsEditing(true)}
        >
          {goal.summary}
        </div>
      )}
      { 
        showButtons && (
          <div className="relative group">
            <button
              onClick={toggleAddPanel}
              className="p-2 rounded bg-gray-100 hover:bg-gray-200"
            >
              <FiPlus />
            </button>
            {panel === 'add' && <AddPanel />}
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
            {panel === 'tag' && (
              <div className="absolute right-full bottom-0 ml-1 w-40 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2">
                <ul>
                  {tags.map((tag, index) => (
                    <li key={index} className="flex justify-between items-center p-1 hover:bg-gray-200">
                      { tag.isPublic
                        ?  <FiEye className="mr-2"/>
                        : <FiEyeOff className="mr-2"/>
                      }
                      <span
                        onClick={() => tag.isPublic ? navigateToPoolTag(tag.tag) : navigateToLocalTag(tag.tag)}
                        className="cursor-pointer"
                      >
                        {tag.tag}
                      </span>
                      <button onClick={() => removeTag(tag)} className="text-xs p-1">
                        <FiX />
                      </button>
                    </li>
                  ))}
                </ul>
                <div className="flex items-center">
                  <button
                    onClick={() => setNewTagIsPublic(!newTagIsPublic)}
                    className="p-2 mr-2 border border-gray-300 rounded hover:bg-gray-200 flex items-center justify-center"
                    style={{ height: '2rem', width: '2rem' }} // Adjust the size as needed
                  >
                    {newTagIsPublic ? <FiEye /> : <FiEyeOff />}
                  </button>
                  <input
                    type="text"
                    value={newTag}
                    onChange={(e) => setNewTag(e.target.value)}
                    onKeyDown={handleNewTagKeyDown}
                    className="w-full p-1 border rounded"
                    placeholder={"Add tag: " + placeholderTag}
                    style={{ height: '2rem' }} // Match the height of the button
                  />
                </div>
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
      <div className="relative group">
        <button
          className="p-2 rounded bg-gray-100 hover:bg-gray-200"
          onClick={toggleInfoPanel}
        >
          <FiInfo />
        </button>
        {
          panel === 'info' && (
            <div className="absolute right-full bottom-0 ml-1 w-40 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2">
              <p>Info Panel</p>
              {/* Place your info content here */}
            </div>
          )
        }
      </div>
      <button
        className="p-2 rounded bg-gray-100 hover:bg-gray-200"
        onClick={() => console.log("menu")}
      >
        <FiMenu />
      </button>
    </div>
  );
};

export default GoalRow;