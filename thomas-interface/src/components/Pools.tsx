import React, { useState } from 'react';
import PoolList from './PoolList';
import Harvest from './Harvest';
import PoolTagSearch from './TagSearchBar';
import { FiEye, FiEyeOff } from 'react-icons/fi';
import api from '../api';

function Pools() {
  const [newTitle, setNewTitle] = useState<string>('');
  const [refreshPools, setRefreshPools] = useState(false);
  const [tags, setTags] = useState<string[]>([]); // For managing Harvest tags
  const [selectedOperation, setSelectedOperation] = useState('some'); // For managing the Harvest operation
  const [activeTab, setActiveTab] = useState('Pools'); // New state for active tab
  const [tagIsPublic, setTagIsPublic] = useState(false);

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

  // Function to add a tag for Harvest
  const handleAddTag = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && e.currentTarget.value.trim() !== '') {
      setTags([...tags, e.currentTarget.value.trim()]);
      e.currentTarget.value = ''; // Clear the input
    }
  };

  // Function to remove a tag for Harvest
  const handleRemoveTag = (index: number) => {
    setTags(tags.filter((_, i) => i !== index));
  };

  return (
    <div className="bg-gray-200 h-full flex justify-center items-center h-screen">
      <div className="bg-[#DFF7DC] p-6 rounded shadow-md w-full h-screen overflow-y-auto">
        <div className="flex justify-between items-center mb-4">
          <PoolTagSearch host={''} name={''}/>
        </div>
        <h1 className="text-2xl font-semibold text-blue-600 text-center mb-4">All Pools</h1>
        <ul className="flex justify-center -mb-px">
          <li className={`${activeTab === 'Pools' ? 'border-blue-500' : ''}`}>
            <button 
              className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                activeTab === 'Pools' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
              }`} 
              onClick={() => setActiveTab('Pools')}
            >
              Pools
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
        {activeTab === 'Pools' && (
          <>
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
          </>
        )}
        {activeTab === 'Harvest' && (
          <div className="my-4">
            <div className="flex flex-row justify-center items-center mb-4">
              <select
                className="p-2 border rounded mr-2"
                value={selectedOperation}
                onChange={(e) => setSelectedOperation(e.target.value)}
              >
                <option value="some">Some</option>
                <option value="every">Every</option>
              </select>
              <button
                onClick={() => setTagIsPublic(!tagIsPublic)}
                className="p-2 mr-2 border border-gray-300 bg-gray-200 rounded hover:bg-gray-200 flex items-center justify-center"
                style={{ height: '2rem', width: '2rem' }} // Adjust the size as needed
              >
                {tagIsPublic ? <FiEye /> : <FiEyeOff />}
              </button>
              <input
                type="text"
                placeholder="Enter tags..."
                className="p-2 border box-border rounded"
                onKeyDown={handleAddTag}
              />
            </div>
            <div className="flex flex-wrap justify-center mb-4">
              {tags.map((tag, index) => (
                <div key={index} className="flex items-center bg-gray-200 rounded px-2 py-1 m-1">
                  { false
                    ?  <FiEye className="mr-2"/>
                    : <FiEyeOff className="mr-2"/>
                  }
                  {tag}
                  <button 
                    className="ml-2 rounded-full bg-gray-300 hover:bg-gray-400"
                    onClick={() => handleRemoveTag(index)}
                  >
                    ×
                  </button>
                </div>
              ))}
            </div>
            <Harvest method={selectedOperation} tags={tags} refresh={() => { } } host={null} name={null} goalKey={null} />
          </div>
        )}
      </div>
    </div>
  );
}

export default Pools;