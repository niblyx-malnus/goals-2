import React, { useState, useEffect } from 'react';
import PoolRow from './PoolRow';
import api from '../api';

type Pool = { pin: string, title: string }; // Type for pool object

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

  return (
    <ul>
      {pools.map((pool, index) => (
        <div
          key={pool.pin}
          className="block text-current no-underline hover:no-underline"
        >
          <PoolRow pin={pool.pin} title={pool.title} refresh={refresh}/>
        </div>
      ))}
    </ul>
  );
}

export default PoolList;