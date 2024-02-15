import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import { FiSquare, FiCheckSquare, FiTag, FiX, FiEdit, FiTrash, FiSave, FiMenu, FiCheck, FiPlay, FiLock } from 'react-icons/fi';
import { getWeekDay, getMonday, addDays, formatDate } from './dateUtils';
import GoalActionBar from './GoalActionBar';
import useStore from '../store';
import { Tag, Goal } from '../types';

const TagIcon = () => {
  return (
    <div>
      <FiTag />
      <span className="p-1 absolute bottom-[-2px] right-[-2px] rounded-full text-xs">
        <FiLock />
      </span>
    </div>
  );
};

const GoalRow: React.FC<{
    host: string,
    poolName: string,
    goal: Goal,
    showButtons: boolean,
    refresh: () => void,
    moveGoalUp: (goalId: string) => void,
    moveGoalDown: (goalId: string) => void
  }> = ({
    host,
    poolName,
    goal,
    showButtons,
    refresh,
    moveGoalUp,
    moveGoalDown
  }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [newDescription, setNewDescription] = useState(goal.summary);
  const [isActionable, setIsActionable] = useState(goal.actionable);
  const [panel, setPanel] = useState('');
  const [newTag, setNewTag] = useState('');
  const rowRef = useRef<HTMLDivElement>(null);
  const [newTagIsPublic, setNewTagIsPublic] = useState(true);
  const [isActive, setIsActive] = useState(goal.active);
  const [listType, setListType] = useState<'day' | 'week'>('day');
  const [selectedDate, setSelectedDate] = useState(new Date());

  const pid = `/${host}/${poolName}`;

  const toggleActionBar = () => {
    if (panel === 'action-bar') {
      setPanel('');
    } else {
      setPanel('action-bar');
    }
  };

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

  const toggleEdit = () => { setIsEditing(!isEditing); }

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
        await api.deleteGoal(goal.key);
        refresh();
      } catch (error) {
        console.error(error);
      }
    }
  };


  const updateGoal = async () => {
    try {
      console.log("updating goal...");
      await api.setGoalSummary(goal.key, newDescription);
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
      const actionable = await api.getGoalActionable(goal.key);
      setIsActionable(actionable);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };
  
  const toggleComplete = async () => {
    try {
      await api.setGoalComplete(goal.key, !goal.complete);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };

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
      await api.setGoalActive(goal.key, newActiveState);
      setIsActive(newActiveState); // Update the local state to reflect the change
      refresh(); // Call refresh to update the UI based on the new state
    } catch (error) {
      console.error("Error toggling goal active state:", error);
    }
  };

  const CompleteIcon = () => {
    if (goal.complete) {
      return <FiCheckSquare />;
    } else {
      return <FiSquare />;
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
              className="p-2 rounded bg-gray-100"
              onClick={toggleComplete}
            >
              <CompleteIcon />
            </button>
          </>
        )
      }
      {isEditing ? (
        <input 
          type="text" 
          value={newDescription}
          onChange={(e) => setNewDescription(e.target.value)}
          className="truncate bg-white shadow rounded cursor-pointer flex-grow p-2"
          onKeyDown={handleKeyDown}
        />
      ) : (
        <div
          className={`truncate bg-gray-100 rounded cursor-pointer flex-grow p-2 ${goal.complete ? 'line-through' : ''}`}
          onClick={() => navigateToGoal(goal.key)}
          onDoubleClick={toggleEdit}
        >
          {goal.summary}
        </div>
      )}
      {showButtons && !isEditing && (
        <>
          <button
            className="p-2 rounded bg-gray-100"
            onClick={() => setIsEditing(!isEditing)}
          >
            <FiEdit />
          </button>
          <button
            className="p-2 rounded bg-gray-100"
            onClick={deleteGoal}
          >
            <FiTrash />
          </button>
        </>
      )}
      {showButtons && isEditing && (
        <>
          <button
            className="p-2 rounded bg-gray-100 hover:bg-gray-200"
            onClick={updateGoal}
          >
            <FiSave />
          </button>
          <button
            className="p-2 rounded bg-gray-100 hover:bg-gray-200"
            onClick={cancelUpdateGoal}
          >
            <FiX />
          </button>
        </>
      )}
      <div className="relative group">
        <button
          className="p-2 rounded bg-gray-100"
          onClick={toggleActionBar}
        >
          <FiMenu />
        </button>
        {
          panel === 'action-bar' && (
            <div className="absolute right-0 bottom-8 shadow-2xl rounded-md">
              <GoalActionBar goal={goal} toggleEdit={toggleEdit} refresh={refresh} />
            </div>
          )
        }
      </div>
    </div>
  );
};

export default GoalRow;