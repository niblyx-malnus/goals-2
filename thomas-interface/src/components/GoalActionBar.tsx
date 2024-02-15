import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import { FiPlay, FiPause, FiTriangle, FiArchive, FiCircle, FiTag, FiX, FiInfo, FiEye, FiEyeOff, FiCopy, FiPlus, FiLock } from 'react-icons/fi';
import { getWeekDay, getMonday, addDays, formatDate } from './dateUtils';
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

const ActionableIcon = (actionable: boolean) => {
  if (actionable) {
    return <FiTriangle />;
  } else {
    return <FiCircle />;
  }
};

const ActiveIcon = (active: boolean) => {
  if (active) {
    return <FiPause />;
  } else {
    return <FiPlay />;
  }
};

const GoalActionBar: React.FC<{
    goal: Goal,
    refresh: () => void,
    toggleEdit: () => void,
  }> = ({
    goal,
    toggleEdit,
    refresh,
  }) => {
  const [panel, setPanel] = useState('');
  const [newTag, setNewTag] = useState('');
  const barRef = useRef<HTMLDivElement>(null);
  const [newTagIsPublic, setNewTagIsPublic] = useState(true);
  const [listType, setListType] = useState<'day' | 'week'>('day');
  const [selectedDate, setSelectedDate] = useState(new Date());

  const { pid } = api.goalKeyToPidGid(goal.key);

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
      if (barRef.current && !barRef.current.contains(event.target as Node)) {
        setPanel('');
      }
    };

    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [barRef]);

  const navigate = useNavigate();

  const navigateToPoolTag = (tag: string) => {
    navigate(`/pool-tag${pid}/${tag}`);
  };

  const navigateToLocalTag = (tag: string) => {
    navigate(`/local-tag/${tag}`);
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

  const AddPanel = () => {
    const navigateDate = (direction: 'prev' | 'next') => {
      const adjustment = listType === 'day' ? 1 : 7;
      const newDate = addDays(selectedDate, direction === 'next' ? adjustment : -adjustment);
      setSelectedDate(newDate);
    };
  
    // Check if the selected date is today for the "Now" button
    const isTodaySelected = formatDate(new Date()) === formatDate(selectedDate);
    
    return (
      <div>
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

  const InfoPanel = () => {
    return (
      <div>
        <p>Info Panel</p>
        {/* Place your info content here */}
      </div>
    );
  };

  const TagPanel = () => {
    return (
      <div>
        <ul>
          {goal.tags.map((tag, index) => (
            <li key={index} className="flex justify-between items-center p-1">
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
            className="p-2 mr-2 border border-gray-300 rounded flex items-center justify-center"
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

  const copyToClipboard = () => {
    setPanel('');
    navigator.clipboard.writeText(goal.key);
  }
  
  return (
    <div ref={barRef} className="p-1 relative group bg-gray-200 flex items-center">
      <button
        className="p-2 rounded bg-gray-100"
        onClick={copyToClipboard}
      >
        <FiCopy />
      </button>
      <button
        onClick={toggleAddPanel}
        className="p-2 rounded bg-gray-100"
      >
        <FiPlus />
      </button>
      <button
        className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
      >
        <TagIcon />
      </button>
      <div className="relative group">
        <button
          className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
          onClick={handleTagButtonClick}
        >
          <FiTag />
          {goal.tags.length > 0 && (
            <span className="absolute top-0 right-0 bg-gray-300 rounded-full text-xs px-1">
              {goal.tags.length}
            </span>
          )}
        </button>
      </div>
      <button
        className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
      >
        {ActionableIcon(goal.actionable)}
      </button>
      <button
        className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
      >
        {ActiveIcon(goal.active)}
      </button>
      <button
        className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
      >
        <FiArchive />
      </button>
      <div className="relative group">
        <button
          className="p-2 rounded bg-gray-100"
          onClick={toggleInfoPanel}
        >
          <FiInfo />
        </button>
        { panel !== '' && (
          <div className="z-10 absolute right-0 bottom-full mt-2 w-64 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2">
            {panel === 'add' && <AddPanel />}
            {panel === 'tag' && <TagPanel />}
            { panel === 'info' && <InfoPanel /> }
          </div>
        )}
      </div>
    </div>
  );
};

export default GoalActionBar;