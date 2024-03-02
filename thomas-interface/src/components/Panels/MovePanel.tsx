import React, { useState } from 'react';
import api from '../../api';

const MovePanel: React.FC<{
  goalKey: string,
  refresh: () => void,
}> = ({
  goalKey,
  refresh,
}) => {
  const [moveType, setMoveType] = useState<string>('Move To');
  const [targetKey, setTargetKey] = useState<string>('');

  const handleMove = async () => {
    try {
      switch (moveType) {
        case 'Move To Root':
          await api.move(goalKey, null);
          break;
        case 'Move To':
          if (targetKey.trim() !== '') {
            await api.move(goalKey, targetKey);
          }
          break;
        case 'Loan To':
          if (targetKey.trim() !== '') {
            await api.loan(goalKey, targetKey);
          }
          break;
        case 'Unloan':
          if (targetKey.trim() !== '') {
            await api.unloan(goalKey, targetKey);
          }
          break;
        default:
          // Handle unexpected cases
          console.error('Unexpected move type');
      }
      refresh(); // Refresh the list or UI
    } catch (error) {
      console.error("Error processing move: ", error);
    }
  };

  return (
    <div className="flex items-center flex-col">
      {(moveType === 'Move To' || moveType === 'Loan To' ||  moveType === 'Unloan') && (
        <div className="text-center w-full">
          <input
            type="text"
            value={targetKey}
            onChange={(e) => setTargetKey(e.target.value)}
            className="p-1 border rounded w-4/5"
            placeholder="Enter goal key"
          />
        </div>
      )}
      <div className="mt-2 flex justify-center w-full">
        <select
          className="mr-1 p-1 text-center border rounded"
          value={moveType}
          onChange={(e) => setMoveType(e.target.value)}
        >
          <option>Move To Root</option>
          <option>Move To</option>
          <option>Loan To</option>
          <option>Unloan</option>
        </select>
        <button
          onClick={handleMove}
          className="ml-1 p-1 bg-blue-500 text-white rounded"
        >
          Submit
        </button>
      </div>
    </div>
  );
};

export default MovePanel;