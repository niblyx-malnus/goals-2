import React, { useState } from 'react';
import { FiX } from 'react-icons/fi';
import { useNavigate } from 'react-router-dom';
import api from '../../api';
import { goalKeyToPidGid } from '../../utils';
import { Goal } from '../../types';

const LabelPanel: React.FC<{
    goal: Goal,
    exit: () => void,
    refresh: () => void,
  }> = ({
    goal,
    exit,
    refresh,
  }) => {
  const [newLabel, setNewLabel] = useState<string>('');

  const navigate = useNavigate();

  const navigateToLabel = (label: string) => {
    const { pid } = goalKeyToPidGid(goal.key);
    navigate(`/label${pid}/${label}`);
  };

  const removeLabel = async (labelToRemove: string) => {
    try {
      // Logic to remove the label from the goal
      // For example, update the labels array and send a request to the backend
      await api.delGoalLabel(`${goal.key}`, labelToRemove);
      refresh();
    } catch (error) {
      console.error("Error removing label: ", error);
    }
  };

  const addNewLabel = async () => {
    console.log("adding new label");
    try {
      if (newLabel.trim() !== '') {
        await api.addGoalLabel(`${goal.key}`, newLabel);
        setNewLabel('');
        refresh();
      }
    } catch (error) {
      console.error("Error adding new label: ", error);
    }
  };

  const handleNewLabelKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'Enter') {
      addNewLabel();
    } else if (event.key === 'Escape') {
    exit();
    }
  };

  const handleNewLabelChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setNewLabel(e.target.value);
  };

  return (
    <div>
      <ul>
        {goal.labels.map((label, index) => (
          <li key={index} className="flex justify-between items-center p-1">
            <span
              onClick={() => navigateToLabel(label)}
              className="cursor-pointer"
            >
              {label}
            </span>
            <button onClick={() => removeLabel(label)} className="text-xs p-1">
              <FiX />
            </button>
          </li>
        ))}
      </ul>
      <div className="flex items-center">
        <input
          type="text"
          value={newLabel}
          onChange={handleNewLabelChange}
          onKeyDown={handleNewLabelKeyDown}
          className="w-full p-1 border rounded"
          placeholder={"Add label"}
          style={{ height: '2rem' }}
        />
      </div>
    </div>
  );
};

export default LabelPanel;