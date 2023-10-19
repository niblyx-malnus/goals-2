import React, { useState, useEffect, useRef } from 'react';
import { Link } from 'react-router-dom';
import MarkdownEditor from './MarkdownEditor';
import api from '../api';
import '../global.css';

type Goal = { id: string, description: string };

function Pool({ host, name }: { host: any; name: any; }) {
  const poolId = `/${host}/${name}`;
  const [roots, setRoots] = useState<Goal[]>([]);
  const [poolTitle, setPoolTitle] = useState<string>('');
  const [poolNote, setPoolNote] = useState<string>('');
  const [newDescription, setNewDescription] = useState<string>('');
  const [dragOverIndex, setDragOverIndex] = useState<number | null>(null);


  // Fetch pools on mount
  useEffect(() => {
    const fetch = async () => {
      try {
        const fetchedRoots = await api.getPoolRoots(poolId);
        setRoots(fetchedRoots);
        const fetchedTitle = await api.getPoolTitle(poolId);
        setPoolTitle(fetchedTitle);
        const fetchedNote = await api.getPoolNote(poolId);
        setPoolNote(fetchedNote);
      } catch (error) {
        console.error("Error fetching pools: ", error);
      }
    };
    fetch();
  }, [poolId]);

  const handleAddTitle = async () => {
    if (newDescription.trim() !== '') {
      try {
        await api.spawnGoal(`/${host}/${name}`, null, newDescription, true);
        const updatedRoots = await api.getPoolRoots(`/${host}/${name}`);
        setRoots(updatedRoots);
      } catch (error) {
        console.error(error);
      }
      setNewDescription('');
    }
  };

  const saveMarkdown = async (markdown: string) => {
    try {
      await api.editPoolNote(poolId, markdown);
      const fetchedNote = await api.getPoolNote(poolId);
      setPoolNote(fetchedNote);
    } catch (error) {
      console.error(error);
    }
  }

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
        roots.length - 1,
        Math.max(
          0,
          Math.floor((y / rect.height) * roots.length)
        )
      );
  
      setDragOverIndex(closestIndex);
    }
  };
  
  const onDrop = (e: React.DragEvent<HTMLAnchorElement>, droppedIndex: number) => {
    const draggedIndex = Number(e.dataTransfer.getData('draggedIndex'));
    if (isNaN(draggedIndex)) return;
  
    const updatedPools = [...roots];
    const [removed] = updatedPools.splice(draggedIndex, 1);
    updatedPools.splice(droppedIndex, 0, removed);
  
    setRoots(updatedPools);
    setDragOverIndex(null);
  };


  return (
    <div className="bg-gray-200 h-full flex justify-center items-center">
      <div className="bg-[#FAF3DD] p-6 rounded shadow-md w-full">
        <a href="/pools" className="mr-2 flex justify-end">
          <h2 className="text-blue-800">All Pools</h2>
        </a>
        <h1 className="text-2xl font-semibold text-blue-600 text-center mb-4">
          {poolTitle}
        </h1>
        <div className="pt-6 flex items-center mb-4">
          <input
            type="text"
            value={newDescription}
            onChange={(e) => setNewDescription(e.target.value)}
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
          {roots.map((root, index) => (
            <>
              <Link
                draggable
                onDragStart={(e) => dragStart(e, index)}
                onDragOver={(e) => onDragOver(e)}
                onDrop={(e) => onDrop(e, index)}
                to={`/goal${root.id}`}
                key={root.id}
              className="block text-current no-underline hover:no-underline"
              >
              <li className="p-2 bg-gray-200 hover:bg-gray-300 mt-2 rounded" title={root.id}>
                {root.description}
              </li>
              </Link>
              {dragOverIndex === index && <div className="h-[2px] bg-blue-500 transition-all ease-in-out duration-100 mt-1 mb-1"></div>}
            </>
          ))}
        </ul>
        <div className="p-6 markdown-container all:unstyled overflow-y-auto">
          <MarkdownEditor
            initialMarkdown={poolNote}
            onSave={saveMarkdown}
          />
        </div>
      </div>
    </div>
  );
}

export default Pool;
