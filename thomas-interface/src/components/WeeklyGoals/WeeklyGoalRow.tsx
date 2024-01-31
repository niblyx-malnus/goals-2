import React, { useState, useEffect } from 'react';
import { FiTrash, FiEdit, FiSave, FiX, FiCalendar, FiTag } from 'react-icons/fi';
import { WeeklyGoal } from './types';
import useStore, { StoreState, StoreActions } from './store';
import api from '../../api';

const serverFolderPath = '/weekly_goals';

interface WeeklyGoalRowProps {
  id: string;
  weeklyGoal: WeeklyGoal;
  triggerRefresh: () => void;
}

const WeeklyGoalRow: React.FC<WeeklyGoalRowProps> = ({ 
  id,
  weeklyGoal,
  triggerRefresh
}) => {
  const [editing, setEditing] = useState(false);
  const [editDescription, setEditDescription] = useState(weeklyGoal.description);
  const [editType, setEditType] = useState(weeklyGoal.type);
  const [editTags, setEditTags] = useState(weeklyGoal.tags);

  const setWeeklyGoal = useStore((state: StoreState & StoreActions) => state.setWeeklyGoal);
  const delWeeklyGoal = useStore((state: StoreState & StoreActions) => state.delWeeklyGoal);

  const saveWeeklyGoalToServer = async (id: string, weeklyGoal: WeeklyGoal) => {
    try {
      await api.jsonPut(`${serverFolderPath}/${id}.json`, weeklyGoal);
    } catch (error) {
      console.error('Error saving weekly goal to server:', error);
    }
  };

  const applyEditLocal = async () => {
    if (editDescription.trim() !== '') {
      const updatedGoal = { ...weeklyGoal, description: editDescription, type: editType, tags: editTags };
      setWeeklyGoal(id, updatedGoal);
      await saveWeeklyGoalToServer(id, updatedGoal);
    }
    setEditing(false);
  };

  const cancelEdit = () => {
    setEditing(false);
    setEditDescription(weeklyGoal.description);
    setEditType(weeklyGoal.type);
    setEditTags(weeklyGoal.tags);
  };

  const confirmAndDeleteWeeklyGoal = async () => {
    const confirmed = window.confirm("Are you sure you want to delete this weekly goal?");
    if (confirmed) {
      delWeeklyGoal(id);
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

  // Additional functions for editing and handling changes go here

  return (
    <div className={`flex bg-gray-300 flex-grow justify-between items-center p-1 mb-2 rounded`}>
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
            <span className="block text-gray-800">{weeklyGoal.description}</span>
            {/* Display other properties of the weekly goal */}
          </>
        )}
      </div>
      <div className="flex items-center">
        {editing ? (
          <FiSave className="m-1 cursor-pointer text-gray-800" onClick={applyEditLocal} />
        ) : (
          <FiEdit className="m-1 cursor-pointer text-gray-800" onClick={() => setEditing(true)} />
        )}
        {editing ? (
          <FiX className="m-1 cursor-pointer text-gray-800" onClick={cancelEdit} />
        ) : (
          <FiTrash className="m-1 cursor-pointer text-gray-800" onClick={confirmAndDeleteWeeklyGoal} />
        )}
      </div>
    </div>
  );
};

export default WeeklyGoalRow;