import React, { useState, useEffect } from 'react';
import api from '../api';
import GoalRow from './GoalRow';
import useStore from '../store';
import { Goal } from '../types';
import { gidFromKey } from '../utils';

function GoalList({ host, name, goalId, refresh }: { host: any; name: any; goalId: any; refresh: () => void; }) {
  const pid = `/${host}/${name}`;
  const isPool = goalId == null;
  const [goals, setGoals] = useState<Goal[]>([]);
  const [selectedGoalKey, setSelectedGoalKey] = useState<string | null>(null);

  // Use Zustand store
  const { showCompleted, setShowCompleted } = useStore(state => ({ 
      showCompleted: state.showCompleted, 
      setShowCompleted: state.setShowCompleted 
    }));

  useEffect(() => {
    const updateShowCompletedSetting = async () => {
      try {
        // Convert boolean to string
        const showCompletedValue = showCompleted ? "true" : "false";
        await api.updateSetting('put', 'show-completed', showCompletedValue);
      } catch (error) {
        console.error("Failed to update show-completed setting:", error);
      }
    };
  
    updateShowCompletedSetting();
  }, [showCompleted]);

  useEffect(() => {
    const fetchSettings = async () => {
      try {
        const showCompletedValue = await api.getSetting('show-completed');
        // Convert string to boolean
        setShowCompleted(showCompletedValue === "true");
      } catch (error) {
        console.error("Failed to fetch settings:", error);
      }
    };
  
    fetchSettings();
  }, [setShowCompleted]); // Empty dependency array to run only on mount

  const moveGoal = (aboveGoalKey: string | null, belowGoalKey: string | null) => {
    if (selectedGoalKey !== null) {
      let keys = goals.map(goal => goal.key);
      const currentIndex = keys.indexOf(selectedGoalKey);
  
      // Early exit if the goal isn't found
      if (currentIndex === -1) return;

      // if the below goal is above me, I'm moving up
      const isMovingUp = (belowGoalKey && keys.indexOf(belowGoalKey) < currentIndex);
      // if the above goal is below me, I'm moving down
      const isMovingDown = (aboveGoalKey && keys.indexOf(aboveGoalKey) > currentIndex);
  
      const isMovingToSamePosition = 
        (aboveGoalKey && currentIndex - 1 === keys.indexOf(aboveGoalKey)) ||
        (aboveGoalKey && currentIndex === keys.indexOf(aboveGoalKey)) ||
        (belowGoalKey && currentIndex + 1 === keys.indexOf(belowGoalKey)) ||
        (belowGoalKey && currentIndex === keys.indexOf(belowGoalKey));
      if (isMovingToSamePosition) { return; }

      // Remove the selected goal from its current position
      keys.splice(currentIndex, 1);

      let newIndex = 0;
      // If we're moving up, we go above the belowGoalKey
      if (isMovingUp) {
        newIndex = keys.indexOf(belowGoalKey);
      // If we're moving down, we go below the aboveGoalKey
      } else if (isMovingDown) {
        newIndex = keys.indexOf(aboveGoalKey) + 1;
      }
  
      // Insert the selected goal at the new position
      keys.splice(newIndex, 0, selectedGoalKey);

      // Update the API with the new goals order
      if (goalId != null) {
        api.reorderChildren(`${pid}/${goalId}`, keys.map(key => gidFromKey(key)))
          .then(() => {
            refresh(); // Trigger a refresh to re-fetch the updated goals
          })
          .catch(error => console.error("Failed to reorder children:", error));
      } else if (goalId == null) {
        api.reorderRoots(pid, keys.map(key => gidFromKey(key)))
          .then(() => {
            refresh(); // Trigger a refresh to re-fetch the updated goals
          })
          .catch(error => console.error("Failed to reorder roots:", error));
      }
    }
  };

  const displayedGoals = showCompleted ? goals : goals.filter(goal => !goal.complete);

  useEffect(() => {
    const fetchGoals = async () => {
      try {
        let fetchedGoals;
        if (isPool) {
          // If goalId is null, we're dealing with roots
          fetchedGoals = await api.getPoolRoots(`/${host}/${name}`);
        } else {
          // Otherwise, we're dealing with the young of a specific goal
          fetchedGoals = await api.getGoalChildren(`/${host}/${name}`, `/${goalId}`);
        }
        setGoals(fetchedGoals);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
  
    fetchGoals();
  }, [refresh, isPool, host, name, goalId]);

  return (
    <>
      <div className="flex items-center space-x-4 mb-4">
        <label className="flex items-center space-x-2">
          <input 
            type="checkbox" 
            checked={showCompleted} 
            onChange={() => setShowCompleted(!showCompleted)} 
            className="form-checkbox rounded"
          />
          <span>Show Completed</span>
        </label>
      </div>
      <ul>
        {displayedGoals.map((goal, index) => (
          <React.Fragment key={index}>
            {/* Insert separator before the first goal for moving to the start */}
            {selectedGoalKey !== null && index === 0 && (
              <li
                onClick={() => moveGoal(null, goal.key)}
                className="cursor-pointer my-2 h-3 rounded-full bg-blue-200"
              />
            )}
            <div
              key={goal.key}
              className="block text-current no-underline hover:no-underline"
            >
              <GoalRow
                goal={goal}
                refresh={refresh}
                toggleMove={
                  () => {
                    console.log(selectedGoalKey);
                    if (selectedGoalKey === goal.key) {
                      setSelectedGoalKey(null);
                    } else {
                      setSelectedGoalKey(goal.key);
                    }
                  }
                }
                moveState={selectedGoalKey === goal.key}
              />
            </div>
            {/* Separator between goals or after the last goal */}
            {selectedGoalKey !== null && (
              <li
                onClick={() => moveGoal(goal.key, goals[index + 1]?.key || null)}
                className="cursor-pointer my-2 h-3 rounded-full bg-blue-200"
              />
            )}
          </React.Fragment>
        ))}
      </ul>
    </>
  );
};

export default GoalList;