import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import MarkdownEditor from './MarkdownEditor';
import GoalList from './GoalList';
import api from '../api';
import '../global.css';

type Goal = { id: string, description: string }; // Type for pool object

function GoalPage({ host, name, goalKey }: { host: any; name: any; goalKey: any; }) {
  const poolId = `/${host}/${name}`;
  const goalId = `/${host}/${name}/${goalKey}`;
  const [kids, setKids] = useState<Goal[]>([]);
  const  [parent, setParent] = useState<string | null>(null);
  const [goalDescription, setGoalDescription] = useState<string>('');
  const [goalNote, setGoalNote] = useState<string>('');
  const [newDescription, setNewDescription] = useState<string>('');
  const [refreshKids, setRefreshKids] = useState(false);

  // Function to toggle refreshFlag
  const triggerRefreshKids = () => {
    setRefreshKids(!refreshKids);
  };

  // Fetch pools on mount
  useEffect(() => {
    const fetch = async () => {
      try {
        const fetchedKids = await api.getGoalKids(goalId);
        setKids(fetchedKids);
        const fetchedDesc = await api.getGoalDesc(goalId);
        setGoalDescription(fetchedDesc);
        const fetchedNote = await api.getGoalNote(goalId);
        setGoalNote(fetchedNote);
        const fetchedParent = await api.getGoalParent(goalId);
        setParent(fetchedParent);
      } catch (error) {
        console.error("Error fetching pools: ", error);
      }
    };
    fetch();
  }, [goalId]);

  const handleAddTitle = async () => {
    if (newDescription.trim() !== '') {
      try {
        await api.spawnGoal(poolId, goalId, newDescription, true);
        const updatedKids = await api.getGoalKids(goalId);
        setKids(updatedKids);
      } catch (error) {
        console.error(error);
      }
      setNewDescription('');
    }
  };

  const saveMarkdown = async (markdown: string) => {
    try {
      await api.editGoalNote(goalId, markdown);
      const fetchedNote = await api.getGoalNote(goalId);
      setGoalNote(fetchedNote);
    } catch (error) {
      console.error(error);
    }
  }

  return (
    <div className="bg-gray-200 h-full flex justify-center items-center">
      <div className="bg-blue-300 p-6 rounded shadow-md w-full">
        <div className="flex justify-between pb-2">
          <a href={`/pool${poolId}`} className="mr-2">
            <h2 className="text-blue-800">Parent Pool</h2>
          </a>
          {parent && (
            <a href={`/goal${parent}`} className="mr-2">
              <h2 className="text-blue-800">Parent Goal</h2>
            </a>
          )}
          <a href="/pools" className="mr-2">
            <h2 className="text-blue-800">All Pools</h2>
          </a>
        </div>
        <h1 className="text-2xl font-semibold text-blue-600 text-center mb-4">
          {goalDescription}
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
        <GoalList host={host} name={name} goalKey={goalKey} refresh={triggerRefreshKids}/>
        <div className="p-6 markdown-container all:unstyled overflow-y-auto">
          <MarkdownEditor
            initialMarkdown={goalNote}
            onSave={saveMarkdown}
          />
        </div>
      </div>
    </div>
  );
}

export default GoalPage;
