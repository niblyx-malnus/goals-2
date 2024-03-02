import React, { useState } from 'react';
import api from '../../api';

const RestorePanel: React.FC<{
  goalKey: string,
  refresh: () => void,
}> = ({
  goalKey,
  refresh,
}) => {

  const handleRestoreToRoot = async () => {
    try {
      await api.restoreToRoot(goalKey);
      refresh(); // Refresh the list or UI
    } catch (error) {
      console.error("Error processing restore to root: ", error);
    }
  };

  const handleRestoreToContext = async () => {
    try {
      await api.restoreGoal(goalKey);
      refresh(); // Refresh the list or UI
    } catch (error) {
      console.error("Error processing restore to context: ", error);
    }
  };

  return (
    <div className="flex items-center flex-col">
      <button
        onClick={handleRestoreToRoot}
        className="m-1 p-1 bg-gray-300 rounded"
      >
        Restore to Root
      </button>
      <button
        onClick={handleRestoreToContext}
        className="m-1 p-1 bg-gray-300 rounded"
      >
        Restore to Context
      </button>
    </div>
  );
};

export default RestorePanel;
