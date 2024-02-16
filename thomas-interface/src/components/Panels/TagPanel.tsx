import React, { useState } from 'react';
import { FiX } from 'react-icons/fi';
import useCustomNavigation from '../useCustomNavigation';
import api from '../../api';
import { Goal } from '../../types';

const TagPanel: React.FC<{
    goal: Goal,
    exit: () => void,
    refresh: () => void,
  }> = ({
    goal,
    exit,
    refresh,
  }) => {
  const [newTag, setNewTag] = useState<string>('');

  const { navigateToTag } = useCustomNavigation();

  const removeTag = async (tagToRemove: string) => {
    try {
      // Logic to remove the tag from the goal
      // For example, update the tags array and send a request to the backend
      await api.delGoalTag(`${goal.key}`, tagToRemove);
      refresh();
    } catch (error) {
      console.error("Error removing tag: ", error);
    }
  };

  const addNewTag = async () => {
    console.log("adding new tag");
    try {
      if (newTag.trim() !== '') {
        await api.addGoalTag(`${goal.key}`, newTag);
        setNewTag('');
        refresh();
      }
    } catch (error) {
      console.error("Error adding new tag: ", error);
    }
  };

  const handleNewTagKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'Enter') {
      addNewTag();
    } else if (event.key === 'Escape') {
    exit();
    }
  };

  const handleNewTagChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setNewTag(e.target.value);
  };

  return (
    <div>
      <ul>
        {goal.tags.map((tag, index) => (
          <li key={index} className="flex justify-between items-center p-1">
            <span
              onClick={() => navigateToTag(tag)}
              className="cursor-pointer"
            >
              {tag}
            </span>
            <button onClick={() => removeTag(tag)} className="text-xs p-1">
              <FiX />
            </button>
          </li>
        ))}
      </ul>
      <div className="flex items-center">
        <input
          type="text"
          value={newTag}
          onChange={handleNewTagChange}
          onKeyDown={handleNewTagKeyDown}
          className="w-full p-1 border rounded"
          placeholder={"Add a private tag"}
          style={{ height: '2rem' }}
        />
      </div>
    </div>
  );
};

export default TagPanel;