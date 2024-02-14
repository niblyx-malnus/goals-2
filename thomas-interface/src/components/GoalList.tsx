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

  const { showButtons, setShowButtons } = useStore(state => ({ 
      showButtons: state.showButtons, 
      setShowButtons: state.setShowButtons 
    }));

  useEffect(() => {
    const updateShowButtonsSetting = async () => {
      try {
        // Convert boolean to string
        const showButtonsValue = showButtons ? "true" : "false";
        await api.updateSetting('put', 'show-buttons', showButtonsValue);
      } catch (error) {
        console.error("Failed to update show-buttons setting:", error);
      }
    };
  
    updateShowButtonsSetting();
  }, [showButtons]);
  
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
        const showButtonsValue = await api.getSetting('show-buttons');
        const showCompletedValue = await api.getSetting('show-completed');
        // Convert string to boolean
        setShowButtons(showButtonsValue === "true");
        setShowCompleted(showCompletedValue === "true");
      } catch (error) {
        console.error("Failed to fetch settings:", error);
      }
    };
  
    fetchSettings();
  }, [setShowButtons, setShowCompleted]); // Empty dependency array to run only on mount

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

  const moveGoalUp = async (gid: string) => {
    const index = _.findIndex(displayedGoals, { gid });
    if (index > 0) {
      const aboveGoalId = displayedGoals[index - 1].gid;
      try {
        if (isPool) {
          await api.rootsSlotAbove(gid, aboveGoalId);
        } else {
          await api.youngSlotAbove(`/${host}/${name}/${goalId}`, gid, aboveGoalId);
        }
        refresh();
      } catch (error) {
        console.error("Error reordering", error);
      }
    }
  };
  
  const moveGoalDown = async (gid: string) => {
    const index = _.findIndex(displayedGoals, { gid });
    if (index >= 0 && index < displayedGoals.length - 1) {
      const belowGoalId = displayedGoals[index + 1].gid;
      try {
        if (isPool) {
          await api.rootsSlotBelow(gid, belowGoalId);
        } else {
          await api.youngSlotBelow(`/${host}/${name}/${goalId}`, gid, belowGoalId);
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
        <label className="flex items-center space-x-2">
          <input 
            type="checkbox" 
            checked={showButtons} 
            onChange={() => setShowButtons(!showButtons)} 
            className="form-checkbox rounded"
          />
          <span>Show Buttons</span>
        </label>
      </div>
      <ul>
        {displayedGoals.map((goal, index) => (
          <div
            key={goal.gid}
            className="block text-current no-underline hover:no-underline"
          >
            <GoalRow
              host={host}
              poolName={name}
              goal={goal}
              showButtons={showButtons}
              tags={goal.tags}
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