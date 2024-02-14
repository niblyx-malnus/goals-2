import React, { useState, useEffect, useRef } from 'react';
import { FiPlus, FiX, FiTrash, FiTag, FiEye, FiEyeOff } from 'react-icons/fi';
import { Tag, Goal } from '../../types';
import { periodType } from './types';
import { formatDate } from '../dateUtils';
import { isPeriodType, determinePath, formatDateDisplay, formatNowDisplay, navigateDate } from './helpers';
import api from '../../api';

const TodoRow = ({
  goal,
  onToggleComplete,
  onDelete,
  onRemove,
  onAddToTodoList,
}: {
  goal: Goal,
  onToggleComplete: (id: string) => void,
  onDelete: (id: string) => void,
  onRemove: (id: string) => void,
  onAddToTodoList: (path: string, key: string) => void
}) => {
  const [panel, setPanel] = useState('');
  const [listType, setListType] = useState<periodType>('day');
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [newTag, setNewTag] = useState('');
  const [newTagIsPublic, setNewTagIsPublic] = useState(true);
  
  const rowRef = useRef<HTMLLIElement>(null);

  useEffect(() => {
    // Function to check if clicked outside of element
    const handleClickOutside = (event: { target: any; }) => {
      if (rowRef.current && !rowRef.current.contains(event.target)) {
        setPanel(''); // Close the panel
      }
    };
  
    // Add event listener when the component mounts
    document.addEventListener("mousedown", handleClickOutside);
  
    // Cleanup event listener
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, []);

  const togglePlusPanel = () => {
    if (panel === '') {
      setPanel('plus');
    } else {
      setPanel('');
    }
  }

  // Toggle dropdown visibility
  const toggleTagDropdown = () => {
    if (panel === 'tag') {
      setPanel('');
    } else {
      setPanel('tag');
    }
  };

  const AddPanel = () => {
    const path = determinePath(listType, selectedDate);
  
    // Check if the selected selectedDate is today for the "Now" button
    const isTodaySelected = formatDate(new Date()) === formatDate(selectedDate);

    const handleListTypeChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
      const newValue = e.target.value;
      if (isPeriodType(newValue)) {
        setListType(newValue);
      } else {
        console.error(`${newValue} is not a valid periodType`);
        // Handle the error appropriately
      }
    };
    
    return (
      <div className="z-10 absolute right-0 bottom-full mt-2 w-64 bg-white p-4 shadow-lg rounded-lg">
        <div className="flex justify-center mb-4">
          <select
            value={listType}
            onChange={handleListTypeChange}
            className="max-w-20 mr-2 px-3 py-2 bg-gray-200 text-gray-800 rounded-md"
          >
            <option value="day">Day</option>
            <option value="week">Week</option>
            <option value="month">Month</option>
            <option value="quarter">Quarter</option>
            <option value="year">Year</option>
          </select>
          <button 
            className={`w-28 px-3 py-1 text-sm font-medium rounded-md ${isTodaySelected ? 'bg-gray-400 text-white' : 'bg-blue-500 text-white'}`}
            onClick={() => !isTodaySelected && setSelectedDate(new Date())}
            disabled={isTodaySelected}>
            {formatNowDisplay(listType)}
          </button>
        </div>
        <div className="flex items-center justify-between mb-4">
          <button 
            className="p-2 rounded-md bg-gray-200 text-gray-800" 
            onClick={() => setSelectedDate(navigateDate(selectedDate, listType, 'prev'))}>
            ←
          </button>
          <span className="text-sm text-center font-medium">
            {formatDateDisplay(listType, selectedDate)}
          </span>
          <button 
            className="p-2 rounded-md bg-gray-200 text-gray-800" 
            onClick={() => setSelectedDate(navigateDate(selectedDate, listType, 'next'))}>
            →
          </button>
        </div>
        <button 
          className="w-full px-4 py-2 bg-blue-500 text-white rounded-md text-sm font-medium hover:bg-blue-600" 
          onClick={() => onAddToTodoList(path, goal.key)}>
          Add to {listType} list
        </button>
      </div>
    );
  };
  
  const toggleComplete = () => {
    onToggleComplete(goal.key);
  }

  const addNewTag = async () => {
    try {
      // Logic to add the new tag to the goal
      // For example, update the tags array and send a request to the backend
      if (newTag.trim() !== '') {
        await api.addGoalTag(goal.key, newTagIsPublic, newTag);
        setNewTag(''); // Reset input field
        await api.updateSetting('put', 'placeholder-tag', newTag);
      } else {
        await api.addGoalTag(goal.key, newTagIsPublic, 'placeholder');
      }
    } catch (error) {
      console.error("Error adding new tag: ", error);
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
    } catch (error) {
      console.error("Error removing tag: ", error);
    }
  };

  const handleNewTagKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'Enter') {
      addNewTag();
    }
  };

  return (
    <li ref={rowRef} className={`flex justify-between items-center mb-2 p-2 ${goal.complete ? 'bg-gray-200' : 'bg-white'} rounded shadow`}>
      <span
        className={`flex-1 cursor-pointer ${goal.complete ? 'line-through' : ''}`}
        onClick={toggleComplete}
      >
        {goal.summary}
      </span>
      <div className="relative group">
        <button
          onClick={togglePlusPanel}
          className="mr-1 bg-gray-300 hover:bg-gray-500 font-bold py-1 px-1 rounded"
        >
          <FiPlus />
        </button>
        {panel === 'plus' && <AddPanel />}
      </div>
      <div className="relative group">
        <button
          className="mr-1 bg-gray-300 hover:bg-gray-400 font-bold py-1 px-1 rounded"
          onClick={handleTagButtonClick}
        >
        <FiTag />
          {goal.tags.length > 0 && (
            <span className="absolute bottom-0 right-0 bg-gray-300 rounded-full text-xs px-1">
              {goal.tags.length}
            </span>
          )}
        </button>
        {panel === 'tag' && (
          <div className="absolute right-full bottom-0 ml-1 w-40 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2">
            <ul>
              {goal.tags.map((tag, index) => (
                <li key={index} className="flex justify-between items-center p-1 hover:bg-gray-200">
                  { tag.isPublic
                    ?  <FiEye className="mr-2"/>
                    : <FiEyeOff className="mr-2"/>
                  }
                  <span
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
                placeholder={"Add tag " }
                style={{ height: '2rem' }} // Match the height of the button
              />
            </div>
          </div>
        )}
      </div>
      <button
        onClick={() => onRemove(goal.key)}
        className="mr-1 bg-gray-300 hover:bg-gray-500 font-bold py-1 px-1 rounded"
      >
        <FiX />
      </button>
      <button
        onClick={() => {
          const isConfirmed = window.confirm("Deleting a goal is irreversible. Are you sure you want to delete this goal?");
          if (isConfirmed) {
            onDelete(goal.key);
          }
        }}
        className="bg-gray-300 hover:bg-gray-500 font-bold py-1 px-1 rounded"
      >
        <FiTrash />
      </button>
    </li>
  );
};

export default TodoRow;