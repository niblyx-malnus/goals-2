import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { FiPlus, FiEdit, FiSave, FiX, FiMinus, FiMenu } from 'react-icons/fi';
import { FaArrowsAlt } from 'react-icons/fa'; 
import { CompleteIcon } from '../CustomIcons';
import AddTodoPanel from './AddTodoPanel';
import TodoActionBar from './TodoActionBar';
import { Goal } from '../../types';
import api from '../../api';

const TodoRow = ({
  goal,
  onRemove,
  toggleMove,
  moveState,
  refresh,
}: {
  goal: Goal,
  onRemove: (id: string) => void,
  toggleMove: () => void,
  moveState: boolean,
  refresh: () => void,
}) => {
  const [isEditing, setIsEditing] = useState(false);
  const [newSummary, setNewSummary] = useState(goal.summary);
  const [panel, setPanel] = useState('');
  const rowRef = useRef<HTMLDivElement>(null);

  const navigate = useNavigate();

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

  const toggleActionBar = () => {
    console.log(goal);
    if (panel === 'action-bar') {
      setPanel('');
    } else {
      setPanel('action-bar');
    }
  };
  
  const toggleComplete = async () => {
    try {
      const isCompleted = await api.getGoalComplete(goal.key);
      await api.setGoalComplete(goal.key, !isCompleted);
      refresh();
      // No need to update the local state for completion status, as it will be fetched dynamically
    } catch (error) {
      console.error("Failed to toggle goal completion:", error);
    }
  };

  const toggleEdit = () => { setIsEditing(!isEditing); }

  const editGoalSummary = async () => {
    try {
      console.log("updating goal...");
      await api.setGoalSummary(goal.key, newSummary);
      // refresh();
      setIsEditing(false);
    } catch (error) {
      console.error(error);
    }
  };

  const cancelEditGoalSummary = async () => {
    try {
      setNewSummary(goal.summary);
      // refresh();
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

  return (
    <div ref={rowRef} className={`flex justify-between items-center my-1 rounded ${goal.actionable ? 'border-4 border-gray-400 box-border' : 'p-1' } hover:bg-gray-300 bg-gray-200`}>
      <button
        className={`p-2 rounded bg-gray-${moveState ? "300" : "100"}`}
        onClick={toggleMove}
      >
        <FaArrowsAlt style={{ color: moveState ? "#f7fafc" : "gray" }} />
      </button>
      <button
        className="p-2 rounded bg-gray-100"
        onClick={toggleComplete}
      >
        <CompleteIcon
          complete={goal.complete}
          style={ { color: goal.complete ? 'black' : goal.active ? 'black' : 'gray' } }
        />
      </button>
      {isEditing ? (
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
          // onClick={() => navigate(`/goal${goal.key}`)}
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
            onClick={() => {
              const isConfirmed = window.confirm("Are you sure you want to remove this goal from this list?");
              if (isConfirmed) {
                onRemove(goal.key);
              }
            }}
          >
            <FiMinus />
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
          onClick={togglePlusPanel}
          className="p-2 rounded bg-gray-100"
        >
          <FiPlus />
        </button>
        {panel === 'plus' && (
          <div className="z-10 absolute right-0 bottom-full mt-2 w-64 bg-white p-4 shadow-lg rounded-lg">
            <AddTodoPanel goalKey={goal.key} exit={() => setPanel('')} />
          </div>
        )}
      </div>
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
              <TodoActionBar goal={goal} refresh={refresh} />
            </div>
          )
        }
      </div>
    </div>
  );
};

export default TodoRow;