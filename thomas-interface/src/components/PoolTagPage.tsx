import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import MarkdownEditor from './MarkdownEditor';
import TagGoalList from './TagGoalList';
import Harvest from './Harvest'; // Assuming this is the correct import
import api from '../api';
import '../global.css';
import { FiEye, FiEyeOff } from 'react-icons/fi';

function PoolTagPage({ host, name, tag }: { host: any; name: any; tag: any; }) {
  const poolId = `/${host}/${name}`;
  const [poolTagNote, setPoolTagNote] = useState<string>('');
  const [selectedOperation, setSelectedOperation] = useState('some');
  const [refreshGoals, setRefreshGoals] = useState(false);
  const [refreshHarvest, setRefreshHarvest] = useState(false);
  const [tags, setTags] = useState<string[]>([]);
  const [activeTab, setActiveTab] = useState('Goals');
  const [tagIsPublic, setTagIsPublic] = useState(false);

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
        const fetchedNote = await api.getPoolTagNote(poolId, tag);
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
      const fetchedNote = await api.getPoolTagNote(poolId, tag);
      setPoolTagNote(fetchedNote);
    } catch (error) {
      console.error(error);
    }
  };

  const handleAddTag = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && e.currentTarget.value.trim() !== '') {
      setTags([...tags, e.currentTarget.value.trim()]);
      e.currentTarget.value = ''; // Clear the input
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
        <div className="p-6 markdown-container all:unstyled overflow-y-auto">
          <MarkdownEditor
            initialMarkdown={poolTagNote}
            onSave={saveMarkdown}
          />
        </div>
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
        {activeTab === 'Goals' && (
          <>
            <TagGoalList host={host} name={name} tag={tag} refresh={triggerRefreshRoots}/>
          </>
        )}
        {activeTab === 'Harvest' && (
          <>
            <Harvest host={host} name={name} goalKey={tag} method={selectedOperation} tags={tags} refresh={triggerRefreshHarvest}/>
          </>
        )}
      </div>
    </div>
  );
}

export default PoolTagPage;