import React, { useState, useEffect, useRef } from 'react';
import { FiTrash, FiEdit, FiSave, FiX, FiClock, FiCalendar, FiTag } from 'react-icons/fi';
import ToggleButton from './ToggleButton';
import { State } from './types';
import api from '../../api';
import useStore, { StoreState, StoreActions } from './store';

const serverFolderPath = '/states';

interface StateRowProps {
  id: string;
  state: State;
  triggerRefresh: () => void;
}

const StateRow: React.FC<StateRowProps> = ({ 
  id,
  state,
  triggerRefresh,
}) => {
  const [editDescription, setEditDescription] = useState('');
  const [editing, setEditing] = useState(false);
  const [panel, setPanel] = useState('');
  const [selectedExpiration, setSelectedExpiration] = useState('');
  const [newTag, setNewTag] = useState('');
  const [isExpired, setIsExpired] = useState(false);

    // Zustand store usage
  const setState = useStore((state: StoreState & StoreActions) => state.setState);
  const delState = useStore((state: StoreState & StoreActions) => state.delState);
  const getAllTags = useStore((state: StoreState & StoreActions) => state.getAllTags);

  // Dropdown UI logic (similar to TagSearchBar)
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const handleInputFocus = () => {
    setDropdownOpen(true);
  };
  const handleInputBlur = () => {
    setTimeout(() => {
      setDropdownOpen(false);
    }, 100);
  };

  useEffect(() => {
    // Function to check expiration and update color
    const checkExpiration = () => {
      const currentTime = Date.now();
      if (state.expiration !== null && state.expiration < currentTime) {
        setIsExpired(true); // Set as expired if the current time is past expiration
        triggerRefresh();
      } else {
        setIsExpired(false);
      }
    };

    // Check immediately and set an interval for continuous checking
    checkExpiration();
    const intervalId = setInterval(checkExpiration, 1000);

    // Cleanup function to clear the interval
    return () => clearInterval(intervalId);
  }, [state.expiration, triggerRefresh]);

  const saveStateToServer = async (id: string, state: State) => {
    try {
      await api.jsonPut(`${serverFolderPath}/${id}.json`, state);
    } catch (error) {
      console.error('Error saving state to server:', error);
    }
  };
  
  const handleAddTag = async (newTag: string) => {
    if (newTag.trim() !== '' && !state.tags.includes(newTag)) {
      const cleanTag = newTag.trim().toLowerCase();
      const newState: State = { ...state, tags: [...state.tags, cleanTag] };
      setState(id, newState);
      await saveStateToServer(id, newState);
      setNewTag('');
      triggerRefresh();
    }
  };
  
  const handleRemoveTag = async (tag: string) => {
    const newState = { ...state, tags: state.tags.filter((t: string) => t !== tag) };
    setState(id, newState);
    await saveStateToServer(id, newState);
    triggerRefresh();
  };

  const toggleTagsPanel = () => {
    if (panel === 'tags') {
        setPanel('');
    } else {
      setPanel('tags');
    }
  };

  const [days, setDays] = useState<number>(0);
  const [hours, setHours] = useState<number>(0);
  const [minutes, setMinutes] = useState<number>(0);
  const [seconds, setSeconds] = useState<number>(0);

  // Convert shelf life in seconds to days, hours, minutes, and seconds
  useEffect(() => {
    if (state.shelflife != null) {
      const totalSeconds = Math.floor(state.shelflife / 1000);
      const days = Math.floor(totalSeconds / 86400);
      const hours = Math.floor((totalSeconds % 86400) / 3600);
      const minutes = Math.floor((totalSeconds % 3600) / 60);
      const seconds = totalSeconds % 60;

      setDays(days);
      setHours(hours);
      setMinutes(minutes);
      setSeconds(seconds);
    }
  }, [state.shelflife, panel]);

  // Format expiration date
  useEffect(() => {
    if (state.expiration != null) {
      const expirationDate = new Date(state.expiration).toLocaleString('sv-SE').replace(' ', 'T');
      setSelectedExpiration(expirationDate);
    } else {
      setSelectedExpiration('');
    }
  }, [state.expiration, panel]);

  const toggleDateTimePicker = () => {
    if (panel === 'expiration') {
        setPanel('');
    } else {
      setPanel('expiration');
    }
  };

  const applyShelflife = (state: State) => {
    let newExpiration = null;
    if (state.shelflife != null) {
      newExpiration = Date.now() + state.shelflife;
    }
    return { ...state, expiration: newExpiration };
  }

  const toggleStateLocal = async (newValue: boolean) => {
    let newState = applyShelflife(state);
    newState = { 
      ...newState, 
      value: [...newState.value, { timestamp: Date.now(), value: newValue }],
    };
    setState(id, newState);
    await saveStateToServer(id, newState);
  };

  const handleDateTimeChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSelectedExpiration(e.target.value);
  };

  const rowRef = useRef<HTMLDivElement>(null); // Ref for the entire row

  useEffect(() => {
    // Function to check if clicked outside of the row
    function handleClickOutside(event: MouseEvent) {
      if (rowRef.current && !rowRef.current.contains(event.target as Node)) {
        setPanel('');
      }
    }

    // Bind the event listener
    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      // Unbind the event listener on clean up
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [rowRef]);

  const includeNullState = state.value.length === 0;
  const latestValue = state.value[state.value.length - 1]?.value;
  const isEmptyValueList = state.value.length === 0;

  let rowBackgroundColor;
  if (isExpired) {
    rowBackgroundColor = 'bg-yellow-200';
  } else {
    rowBackgroundColor = isEmptyValueList ? 'bg-gray-300' : latestValue ? 'bg-green-300' : 'bg-red-300';
  }

  const startEditing = () => {
    setEditDescription(state.description);
    setEditing(true);
  };

  const applyEditLocal = async () => {
    if (editDescription.trim() !== '') {
      const newState = { ...state, description: editDescription };
      setState(id, newState);
      await saveStateToServer(id, newState);
    }
    setEditing(false);
    setEditDescription('');
  };

  const cancelEdit = () => {
    setEditing(false);
    setEditDescription('');
  };

  const handleKeyDown = (event: React.KeyboardEvent) => {
    if (event.key === 'Enter') {
      applyEditLocal();
    } else if (event.key === 'Escape') {
      cancelEdit();
    }
  };

  const toggleTimePanel = () => {
    if (panel === 'shelflife') {
        setPanel('');
    } else {
      setPanel('shelflife');
    }
  };

  const updateField = (value: string, fieldSetter: React.Dispatch<React.SetStateAction<number>>, max: number) => {
    if (value === '') {
      fieldSetter(0);  // Reset to 0 if input is empty
    } else {
      const num = Math.max(0, Math.min(max, parseInt(value) || 0));
      fieldSetter(num);
    }
  };

  const setShelflifeLocal = async () => {
    const totalSeconds = days * 86400 + hours * 3600 + minutes * 60 + seconds;
    const newState = (totalSeconds === 0)
      ? { ...state, shelflife: null, expiration: null }
      : { ...state, shelflife: totalSeconds * 1000, expiration: Date.now() + totalSeconds * 1000 };
    setState(id, newState);
    await saveStateToServer(id, newState);
    setPanel('');
    setDays(0);
    setHours(0);
    setMinutes(0);
    setSeconds(0);
  };

  const setExpirationLocal = async () => {
    // Convert the selected date to a Unix timestamp
    const expirationTimestamp = selectedExpiration ? new Date(selectedExpiration).getTime() : null;
    const newState = { ...state, expiration: expirationTimestamp };
    setState(id, newState);
    await saveStateToServer(id, newState);
    setSelectedExpiration('')
    setPanel(''); // Close the panel after applying
  };

  const confirmAndDeleteState = async () => {
    const confirmed = window.confirm("Deleting a state is permanent. Are you sure you want to delete this state?");
    if (confirmed) {
      delState(id);
      await api.jsonDel(`${serverFolderPath}/${id}.json`);
    }
  };

  return (
    <div ref={rowRef} className={`flex flex-grow justify-between items-center p-1 mb-2 rounded ${rowBackgroundColor}`}>
      <div className="relative group">
        <FiClock onClick={toggleTimePanel} className="m-1 cursor-pointer text-gray-800" />
    {
      panel === 'shelflife' && (
        <div className="absolute left-full top-full ml-1 z-10 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2">
            <p className="text-center font-bold text-lg mb-2">Set Shelf Life</p>
            <div className="flex items-center justify-center">
              <input
                type="text"
                value={days !== 0 ? days.toString() : ''}
                onChange={(e) => updateField(e.target.value, setDays, Infinity)}
                placeholder="DD"
                className="w-8 text-center border border-gray-300 rounded"
              />
              <span>:</span>
              <input
                type="text"
                value={hours !== 0 ? hours.toString() : ''}
                onChange={(e) => updateField(e.target.value, setHours, 23)}
                placeholder="HH"
                className="w-8 text-center border border-gray-300 rounded"
              />
              <span>:</span>
              <input
                type="text"
                value={minutes !== 0 ? minutes.toString() : ''}
                onChange={(e) => updateField(e.target.value, setMinutes, 59)}
                placeholder="MM"
                className="w-8 text-center border border-gray-300 rounded"
              />
              <span>:</span>
              <input
                type="text"
                value={seconds !== 0 ? seconds.toString() : ''}
                onChange={(e) => updateField(e.target.value, setSeconds, 59)}
                placeholder="SS"
                className="w-8 text-center border border-gray-300 rounded"
              />
            </div>
            <div className="flex justify-center">
              <button
                className="mt-2 px-4 py-1 bg-blue-500 text-white rounded hover:bg-blue-600"
                onClick={setShelflifeLocal}
              >
                Apply
              </button>
            </div>
        </div>
      )
    }
      </div>
      <div className="relative group">
        <FiCalendar
          onClick={toggleDateTimePicker}
          className="m-1 cursor-pointer text-gray-800"
        />
      {
        panel === 'expiration' && (
          <div className="absolute left-full top-full ml-1 z-10 w-48 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2">
            <p className="text-center font-bold text-lg mb-2">Set Expiration</p>
            <input 
              type="datetime-local" 
              value={selectedExpiration}
              onChange={handleDateTimeChange}
              className="p-1 border border-gray-300 rounded w-full mb-2"
            />
            <div className="flex justify-center space-x-2">
              <button
                className="px-4 py-1 bg-blue-500 text-white rounded hover:bg-blue-600"
                onClick={setExpirationLocal}
              >
                Apply
              </button>
            </div>
          </div>
        )
      }
      </div>
      <ToggleButton 
        onChange={toggleStateLocal}
        currentValue={state.value}
        includeNullState={includeNullState}
      />
      <div className="ml-1 mr-1 flex-grow">
        {editing ? (
          <input 
            type="text"
            value={editDescription}
            onChange={(e) => setEditDescription(e.target.value)}
            onKeyDown={handleKeyDown}
            className="border border-gray-300 bg-gray-100 rounded w-full pl-1 pr-1"
          />
        ) : (
          <span className="block text-gray-800">{state.description}</span>
        )}
      </div>
      <div className="flex items-center">
        <div className="relative group">
          <button
            className="m-1 cursor-pointer text-gray-800 relative justify-center flex items-center"
            onClick={toggleTagsPanel}
          >
            <FiTag />
            {state.tags.length > 0 && (
              <span className="absolute -bottom-1.5 -right-1.5 bg-gray-100 rounded-full text-xs px-1">
                {state.tags.length}
              </span>
            )}
          </button>
          {panel === 'tags' && (
            <div className="absolute right-0 top-full mt-1 z-10 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2 w-52"> {/* Adjust width here */}
              <div className="flex items-center">
                <input
                  type="text"
                  value={newTag}
                  onChange={(e) => setNewTag(e.target.value)}
                  onFocus={handleInputFocus}
                  onBlur={handleInputBlur}
                  onKeyDown={(e) => e.key === 'Enter' && handleAddTag(newTag)}
                  className="p-1 border border-gray-300 rounded w-full"
                  placeholder="Add Tag"
                />
                <button onClick={() => handleAddTag(newTag)} className="ml-2 px-2 py-1 bg-blue-500 text-white rounded hover:bg-blue-600">Add</button>
              </div>
              {dropdownOpen && (
                <div className="tag-list absolute bottom-full left-0 bg-gray-100 border rounded mt-1 w-48 max-h-60 overflow-auto">
                  {getAllTags().filter(tag => tag.toLowerCase().includes(newTag.toLowerCase()) && !state.tags.includes(tag)).map((tag, index) => (
                    <div
                      key={index}
                      className="tag-item flex items-center p-1 hover:bg-gray-200 cursor-pointer"
                      onClick={() => {
                        handleAddTag(tag);
                        setDropdownOpen(false);
                      }}
                      style={{ lineHeight: '1.5rem' }}
                    >
                      {tag}
                    </div>
                  ))}
                </div>
              )}
              <ul className="mt-2">
                {state.tags.map((tag, idx) => (
                  <li key={idx} className="flex justify-between items-center p-1 hover:bg-gray-200">
                    {tag}
                    <button
                      onClick={() => handleRemoveTag(tag)}
                    >
                      <FiX className="cursor-pointer text-red-500" />
                    </button>
                  </li>
                ))}
              </ul>
            </div>
          )}
        </div>
        {editing ? (
          <FiSave className="m-1 cursor-pointer text-gray-800" onClick={applyEditLocal} />
        ) : (
          <FiEdit className="m-1 cursor-pointer text-gray-800" onClick={startEditing} />
        )}
        {editing ? (
          <FiX className="m-1 cursor-pointer text-gray-800" onClick={cancelEdit} />
        ) : (
          <FiTrash className="m-1 cursor-pointer text-gray-800" onClick={confirmAndDeleteState} />
        )}
      </div>
    </div>
  );
};

export default StateRow;