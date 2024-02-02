import React, { useState, useEffect, useRef } from 'react';
import { WeeklyTarget } from './types';
import WeeklyTargetRow from './WeeklyTargetRow';
import api from '../../api';
import useStore, { StoreState, StoreActions } from './store';
import { v4 as uuidv4 } from 'uuid';

function TagSearchBar({ tags, onTagSelected }: { tags: string[], onTagSelected: (tag: string) => void}) {
  const [searchTerm, setSearchTerm] = useState('');
  const [dropdownOpen, setDropdownOpen] = useState(false);

  const handleInputFocus = () => {
    setDropdownOpen(true);
  };

  const handleInputBlur = () => {
    setTimeout(() => {
      setDropdownOpen(false);
    }, 100);
  };

  return (
    <div className="flex items-center tag-search-dropdown relative">
      <input
        type="text"
        placeholder="Add tag filter..."
        value={searchTerm}
        onChange={(e) => setSearchTerm(e.target.value)}
        onFocus={handleInputFocus}
        onBlur={handleInputBlur}
        className="p-2 border box-border rounded text-sm"
        style={{ width: '200px', height: '2rem' }}
      />
      {dropdownOpen && (
        <div className="tag-list absolute top-full right-0 bg-gray-100 border rounded mt-1 w-48 max-h-60 overflow-auto">
        {tags.filter(tag => tag.toLowerCase().includes(searchTerm.toLowerCase())).map((tag, index) => (
            <div
              key={index}
              className="tag-item flex items-center p-1 hover:bg-gray-200 cursor-pointer"
              onClick={() => onTagSelected(tag)}
              style={{ lineHeight: '1.5rem' }}
            >
              {tag}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

const WeeklyTargetList = () => {
  const [newTarget, setNewTarget] = useState(0); // Placeholder for new goal value
  const inputRef = useRef<HTMLInputElement>(null);
  const [tags, setTags] = useState<string[]>([]);
  const [uniqueTags, setUniqueTags] = useState<string[]>([]);
  const [selectedOperation, setSelectedOperation] = useState('some');
  const [withTags, setWithTags] = useState(true);
  const [triggerRerender, setTriggerRerender] = useState(false);
  const [newDescription, setNewDescription] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [displayList, setDisplayList] = useState<[key: string, weeklyTarget: WeeklyTarget][]>([]);

  // Zustand store usage
  const weeklyTargets = useStore((state: StoreState & StoreActions) => state.weeklyTargets);
  const setWeeklyTarget = useStore((state: StoreState & StoreActions) => state.setWeeklyTarget);
  const getAllTags = useStore((state: StoreState & StoreActions) => state.getAllTags);

  // Function to trigger re-render
  const triggerRefresh = () => {
    setTriggerRerender(prev => !prev); // Toggle the state to trigger a re-render
  };

  const serverFolderPath = '/weekly_goals';

  useEffect(() => {
    const loadWeeklyTargetsFromServer = async () => {
      setIsLoading(true);
      try {
        const paths: string[] = await api.jsonTree(serverFolderPath);
        const fullPaths = paths.map(path => `${serverFolderPath}${path}`);
        const weeklyTargetsData: Record<string, WeeklyTarget> = await api.jsonReadMany(fullPaths);
        Object.entries(weeklyTargetsData).forEach(([path, weeklyTarget]) => {
          const id = path.split('/').pop()?.split('.')[0]; // Assuming the filename is the ID
          if (id) { setWeeklyTarget(id, weeklyTarget); }
        });
        setUniqueTags(getAllTags());
        // Apply sorting logic here if needed
        setTriggerRerender(!triggerRerender);
      } catch (error) {
        console.error('Error fetching weekly goals from server:', error);
      } finally {
        setIsLoading(false);
      }
    };
    loadWeeklyTargetsFromServer();
  }, [getAllTags, setWeeklyTarget]);

  const filterWeeklyTargetsByTags = (states: Record<string, WeeklyTarget>, tags: string[], operation: string): Record<string, WeeklyTarget> => {
    if (tags.length === 0) return states; // No filtering if no tags are selected
  
    const filteredStates: Record<string, WeeklyTarget> = {};
  
    Object.entries(states).forEach(([key, state]) => {
      const tagSet = new Set(state.tags);
      const isMatch = operation === 'some' 
        ? tags.some(tag => tagSet.has(tag)) 
        : tags.every(tag => tagSet.has(tag));
  
      if (isMatch) {
        filteredStates[key] = state;
      }
    });
  
    return filteredStates;
  };

  useEffect(() => {
    const filteredTargets = filterWeeklyTargetsByTags(weeklyTargets, tags, selectedOperation);
    const sortedArray = Object.entries(filteredTargets); // You might add sorting logic here if needed
    setDisplayList(sortedArray);
  }, [weeklyTargets, tags, selectedOperation, triggerRerender]);

  const addNewWeeklyTarget = async () => {
    if (newDescription.trim() !== '') {
      const id = uuidv4();
      const newWeeklyTarget: WeeklyTarget = {
        timestamp: Date.now(),
        description: newDescription,
        weeks: {}, // Initialize with empty weeks
        tags: withTags ? tags : [],
      };
      setNewDescription('');
      setWeeklyTarget(id, newWeeklyTarget);
      await api.jsonPut(`${serverFolderPath}/${id}.json`, newWeeklyTarget);
      triggerRefresh();
    }
  };

  const handleTagSelected = (tag: string) => {
    setTags(prevTags => {
      const cleanTag = tag.trim().toLowerCase();
      return prevTags.includes(cleanTag) ? prevTags : [...prevTags, cleanTag];
    });
  };

  const handleKeyDown = (event: React.KeyboardEvent) => {
    if (event.key === 'Enter') {
      addNewWeeklyTarget();
    } else if (event.key === 'Escape') {
      setNewDescription(''); // Clear the input
    }
  };

  return (
    <div className="flex justify-center items-center w-full">
      <div className="p-4 max-w-md w-full">
        <div className="flex flex-col items-center h-auto space-x-2 mb-1">
          <div className="flex items-center space-x-2 mb-1">
            <input 
              type="text"
              value={newDescription}
              onChange={(e) => setNewDescription(e.target.value)}
              onKeyDown={handleKeyDown}
              placeholder="Enter Target Description"
              className="p-2 border border-gray-300 rounded"
            />

            <button 
              onClick={addNewWeeklyTarget}
              className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
            >
              Add
            </button>
          </div>
                    <div className="flex justify-center items-center w-full mb-1">
            <div className="flex flex-row justify-center items-center">
              <select
                className="p-1 border rounded mr-2"
                value={selectedOperation}
                onChange={(e) => setSelectedOperation(e.target.value)}
              >
                <option value="some">Some</option>
                <option value="every">Every</option>
              </select>
              <TagSearchBar tags={getAllTags()} onTagSelected={handleTagSelected} />
              <div className="flex items-center ml-2">
                <input 
                  type="checkbox"
                  checked={withTags}
                  onChange={() => setWithTags(prev => !prev)}
                  className="mr-1"
                />
                <label title="Attach current tags to new weekly goals.">
                  Attach
                </label>
              </div>
            </div>
          </div>
          <div className="flex flex-wrap justify-center mb-1">
            {tags.map((tag, index) => (
              <div key={index} className="flex items-center bg-gray-200 rounded px-2 py-1 m-1">
                {tag}
                <button 
                  className="ml-2"
                  onClick={() => setTags(tags.filter((_, i) => i !== index))}
                >
                  ×
                </button>
              </div>
            ))}
          </div>
        </div>
        { isLoading && (
          <div className="flex justify-center mt-20">
            <div className="animate-spin rounded-full h-16 w-16 border-b-8 border-t-transparent border-blue-500"></div>
          </div>
        )}
        {
          !isLoading && (
            displayList.length === 0 && (
              <div className="text-center mt-5 text-lg text-gray-600">No states found.</div>
            )
          )
        }
        { !isLoading && (
            displayList.map(([key, weeklyTarget]) => (
              <WeeklyTargetRow
                key={key}
                id={key}
                weeklyTarget={weeklyTarget}
                triggerRefresh={triggerRefresh}
              />
            ))
          )
        }
      </div>
    </div>
  );
};

export default WeeklyTargetList;