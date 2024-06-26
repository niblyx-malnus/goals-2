import React, { useState, useEffect } from 'react';
import api from '../api';
import _ from 'lodash';
import GoalRow from './GoalRow';
import useStore from '../store';
import { Goal } from '../types';

function LabelHarvestList({ host, name, tag, refresh }: { host: any; name: any; tag: string; refresh: () => void; }) {
  const [goals, setGoals] = useState<Goal[]>([]);

  useEffect(() => {
    const fetchGoals = async () => {
      try {
        const fetchedGoals = await api.getLabelHarvest(`/${host}/${name}`, tag);
        setGoals(fetchedGoals);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
  
    fetchGoals();
  }, [refresh, host, name, tag]);

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
      <div className="flex items-center space-x-4 mb-4">
      </div>
      <ul>
        {goals.map((goal, index) => (
          <div
            key={goal.key}
            className="block text-current no-underline hover:no-underline"
          >
            <GoalRow
              goal={goal}
              refresh={refresh}
            />
          </div>
        ))}
      </ul>
    </>
  );
};

export default LabelHarvestList;