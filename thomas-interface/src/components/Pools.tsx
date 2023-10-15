import React, { useState, useEffect, useRef } from 'react';
import { Link } from 'react-router-dom';
import api from '../api';

type Pool = { pin: string, title: string }; // Type for pool object

function Pools() {
  const [pools, setPools] = useState<Pool[]>([]); // Updated from titles to pools
  const [newTitle, setNewTitle] = useState<string>('');
  const [dragOverIndex, setDragOverIndex] = useState<number | null>(null);


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
  }, []);

  const handleAddTitle = async () => {
    if (newTitle.trim() !== '') {
      console.log(newTitle);
      try {
        await api.spawnPool(newTitle);
        const updatedPools = await api.getPoolsIndex(); // Get updated list
        console.log(updatedPools);
        setPools(updatedPools);
      } catch (error) {
        console.error(error);
      }
      setNewTitle('');
    }
  };

  const listRef = useRef<HTMLUListElement>(null);

  const dragStart = (e: React.DragEvent<HTMLAnchorElement>, index: number) => {
    e.dataTransfer.setData('draggedIndex', index.toString());
  };

  const onDragOver = (e: React.DragEvent<HTMLElement>) => {
    e.preventDefault();
    
    if (listRef.current) {
      const rect = listRef.current.getBoundingClientRect();
      const y = e.clientY - rect.top; // get the y-coordinate within the list
      const closestIndex = Math.min(
        pools.length - 1,
        Math.max(
          0,
          Math.floor((y / rect.height) * pools.length)
        )
      );
  
      setDragOverIndex(closestIndex);
    }
  };
  
  const onDrop = (e: React.DragEvent<HTMLAnchorElement>, droppedIndex: number) => {
    const draggedIndex = Number(e.dataTransfer.getData('draggedIndex'));
    if (isNaN(draggedIndex)) return;
  
    const updatedPools = [...pools];
    const [removed] = updatedPools.splice(draggedIndex, 1);
    updatedPools.splice(droppedIndex, 0, removed);
  
    setPools(updatedPools);
    setDragOverIndex(null);
  };


  return (
    <div className="bg-gray-200 h-full flex justify-center items-center">
      <div className="bg-blue-300 p-6 rounded shadow-md w-full">
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
        <ul onDragOver={onDragOver} ref={listRef}>
          {pools.map((pool, index) => (
            <>
              <Link
                draggable
                onDragStart={(e) => dragStart(e, index)}
                onDragOver={(e) => onDragOver(e)}
                onDrop={(e) => onDrop(e, index)}
                to={`/pool/${pool.pin}`}
                key={pool.pin}
              className="block text-current no-underline hover:no-underline"
              >
              <li className="p-2 bg-gray-200 hover:bg-gray-300 mt-2 rounded" title={pool.pin}>
                {pool.title}
              </li>
              </Link>
              {dragOverIndex === index && <div className="h-[2px] bg-blue-500 transition-all ease-in-out duration-100 mt-1 mb-1"></div>}
            </>
          ))}
        </ul>
      </div>
    </div>
  );
}

export default Pools;
