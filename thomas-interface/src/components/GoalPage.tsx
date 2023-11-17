import React, { useState, useEffect } from 'react';
import MarkdownEditor from './MarkdownEditor';
import GoalList from './GoalList';
import Harvest from './Harvest';
import api from '../api';
import '../global.css';

type Goal = { id: string, tags?: string[], description: string, complete: boolean, actionable: boolean }; // Type for pool object

function GoalPage({ host, name, goalKey }: { host: any; name: any; goalKey: any; }) {
  const poolId = `/${host}/${name}`;
  const goalId = `/${host}/${name}/${goalKey}`;
  const [parent, setParent] = useState<string | null>(null);
  const [goalDescription, setGoalDescription] = useState<string>('');
  const [goalNote, setGoalNote] = useState<string>('');
  const [newDescription, setNewDescription] = useState<string>('');
  const [refreshKids, setRefreshKids] = useState(false);
  const [refreshHarvest, setRefreshHarvest] = useState(false);
  const [actionType, setActionType] = useState('move');
  const [goalId1, setGoalId1] = useState<string>('');
  const [goalId2, setGoalId2] = useState<string>('');
  const [activeTab, setActiveTab] = useState('Sub-goals');
  const [harvestTags, setHarvestTags] = useState<string[]>([]);
  const [selectedOperation, setSelectedOperation] = useState('some');
  const [goalTags, setGoalTags] = useState<string[]>([]);

  // Function to toggle refreshFlag
  const triggerRefreshKids = () => {
    setRefreshKids(!refreshKids);
  };

  // Function to toggle refreshFlag
  const triggerRefreshHarvest = () => {
    setRefreshHarvest(!refreshHarvest);
  };

  // Fetch pools on mount
  useEffect(() => {
    const fetch = async () => {
      try {
        const fetchedDesc = await api.getGoalDesc(goalId);
        setGoalDescription(fetchedDesc);
        const fetchedNote = await api.getGoalNote(goalId);
        setGoalNote(fetchedNote);
        const fetchedParent = await api.getGoalParent(goalId);
        setParent(fetchedParent);
        const fetchedTags = await api.getGoalTags(goalId);
        setGoalTags(fetchedTags);
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

  const handleGoClick = async () => {
    try {
      const id2 = goalId2 === '' ? null : goalId2;
      if (actionType === 'move') {
        await api.move(goalId1, id2);
      } else if (actionType === 'nest') {
        await api.move(goalId1, id2);
      }
      triggerRefreshKids();
    } catch (error) {
      console.error(error);
    }
  };

  // Function to handle adding tags
  const addHarvestTag = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && e.currentTarget.value.trim() !== '') {
      setHarvestTags([...harvestTags, e.currentTarget.value.trim()]);
      e.currentTarget.value = ''; // Clear the input
    }
  };

  // Function to handle removing tags
  const removeHarvestTag = (index: number) => {
    setHarvestTags(harvestTags.filter((_, i) => i !== index));
  };
  // Function to handle adding tags
  const addGoalTag = async (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && e.currentTarget.value.trim() !== '') {
      try {
        await api.addGoalTag(goalId, e.currentTarget.value.trim()); // Assuming such a function exists in your API
        const fetchedTags = await api.getGoalTags(goalId);
        setGoalTags(fetchedTags);
        e.currentTarget.value = ''; // Clear the input
      } catch (error) {
        console.error("Error adding goal tag: ", error);
      }
    }
  };

  // Function to handle removing tags from a goal
  const removeGoalTag = async (index: number) => {
    const tagToRemove = goalTags[index];
    try {
      await api.delGoalTag(goalId, tagToRemove); // Assuming such a function exists in your API
      const fetchedTags = await api.getGoalTags(goalId);
      setGoalTags(fetchedTags);
    } catch (error) {
      console.error("Error removing goal tag: ", error);
    }
  };

  return (
    <div className="bg-gray-200 h-full flex justify-center items-center">
      <div className="bg-blue-300 p-6 rounded shadow-md w-full">
        <div className="flex justify-between pb-2">
          {parent && (
            <a href={`/goal${parent}`} className="mr-2">
              <h2 className="text-blue-800">Parent Goal</h2>
            </a>
          )}
          <a href={`/pool${poolId}`} className="mr-2">
            <h2 className="text-blue-800">Parent Pool</h2>
          </a>
          <a href="/pools" className="mr-2">
            <h2 className="text-blue-800">All Pools</h2>
          </a>
        </div>
        <h1 className="text-2xl font-semibold text-blue-600 text-center mb-4">
          {goalDescription}
        </h1>
        <div className="flex flex-row justify-center items-center w-full mb-4 h-auto">
          <input
            type="text"
            placeholder="Enter tags..."
            className="p-2 w-1/3 border box-border rounded"
            onKeyDown={addGoalTag}
          />
        </div>
        <div className="flex flex-wrap justify-center mb-4">
          {goalTags.map((tag, index) => (
            <div key={index} className="flex items-center bg-gray-200 rounded px-2 py-1 m-1">
              {tag}
              <button 
                className="ml-2 rounded-full bg-gray-300 hover:bg-gray-400"
                onClick={() => removeGoalTag(index)}
              >
                ×
              </button>
            </div>
          ))}
        </div>
        <div className="flex justify-center mb-4">
          <div className="p-1">
            <select onChange={(e) => setActionType(e.target.value)} value={actionType}>
              <option value="move">Move</option>
              <option value="nest">Nest</option>
            </select>
          </div>
          <div className="p-1">
            <input 
              type="text" 
              placeholder="Goal ID 1" 
              value={goalId1} 
              onChange={(e) => setGoalId1(e.target.value)} 
            />
          </div>
          <div className="p-1">
            <input 
              type="text" 
              placeholder="Goal ID 2" 
              value={goalId2} 
              onChange={(e) => setGoalId2(e.target.value)} 
            />
          </div>
          
          <button
            className="p-1 bg-gray-100 justify-center flex items-center rounded"
            onClick={handleGoClick}
          >
            Go
          </button>
        </div>
        <div className="border-b">
          <ul className="flex justify-center -mb-px">
            <li className={`${activeTab === 'Sub-goals' ? 'border-blue-500' : ''}`}>
              <button 
                className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                  activeTab === 'Sub-goals' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
                }`} 
                onClick={() => setActiveTab('Sub-goals')}
              >
                Sub-goals
              </button>
            </li>
            <li className={`${activeTab === 'Harvest' ? 'border-blue-500' : ''}`}>
              <button 
                className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                  activeTab === 'Harvest' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
                }`} 
                onClick={() => setActiveTab('Harvest')}
              >
                Harvest
              </button>
            </li>
          </ul>
        </div>
        {activeTab === 'Sub-goals' && (
          <div>
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
        )}
        {activeTab === 'Harvest' && (
          <>
            <div className="flex flex-col items-center h-auto">
              <div className="flex justify-center items-center w-full mb-4">
                <div className="flex flex-row justify-center items-center">
                  <select
                    className="p-2 border rounded mr-2"
                    value={selectedOperation}
                    onChange={(e) => setSelectedOperation(e.target.value)}
                  >
                    <option value="some">Some</option>
                    <option value="every">Every</option>
                  </select>
                  <input
                    type="text"
                    placeholder="Enter tags..."
                    className="p-2 flex-grow border box-border rounded"
                    onKeyDown={addHarvestTag}
                  />
                </div>
              </div>
              <div className="flex flex-wrap justify-center mb-4">
                {harvestTags.map((tag, index) => (
                  <div key={index} className="flex items-center bg-gray-200 rounded px-2 py-1 m-1">
                    {tag}
                    <button 
                      className="ml-2 rounded-full bg-gray-300 hover:bg-gray-400"
                      onClick={() => removeHarvestTag(index)}
                    >
                      ×
                    </button>
                  </div>
                ))}
              </div>
            </div>
            <Harvest host={host} name={name} goalKey={goalKey} method={selectedOperation} tags={harvestTags} refresh={triggerRefreshHarvest}/>
          </>
        )}
      </div>
    </div>
  );
}

export default GoalPage;
