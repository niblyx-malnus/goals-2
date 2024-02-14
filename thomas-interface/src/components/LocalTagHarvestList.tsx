import React, { useState, useEffect } from 'react';
import api from '../api';
import _ from 'lodash';
import GoalRow from './GoalRow';
import useStore from '../store';
import { Goal } from '../types';

function LocalTagHarvestList({ host, name, tag, refresh }: { host: any; name: any; tag: string; refresh: () => void; }) {
  const [goals, setGoals] = useState<Goal[]>([]);

  const { showButtons, setShowButtons } = useStore(state => ({ 
      showButtons: state.showButtons, 
      setShowButtons: state.setShowButtons 
    }));

  useEffect(() => {
    const fetchGoals = async () => {
      try {
        const fetchedGoals = await api.getLocalTagHarvest(tag);
        setGoals(fetchedGoals);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
  
    fetchGoals();
  }, [refresh, host, name, tag]);

  const moveGoalUp = async (gid: string) => {
    const index = _.findIndex(goals, { gid });
    if (index > 0) {
      try {
        const aboveGoalId = goals[index - 1].gid;
        await api.goalsSlotAbove(gid, aboveGoalId);
        refresh();
      } catch (error) {
        console.error("Error reordering", error);
      }
    }
  };
  
  const moveGoalDown = async (gid: string) => {
    const index = _.findIndex(goals, { gid });
    if (index >= 0 && index < goals.length - 1) {
      const belowGoalId = goals[index + 1].gid;
      try {
        await api.goalsSlotBelow(gid, belowGoalId);
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
            checked={showButtons} 
            onChange={() => setShowButtons(!showButtons)} 
            className="form-checkbox rounded"
          />
          <span>Show Buttons</span>
        </label>
      </div>
      <ul>
        {goals.map((goal, index) => (
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

export default LocalTagHarvestList;
