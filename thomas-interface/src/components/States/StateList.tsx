import React, { useState, useEffect, useRef } from 'react';
import { State } from './types';
import StateRow from './StateRow';
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

const sortStates = (a: State, b: State) => {
  const currentTime = Date.now();

  const aValueListEmpty = a.value.length === 0;
  const bValueListEmpty = b.value.length === 0;
  const aExpired = a.expiration !== null && a.expiration < currentTime;
  const bExpired = b.expiration !== null && b.expiration < currentTime;
  const aLatestValue = aValueListEmpty ? null : a.value[a.value.length - 1].value;
  const bLatestValue = bValueListEmpty ? null : b.value[b.value.length - 1].value;

  // Empty value list states on top
  if (aValueListEmpty && bValueListEmpty) {
    return b.timestamp - a.timestamp; // Newest first
  }
  if (aValueListEmpty && !bValueListEmpty) return -1;
  if (!aValueListEmpty && bValueListEmpty) return 1;

  // Among non-empty states, expired ones come next
  if (aExpired && !bExpired) return -1;
  if (!aExpired && bExpired) return 1;

  // Among expired states, older ones come first
  if (aExpired && bExpired) {
    return (a.expiration || 0) - (b.expiration || 0);
  }

  // Among non-expired states, false-valued on top with nearest expiration first
  if (aLatestValue !== null && bLatestValue !== null) {
    if (!aLatestValue && bLatestValue) return -1;
    if (aLatestValue && !bLatestValue) return 1;

    // If both have the same value, sort by nearest expiration
    return (a.expiration || Infinity) - (b.expiration || Infinity);
  }

  return 0;
};

const filterStatesByTags = (states: Record<string, State>, tags: string[], operation: string): Record<string, State> => {
  if (tags.length === 0) return states; // No filtering if no tags are selected

  const filteredStates: Record<string, State> = {};

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

const StateList = () => {
  const [newDescription, setNewDescription] = useState('');
  const inputRef = useRef<HTMLInputElement>(null);  // Create a ref for the input element
  const [tags, setTags] = useState<string[]>([]);
  const [uniqueTags, setUniqueTags] = useState<string[]>([]);
  const [selectedOperation, setSelectedOperation] = useState('some');
  const [triggerRerender, setTriggerRerender] = useState(false);
  const [withTags, setWithTags] = useState(true);
  const [isLoading, setIsLoading] = useState(true);
  const [displayList, setDisplayList] = useState<[key: string, state: State][]>([]);

  // Zustand store usage
  const states = useStore((state: StoreState & StoreActions) => state.states);
  const setState = useStore((state: StoreState & StoreActions) => state.setState);
  const getAllTags = useStore((state: StoreState & StoreActions) => state.getAllTags);

  // Function to trigger re-render
  const triggerRefresh = () => {
    setTriggerRerender(prev => !prev); // Toggle the state to trigger a re-render
  };
  
  const serverFolderPath = '/states';

  useEffect(() => {
    const loadStatesFromServer = async () => {
      setIsLoading(true);
      try {
        const paths: string[] = await api.jsonTree(serverFolderPath);
        const fullPaths = paths.map(path => `${serverFolderPath}${path}`);
        const statesData: Record<string, State> = await api.jsonReadMany(fullPaths);
        Object.entries(statesData).forEach(([path, state]) => {
          const id = path.split('/').pop()?.split('.')[0]; // Assuming the filename is the ID
          if (id) { setState(id, state); }
        });
        setUniqueTags(getAllTags());
        const sortedArray = Object.entries(filterStatesByTags(states, tags, selectedOperation))
          .sort(([keyA, stateA], [keyB, stateB]) => sortStates(stateA, stateB));
        setDisplayList(sortedArray);
      } catch (error) {
        console.error('Error fetching states from server:', error);
      } finally {
        setIsLoading(false);
      }
    };
    loadStatesFromServer();
  }, [getAllTags, selectedOperation, setState, states, tags]);

  useEffect(() => {
    const sortedArray = Object.entries(filterStatesByTags(states, tags, selectedOperation))
      .sort(([keyA, stateA], [keyB, stateB]) => sortStates(stateA, stateB));
    setDisplayList(sortedArray);
  }, [selectedOperation, states, tags, triggerRerender]); // Listen to changes in states and triggerRerender


  const addState = async () => {
    if (newDescription.trim() !== '') {
      const newState = {
        timestamp: Date.now(),
        description: newDescription,
        value: [],
        shelflife: null,
        expiration: null,
        tags: withTags ? tags : []
      }
      setNewDescription('');
      const id = uuidv4();
      setState(id, newState);
      await api.jsonPut(`${serverFolderPath}/${id}.json`, newState);
      setUniqueTags(getAllTags());
    }
  };

  const handleKeyDown = (event: React.KeyboardEvent) => {
    if (event.key === 'Enter') {
      addState();
    } else if (event.key === 'Escape') {
      setNewDescription('');  // Clear the input
      inputRef.current?.blur();  // Defocus the input element
    }
  };

  const addFilterTag = async (tag: string) => {
    const cleanTag = tag.trim().toLowerCase();
    if (!tags.includes(cleanTag)) {
      setTags([...tags, cleanTag ]);
    }
  }

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
              placeholder="Enter State Description"
              className="p-2 border border-gray-300 rounded"
            />
            <button 
              onClick={addState}
              className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
            >
              Add State
            </button>
          </div>
        </div>
        <div className="flex flex-col items-center h-auto">
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
              <TagSearchBar tags={uniqueTags} onTagSelected={addFilterTag} />
              <div className="flex items-center ml-2">
                <input 
                  type="checkbox"
                  checked={withTags}
                  onChange={() => setWithTags(prev => !prev)}
                  className="mr-1"
                />
                <label title="Attach current tags to new states.">
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
        {
          !isLoading && (
              displayList.map(([key, state]) => {
                return (
                  <StateRow
                    key={key}
                    id={key}
                    state={state}
                    triggerRefresh={triggerRefresh}
                  />
                );
              })
          )
        }

      </div>
    </div>
  );
};

export default StateList;