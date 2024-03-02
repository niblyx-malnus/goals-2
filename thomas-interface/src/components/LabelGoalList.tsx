import React, { useState, useEffect } from 'react';
import api from '../api';
import GoalRow from './GoalRow';
import useStore from '../store';
import { Goal } from '../types';

function LabelGoalList({ host, name, tag, refresh }: { host: any; name: any; tag: string; refresh: () => void; }) {
  const [goals, setGoals] = useState<Goal[]>([]);

  // Use Zustand store
  const { showCompleted, setShowCompleted } = useStore(state => ({ 
      showCompleted: state.showCompleted, 
      setShowCompleted: state.setShowCompleted 
    }));

  const displayedGoals = showCompleted ? goals : goals.filter(goal => !goal.complete);

  useEffect(() => {
    const fetchGoals = async () => {
      try {
        const fetchedGoals = await api.getLabelGoals(`/${host}/${name}`, tag);
        setGoals(fetchedGoals);
        console.log(fetchedGoals);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
  
    fetchGoals();
  }, [refresh, host, name, tag]);

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
        { 
          displayedGoals.map((goal, index) => (
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

export default LabelGoalList;