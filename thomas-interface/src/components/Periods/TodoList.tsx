import React, { useState, useEffect } from 'react';
import { formatDate } from '../dateUtils';
import useStore from './store';
import api from '../../api';
import { periodType } from './types';
import { Goal } from '../../types';
import { ourPool } from '../../constants';
import { isPeriodType, determinePath, formatDateDisplay, formatNowDisplay, navigateDate } from './helpers';
import TodoRow from './TodoRow';

const TodoList: React.FC = () => {
  const [viewType, setViewType] = useState<periodType>('day');
  const [currentDate, setCurrentDate] = useState(new Date());
  const [input, setInput] = useState('');
  const [themeInput, setThemeInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [refresh, setRefresh] = useState(false);
  const { collections, setCollection } = useStore(state => state);

  const path = determinePath(viewType, currentDate);

  useEffect(() => {
    setIsLoading(true);
  
    api.jsonRead(path)
      .then(async (data: { keys: string[], themes: string[] }) => {
        const goals: Goal[] = await api.getGoalData(data.keys);
        setCollection(path, { themes: data.themes, goals: goals });
      })
      .catch(error => {
        setCollection(path, { goals: [], themes: [] });
      })

    setIsLoading(false);
  }, [viewType, currentDate, setCollection, refresh, path]);

  const isToday = formatDate(new Date()) === formatDate(currentDate);

  const handleCreate = async () => {
    if (!input.trim()) return;
    try {
      const key = await api.createGoal(ourPool, null, input, true);
      if (path in collections) {
        if (!collections[path].goals.some(goal => goal.key === key)) {
          api.jsonPut(path, { themes: collections[path].themes, keys: [...collections[path].goals.map(goal => goal.key), key] })
        }
      } else {
        api.jsonPut(path, { themes: [], keys: [] })
      }
      setInput('');
      setRefresh(!refresh);
    } catch (error) {
      console.error("Failed to create a new goal:", error);
    }
  };

  const handleAdd = async (path: string, key: string) => {
    try {
      if (path in collections) {
        if (!collections[path].goals.some(goal => goal.key === key)) {
          api.jsonPut(path, { themes: collections[path].themes, keys: [...collections[path].goals.map(goal => goal.key), key] })
        }
      } else {
        api.jsonPut(path, { themes: [], keys: [] })
      }
      setInput('');
      setRefresh(!refresh);
    } catch (error) {
      console.error("Failed to create a new goal:", error);
    }
  };

  const handleDelete = async (key: string) => {
    try {
      await api.deleteGoal(key);
      if (path in collections) {
        api.jsonPut(path, { themes: collections[path].themes, keys: collections[path].goals.map(goal => goal.key).filter(k => k !== key) })
      }
      setRefresh(!refresh);
    } catch (error) {
      console.error("Failed to delete goal:", error);
    }
  };

  const handleRemove = async (key: string) => {
    try {
      if (path in collections) {
        api.jsonPut(path, { themes: collections[path].themes, keys: collections[path].goals.map(goal => goal.key).filter(k => k !== key) })
      }
      setRefresh(!refresh);
    } catch (error) {
      console.error("Failed to remove goal:", error);
    }
  };

  const handleToggleComplete = async (key: string) => {
    try {
      const isCompleted = await api.getGoalComplete(key);
      await api.setGoalComplete(key, !isCompleted);
      setRefresh(!refresh);
      // No need to update the local state for completion status, as it will be fetched dynamically
    } catch (error) {
      console.error("Failed to toggle goal completion:", error);
    }
  };

  const handleCreateTheme = () => {
    setThemeInput(''); // Clear input after adding
    if (!themeInput.trim()) return;
    try {
      if (path in collections) {
        api.jsonPut(path, { themes: [...collections[path].themes, themeInput], keys: collections[path].goals.map(goal => goal.key) })
      } else {
        api.jsonPut(path, { themes: [themeInput], keys: [] })
      }
      setRefresh(!refresh);
    } catch (error) {
      console.error("Failed to create a new goal:", error);
    }
  };

  const handleRemoveTheme = (themeToRemove: string) => {
    try {
      if (path in collections) {
        api.jsonPut(path, { themes: collections[path].themes.filter(t => t !== themeToRemove), keys: collections[path].goals.map(goal => goal.key) })
        setRefresh(!refresh);
      }
    } catch (error) {
      console.error("Failed to create a new goal:", error);
    }
  };

  const goToToday = () => {
    setCurrentDate(new Date());
  };

  const handleViewTypeChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const newValue = e.target.value;
    if (isPeriodType(newValue)) {
      setViewType(newValue);
    } else {
      console.error(`${newValue} is not a valid periodType`);
      // Handle the error appropriately
    }
  };

  return (
    <div className="max-w-xl mx-auto my-10 p-4">
      <div className="relative group items-center">
        <div className="mb-4 flex justify-center">
          <select
            value={viewType}
            onChange={handleViewTypeChange}
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
            className={`w-28 py-1 px-2 ${isToday ? 'bg-gray-400' : 'bg-blue-700'} text-white rounded`}
            disabled={isToday}
          >
            {formatNowDisplay(viewType)}
          </button>
        </div>
        <div className="mb-4 flex justify-between">
          <button
            onClick={() => setCurrentDate(navigateDate(currentDate, viewType, 'prev'))}
            className="py-2 px-4 bg-gray-300 text-gray-700 rounded"
          >
            Prev
          </button>
          <div
            className="w-56 text-center font-bold py-2 px-4 bg-gray-200 text-gray-700 rounded"
          >
            {formatDateDisplay(viewType, currentDate)}
          </div>
          <button
            onClick={() => setCurrentDate(navigateDate(currentDate, viewType, 'next'))}
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
          {collections[path]?.themes.map(theme => (
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
        {collections[path]?.goals.map((goal) => (
          <TodoRow
            goal={goal}
            onToggleComplete={handleToggleComplete}
            onDelete={handleDelete}
            onRemove={handleRemove}
            onAddToTodoList={handleAdd}
          />
        ))}
      </ul>
    )}
    </div>
  );
};

export default TodoList;