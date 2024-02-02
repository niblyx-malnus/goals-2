import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { FiTrash, FiEdit, FiSave, FiX, FiCalendar, FiTag } from 'react-icons/fi';
import { WeeklyTarget, Weekday } from './types';
import useStore, { StoreState, StoreActions } from './store';
import api from '../../api';

const weekDays: Weekday[] = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

const serverFolderPath = '/weekly_goals';

interface WeeklyTargetRowProps {
  id: string;
  weeklyTarget: WeeklyTarget;
  triggerRefresh: () => void;
}

const WeeklyTargetRow: React.FC<WeeklyTargetRowProps> = ({ 
  id,
  weeklyTarget,
  triggerRefresh
}) => {
  const [editing, setEditing] = useState(false);
  const [editDescription, setEditDescription] = useState(weeklyTarget.description);
  const [newTag, setNewTag] = useState('');
  const [panel, setPanel] = useState('');
  const [dropdownOpen, setDropdownOpen] = useState(false);

  const rowRef = useRef<HTMLDivElement>(null);

  const navigate = useNavigate();

  const handleRowClick = () => {
    navigate(`/weekly_targets/${id}`);
  };

  useEffect(() => {
    // Function to check if clicked outside of the row
    function handleClickOutside(event: MouseEvent) {
      if (rowRef.current && !rowRef.current.contains(event.target as Node)) {
        setPanel('');
        setDropdownOpen(false); // Close dropdowns
      }
    }

    // Bind the event listener
    document.addEventListener("mousedown", handleClickOutside);

    // Cleanup function to unbind the event listener
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [rowRef]);

  const handleInputFocus = () => {
    setDropdownOpen(true);
  };

  const handleInputBlur = () => {
    setTimeout(() => {
      setDropdownOpen(false);
    }, 100);
  };
  
  const handleAddTag = async (newTag: string) => {
    if (newTag.trim() !== '' && !weeklyTarget.tags.includes(newTag)) {
      setNewTag('');
      const cleanTag = newTag.trim().toLowerCase();
      const newWeeklyTarget: WeeklyTarget = { ...weeklyTarget, tags: [...weeklyTarget.tags, cleanTag] };
      setWeeklyTarget(id, newWeeklyTarget);
      await saveWeeklyTargetToServer(id, newWeeklyTarget);
      triggerRefresh();
    }
  };
  
  const handleRemoveTag = async (tag: string) => {
    const newState = { ...weeklyTarget, tags: weeklyTarget.tags.filter((t: string) => t !== tag) };
    setWeeklyTarget(id, newState);
    await saveWeeklyTargetToServer(id, newState);
    triggerRefresh();
  };

  const setWeeklyTarget = useStore((state: StoreState & StoreActions) => state.setWeeklyTarget);
  const delWeeklyTarget = useStore((state: StoreState & StoreActions) => state.delWeeklyTarget);
  const getAllTags = useStore((state: StoreState & StoreActions) => state.getAllTags);

  const saveWeeklyTargetToServer = async (id: string, weeklyTarget: WeeklyTarget) => {
    try {
      await api.jsonPut(`${serverFolderPath}/${id}.json`, weeklyTarget);
    } catch (error) {
      console.error('Error saving weekly goal to server:', error);
    }
  };

  const applyEditLocal = async () => {
    if (editDescription.trim() !== '') {
      const updatedTarget = { ...weeklyTarget, description: editDescription };
      setWeeklyTarget(id, updatedTarget);
      await saveWeeklyTargetToServer(id, updatedTarget);
    }
    setEditing(false);
  };

  const cancelEdit = () => {
    setEditing(false);
    setEditDescription(weeklyTarget.description);
  };

  const confirmAndDeleteWeeklyTarget = async () => {
    const confirmed = window.confirm("Are you sure you want to delete this weekly goal?");
    if (confirmed) {
      delWeeklyTarget(id);
      await api.jsonDel(`${serverFolderPath}/${id}.json`);
      triggerRefresh();
    }
  };

  const handleKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'Enter') {
      applyEditLocal();
    } else if (event.key === 'Escape') {
      cancelEdit();
    }
  };

  const toggleTagsPanel = () => {
    if (panel === 'tags') {
        setPanel('');
    } else {
      setPanel('tags');
    }
  };

  const getCurrentWeekKey = (): string => {
    const today = new Date();
    const dayOfWeek = today.getDay();
    const diff = dayOfWeek === 0 ? -6 : 1 - dayOfWeek; // Calculate difference to last Monday
    today.setDate(today.getDate() + diff);
    const year = today.getFullYear();
    const month = today.getMonth() + 1; // getMonth() is zero-based
    const day = today.getDate();
    return `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;
  };

  const currentWeekKey = getCurrentWeekKey();
  const weekExists = weeklyTarget.weeks[currentWeekKey] !== undefined;

  const calculateCumulativeValue = (): string => {
    if (!weekExists) return '-';
    const entries = weeklyTarget.weeks[currentWeekKey]?.entries || {};
    const cumulative = weekDays.reduce((acc, day) => acc + (entries[day] || 0), 0);
    return cumulative.toString();
  };

  const getCumulativeAndTargetDisplay = (): string => {
    if (!weekExists) return '- / -';
    const cumulative = calculateCumulativeValue();
    const target = weeklyTarget.weeks[currentWeekKey]?.target;
    return `${cumulative} / ${target !== null ? target : '-'}`;
  };

  const isComparisonMet = (): boolean => {
    if (!weekExists || weeklyTarget.weeks[currentWeekKey]?.target === null) return false;
    const cumulative = parseInt(calculateCumulativeValue(), 10);
    const target = weeklyTarget.weeks[currentWeekKey].target;
    switch (weeklyTarget.weeks[currentWeekKey].type) {
      case '==': return cumulative === target;
      case '>=': return target === null ? false : cumulative >= target;
      case '<=': return target === null ? false : cumulative <= target;
      default: return false;
    }
  };

  return (
    <div ref={rowRef} className={`flex bg-gray-300 flex-grow justify-between items-center p-1 mb-2 rounded`}>
      <div className="ml-1 mr-1 flex-grow">
        {editing ? (
          <input 
            type="text"
            value={editDescription}
            onChange={(e) => setEditDescription(e.target.value)}
            onKeyDown={handleKeyDown}
            className="border border-gray-300 bg-gray-100 rounded w-full pl-1 pr-1"
          />
          // Additional editable fields for 'type', 'tags', etc.
        ) : (
          <>
          <div className="cursor-pointer" onClick={handleRowClick}>
            <span className="block text-gray-800">{weeklyTarget.description}</span>
          </div>
            {/* Display other properties of the weekly goal */}
          </>
        )}
      </div>
      <div className="flex items-center">
        <div className="p-1">
          <span style={{ color: isComparisonMet() ? 'green' : 'inherit' }}>
            {getCumulativeAndTargetDisplay()}
          </span>
        </div>
        <div className="relative group">
          <button
            className="m-1 cursor-pointer text-gray-800 relative justify-center flex items-center"
            onClick={toggleTagsPanel}
          >
            <FiTag />
            {weeklyTarget.tags.length > 0 && (
              <span className="absolute -bottom-1.5 -right-1.5 bg-gray-100 rounded-full text-xs px-1">
                {weeklyTarget.tags.length}
              </span>
            )}
          </button>
          {panel === 'tags' && (
            <div className="absolute right-0 top-full mt-1 z-10 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2 w-52">
              <input
                type="text"
                value={newTag}
                onChange={(e) => setNewTag(e.target.value)}
                onFocus={handleInputFocus}
                onBlur={handleInputBlur}
                onKeyDown={(e) => e.key === 'Enter' && handleAddTag(newTag)}
                className="p-1 border border-gray-300 rounded w-full"
                placeholder="Add Tag"
              />
              {dropdownOpen && (
                <div className="tag-list absolute bottom-full left-0 bg-gray-100 border rounded mt-1 w-48 max-h-60 overflow-auto">
                  {getAllTags().filter(tag => tag.toLowerCase().includes(newTag.toLowerCase()) && !weeklyTarget.tags.includes(tag)).map((tag, index) => (
                    <div
                      key={index}
                      className="tag-item flex items-center p-1 hover:bg-gray-200 cursor-pointer"
                      onClick={() => {
                        handleAddTag(tag);
                        setDropdownOpen(false);
                      }}
                      style={{ lineHeight: '1.5rem' }}
                    >
                      {tag}
                    </div>
                  ))}
                </div>
              )}
              <ul className="mt-2">
                {weeklyTarget.tags.map((tag, idx) => (
                  <li key={idx} className="flex justify-between items-center p-1 hover:bg-gray-200">
                    {tag}
                    <FiX className="cursor-pointer text-red-500" onClick={() => handleRemoveTag(tag)} />
                  </li>
                ))}
              </ul>
            </div>
          )}
        </div>
        {editing ? (
          <FiSave className="m-1 cursor-pointer text-gray-800" onClick={applyEditLocal} />
        ) : (
          <FiEdit className="m-1 cursor-pointer text-gray-800" onClick={() => setEditing(true)} />
        )}
        {editing ? (
          <FiX className="m-1 cursor-pointer text-gray-800" onClick={cancelEdit} />
        ) : (
          <FiTrash className="m-1 cursor-pointer text-gray-800" onClick={confirmAndDeleteWeeklyTarget} />
        )}
      </div>
    </div>
  );
};

export default WeeklyTargetRow;