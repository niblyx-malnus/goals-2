import React from 'react';
import { FiX, FiEdit } from 'react-icons/fi'; // Import FiEdit for the edit icon
import { Goal } from '../../types';

interface GoalUsersPanelProps {
  goal: Goal;
  exit: () => void;
  // Assume additional props for handling edit actions if needed
}

const GoalUsersPanel: React.FC<GoalUsersPanelProps> = ({ goal, exit }) => {
  function capitalizeFirstLetter(string: string) {
    if (!string) return '';
    return string.charAt(0).toUpperCase() + string.slice(1);
  }

  // Placeholder functions for edit actions
  // You'll need to implement the logic for these or pass them down as props
  const onEditChief = () => console.log("Edit Chief");
  const onEditOpenTo = () => console.log("Edit Open To");
  const onEditDeputies = () => console.log("Edit Deputies");

  return (
    <div className="z-10 fixed inset-0 bg-black bg-opacity-30 backdrop-blur-sm flex justify-center items-center p-4">
      <div className="bg-white shadow rounded-lg w-full max-w-md mx-auto overflow-hidden">
        <div className="flex justify-between items-center border-b p-4">
          <h2 className="text-lg font-semibold">Goal Membership and Permissions</h2>
          <button onClick={exit} className="p-1 rounded hover:bg-gray-200">
            <FiX className="h-5 w-5" />
          </button>
        </div>
        <div className="p-4">
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-md font-semibold">Chief:</h3>
            <div className="flex items-center">
              <div className="p-2 bg-blue-100 text-blue-500 rounded">{goal.chief}</div>
              <FiEdit className="ml-2 cursor-pointer" onClick={onEditChief} />
            </div>
          </div>
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-md font-semibold">Open To:</h3>
            <div className="flex items-center">
              <div className={`p-2 ${goal.openTo ? "bg-green-200 text-green-800" : "bg-gray-200 text-gray-800"} rounded`}>
                {goal.openTo ? capitalizeFirstLetter(goal.openTo) : "None"}
              </div>
              <FiEdit className="ml-2 cursor-pointer" onClick={onEditOpenTo} />
            </div>
          </div>
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-md font-semibold">Deputies:</h3>
            <FiEdit className="cursor-pointer" onClick={onEditDeputies} />
          </div>
          <div className="max-h-60 overflow-y-auto shadow-inner" style={{ backgroundColor: '#f0f0f0' }}>
            {Object.entries(goal.deputies).length > 0 ? (
              Object.entries(goal.deputies).map(([name, role], index) => (
                <div key={index} className="p-2 bg-white text-gray-700 rounded mb-2 shadow">
                  {name}: {role}
                </div>
              ))
            ) : (
              <div className="p-2">No deputies assigned</div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default GoalUsersPanel;
