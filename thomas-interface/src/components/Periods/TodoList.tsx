import React, { useState, useEffect } from 'react';
import useStore from '../../store';
import api from '../../api';
import { periodType } from '../../types';
import { Goal } from '../../types';
import { ourPool } from '../../constants';
import { getAdjacentPeriod, convertToPeriod, formatDateKeyDisplay, getCurrentPeriod, isPeriodType, formatNowDisplay } from './utils';
import { useNavigate } from 'react-router-dom';
import TodoRow from './TodoRow';

const TodoList: React.FC<{
  periodType: periodType,
  dateKey: string
}> = ({
  periodType,
  dateKey
}) => {
  const [input, setInput] = useState('');
  const [themeInput, setThemeInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [refresh, setRefresh] = useState(false);
  const [selectedGoalKey, setSelectedGoalKey] = useState<string | null>(null);

  const { collections, setCollection } = useStore(state => state);

  const navigate = useNavigate();

  const jsonPath = `/periods/${periodType}/${dateKey}.json`;
  
  const today = getCurrentPeriod(periodType);

  useEffect(() => {
    setIsLoading(true);
  
    api.jsonRead(jsonPath)
      .then(async (data: { keys: string[], themes: string[] }) => {
        const goals: Goal[] = await api.getGoalData(data.keys);
        setCollection(jsonPath, { themes: data.themes, goals: goals });
      })
      .catch(error => {
        setCollection(jsonPath, { goals: [], themes: [] });
      })

    setIsLoading(false);
  }, [periodType, setCollection, refresh, jsonPath]);

  const moveGoal = (aboveGoalKey: string | null, belowGoalKey: string | null) => {
    if (selectedGoalKey !== null) {
      let keys = collections[jsonPath]?.goals.map(goal => goal.key) ?? [];
      const currentIndex = keys.indexOf(selectedGoalKey);
  
      // Early exit if the goal isn't found
      if (currentIndex === -1) return;
  
      // Remove the selected goal from its current position
      keys.splice(currentIndex, 1);
  
      let newIndex = 0;
      if (belowGoalKey) {
        // If there's a belowGoalKey, find its new index
        newIndex = keys.indexOf(belowGoalKey);
      } else if (aboveGoalKey) {
        // If there's an aboveGoalKey, place after it (hence +1)
        newIndex = keys.indexOf(aboveGoalKey) + 1;
      }
  
      // Insert the selected goal at the new position
      keys.splice(newIndex, 0, selectedGoalKey);
  
      // Update the API with the new goals order
      api.jsonPut(jsonPath, { themes: collections[jsonPath].themes, keys: keys })
        .then(() => {
          setRefresh(!refresh); // Trigger a refresh to re-fetch the updated goals
        })
        .catch(error => console.error("Failed to reorder goals:", error));
    }
  };

  const handleCreate = async () => {
    if (!input.trim()) return;
    try {
      const key = await api.createGoal(ourPool, null, input, true);
      console.log("getting created key");
      console.log(key);
      if (jsonPath in collections) {
        if (!collections[jsonPath].goals.some(goal => goal.key === key)) {
          api.jsonPut(jsonPath, { themes: collections[jsonPath].themes, keys: [...collections[jsonPath].goals.map(goal => goal.key), key] })
        }
      } else {
        api.jsonPut(jsonPath, { themes: [], keys: [] })
      }
      setInput('');
      setRefresh(!refresh);
    } catch (error) {
      console.error("Failed to create a new goal:", error);
    }
  };

  const handleRemove = async (key: string) => {
    try {
      if (jsonPath in collections) {
        api.jsonPut(jsonPath, { themes: collections[jsonPath].themes, keys: collections[jsonPath].goals.map(goal => goal.key).filter(k => k !== key) })
      }
      setRefresh(!refresh);
    } catch (error) {
      console.error("Failed to remove goal:", error);
    }
  };

  const handleCreateTheme = () => {
    setThemeInput(''); // Clear input after adding
    if (!themeInput.trim()) return;
    try {
      if (jsonPath in collections) {
        api.jsonPut(jsonPath, { themes: [...collections[jsonPath].themes, themeInput], keys: collections[jsonPath].goals.map(goal => goal.key) })
      } else {
        api.jsonPut(jsonPath, { themes: [themeInput], keys: [] })
      }
      setRefresh(!refresh);
    } catch (error) {
      console.error("Failed to create a new goal:", error);
    }
  };

  const handleRemoveTheme = (themeToRemove: string) => {
    try {
      if (jsonPath in collections) {
        api.jsonPut(jsonPath, { themes: collections[jsonPath].themes.filter(t => t !== themeToRemove), keys: collections[jsonPath].goals.map(goal => goal.key) })
        setRefresh(!refresh);
      }
    } catch (error) {
      console.error("Failed to create a new goal:", error);
    }
  };

  const goToToday = () => {
    navigate(`/periods/${periodType}/${today}`);
  };

  const handlePeriodTypeChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    if (isPeriodType(e.target.value)) {
      const newDateKey = convertToPeriod(periodType, dateKey, e.target.value);
      navigate(`/periods/${e.target.value}/${newDateKey}`);
    } else {
      console.error(`${e.target.value} is not a valid periodType`);
    }
  };

  const handleNavigation = (direction: 'prev' | 'next') => {
    const newDateKey = getAdjacentPeriod(periodType, dateKey, direction);
    navigate(`/periods/${periodType}/${newDateKey}`);
  };

  return (
    <div className="max-w-xl mx-auto my-10 p-4">
      <div className="relative group items-center">
        <div className="mb-4 flex justify-center">
          <select
            value={periodType}
            onChange={handlePeriodTypeChange}
            className="max-w-20 mr-2 px-3 py-2 bg-gray-200 text-gray-800 rounded-md"
          >
            <option value="day">Day</option>
            <option value="week">Week</option>
            <option value="month">Month</option>
            <option value="quarter">Quarter</option>
            <option value="year">Year</option>
          </select>
          <button
            onClick={goToToday}
            className={`w-28 py-1 px-2 ${dateKey === today ? 'bg-gray-400' : 'bg-blue-700'} text-white rounded`}
            disabled={dateKey === today}
          >
            {formatNowDisplay(periodType)}
          </button>
        </div>
        <div className="mb-4 flex justify-between">
          <button
            onClick={() => handleNavigation('prev')}
            className="py-2 px-4 bg-gray-300 text-gray-700 rounded"
          >
            Prev
          </button>
          <div
            className="w-56 text-center font-bold py-2 px-4 bg-gray-200 text-gray-700 rounded"
          >
            {formatDateKeyDisplay(periodType, dateKey)}
          </div>
          <button
            onClick={() => handleNavigation('next')}
            className="py-2 px-4 bg-gray-300 text-gray-700 rounded"
          >
            Next
          </button>
        </div>
      </div>
      <div className="flex justify-center mb-2">
        <input
          type="text"
          value={themeInput}
          onChange={(e) => setThemeInput(e.target.value)}
          className="border border-gray-300 p-1 w-auto text-sm rounded-l bg-gray-50"
          placeholder="New theme"
          onKeyDown={(e) => e.key === 'Enter' && handleCreateTheme()}
          style={{ maxWidth: '200px' }} // Limit the width of the input to make it smaller
        />
      </div>
      { isLoading && (
        <div className="flex justify-center my-4">
          <div className="animate-spin rounded-full h-16 w-16 border-b-8 border-t-transparent border-blue-500"></div>
        </div>
      )}
      {!isLoading && (
        <div className="flex justify-center flex-wrap">
          {collections[jsonPath]?.themes.map(theme => (
            <div key={theme} className="bg-blue-100 text-blue-800 text-sm font-semibold mr-2 mb-2 px-3 py-1 rounded-full flex align-center">
              {theme}
              <button
                onClick={() => handleRemoveTheme(theme)}
                className="text-blue-800 ml-2 cursor-pointer"
              >
                ×
              </button>
            </div>
          ))}
        </div>
      )}
      <div className="flex mb-4">
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          className="border border-gray-300 p-2 w-full rounded-l"
          placeholder="Add a new task"
          onKeyDown={(e) => e.key === 'Enter' && handleCreate()}
        />
        <button onClick={handleCreate} className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-r">Add</button>
      </div>
      { isLoading && (
        <div className="flex justify-center mt-10">
          <div className="animate-spin rounded-full h-16 w-16 border-b-8 border-t-transparent border-blue-500"></div>
        </div>
      )}
    { !isLoading && (
      <ul>
      {collections[jsonPath]?.goals.map((goal, index) => (
        <React.Fragment key={index}>
          {/* Insert separator before the first goal for moving to the start */}
          {selectedGoalKey !== null && index === 0 && (
            <li
              onClick={() => moveGoal(null, goal.key)}
              className="cursor-pointer my-2 h-3 rounded-full bg-blue-200"
            />
          )}
          <div className="block text-current no-underline hover:no-underline">
            <TodoRow
              goal={goal}
              onRemove={handleRemove}
              toggleMove={
                () => {
                  console.log(selectedGoalKey);
                  if (selectedGoalKey === goal.key) {
                    setSelectedGoalKey(null);
                  } else {
                    setSelectedGoalKey(goal.key);
                  }
                }
              }
              moveState={selectedGoalKey === goal.key}
              refresh={() => setRefresh(!refresh)}
            />
          </div>
          {/* Separator between goals or after the last goal */}
          {selectedGoalKey !== null && (
            <li
              onClick={() => moveGoal(goal.key, collections[jsonPath]?.goals[index + 1]?.key || null)}
              className="cursor-pointer my-2 h-3 rounded-full bg-blue-200"
            />
          )}
        </React.Fragment>
      ))}
      </ul>
    )}
    </div>
  );
};

export default TodoList;