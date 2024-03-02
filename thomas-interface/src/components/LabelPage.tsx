import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import MarkdownEditor from './MarkdownEditor';
import PoolTagGoalList from './LabelGoalList';
import PoolTagHarvestList from './LabelHarvestList';
import api from '../api';

function LabelPage({ host, name, tag }: { host: any; name: any; tag: any; }) {
  const poolId = `/${host}/${name}`;
  const [poolTagNote, setPoolTagNote] = useState<string>('');
  const [newDescription, setNewDescription] = useState<string>('');
  const [refreshGoals, setRefreshGoals] = useState(false);
  const [refreshHarvest, setRefreshHarvest] = useState(false);
  const [activeTab, setActiveTab] = useState('Goals');

  const navigate = useNavigate();

  const navigateToAllPools = () => {
    navigate(`/pools`);
  };

  const navigateToPoolPage = () => {
    navigate(`/pool/${host}/${name}`);
  };

  // Fetch pool tag details on mount
  useEffect(() => {
    const fetch = async () => {
      try {
        const fetchedNote = await api.getLabelNote(poolId, tag);
        setPoolTagNote(fetchedNote);
      } catch (error) {
        console.error("Error fetching pool tag details: ", error);
      }
    };
    fetch();
  }, [poolId, tag]);

  const saveMarkdown = async (markdown: string) => {
    try {
      await api.editPoolTagNote(poolId, tag, markdown);
      const fetchedNote = await api.getLabelNote(poolId, tag);
      setPoolTagNote(fetchedNote);
    } catch (error) {
      console.error(error);
    }
  };

  const handleAddTitle = async () => {
    if (newDescription.trim() !== '') {
      try {
        await api.createGoalWithTag(`/${host}/${name}`, null, newDescription, true, tag);
      } catch (error) {
        console.error(error);
      }
      setNewDescription('');
    }
  };

  const triggerRefreshRoots = () => {
    setRefreshGoals(!refreshGoals);
  };

  const triggerRefreshHarvest = () => {
    setRefreshHarvest(!refreshHarvest);
  };

  return (
    <div className="bg-gray-200 h-full flex justify-center items-center">
      <div className="bg-[#FAF3DD] p-6 rounded shadow-md w-full">
        <div className="flex justify-between pb-2">
          <div
            className="cursor-pointer"
            onClick={navigateToPoolPage}
          >
            <h2 className="text-blue-800">Parent Pool</h2>
          </div>
          <div
            className="cursor-pointer"
            onClick={navigateToAllPools}
          >
            <h2 className="text-blue-800">All Pools</h2>
          </div>
        </div>
        <h1 className="text-2xl font-semibold text-blue-600 text-center mb-4">
          {tag}
        </h1>
        <div className="border-b">
          <ul className="flex justify-center -mb-px">
            <li className={`${activeTab === 'Goals' ? 'border-blue-500' : ''}`}>
              <button 
                className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                  activeTab === 'Goals' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
                }`} 
                onClick={() => setActiveTab('Goals')}
              >
                Goals
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
        {activeTab === 'Goals' && (
          <>
            <PoolTagGoalList host={host} name={name} tag={tag} refresh={triggerRefreshRoots}/>
          </>
        )}
        {activeTab === 'Harvest' && (
          <>
            <PoolTagHarvestList host={host} name={name} tag={tag} refresh={triggerRefreshHarvest}/>
          </>
        )}
        <div className="p-6 markdown-container all:unstyled overflow-y-auto">
          <MarkdownEditor
            initialMarkdown={poolTagNote}
            onSave={saveMarkdown}
          />
        </div>
      </div>
    </div>
  );
}

export default LabelPage;