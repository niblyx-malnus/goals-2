import React, { useState, useEffect } from 'react';
import PoolRow from './PoolRow';
import api from '../api';
import _ from 'lodash';
import useStore from '../store';

type Pool = { pin: string, title: string }; // Type for pool object

function PoolList({ refresh } : { refresh: () => void; }) {
  const [pools, setPools] = useState<Pool[]>([]); // Updated from titles to pools

  const { showButtons, setShowButtons } = useStore(state => ({ 
      showButtons: state.showButtons, 
      setShowButtons: state.setShowButtons 
    }));

  // Fetch pools on mount
  useEffect(() => {
    const fetchPools = async () => {

      try {
        const fetchedPools = await api.getPoolsIndex();
        setPools(fetchedPools);
      } catch (error) {
        console.error("Error fetching pools: ", error);
      }
    };
    fetchPools();
  }, [refresh]);

  const movePoolUp = async (pin: string) => {
    const index = _.findIndex(pools, { pin });
    if (index > 0) {
      const abovePoolId = pools[index - 1].pin;
      try {
        await api.poolsSlotAbove(pin, abovePoolId);
        refresh();
      } catch (error) {
        console.error("Error reordering", error);
      }
    }
  };
  
  const movePoolDown = async (pin: string) => {
    const index = _.findIndex(pools, { pin });
    if (index >= 0 && index < pools.length - 1) {
      const belowGoalId = pools[index + 1].pin;
      try {
        await api.poolsSlotBelow(pin, belowGoalId);
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
        {pools.map((pool, index) => (
          <div
            key={pool.pin}
            className="block text-current no-underline hover:no-underline"
          >
            <PoolRow pin={pool.pin} title={pool.title} refresh={refresh} movePoolUp={movePoolUp} movePoolDown={movePoolDown} showButtons={showButtons}/>
          </div>
        ))}
      </ul>
    </>
  );
}

export default PoolList;