import React, { useState, useEffect } from 'react';
import PoolRow from './PoolRow';
import api from '../api';
import _ from 'lodash';
import useStore from '../store';

type Pool = { pid: string, title: string }; // Type for pool object

function PoolList({ refresh } : { refresh: () => void; }) {
  const [pools, setPools] = useState<Pool[]>([]); // Updated from titles to pools

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

  const movePoolUp = async (pid: string) => {
    const index = _.findIndex(pools, { pid });
    if (index > 0) {
      const abovePoolId = pools[index - 1].pid;
      try {
        await api.poolsSlotAbove(pid, abovePoolId);
        refresh();
      } catch (error) {
        console.error("Error reordering", error);
      }
    }
  };
  
  const movePoolDown = async (pid: string) => {
    const index = _.findIndex(pools, { pid });
    if (index >= 0 && index < pools.length - 1) {
      const belowGoalId = pools[index + 1].pid;
      try {
        await api.poolsSlotBelow(pid, belowGoalId);
        refresh();
      } catch (error) {
        console.error("Error reordering", error);
      }
    }
  };

  return (
    <>
      <ul>
        {pools.map((pool, index) => (
          <div
            key={pool.pid}
            className="block text-current no-underline hover:no-underline"
          >
            <PoolRow pid={pool.pid} title={pool.title} refresh={refresh} movePoolUp={movePoolUp} movePoolDown={movePoolDown}/>
          </div>
        ))}
      </ul>
    </>
  );
}

export default PoolList;