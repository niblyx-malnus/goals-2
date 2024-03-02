import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { FiX, FiEdit, FiTrash, FiSave, FiMenu } from 'react-icons/fi';
import { FaArrowsAltV } from 'react-icons/fa'; 
import { CompleteIcon } from './CustomIcons';
import GoalActionBar from './GoalActionBar';
import { Goal } from '../types';
import api from '../api';

const GoalRow: React.FC<{
    goal: Goal,
    refresh: () => void,
    toggleMove?: () => void,
    moveState?: boolean,
  }> = ({
    goal,
    refresh,
    toggleMove,
    moveState = false,
  }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [newSummary, setNewSummary] = useState(goal.summary);
  const [panel, setPanel] = useState('');
  const rowRef = useRef<HTMLDivElement>(null);

  const toggleActionBar = () => {
    console.log(goal);
    if (panel === 'action-bar') {
      setPanel('');
    } else {
      setPanel('action-bar');
    }
  };

  const toggleEdit = () => { setIsEditing(!isEditing); }
  
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

  const editGoalSummary = async () => {
    try {
      console.log("updating goal...");
      await api.setGoalSummary(goal.key, newSummary);
      refresh();
      setIsEditing(false);
    } catch (error) {
      console.error(error);
    }
  };

  const cancelEditGoalSummary = async () => {
    try {
      setNewSummary(goal.summary);
      refresh();
      setIsEditing(false);
    } catch (error) {
      console.error(error);
    }
  };

  const handleKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'Enter') {
      editGoalSummary();
    }
    if (event.key === 'Escape') {
      cancelEditGoalSummary();
    }
  };

  const navigate = useNavigate();
  
  const toggleComplete = async () => {
    try {
      await api.setGoalComplete(goal.key, !goal.complete);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <div ref={rowRef} className={`flex justify-between items-center mt-2 rounded ${goal.actionable ? 'border-4 border-gray-400 box-border' : 'p-1' } ${goal.active ? 'hover:bg-gray-300 bg-gray-200' : 'opacity-60 bg-gray-200'} `}>
      {toggleMove &&
        <button
          className={`p-2 rounded bg-gray-${moveState ? "300" : "100"}`}
          onClick={toggleMove}
        >
          <FaArrowsAltV style={{ color: moveState ? "#f7fafc" : "gray" }} />
        </button>
      }
      <button
        className="p-2 rounded bg-gray-100 text-white"
        onClick={toggleComplete}
      >
        <div className="text-white">
          <CompleteIcon
            complete={goal.complete}
            style={ { color: 'gray' } }
          />
        </div>
      </button>
      { isEditing ? (
        <input 
          type="text" 
          value={newSummary}
          onChange={(e) => setNewSummary(e.target.value)}
          className="truncate bg-white shadow rounded cursor-pointer flex-grow p-1"
          onKeyDown={handleKeyDown}
        />
      ) : (
        <div
          className={`truncate bg-gray-100 rounded cursor-pointer flex-grow p-1 ${goal.complete ? 'line-through' : ''}`}
          onClick={() => navigate(`/goal${goal.key}`)}
          onDoubleClick={toggleEdit}
        >
          {goal.summary}
        </div>
      )}
      { !isEditing && (
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
      { isEditing && (
        <>
          <button
            className="p-2 rounded bg-gray-100 hover:bg-gray-200"
            onClick={editGoalSummary}
          >
            <FiSave />
          </button>
          <button
            className="p-2 rounded bg-gray-100 hover:bg-gray-200"
            onClick={cancelEditGoalSummary}
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
              <GoalActionBar goal={goal} refresh={refresh} />
            </div>
          )
        }
      </div>
    </div>
  );
};

export default GoalRow;