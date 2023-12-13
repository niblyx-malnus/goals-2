import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import _ from 'lodash';
import { FiCopy } from 'react-icons/fi';

type Goal = {
  id: string,
  tags?: string[],
  description: string,
  complete: boolean,
  actionable: boolean
}; // Type for pool object

const GoalRow: React.FC<{
    name: string,
    id: string,
    complete: boolean,
    actionable: boolean,
    refresh: () => void,
    moveGoalUp: (id: string) => void,
    moveGoalDown: (id: string) => void
  }> = ({
    name,
    id,
    complete,
    actionable,
    moveGoalUp,
    moveGoalDown,
    refresh
  }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [newDescription, setNewDescription] = useState(name);
  const [isActionable, setIsActionable] = useState(actionable);
  const [isComplete, setIsComplete] = useState(complete);

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
      await api.setGoalSummary(id, newDescription);
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
      await api.setGoalActionable(id, !isActionable);
      const actionable = await api.getGoalActionable(id);
      setIsActionable(actionable);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };
  
  const toggleComplete = async () => {
    try {
      await api.setGoalComplete(id, !isComplete);
      const complete = await api.getGoalComplete(id);
      setIsComplete(complete);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };
  
  const copyToClipboard = () => {
    navigator.clipboard.writeText(id);
  }

  return (
    <div className={`flex justify-between items-center p-1 mt-2 rounded ${isActionable ? 'hover:bg-blue-500 bg-blue-400' : 'hover:bg-gray-300 bg-gray-200'}`}>
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
      <button onClick={() => moveGoalUp(id)} className="p-2 rounded bg-gray-100 hover:bg-gray-200">
        ↑
      </button>
      <button onClick={() => moveGoalDown(id)} className="p-2 rounded bg-gray-100 hover:bg-gray-200">
        ↓
      </button>
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
          onDoubleClick={() => setIsEditing(true)}
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

function Harvest({ host, name, goalKey, method, tags, refresh }: { host: any; name: any; goalKey: any; method: string, tags: string[], refresh: () => void; }) {
  const isPool = goalKey == null;
  const [goals, setGoals] = useState<Goal[]>([]);
  const [filteredGoals, setFilteredGoals] = useState<Goal[]>(goals); // State for filtered goals

  useEffect(() => {
    const fetchGoals = async () => {
      try {
        let fetchedGoals;
        if (isPool) {
          fetchedGoals = await api.poolHarvest(`/${host}/${name}`, 'any', []);
        } else {
          fetchedGoals = await api.goalHarvest(`/${host}/${name}/${goalKey}`, 'any', []);
        }
        setGoals(fetchedGoals);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
  
    fetchGoals();
  }, [refresh, isPool, host, name, goalKey]);

  // Function to filter goals by selected tags
  useEffect(() => {
    if (tags.length === 0) {
      // If no tags are selected, show all goals
      setFilteredGoals(goals);
    } else {
      // Filter goals based on selected tags and method
      const filtered = goals.filter((goal) => {
        if (goal.tags) {
          if (method === 'every') {
            // Filter goals that have ALL of the selected tags
            return tags.every((tag) => goal.tags?.includes(tag));
          } else if (method === 'some') {
            // Filter goals that have ANY of the selected tags
            return tags.some((tag) => goal.tags?.includes(tag));
          }
        }
        return false;
      });
      setFilteredGoals(filtered);
    }
  }, [refresh, goals, method, tags]);

  const moveGoalUp = async (id: string) => {
    const index = _.findIndex(goals, { id });
    if (index > 0) {
      try {
        const aboveGoalId = goals[index - 1].id;
        if (isPool) {
          await api.rootsSlotAbove(id, aboveGoalId);
        } else {
          await api.youngSlotAbove(`/${host}/${name}/${goalKey}`, id, aboveGoalId);
        }
        refresh();
      } catch (error) {
        console.error("Error reordering", error);
      }
    }
  };
  
  const moveGoalDown = async (id: string) => {
    const index = _.findIndex(goals, { id });
    if (index >= 0 && index < goals.length - 1) {
      const belowGoalId = goals[index + 1].id;
      try {
        if (isPool) {
          await api.rootsSlotBelow(id, belowGoalId);
        } else {
          await api.youngSlotBelow(`/${host}/${name}/${goalKey}`, id, belowGoalId);
        }
        refresh();
      } catch (error) {
        console.error("Error reordering", error);
      }
    }
  };

  return (
    <>
      <ul>
        {filteredGoals.map((goal, index) => (
          <div
            key={goal.id}
            className="block text-current no-underline hover:no-underline"
          >
            <GoalRow
              name={goal.description}
              id={goal.id}
              complete={goal.complete}
              actionable={goal.actionable}
              refresh={refresh}
              moveGoalUp={moveGoalUp}
              moveGoalDown={moveGoalDown}
            />
          </div>
        ))}
      </ul>
    </>
  );
};

export default Harvest;
