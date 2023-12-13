import React, { useState, useEffect } from 'react';
import MarkdownEditor from './MarkdownEditor';
import Harvest from './Harvest';
import api from '../api';
import '../global.css';

function PoolTagPage({ host, name, tag }: { host: any; name: any; tag: any; }) {
  const poolId = `/${host}/${name}`;
  const [poolTagNote, setPoolTagNote] = useState<string>('');
  const [refreshHarvest, setRefreshHarvest] = useState(false);
  const [selectedOperation, setSelectedOperation] = useState('some');
  const [tags, setTags] = useState<string[]>([]);

  // Function to toggle refreshFlag
  const triggerRefreshHarvest = () => {
    setRefreshHarvest(!refreshHarvest);
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
  }, []);

  const saveMarkdown = async (markdown: string) => {
    try {
      await api.editPoolTagNote(poolId, tag, markdown);
      const fetchedNote = await api.getPoolTagNote(poolId, tag);
      setPoolTagNote(fetchedNote);
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <div className="bg-gray-200 h-full flex justify-center items-center">
      <div className="bg-[#FAF3DD] p-6 rounded shadow-md w-full">
        <a href={`/pool${poolId}`} className="mr-2 flex">
          <h2 className="text-blue-800">Parent Pool</h2>
        </a>
        <h1 className="text-2xl font-semibold text-blue-600 text-center mb-4">
          {tag}
        </h1>
        <div className="p-6 markdown-container all:unstyled overflow-y-auto">
          <MarkdownEditor
            initialMarkdown={poolTagNote}
            onSave={saveMarkdown}
          />
        </div>
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
                onKeyDown={(e) => {
                  if (e.key === 'Enter' && e.currentTarget.value.trim() !== '') {
                    setTags([...tags, e.currentTarget.value.trim()]);
                    e.currentTarget.value = ''; // Clear the input
                  }
                }}
              />
            </div>
          </div>
          <div className="flex flex-wrap justify-center mb-4">
            {tags.map((tag, index) => (
              <div key={index} className="flex items-center bg-gray-200 rounded px-2 py-1 m-1">
                {tag}
                <button 
                  className="ml-2 rounded-full bg-gray-300 hover:bg-gray-400"
                  onClick={() => setTags(tags.filter((_, i) => i !== index))}
                >
                  ×
                </button>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

// <Harvest host={host} name={name} goalKey={tag} method={selectedOperation} tags={tags} refresh={triggerRefreshHarvest}/>

export default PoolTagPage;