import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import { FiCopy, FiTag, FiX, FiEdit, FiTrash, FiSave, FiMenu, FiInfo, FiEye, FiEyeOff } from 'react-icons/fi';
import useStore from '../store';

type Tag = {
  isPublic: boolean;
  tag: string;
};

const GoalRow: React.FC<{
    host: string,
    poolName: string,
    name: string,
    id: string,
    complete: boolean,
    actionable: boolean,
    showButtons: boolean,
    tags: Tag[],
    refresh: () => void,
    moveGoalUp: (id: string) => void,
    moveGoalDown: (id: string) => void
  }> = ({
    host,
    poolName,
    name,
    id,
    complete,
    actionable,
    showButtons,
    tags,
    moveGoalUp,
    moveGoalDown,
    refresh
  }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [newDescription, setNewDescription] = useState(name);
  const [isActionable, setIsActionable] = useState(actionable);
  const [isComplete, setIsComplete] = useState(complete);
  const [showTagDropdown, setShowTagDropdown] = useState(false);
  const [newTag, setNewTag] = useState('');
  const rowRef = useRef<HTMLDivElement>(null);
  const [showInfoPanel, setShowInfoPanel] = useState(false);
  const [newTagIsPublic, setNewTagIsPublic] = useState(true);


  const toggleInfoPanel = () => {
    setShowInfoPanel(!showInfoPanel);
  };

  // Use Zustand store
  const { placeholderTag, setPlaceholderTag } = useStore(state => ({ 
      placeholderTag: state.placeholderTag, 
      setPlaceholderTag: state.setPlaceholderTag 
    }));

  // Fetch the placeholder tag when the component mounts
  useEffect(() => {
    const fetchPlaceholderTag = async () => {
      const fetchedTag = await api.getSetting("placeholder-tag");
      setPlaceholderTag(fetchedTag || 'today');
    };

    fetchPlaceholderTag();
  }, [setPlaceholderTag]);
  
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (rowRef.current && !rowRef.current.contains(event.target as Node)) {
        setShowTagDropdown(false);
        setShowInfoPanel(false);
      }
    };

    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [rowRef]);

  const deleteGoal = async () => {
    // Show confirmation dialog
    const isConfirmed = window.confirm("Deleting a goal is irreversible. Are you sure you want to delete this goal?");
  
    // Only proceed if the user confirms
    if (isConfirmed) {
      try {
        await api.deleteGoal(id);
        refresh();
      } catch (error) {
        console.error(error);
      }
    }
  };


  const updateGoal = async () => {
    try {
      console.log("updating goal...");
      await api.setGoalSummary(id, newDescription);
      refresh();
      setIsEditing(false);
    } catch (error) {
      console.error(error);
    }
  };

  const cancelUpdateGoal = async () => {
    try {
      setNewDescription(name);
      refresh();
      setIsEditing(false);
    } catch (error) {
      console.error(error);
    }
  };

  const handleKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'Enter') {
      updateGoal();
    }
    if (event.key === 'Escape') {
      cancelUpdateGoal();
    }
  };

  const navigate = useNavigate();

  const navigateToGoal = (id: string) => {
    navigate(`/goal${id}`);
  };

  const navigateToPoolTag = (tag: string) => {
    navigate(`/pool-tag/${host}/${poolName}/${tag}`);
  };

  const navigateToLocalTag = (tag: string) => {
    navigate(`/local-tag/${tag}`);
  };

  const toggleActionable = async () => {
    try {
      await api.setGoalActionable(id, !isActionable);
      const actionable = await api.getGoalActionable(id);
      setIsActionable(actionable);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };
  
  const toggleComplete = async () => {
    try {
      await api.setGoalComplete(id, !isComplete);
      const complete = await api.getGoalComplete(id);
      setIsComplete(complete);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };
  
  const copyToClipboard = () => {
    navigator.clipboard.writeText(id);
  }

  // Toggle dropdown visibility
  const toggleTagDropdown = () => {
    setShowTagDropdown(!showTagDropdown);
  };

  const addNewTag = async () => {
    try {
      // Logic to add the new tag to the goal
      // For example, update the tags array and send a request to the backend
      if (newTag.trim() !== '') {
        await api.addGoalTag(id, newTagIsPublic, newTag);
        setNewTag(''); // Reset input field
        await api.updateSetting('put', 'placeholder-tag', newTag);
        const fetchedTag = await api.getSetting("placeholder-tag");
        setPlaceholderTag(fetchedTag || 'today');
        refresh();
      } else {
        await api.addGoalTag(id, newTagIsPublic, placeholderTag);
        const fetchedTag = await api.getSetting("placeholder-tag");
        setPlaceholderTag(fetchedTag || 'today');
        refresh();
      }
    } catch (error) {
      console.error("Error adding new tag: ", error);
    }
  };

  const handleNewTagKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'Enter') {
      addNewTag();
    }
  };

  const handleTagButtonClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    if (event.shiftKey) {
      // Shift+Click: Add placeholder tag directly
      addNewTag();
    } else {
      // Regular Click: Toggle dropdown
      toggleTagDropdown();
    }
  };

  const removeTag = async (tagToRemove: Tag) => {
    try {
      // Logic to remove the tag from the goal
      // For example, update the tags array and send a request to the backend
      await api.delGoalTag(id, tagToRemove.isPublic, tagToRemove.tag);
      refresh();
    } catch (error) {
      console.error("Error removing tag: ", error);
    }
  };
  
  return (
    <div ref={rowRef} className={`flex justify-between items-center p-1 mt-2 rounded ${isActionable ? 'hover:bg-blue-500 bg-blue-400' : 'hover:bg-gray-300 bg-gray-200'}`}>
      {
        showButtons && (
          <>
            <div className="flex flex-col space-y-1">
              <input type="checkbox" checked={isActionable} onChange={toggleActionable} />
              <input type="checkbox" checked={isComplete} onChange={toggleComplete} />
            </div>
            <button
              className="p-2 rounded bg-gray-100 hover:bg-gray-200"
              onClick={copyToClipboard}
            >
              <FiCopy />
            </button>
            <button onClick={() => moveGoalUp(id)} className="p-2 rounded bg-gray-100 hover:bg-gray-200">
              ↑
            </button>
            <button onClick={() => moveGoalDown(id)} className="p-2 rounded bg-gray-100 hover:bg-gray-200">
              ↓
            </button>
          </>
        )
      }
      {isEditing ? (
        <input 
          type="text" 
          value={newDescription}
          onChange={(e) => setNewDescription(e.target.value)}
          className="bg-white shadow rounded cursor-pointer flex-grow p-2"
          onKeyDown={handleKeyDown}
        />
      ) : (
        <div
          className={`truncate bg-gray-100 rounded cursor-pointer flex-grow p-2 ${isComplete ? 'line-through' : ''}`}
          onClick={() => navigateToGoal(id)}
          onDoubleClick={() => setIsEditing(true)}
        >
          {name}
        </div>
      )}
      { 
        showButtons && (
          <div className="relative group">
            <button
              className="p-2 rounded bg-gray-100 hover:bg-gray-200 relative justify-center flex items-center"
              onClick={handleTagButtonClick}
            >
              <FiTag />
              {tags.length > 0 && (
                <span className="absolute bottom-0 right-0 bg-gray-300 rounded-full text-xs px-1">
                  {tags.length}
                </span>
              )}
            </button>
            {showTagDropdown && (
              <div className="absolute right-full bottom-0 ml-1 w-40 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2">
                <ul>
                  {tags.map((tag, index) => (
                    <li key={index} className="flex justify-between items-center p-1 hover:bg-gray-200">
                      { tag.isPublic
                        ?  <FiEye className="mr-2"/>
                        : <FiEyeOff className="mr-2"/>
                      }
                      <span
                        onClick={() => tag.isPublic ? navigateToPoolTag(tag.tag) : navigateToLocalTag(tag.tag)}
                        className="cursor-pointer"
                      >
                        {tag.tag}
                      </span>
                      <button onClick={() => removeTag(tag)} className="text-xs p-1">
                        <FiX />
                      </button>
                    </li>
                  ))}
                </ul>
                <div className="flex items-center">
                  <button
                    onClick={() => setNewTagIsPublic(!newTagIsPublic)}
                    className="p-2 mr-2 border border-gray-300 rounded hover:bg-gray-200 flex items-center justify-center"
                    style={{ height: '2rem', width: '2rem' }} // Adjust the size as needed
                  >
                    {newTagIsPublic ? <FiEye /> : <FiEyeOff />}
                  </button>
                  <input
                    type="text"
                    value={newTag}
                    onChange={(e) => setNewTag(e.target.value)}
                    onKeyDown={handleNewTagKeyDown}
                    className="w-full p-1 border rounded"
                    placeholder={"Add tag: " + placeholderTag}
                    style={{ height: '2rem' }} // Match the height of the button
                  />
                </div>
              </div>
            )}
          </div>
        )
      }
      {showButtons && !isEditing && (
        <>
          <button
            className="p-2 rounded bg-gray-100 hover:bg-gray-200"
            onClick={() => setIsEditing(!isEditing)}
          >
            <FiEdit />
          </button>
          <button
            className="p-2 rounded bg-gray-100 hover:bg-gray-200"
            onClick={deleteGoal}
          >
            <FiTrash />
          </button>
        </>
      )}
      {showButtons && isEditing && (
        <>
          <button
            className="p-2 rounded bg-teal-100 hover:bg-teal-200"
            onClick={updateGoal}
          >
            <FiSave />
          </button>
          <button
            className="p-2 rounded bg-red-100 hover:bg-red-200"
            onClick={cancelUpdateGoal}
          >
            <FiX />
          </button>
        </>
      )}
      <div className="relative group">
        <button
          className="p-2 rounded bg-gray-100 hover:bg-gray-200"
          onClick={toggleInfoPanel}
        >
          <FiInfo />
        </button>
        {
          showInfoPanel && (
            <div className="absolute right-full bottom-0 ml-1 w-40 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2">
              <p>Info Panel</p>
              {/* Place your info content here */}
            </div>
          )
        }
      </div>
      <button
        className="p-2 rounded bg-gray-100 hover:bg-gray-200"
        onClick={() => console.log("menu")}
      >
        <FiMenu />
      </button>
    </div>
  );
};

export default GoalRow;