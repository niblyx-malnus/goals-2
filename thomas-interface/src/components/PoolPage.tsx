import React, { useState, useEffect } from 'react';
import MarkdownEditor from './MarkdownEditor';
import { useNavigate } from 'react-router-dom';
import GoalList from './GoalList';
import Harvest from './Harvest';
import api from '../api';
import '../global.css';

function Pool({ host, name }: { host: any; name: any; }) {
  const poolId = `/${host}/${name}`;
  const [poolTitle, setPoolTitle] = useState<string>('');
  const [poolNote, setPoolNote] = useState<string>('');
  const [newDescription, setNewDescription] = useState<string>('');
  const [refreshRoots, setRefreshRoots] = useState(false);
  const [refreshHarvest, setRefreshHarvest] = useState(false);
  const [actionType, setActionType] = useState('move');
  const [goalId1, setGoalId1] = useState<string>('');
  const [goalId2, setGoalId2] = useState<string>('');
  const [activeTab, setActiveTab] = useState('Roots');
  const [tags, setTags] = useState<string[]>([]);
  const [selectedOperation, setSelectedOperation] = useState('some');
  const [allTags, setAllTags] = useState<string[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [filteredTags, setFilteredTags] = useState<string[]>([]);
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const [isCollapsed, setIsCollapsed] = useState(true);

  const toggleCollapse = () => {
    setIsCollapsed(!isCollapsed);
  };
  
  const navigate = useNavigate();

  const fetchTags = async () => {
    try {
      const fetchedTags = await api.getPoolTags(poolId);
      setAllTags(fetchedTags);
      setFilteredTags(fetchedTags); // Initialize with all tags
    } catch (error) {
      console.error("Error fetching tags: ", error);
    }
  };

  // Fetch all tags on mount
  useEffect(() => {
    // Assuming an API method to fetch all tags for the pool
    fetchTags();
  }, []);

  // Filter tags based on search term
  useEffect(() => {
    const filtered = allTags.filter(tag => tag.toLowerCase().includes(searchTerm.toLowerCase()));
    setFilteredTags(filtered);
  }, [searchTerm, allTags]);

    // Navigate to PoolTagPage
  const navigateToTagPage = (tag: string) => {
    setDropdownOpen(false);
    navigate(`/tag/${host}/${name}/${tag}`);
  };

  // Handle tag search input focus
  const handleInputFocus = async () => {
    fetchTags();
    setDropdownOpen(true);
  };

  const handleInputBlur = () => {
    // Delay the close to allow for navigation to tag page
    setTimeout(() => {
      setDropdownOpen(false);
    }, 100);
  };

  // Function to toggle refreshFlag
  const triggerRefreshRoots = () => {
    setRefreshRoots(!refreshRoots);
  };

  // Function to toggle refreshFlag
  const triggerRefreshHarvest = () => {
    setRefreshHarvest(!refreshHarvest);
  };

  // Fetch pools on mount
  useEffect(() => {
    const fetch = async () => {
      try {
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
        await api.createGoal(`/${host}/${name}`, null, newDescription, true);
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

  const handleGoClick = async () => {
    try {
      const id2 = goalId2 === '' ? null : goalId2;
      if (actionType === 'move') {
        await api.move(goalId1, id2);
      } else if (actionType === 'nest') {
        await api.move(goalId1, id2);
      }
      triggerRefreshRoots();
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <div className="bg-gray-200 flex justify-center items-center h-screen">
      <div className="bg-[#FAF3DD] p-6 rounded shadow-md w-full h-screen overflow-y-auto">
        <div className="flex justify-between items-center mb-4">
          <div className="tag-search-dropdown relative">
            <input
              type="text"
              placeholder="Search Pool Tags"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              onFocus={handleInputFocus}
              onBlur={handleInputBlur}
              className="p-2 border box-border rounded text-sm"
              style={{ width: '200px', height: '2rem' }}
            />
            {dropdownOpen && (
              <div className="tag-list absolute right-0 bg-gray-100 border rounded mt-1 w-48 max-h-60 overflow-auto">
                {filteredTags.map((tag, index) => (
                  <div
                    key={index}
                    className="tag-item p-1 hover:bg-gray-200 cursor-pointer"
                    onClick={() => navigateToTagPage(tag)}
                    style={{ lineHeight: '1.5rem' }}
                  >
                    {tag}
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
        <h2 className="text-blue-800">
          <a href="/apps/goals/pools" className="mr-2">All Pools</a>
        </h2>
        <h1 className="text-2xl font-semibold text-blue-600 text-center mb-4">
          {poolTitle}
        </h1>
        <div className="w-full px-1">
          <div 
            className="flex items-center justify-between cursor-pointer p-2 border-b"
            onClick={toggleCollapse}
          >
            <span>Yoke Action</span>
            {/* Optional: Replace the following span with an icon component */}
            <span>{isCollapsed ? '▼' : '▲'}</span> 
            {/* <FiChevronDown /> for down arrow and <FiChevronUp /> for up arrow */}
          </div>

          {!isCollapsed && (
            <div className="flex flex-col items-center justify-center mb-4">
              <div className="w-full p-1">
                <select 
                  onChange={(e) => setActionType(e.target.value)} 
                  value={actionType}
                  className="w-full p-2 border box-border rounded text-sm"
                >
                  <option value="move">Move</option>
                  <option value="nest">Nest</option>
                </select>
              </div>
              <div className="w-full p-1">
                <input 
                  type="text" 
                  placeholder="Goal ID 1" 
                  value={goalId1} 
                  onChange={(e) => setGoalId1(e.target.value)}
                  className="w-full p-2 border box-border rounded text-sm"
                />
              </div>
              <div className="w-full p-1">
                <input 
                  type="text" 
                  placeholder="Goal ID 2 (optional)" 
                  value={goalId2} 
                  onChange={(e) => setGoalId2(e.target.value)}
                  className="w-full p-2 border box-border rounded text-sm"
                />
              </div>
              <button
                className="p-2 bg-gray-100 rounded flex items-center justify-center"
                onClick={handleGoClick}
              >
                Go
              </button>
            </div>
          )}
        </div>
        <div className="border-b">
          <ul className="flex justify-center -mb-px">
            <li className={`${activeTab === 'Roots' ? 'border-blue-500' : ''}`}>
              <button 
                className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                  activeTab === 'Roots' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
                }`} 
                onClick={() => setActiveTab('Roots')}
              >
                Roots
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
        {activeTab === 'Roots' && (
          <>
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
            <GoalList host={host} name={name} goalKey={null} refresh={triggerRefreshRoots}/>
            <div className="p-6 markdown-container all:unstyled overflow-y-auto">
              <MarkdownEditor
                initialMarkdown={poolNote}
                onSave={saveMarkdown}
              />
            </div>
          </>
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
            <Harvest host={host} name={name} goalKey={null} method={selectedOperation} tags={tags} refresh={triggerRefreshHarvest}/>
          </>
         )}
        </div>
      </div>
  );
}

export default Pool;
