import React, { useState, useEffect } from 'react';
import api from '../api';

// Interfaces
interface JSONFile {
    version: number,
    json: any,
}

interface WeeklyGoal {
  goal: number;
  entries: Record<string, number>; // key: date, value: mileage
}

type WeeklyGoals = Record<string, number>; // key: date, value: WeeklyGoal

const weeklyGoalVersion = 0;

const enVersion = (ver: number, json: any): JSONFile => {
    return {
        version: ver,
        json: json
    };
};

// GoalSettingComponent
const GoalSettingComponent: React.FC<{ currentGoal: number; onUpdate: (newGoal: number) => void }> = ({ currentGoal, onUpdate }) => {
  const [newGoal, setNewGoal] = useState('');

  const handleSubmit = () => {
    if (!isNaN(Number(newGoal)) && newGoal.trim() !== '') {
      onUpdate(Number(newGoal));
    }
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value;
    if (value === '' || (!isNaN(Number(value)) && /^\d*\.?\d*$/.test(value))) {
      setNewGoal(value);
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      handleSubmit();
    }
  };

  return (
    <div className="p-4">
      <h2 className="text-lg font-semibold mb-2">Set Weekly Goal</h2>
      <div className="flex items-center">
        <input
          type="text"
          className="border border-gray-300 p-2 rounded mr-2"
          placeholder={currentGoal.toString()}
          value={newGoal}
          onChange={handleInputChange}
          onKeyPress={handleKeyPress}
        />
        <button
          className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-1 px-2 rounded text-sm"
          onClick={handleSubmit}
        >
          Update Goal
        </button>
      </div>
    </div>
  );
};

// WeeklySummaryComponent
const WeeklySummaryComponent: React.FC<{ goal: WeeklyGoal, onAddEntry: (date: string, mileage: number | null) => void }> = ({ goal, onAddEntry }) => {
  const [mileageInputs, setMileageInputs] = useState<Record<string, string>>({});

  const handleKeyPress = (event: React.KeyboardEvent, date: string) => {
    if (event.key === 'Enter') {
      handleSubmitMileage(date);
    }
  };

  const weekStructure = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((day, index) => {
    const date = new Date();
    date.setDate(date.getDate() - date.getDay() + index + 1);
    return { 
      day, 
      date: date.toISOString().split('T')[0]
    };
  });

  const handleMileageChange = (date: string, mileage: string) => {
    setMileageInputs({ ...mileageInputs, [date]: mileage });
  };

  const handleSubmitMileage = (date: string) => {
    const mileageInput = mileageInputs[date];
    if (mileageInput === '') {
      // Delete the entry if the input is an empty string
      onAddEntry(date, null);
    } else {
      const mileage = Number(mileageInput);
      if (!isNaN(mileage) && mileage >= 0) {
        onAddEntry(date, mileage);
      }
    }
    setMileageInputs({ ...mileageInputs, [date]: '' }); // Reset input field after adding
  };

  let cumulativeMileage = 0;

  return (
    <div className="relative p-4">
      <h2 className="text-lg font-semibold mb-2">Weekly Summary</h2>
      <div className="grid grid-cols-3 gap-4">
        <div className="font-bold">Date</div>
        <div className="font-bold">Instance</div>
        <div className="font-bold">Cumulative</div>
        {weekStructure.map(({ day, date }) => {
          const dailyMileage = goal.entries[date];
          const isEntryPresent = dailyMileage !== undefined;

          if (isEntryPresent) {
            cumulativeMileage += dailyMileage;
          }

          return (
            <React.Fragment key={day}>
              <div className="flex items-center">
                {day}
              </div>
              <div className="flex items-center">
                <input
                  type="number"
                  className="border border-gray-300 p-1 rounded w-3/4"
                  placeholder={dailyMileage !== undefined ? `${dailyMileage} miles` : ''}
                  value={mileageInputs[date] || ''}
                  onChange={(e) => handleMileageChange(date, e.target.value)}
                  onKeyPress={(e) => handleKeyPress(e, date)}
                />
                <button
                  className="bg-green-500 hover:bg-green-700 text-white font-bold py-1 px-2 ml-1 rounded text-sm"
                  onClick={() => handleSubmitMileage(date)}
                >
                  +
                </button>
              </div>
              <div>{isEntryPresent ? `${cumulativeMileage} miles` : ''}</div>
            </React.Fragment>
          );
        })}
      </div>
      <p className="mt-4">Goal: {goal.goal} miles</p>
      <p>Status: {cumulativeMileage >= goal.goal ? 'Goal Reached' : 'Keep Going'}</p>
    </div>
  );
};

