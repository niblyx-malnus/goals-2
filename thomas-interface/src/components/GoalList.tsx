import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';

type Goal = { id: string, description: string };

const GoalRow: React.FC<{name: string, id: string, refresh: () => void}> = ({ name, id, refresh }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [newDescription, setNewDescription] = useState(name);
  const [isActionable, setIsActionable] = useState(true);
  const [isComplete, setIsComplete] = useState(false);
  
  useEffect(() => {
    const fetchActionableStatus = async () => {
      try {
        const actionable = await api.getGoalActionable(id);
        setIsActionable(actionable);
      } catch (error) {
        console.error(error);
      }
    };
    
    fetchActionableStatus();
    
    const fetchCompleteStatus = async () => {
      try {
        const complete = await api.getGoalComplete(id);
        setIsComplete(complete);
      } catch (error) {
        console.error(error);
      }
    };

    fetchCompleteStatus();
  }, [id]);

  const deleteGoal = async () => {
    try {
      await api.deleteGoal(id);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };

  const updateGoal = async () => {
    try {
      console.log("updating goal...");
      await api.editGoalDescription(id, newDescription);
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
      console.log("isActionable");
      console.log(isActionable);
      await api.setGoalActionable(id, !isActionable);
      const actionable = await api.getGoalActionable(id);
      setIsActionable(actionable);
    } catch (error) {
      console.error(error);
    }
  };
  
  const toggleComplete = async () => {
    try {
      console.log("isComplete");
      console.log(isComplete);
      await api.setGoalComplete(id, !isComplete);
      const complete = await api.getGoalComplete(id);
      setIsComplete(complete);
    } catch (error) {
      console.error(error);
    }
  };


  return (
    <div className={`flex justify-between items-center p-1 mt-2 rounded ${isActionable ? 'hover:bg-blue-500 bg-blue-400' : 'hover:bg-gray-300 bg-gray-200'}`}>
      <div className="flex flex-col space-y-1">
        <input type="checkbox" checked={isActionable} onChange={toggleActionable} />
        <input type="checkbox" checked={isComplete} onChange={toggleComplete} />
      </div>
      {isEditing ? (
        <input 
          type="text" 
          value={newDescription}
          onChange={(e) => setNewDescription(e.target.value)}
          className="bg-white shadow rounded cursor-pointer w-4/5 p-2"
          onKeyDown={handleKeyDown}
        />
      ) : (
        <div
          className={`bg-gray-100 rounded cursor-pointer w-4/5 p-2 ${isComplete ? 'line-through' : ''}`}
          onClick={() => navigateToGoal(id)}
        >
          {name}
        </div>

      )}
      {!isEditing && (
        <>
          <button
            className="bg-gray-100 justify-center flex items-center rounded p-2 w-1/12"
            onClick={() => setIsEditing(!isEditing)}
          >
            Edit
          </button>
          <button
            className="bg-gray-100 justify-center flex items-center rounded p-2 w-1/12"
            onClick={deleteGoal}
          >
            Delete
          </button>
        </>
      )}
      {isEditing && (
        <>
          <button
            className="bg-teal-100 justify-center flex items-center rounded p-2 w-1/12"
            onClick={updateGoal}
          >
            Save
          </button>
          <button
            className="bg-red-100 justify-center flex items-center rounded p-2 w-1/12"
            onClick={cancelUpdateGoal}
          >
            Cancel
          </button>
        </>
      )}
    </div>
  );
};

function GoalList({ host, name, goalKey, refresh }: { host: any; name: any; goalKey: any; refresh: () => void; }) {
  const goalId = `/${host}/${name}/${goalKey}`;
  const [kids, setKids] = useState<Goal[]>([]);
  const [dragOverIndex, setDragOverIndex] = useState<number | null>(null);

  // Fetch pools on mount
  useEffect(() => {
    const fetch = async () => {
      try {
        const fetchedKids = await api.getGoalKids(goalId);
        setKids(fetchedKids);
      } catch (error) {
        console.error("Error fetching pools: ", error);
      }
    };
    fetch();
  }, [goalId, refresh]);

  const listRef = useRef<HTMLUListElement>(null);
  
  const dragStart = (e: React.DragEvent<HTMLElement>, index: number) => {
    e.dataTransfer.setData('draggedIndex', index.toString());
  };
  
  const onDragOver = (e: React.DragEvent<HTMLElement>) => {
    e.preventDefault();
    
    if (listRef.current) {
      const rect = listRef.current.getBoundingClientRect();
      const y = e.clientY - rect.top; // get the y-coordinate within the list
      const closestIndex = Math.min(
        kids.length - 1,
        Math.max(
          0,
          Math.floor((y / rect.height) * kids.length)
        )
      );
  
      setDragOverIndex(closestIndex);
    }
  };
  
  const onDrop = (e: React.DragEvent<HTMLElement>, droppedIndex: number) => {
    const draggedIndex = Number(e.dataTransfer.getData('draggedIndex'));
    if (isNaN(draggedIndex)) return;
  
    const updatedKids = [...kids];
    const [removed] = updatedKids.splice(draggedIndex, 1);
    updatedKids.splice(droppedIndex, 0, removed);
  
    setKids(updatedKids);
    setDragOverIndex(null);
  };

  return (
    <ul onDragOver={onDragOver} ref={listRef}>
      {kids.map((kid, index) => (
        <>
        <div
          draggable
          onDragStart={(e) => dragStart(e, index)}
          onDragOver={(e) => onDragOver(e)}
          onDrop={(e) => onDrop(e, index)}
          key={kid.id}
          className="block text-current no-underline hover:no-underline"
        >
          <GoalRow name={kid.description} id={kid.id} refresh={refresh}/>
        </div>
          {dragOverIndex === index && <div className="h-[2px] bg-blue-500 transition-all ease-in-out duration-100 mt-1 mb-1"></div>}
        </>
      ))}
    </ul>
  );
};

export default GoalList;