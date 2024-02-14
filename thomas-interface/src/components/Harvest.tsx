import React, { useState, useEffect } from 'react';
import api from '../api';
import _ from 'lodash';
import GoalRow from './GoalRow';
import useStore from '../store';
import { Tag, Goal } from '../types';

function Harvest({
  host,
  name,
  goalId,
  method,
  tags,
  refresh,
}: {
  host: any;
  name: any;
  goalId: any;
  method: string;
  tags: Tag[];
  refresh: () => void;
}) {
  const [goals, setGoals] = useState<Goal[]>([]);
  const [filteredGoals, setFilteredGoals] = useState<Goal[]>(goals); // State for filtered goals

  const { showButtons, setShowButtons } = useStore(state => ({ 
      showButtons: state.showButtons, 
      setShowButtons: state.setShowButtons 
    }));

  useEffect(() => {
    const fetchGoals = async () => {
      try {
        let fetchedGoals;
        const isMain = host === null && name === null && goalId === null;
        if (isMain) {
          fetchedGoals = await api.mainHarvest();
        } else if (host && name && goalId != null) {
          fetchedGoals = await api.goalHarvest(`/${host}/${name}`, `/${goalId}`);
        } else {
          fetchedGoals = await api.poolHarvest(`/${host}/${name}`);
        }
        setGoals(fetchedGoals);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
  
    fetchGoals();
  }, [refresh, host, name, goalId, method, tags]);

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

  const moveGoalUp = async (key: string) => {
    const index = _.findIndex(goals, { key });
    if (index > 0) {
      try {
        const aboveGoalId = goals[index - 1].key;
        await api.goalsSlotAbove(key, aboveGoalId);
        refresh();
      } catch (error) {
        console.error("Error reordering", error);
      }
    }
  };
  
  const moveGoalDown = async (key: string) => {
    const index = _.findIndex(goals, { key });
    if (index >= 0 && index < goals.length - 1) {
      const belowGoalId = goals[index + 1].key;
      try {
        await api.goalsSlotBelow(key, belowGoalId);
        refresh();
      } catch (error) {
        console.error("Error reordering", error);
      }
    }
  };

  return (
    <>
      <label className="flex items-center space-x-2">
        <input 
          type="checkbox" 
          checked={showButtons} 
          onChange={() => setShowButtons(!showButtons)} 
          className="form-checkbox rounded"
        />
        <span>Show Buttons</span>
      </label>
      <ul>
        {filteredGoals.map((goal, index) => (
          <div
            key={goal.key}
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

export default Harvest;
