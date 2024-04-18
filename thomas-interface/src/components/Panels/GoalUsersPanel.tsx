import React, { useState } from 'react';
import { FiX, FiEdit } from 'react-icons/fi'; // Import FiEdit for the edit icon
import { Goal } from '../../types';
import api from '../../api';

interface GoalUsersPanelProps {
  goal: Goal;
  exit: () => void;
  refresh: () => void;
  // Assume additional props for handling edit actions if needed
}

const GoalUsersPanel: React.FC<GoalUsersPanelProps> = ({ goal, exit, refresh }) => {
  const [showDropdown, setShowDropdown] = useState(false);

  function capitalizeFirstLetter(string: string) {
    if (!string) return '';
    return string.charAt(0).toUpperCase() + string.slice(1);
  }

  const getOptions = (onOpen: string | null) => {
    if (onOpen === null) {
      return ['supers', 'deputies', 'viewers'];
    } else if (onOpen === 'supers') {
      return ['deputies', 'viewers', 'close'];
    } else if (onOpen === 'deputies') {
      return ['supers', 'viewers', 'close'];
    } else if (onOpen === 'viewers') {
      return ['supers', 'deputies', 'close'];
    } else { return []; }
  }

  // Dynamically generate options based on the current openTo state
  const options = getOptions(goal.openTo);

  // Placeholder functions for edit actions
  // You'll need to implement the logic for these or pass them down as props
  const onEditChief = () => console.log("Edit Chief");
  const onEditDeputies = () => console.log("Edit Deputies");

  const onEditOption = async (option: string) => {
    // Convert 'close' option to null for the API call
    const openToValue = option === 'close' ? null : option;
    try {
      await api.setGoalOpenTo(goal.key, openToValue);
      refresh();
      console.log(`Successfully set openTo to: ${openToValue}`);
      // Here, you might want to update local state or re-fetch goal data to reflect the change
    } catch (error) {
      console.error(`Error setting openTo:`, error);
    }
    setShowDropdown(false); // Hide dropdown after selection
  };

  return (
    <div className="z-10 fixed inset-0 bg-black bg-opacity-30 backdrop-blur-sm flex justify-center items-center p-4">
      <div className="bg-white shadow rounded-lg w-full max-w-md mx-auto overflow-hidden">
        <div className="flex justify-between items-center border-b p-4">
          <h2 className="text-lg font-semibold">Goal Permissions</h2>
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
              <div className="relative group">
                <FiEdit className="ml-2 cursor-pointer" onClick={() => setShowDropdown(!showDropdown)} />
                {showDropdown && (
                  <div className="origin-top-right absolute right-0 mt-2 w-40 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 z-20">
                    <div className="py-1">
                      {options.map((option) => (
                        <a
                          key={option}
                          href="#"
                          className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                          onClick={(e) => {
                            e.preventDefault();
                            onEditOption(option.toLowerCase());
                          }}
                        >
                          {option === 'close' ? 'Close Access' : `Open To ${capitalizeFirstLetter(option)}`}
                        </a>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-md font-semibold">Your Perms:</h3>
            <div className="flex items-center">
              <div className={`p-2 bg-green-200 text-green-800 rounded`}>
                {capitalizeFirstLetter(goal.yourPerms)}
              </div>
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
