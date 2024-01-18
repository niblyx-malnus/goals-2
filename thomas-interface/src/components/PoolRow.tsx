import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import { FiCopy, FiEdit, FiSave, FiTrash, FiX, FiMenu, FiInfo } from 'react-icons/fi';

function PoolRow({
    pin,
    title,
    refresh,
    movePoolUp,
    movePoolDown,
    showButtons,
  }: {
    pin: string;
    title: string;
    refresh: () => void;
    movePoolUp: (poolId: string) => void,
    movePoolDown: (poolId: string) => void
    showButtons: boolean;
  }) {
  const [isEditing, setIsEditing] = useState(false);
  const [newTitle, setNewTitle] = useState(title);

  const updatePool = async () => {
    try {
      await api.setPoolTitle(pin, newTitle);
      setIsEditing(false);
      refresh();
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
    // Show confirmation dialog
    const isConfirmed = window.confirm("Deleting a pool is irreversible. Are you sure you want to delete this pool?");
  
    // Only proceed if the user confirms
    if (isConfirmed) {
      try {
        await api.deletePool(pin);
        refresh();
      } catch (error) {
        console.error(error);
      }
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
      {
        showButtons && (
          <>
            <button
              className="p-2 rounded bg-gray-100 hover:bg-gray-200"
              onClick={copyToClipboard}
            >
              <FiCopy />
            </button>
            <button onClick={() => movePoolUp(pin)} className="p-2 rounded bg-gray-100 hover:bg-gray-200">
              ↑
            </button>
            <button onClick={() => movePoolDown(pin)} className="p-2 rounded bg-gray-100 hover:bg-gray-200">
              ↓
            </button>
          </>
        )
      }
      {isEditing ? (
        <input 
          type="text" 
          value={newTitle}
          onChange={(e) => setNewTitle(e.target.value)}
          className="bg-white shadow rounded cursor-pointer flex-grow p-2"
          onKeyDown={handleKeyDown}
        />
      ) : (
        <div
          className={"truncate bg-gray-100 rounded cursor-pointer flex-grow p-2"}
          onClick={() => navigateToPool(pin)}
          onDoubleClick={() => setIsEditing(true)}
        >
          {title}
        </div>

      )}
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
            onClick={deletePool}
          >
            <FiTrash />
          </button>
        </>
      )}
      {showButtons && isEditing && (
        <>
          <button
            className="p-2 rounded bg-teal-100 hover:bg-teal-200"
            onClick={updatePool}
          >
            <FiSave />
          </button>
          <button
            className="p-2 rounded bg-red-100 hover:bg-red-200"
            onClick={cancelUpdatePool}
          >
            <FiX />
          </button>
        </>
      )}
      <button
        className="p-2 rounded bg-gray-100 hover:bg-gray-200"
        onClick={() => console.log("info")}
      >
        <FiInfo />
      </button>
      <button
        className="p-2 rounded bg-gray-100 hover:bg-gray-200"
        onClick={() => console.log("menu")}
      >
        <FiMenu />
      </button>
    </div>
  );
}

export default PoolRow;
