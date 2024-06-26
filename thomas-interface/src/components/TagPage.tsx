import React, { useState, useEffect } from 'react';
import MarkdownEditor from './MarkdownEditor';
import TagGoalList from './TagGoalList';
import TagHarvestList from './TagHarvestList';
import api from '../api';
import useCustomNavigation from './useCustomNavigation';

function TagPage({ tag }: { tag: any; }) {
  const [localTagNote, setLocalTagNote] = useState<string>('');
  const [refreshGoals, setRefreshGoals] = useState(false);
  const [refreshHarvest, setRefreshHarvest] = useState(false);
  const [activeTab, setActiveTab] = useState('Goals');
  const { navigateToPools } = useCustomNavigation();

  // Fetch pool tag details on mount
  useEffect(() => {
    const fetch = async () => {
      try {
        const fetchedNote = await api.getTagNote(tag);
        setLocalTagNote(fetchedNote);
      } catch (error) {
        console.error("Error fetching pool tag details: ", error);
      }
    };
    fetch();
  }, [tag]);

  const saveMarkdown = async (markdown: string) => {
    try {
      await api.editLocalTagNote(tag, markdown);
      const fetchedNote = await api.getTagNote(tag);
      setLocalTagNote(fetchedNote);
    } catch (error) {
      console.error(error);
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
            onClick={() => navigateToPools(api.destination)}
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
        {activeTab === 'Goals' && (
          <>
            <TagGoalList host={null} name={null} tag={tag} refresh={triggerRefreshRoots}/>
          </>
        )}
        {activeTab === 'Harvest' && (
          <>
            <TagHarvestList host={null} name={null} tag={tag} refresh={triggerRefreshHarvest}/>
          </>
        )}
        <div className="p-6 markdown-container all:unstyled overflow-y-auto">
          <MarkdownEditor
            initialMarkdown={localTagNote}
            onSave={saveMarkdown}
          />
        </div>
      </div>
    </div>
  );
}

export default TagPage;