import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import { FiCopy, FiEdit, FiSave, FiTrash, FiX, FiMenu } from 'react-icons/fi';

function PoolRow({ pin, title, refresh }: { pin: string; title: string, refresh: () => void }) {
  const [isEditing, setIsEditing] = useState(false);
  const [newTitle, setNewTitle] = useState(title);

  const updatePool = async () => {
    try {
      await api.setPoolTitle(pin, newTitle);
      setIsEditing(false);
      // Refresh or update the parent component's state as needed
    } catch (error) {
      console.error("Error updating pool: ", error);
    }
  };

  const cancelUpdatePool = async () => {
    try {
      setNewTitle(title);
      refresh();
      setIsEditing(false);
    } catch (error) {
      console.error(error);
    }
  };

  const navigate = useNavigate();

  const navigateToPool = (tag: string) => {
    navigate(`/pool/${pin}`);
  };

  const deletePool = async () => {
    try {
      await api.deletePool(pin);
      // Refresh or update the parent component's state as needed
    } catch (error) {
      console.error("Error deleting pool: ", error);
    }
  };

  const copyToClipboard = () => {
    navigator.clipboard.writeText(pin);
  };

  const handleKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'Enter') {
      updatePool();
    }
    if (event.key === 'Escape') {
      cancelUpdatePool();
    }
  };

  return (
    <div className="flex justify-between items-center p-2 mt-2 bg-gray-200 hover:bg-gray-300 rounded">
      <button
        className="p-2 rounded bg-gray-100 hover:bg-gray-200"
        onClick={copyToClipboard}
      >
        <FiCopy />
      </button>
      {isEditing ? (
        <input 
          type="text" 
          value={newTitle}
          onChange={(e) => setNewTitle(e.target.value)}
          className="bg-white shadow rounded cursor-pointer w-4/5 p-2"
          onKeyDown={handleKeyDown}
        />
      ) : (
        <div
          className={"bg-gray-100 rounded cursor-pointer w-4/5 p-2"}
          onClick={() => navigateToPool(pin)}
          onDoubleClick={() => setIsEditing(true)}
        >
          {title}
        </div>

      )}
      <button
        className="p-2 rounded bg-gray-100 hover:bg-gray-200"
        onClick={copyToClipboard}
      >
        <FiCopy />
      </button>
      {!isEditing && (
        <>
          <button
            className="bg-gray-100 justify-center flex items-center rounded p-2 w-1/12"
            onClick={() => setIsEditing(!isEditing)}
          >
            <FiEdit />
          </button>
          <button
            className="bg-gray-100 justify-center flex items-center rounded p-2 w-1/12"
            onClick={deletePool}
          >
            <FiTrash />
          </button>
          <button
            className="bg-gray-100 justify-center flex items-center rounded p-2 w-1/12"
            onClick={() => console.log("menu")}
          >
            <FiMenu />
          </button>
        </>
      )}
      {isEditing && (
        <>
          <button
            className="bg-teal-100 justify-center flex items-center rounded p-2 w-1/12"
            onClick={updatePool}
          >
            <FiSave />
          </button>
          <button
            className="bg-red-100 justify-center flex items-center rounded p-2 w-1/12"
            onClick={cancelUpdatePool}
          >
            <FiX />
          </button>
          <button
            className="bg-gray-100 justify-center flex items-center rounded p-2 w-1/12"
            onClick={() => console.log("menu")}
          >
            <FiMenu />
          </button>
        </>
      )}
    </div>
  );
}

export default PoolRow;
