import React, { useState } from 'react';
import PoolList from './PoolList';
import api from '../api';

function Pools() {
  const [newTitle, setNewTitle] = useState<string>('');
  const [refreshPools, setRefreshPools] = useState(false);

  // Function to toggle refreshFlag
  const triggerRefreshPools = () => {
    setRefreshPools(!refreshPools);
  };

  const handleAddTitle = async () => {
    if (newTitle.trim() !== '') {
      console.log(newTitle);
      try {
        await api.createPool(newTitle);
        const updatedPools = await api.getPoolsIndex(); // Get updated list
        console.log(updatedPools);
        setRefreshPools(true);
      } catch (error) {
        console.error(error);
      }
      setNewTitle('');
    }
  };

  return (
    <div className="bg-gray-200 h-full flex justify-center items-center h-screen">
      <div className="bg-[#DFF7DC] p-6 rounded shadow-md w-full h-screen overflow-y-auto">
      <h1 className="text-2xl font-semibold text-blue-600 text-center mb-4">All Pools</h1>
        <div className="flex items-center mb-4">
          <input
            type="text"
            value={newTitle}
            onChange={(e) => setNewTitle(e.target.value)}
            onKeyDown={(e) => {
                if (e.key === 'Enter') handleAddTitle();
            }}
            placeholder="Enter new title..."
            className="p-2 flex-grow border box-border rounded mr-2 w-full" // <-- Notice the flex-grow and w-full here
          />
          <button 
            onClick={handleAddTitle} 
            className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 focus:outline-none"
            style={{maxWidth: '100px'}} // This ensures button never grows beyond 100px.
          >
            Add
          </button>
        </div>
        <PoolList refresh={triggerRefreshPools}/>
      </div>
    </div>
  );
}

export default Pools;
