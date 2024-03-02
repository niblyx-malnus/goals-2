import React, { useState, useRef, useEffect } from 'react';
import ArchiveInfoPanel from './Panels/ArchiveInfoPanel';
import RestorePanel from './Panels/RestorePanel';
import useCustomNavigation from './useCustomNavigation';
import { FiCopy, FiRotateCcw, FiTrash, FiInfo } from 'react-icons/fi';
import { FaArrowsAltV } from 'react-icons/fa'; 
import { Goal } from '../types';
import api from '../api';
import { goalKeyToPidGid } from '../utils';

const ArchiveGoalRow: React.FC<{
    goal: Goal,
    rid?: string,
    refresh: () => void,
    atPoolRoot?: boolean,
    toggleMove?: () => void,
    moveState?: boolean,
  }> = ({
    goal,
    rid,
    refresh,
    atPoolRoot,
    toggleMove,
    moveState = false,
  }) => {
  const { pid, gid } = goalKeyToPidGid(goal.key);
  const [panel, setPanel] = useState('');
  const rowRef = useRef<HTMLDivElement>(null);
  const { navigateToArchive } = useCustomNavigation();
  
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (rowRef.current && !rowRef.current.contains(event.target as Node)) {
        setPanel('');
      }
    };

    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [rowRef]);

  const toggleRestorePanel = () => {
    console.log("setting panel to restore");
    if (panel === 'restore') {
      setPanel('');
    } else {
      setPanel('restore');
    }
    console.log(panel);
  };

  const toggleArchiveInfoPanel = () => {
    if (panel === 'info') {
      setPanel('');
    } else {
      setPanel('info');
    }
  };

  const handleRestoreClick = async () => {
    if (atPoolRoot) {
      try {
        await api.restoreGoal(goal.key);
        refresh(); // Refresh the list or UI
      } catch (error) {
        console.error("Error processing restore to root: ", error);
      }
    } else {
      toggleRestorePanel();
    }
  }

  const deleteGoal = async () => {
    // Show confirmation dialog
    const isConfirmed = window.confirm("Deleting a goal is irreversible. Are you sure you want to delete this goal?");
  
    // Only proceed if the user confirms
    if (isConfirmed) {
      try {
        await api.deleteFromArchive(goal.key);
        refresh();
      } catch (error) {
        console.error(error);
      }
    }
  };

  const copyToClipboard = () => {
    setPanel('');
    navigator.clipboard.writeText(goal.key);
  }

  return (
    <div ref={rowRef} className={`flex justify-between items-center mt-2 rounded ${goal.actionable ? 'border-4 border-gray-400 box-border' : 'p-1' } ${goal.active ? 'hover:bg-gray-300 bg-gray-200' : 'opacity-60 bg-gray-200'} `}>
      <button
        className="p-2 rounded bg-gray-100"
        onClick={copyToClipboard}
      >
        <FiCopy />
      </button>
      { (!rid || (rid === gid)) && toggleMove &&
        <button
          className={`p-2 rounded bg-gray-${moveState ? "300" : "100"}`}
          onClick={toggleMove}
        >
          <FaArrowsAltV style={{ color: moveState ? "#f7fafc" : "gray" }} />
        </button>
      }
      <div
        className={`truncate bg-gray-100 rounded cursor-pointer flex-grow p-1 ${goal.complete ? 'line-through' : ''}`}
        onClick={() => navigateToArchive(pid, gid, gid)}
      >
        {goal.summary}
      </div>
      { (!rid || (rid === gid)) && (
        <div className="relative group">
          <button
            className="p-2 rounded bg-gray-100"
            onClick={handleRestoreClick}
          >
            <FiRotateCcw />
          </button>
          {
            (panel === 'restore') && (
              <div className="absolute right-0 bottom-full mt-2 w-44 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2">
                <RestorePanel goalKey={goal.key} refresh={refresh} />
              </div>
            )
          }
        </div>
      )}
      { (!rid || (rid === gid)) && (
        <button
          className="p-2 rounded bg-gray-100"
          onClick={deleteGoal}
        >
          <FiTrash />
        </button>
      )}
      <div className="relative group">
        <button
          className="p-2 rounded bg-gray-100"
          onClick={toggleArchiveInfoPanel}
        >
          <FiInfo />
        </button>
        {
          panel === 'info' && (
            <div className="absolute right-0 bottom-full mt-2 w-64 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2">
              <ArchiveInfoPanel goal={goal} rid={ rid ? rid : gid } />
            </div>
          )
        }
      </div>
    </div>
  );
};

export default ArchiveGoalRow;