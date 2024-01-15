import React, { useState, useEffect } from 'react';
import api from '../api';
import _ from 'lodash';
import GoalRow from './GoalRow';
import useStore from '../store';

type Goal = {
  id: string,
  tags: string[],
  description: string,
  complete: boolean,
  actionable: boolean
};

function GoalList({ host, name, goalKey, refresh }: { host: any; name: any; goalKey: any; refresh: () => void; }) {
  const isPool = goalKey == null;
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

  const displayedGoals = showCompleted ? goals : goals.filter(goal => !goal.complete);

  useEffect(() => {
    const fetchGoals = async () => {
      try {
        let fetchedGoals;
        if (isPool) {
          // If goalKey is null, we're dealing with roots
          fetchedGoals = await api.getPoolRoots(`/${host}/${name}`);
        } else {
          // Otherwise, we're dealing with the young of a specific goal
          fetchedGoals = await api.getGoalYoung(`/${host}/${name}/${goalKey}`);
        }
        setGoals(fetchedGoals);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
  
    fetchGoals();
  }, [refresh, isPool, host, name, goalKey]);

  const moveGoalUp = async (id: string) => {
    const index = _.findIndex(displayedGoals, { id });
    if (index > 0) {
      const aboveGoalId = displayedGoals[index - 1].id;
      try {
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
    const index = _.findIndex(displayedGoals, { id });
    if (index >= 0 && index < displayedGoals.length - 1) {
      const belowGoalId = displayedGoals[index + 1].id;
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
      <div className="flex space-x-4 mb-4">
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
            key={goal.id}
            className="block text-current no-underline hover:no-underline"
          >
            <GoalRow
              host={host}
              poolName={name}
              name={goal.description}
              id={goal.id}
              complete={goal.complete}
              actionable={goal.actionable}
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