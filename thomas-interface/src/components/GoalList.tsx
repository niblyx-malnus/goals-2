import React, { useState, useEffect } from 'react';
import api from '../api';
import _ from 'lodash';
import GoalRow from './GoalRow';
import useStore from '../store';
import { Goal } from '../types';

function GoalList({ host, name, goalId, refresh }: { host: any; name: any; goalId: any; refresh: () => void; }) {
  const isPool = goalId == null;
  const [goals, setGoals] = useState<Goal[]>([]);

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
          fetchedGoals = await api.getGoalYoung(`/${host}/${name}`, `/${goalId}`);
        }
        setGoals(fetchedGoals);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
  
    fetchGoals();
  }, [refresh, isPool, host, name, goalId]);

  const moveGoalUp = async (key: string) => {
    const index = _.findIndex(displayedGoals, { key });
    if (index > 0) {
      const aboveGoalId = displayedGoals[index - 1].key;
      try {
        if (isPool) {
          await api.rootsSlotAbove(key, aboveGoalId);
        } else {
          await api.youngSlotAbove(`/${host}/${name}/${goalId}`, key, aboveGoalId);
        }
        refresh();
      } catch (error) {
        console.error("Error reordering", error);
      }
    }
  };
  
  const moveGoalDown = async (key: string) => {
    const index = _.findIndex(displayedGoals, { key });
    if (index >= 0 && index < displayedGoals.length - 1) {
      const belowGoalId = displayedGoals[index + 1].key;
      try {
        if (isPool) {
          await api.rootsSlotBelow(key, belowGoalId);
        } else {
          await api.youngSlotBelow(`/${host}/${name}/${goalId}`, key, belowGoalId);
        }
        refresh();
      } catch (error) {
        console.error("Error reordering", error);
      }
    }
  };

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
        {displayedGoals.map((goal) => (
          <div
            key={goal.key}
            className="block text-current no-underline hover:no-underline"
          >
            <GoalRow
              goal={goal}
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

export default GoalList;