import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import { FiSquare, FiCheckSquare, FiX, FiEdit, FiTrash, FiSave, FiMenu } from 'react-icons/fi';
import GoalActionBar from './GoalActionBar';
import { Goal } from '../types';

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
  const [panel, setPanel] = useState('');
  const rowRef = useRef<HTMLDivElement>(null);

  const pid = `/${host}/${poolName}`;

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
  
  const toggleComplete = async () => {
    try {
      await api.setGoalComplete(goal.key, !goal.complete);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };

  const CompleteIcon = () => {
    if (goal.complete) {
      return <FiCheckSquare />;
    } else {
      return <FiSquare />;
    }
  };
  
  return (
    <div ref={rowRef} className={`flex justify-between items-center mt-2 rounded ${goal.actionable ? 'border-4 border-gray-400 box-border' : 'p-1' } hover:bg-gray-300 bg-gray-200`}>
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
          onClick={() => navigate(`/goal${goal.key}`)}
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
              <GoalActionBar goal={goal} refresh={refresh} />
            </div>
          )
        }
      </div>
    </div>
  );
};

export default GoalRow;