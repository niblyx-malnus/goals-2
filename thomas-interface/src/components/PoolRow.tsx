import React, { useState } from 'react';
import rawApi from '../api';
import { Pool } from '../types';
import useCustomNavigation from './useCustomNavigation';
import { FiCopy, FiEdit, FiSave, FiTrash, FiX, FiMenu, FiInfo, FiLogIn, FiLogOut } from 'react-icons/fi';

function PoolRow({
    destination,
    pool,
    refresh,
    movePoolUp,
    movePoolDown,
  }: {
    destination: string,
    pool: Pool;
    refresh: () => void;
    movePoolUp: (poolId: string) => void,
    movePoolDown: (poolId: string) => void
  }) {
  const api = rawApi.setDestination(destination);
  const [isEditing, setIsEditing] = useState(false);
  const [newTitle, setNewTitle] = useState(pool.title);

  const updatePool = async () => {
    try {
      await api.setPoolTitle(pool.pid, newTitle);
      setIsEditing(false);
      refresh();
    } catch (error) {
      console.error("Error updating pool: ", error);
    }
  };

  const cancelUpdatePool = async () => {
    try {
      setNewTitle(pool.title);
      refresh();
      setIsEditing(false);
    } catch (error) {
      console.error(error);
    }
  };

  const { navigateToPool } = useCustomNavigation();

  const deletePool = async () => {
    // Show confirmation dialog
    const isConfirmed = window.confirm("Deleting a pool is irreversible. Are you sure you want to delete this pool?");
  
    // Only proceed if the user confirms
    if (isConfirmed) {
      try {
        await api.deletePool(pool.pid);
        refresh();
      } catch (error) {
        console.error(error);
      }
    }
  };

  const leavePool = async () => {
    // Show confirmation dialog
    const isConfirmed = window.confirm("Are you sure you want to leave this pool?");
  
    // Only proceed if the user confirms
    if (isConfirmed) {
      try {
        await api.leavePool(pool.pid);
        refresh();
      } catch (error) {
        console.error(error);
      }
    }
  };

  const copyToClipboard = () => {
    navigator.clipboard.writeText(pool.pid);
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
      <button onClick={() => movePoolUp(pool.pid)} className="p-1 rounded bg-gray-100 hover:bg-gray-200">
        ↑
      </button>
      <button onClick={() => movePoolDown(pool.pid)} className="p-1 rounded bg-gray-100 hover:bg-gray-200">
        ↓
      </button>
      {isEditing ? (
        <input 
          type="text" 
          value={newTitle}
          onChange={(e) => setNewTitle(e.target.value)}
          className="bg-white shadow rounded cursor-pointer flex-grow p-1"
          onKeyDown={handleKeyDown}
        />
      ) : (
        <div
          className={`truncate rounded flex-grow p-1 ${pool.host === api.destination || pool.areWatching ? 'bg-gray-100 cursor-pointer hover:bg-gray-200' : 'bg-gray-200'}`}
          onClick={
            () => {
              if (pool.host === api.destination || pool.areWatching) {
                navigateToPool(api.destination, pool.pid);
              }
            }
          }
        >
          {pool.title}
        </div>

      )}
      { !isEditing && (
        <>
          <button
            className="p-2 rounded bg-gray-100 hover:bg-gray-200"
            onClick={() => setIsEditing(!isEditing)}
          >
            <FiEdit />
          </button>
          { pool.host !== api.destination ? (
            !pool.areWatching ? (
              <button
                className="p-2 rounded bg-gray-100 hover:bg-gray-200"
                onClick={() => api.watchPool(pool.pid)}
                title="Watch Pool"
              >
                <FiLogIn />
              </button>
            ) : (
              <button
                className="p-2 rounded bg-gray-100 hover:bg-gray-200"
                onClick={leavePool}
                title="Leave Pool"
              >
                <FiLogOut />
              </button>
            )
          ) : (
            <button
              className="p-2 rounded bg-gray-100 hover:bg-gray-200"
              onClick={deletePool}
              title="Delete Pool"
            >
              <FiTrash />
            </button>
          )}
        </>
      )}
      { isEditing && (
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