// Main Component
const serverFolderPath = '/test123'; // Server folder path for data storage

const Mileage: React.FC = () => {
  const [weeklyGoal, setWeeklyGoal] = useState<WeeklyGoal>({ goal: 0, entries: {} });
  const [isLoading, setIsLoading] = useState(true);

  const getStartOfWeek = (inputDate: string | number | Date) => {
    const date = new Date(inputDate);
    date.setHours(0, 0, 0, 0); // Set the time to midnight to avoid any DST changes
  
    // Get the day of the week (0 for Sunday, 1 for Monday, etc.)
    const dayOfWeek = date.getDay();
  
    // If the day is not Monday, adjust the date to the previous Monday
    if (dayOfWeek !== 1) {
      const difference = 1 - dayOfWeek; // If Sunday, go back 6 days; otherwise, go back to the previous Monday
      date.setDate(date.getDate() + difference);
    }
  
    // Format the date to YYYY-MM-DD without converting to UTC
    return date.toISOString().split('T')[0];
  };


  const [selectedWeek, setSelectedWeek] = useState(() => getStartOfWeek(new Date()));

  useEffect(() => {
    const fetchWeekData = async () => {
      setIsLoading(true);
      try {
        const weekPath = `${serverFolderPath}/week_${selectedWeek}.json`;
        const dataResponse = await api.jsonRead(weekPath);
  
        if (dataResponse && dataResponse.version !== weeklyGoalVersion) {
          console.error(`Error: Data version mismatch. Expected version ${weeklyGoalVersion}, but got version ${dataResponse.version}`);
          // Set blanks if version mismatch
          setWeeklyGoal({ goal: 0, entries: {} });
          return; // Halt further execution
        }
  
        if (dataResponse && dataResponse.json) {
          setWeeklyGoal(dataResponse.json);
        } else {
          // If no data found for the week, set blanks
          setWeeklyGoal({ goal: 0, entries: {} });
        }
      } catch (error) {
        console.error('Error fetching data:', error);
        // Set blanks if error in fetching data
        setWeeklyGoal({ goal: 0, entries: {} });
      } finally {
        setIsLoading(false);
      }
    };
  
    fetchWeekData();
  }, [selectedWeek]);


  const updateGoal = async (newGoal: number) => {
    const updatedGoal = { ...weeklyGoal, goal: newGoal };
    try {
      await api.jsonPut(`${serverFolderPath}/week_${selectedWeek}.json`, enVersion(weeklyGoalVersion, updatedGoal));
      setWeeklyGoal(updatedGoal);
    } catch (error) {
      console.error('Error updating goal:', error);
    }
  };

  const addMileageEntry = async (date: string, mileage: number | null) => {
    const updatedEntries = { ...weeklyGoal.entries };
    if (mileage === null) {
      // Delete the entry if mileage is null
      delete updatedEntries[date];
    } else {
      // Update the entry with the new mileage
      updatedEntries[date] = mileage;
    }
    
    const updatedGoal = { ...weeklyGoal, entries: updatedEntries };
    try {
      await api.jsonPut(`${serverFolderPath}/week_${selectedWeek}.json`, enVersion(weeklyGoalVersion, updatedGoal));
      setWeeklyGoal(updatedGoal);
    } catch (error) {
      console.error('Error adding mileage entry:', error);
    }
  };

  return (
    <div className="relative container h-full h-screen mx-auto bg-gray-100 p-8">
      {isLoading && (
        <div className="absolute top-0 left-0 w-full h-full bg-black bg-opacity-20 flex justify-center items-center z-50">
          <div className="animate-spin rounded-full h-32 w-32 border-t-4 border-b-4 border-blue-500"></div>
        </div>
      )}
      <h2 className="text-lg font-semibold mb-2">Select Week</h2>
      <input
        id="week-selector"
        type="date"
        value={selectedWeek}
        onChange={(e) => setSelectedWeek(getStartOfWeek(e.target.value))}
      />
      <GoalSettingComponent currentGoal={weeklyGoal.goal} onUpdate={updateGoal} />
      <WeeklySummaryComponent goal={weeklyGoal} onAddEntry={addMileageEntry} />
    </div>
  );
};

export default Mileage;