import React, { useState, useEffect } from 'react';
import PoolRow from './PoolRow';
import api from '../api';
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
            <PoolRow pin={pool.pin} title={pool.title} refresh={refresh} showButtons={showButtons}/>
          </div>
        ))}
      </ul>
    </>
  );
}

export default PoolList;