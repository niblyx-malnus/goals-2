import React, { useState, useEffect, useRef } from 'react';
import { FiPlus, FiX, FiTrash } from 'react-icons/fi';
import { getWeekDay, getMonday, addDays, formatDate, getMonth, getQuarter, getYear } from '../dateUtils';
import useStore from './store';
import api from '../../api';
import { Goal, periodType, isPeriodType } from './types';
import { ourPool } from '../../constants';

const determinePath = (periodType: periodType, date: Date) => {
  let dateKey;
  switch (periodType) {
    case 'day':
      dateKey = formatDate(date);
      break;
    case 'week':
      dateKey = formatDate(getMonday(date));
      break;
    case 'month':
      dateKey = getMonth(date);
      break;
    case 'quarter':
      dateKey = getQuarter(date);
      break;
    case 'year':
      dateKey = getYear(date);
      break;
    default:
      throw new Error(`Unknown listType: ${periodType}`);
  }
  return `/period/${periodType}/${dateKey}.json`;
};

const formatDateDisplay = (periodType: periodType, date: Date) => {
  switch (periodType) {
    case 'day':
      return `${getWeekDay(date)}, ${formatDate(date)}`;
    case 'week':
      return `Week of ${formatDate(getMonday(date))}`;
    case 'month':
      // Assuming getMonth returns the month and year in format "YYYY-MM"
      return `${new Date(date).toLocaleString('default', { month: 'long' })} ${date.getFullYear()}`;
    case 'quarter':
      // Assuming getQuarter returns "YYYY-QX"
      const quarter = getQuarter(date).split('-')[1];
      return `${quarter} of ${date.getFullYear()}`;
    case 'year':
      return `${getYear(date)}`;
    default:
      return '';
  }
};

const formatNowDisplay = (periodType: periodType) => {
  switch (periodType) {
    case 'day':
      return 'Today';
    case 'week':
      return 'This Week';
    case 'month':
      return 'This Month';
    case 'quarter': 
      return 'This Quarter';
    case 'year':
      return 'This Year';
    default:
      return '';
  }
}

const navigateDate = (currentDate: Date, periodType: periodType, direction: 'prev' | 'next') => {
  let adjustment = 1; // Default for day
  if (periodType === 'week') {
    adjustment = 7;
  } else if (periodType === 'month') {
    adjustment = direction === 'next' ? 1 : -1;
    return new Date(currentDate.setMonth(currentDate.getMonth() + adjustment));
  } else if (periodType === 'quarter') {
    adjustment = direction === 'next' ? 3 : -3;
    return new Date(currentDate.setMonth(currentDate.getMonth() + adjustment));
  } else if (periodType === 'year') {
    adjustment = direction === 'next' ? 1 : -1;
    return new Date(currentDate.setFullYear(currentDate.getFullYear() + adjustment));
  }
  // For day and week navigation
  return addDays(currentDate, direction === 'next' ? adjustment : -adjustment);
};

const TodoRow = ({
  goal,
  onToggleComplete,
  onDelete,
  onRemove,
  onAddToTodoList
}: {
  goal: Goal,
  onToggleComplete: (id: string) => void,
  onDelete: (id: string) => void,
  onRemove: (id: string) => void,
  onAddToTodoList: (path: string, key: string) => void
}) => {
  const [panel, setPanel] = useState('');
  const [listType, setListType] = useState<periodType>('day');
  const [selectedDate, setSelectedDate] = useState(new Date());
  
  const rowRef = useRef<HTMLLIElement>(null);

  useEffect(() => {
    // Function to check if clicked outside of element
    const handleClickOutside = (event: { target: any; }) => {
      if (rowRef.current && !rowRef.current.contains(event.target)) {
        setPanel(''); // Close the panel
      }
    };
  
    // Add event listener when the component mounts
    document.addEventListener("mousedown", handleClickOutside);
  
    // Cleanup event listener
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, []);

  const togglePlusPanel = () => {
    if (panel === '') {
      setPanel('plus');
    } else {
      setPanel('');
    }
  }

  const AddPanel = () => {
    const path = determinePath(listType, selectedDate);
  
    // Check if the selected selectedDate is today for the "Now" button
    const isTodaySelected = formatDate(new Date()) === formatDate(selectedDate);

    const handleListTypeChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
      const newValue = e.target.value;
      if (isPeriodType(newValue)) {
        setListType(newValue);
      } else {
        console.error(`${newValue} is not a valid periodType`);
        // Handle the error appropriately
      }
    };
    
    return (
      <div className="z-10 absolute right-0 bottom-full mt-2 w-64 bg-white p-4 shadow-lg rounded-lg">
        <div className="flex justify-center mb-4">
          <select
            value={listType}
            onChange={handleListTypeChange}
            className="max-w-20 mr-2 px-3 py-2 bg-gray-200 text-gray-800 rounded-md"
          >
            <option value="day">Day</option>
            <option value="week">Week</option>
            <option value="month">Month</option>
            <option value="quarter">Quarter</option>
            <option value="year">Year</option>
          </select>
          <button 
            className={`w-28 px-3 py-1 text-sm font-medium rounded-md ${isTodaySelected ? 'bg-gray-400 text-white' : 'bg-blue-500 text-white'}`}
            onClick={() => !isTodaySelected && setSelectedDate(new Date())}
            disabled={isTodaySelected}>
            {formatNowDisplay(listType)}
          </button>
        </div>
        <div className="flex items-center justify-between mb-4">
          <button 
            className="p-2 rounded-md bg-gray-200 text-gray-800" 
            onClick={() => setSelectedDate(navigateDate(selectedDate, listType, 'prev'))}>
            ←
          </button>
          <span className="text-sm text-center font-medium">
            {formatDateDisplay(listType, selectedDate)}
          </span>
          <button 
            className="p-2 rounded-md bg-gray-200 text-gray-800" 
            onClick={() => setSelectedDate(navigateDate(selectedDate, listType, 'next'))}>
            →
          </button>
        </div>
        <button 
          className="w-full px-4 py-2 bg-blue-500 text-white rounded-md text-sm font-medium hover:bg-blue-600" 
          onClick={() => onAddToTodoList(path, goal.key)}>
          Add to {listType} list
        </button>
      </div>
    );
  };
  
  const toggleComplete = () => {
    onToggleComplete(goal.key);
  }

  return (
    <li ref={rowRef} className={`flex justify-between items-center mb-2 p-2 ${goal.complete ? 'bg-gray-200' : 'bg-white'} rounded shadow`}>
      <span
        className={`flex-1 cursor-pointer ${goal.complete ? 'line-through' : ''}`}
        onClick={toggleComplete}
      >
        {goal.summary}
      </span>
      <div className="relative group">
        <button
          onClick={togglePlusPanel}
          className="mr-1 bg-gray-300 hover:bg-gray-500 font-bold py-1 px-1 rounded"
        >
          <FiPlus />
        </button>
        {panel === 'plus' && <AddPanel />}
      </div>
      <button
        onClick={() => onRemove(goal.key)}
        className="mr-1 bg-gray-300 hover:bg-gray-500 font-bold py-1 px-1 rounded"
      >
        <FiX />
      </button>
      <button
        onClick={() => {
          const isConfirmed = window.confirm("Deleting a goal is irreversible. Are you sure you want to delete this goal?");
          if (isConfirmed) {
            onDelete(goal.key);
          }
        }}
        className="bg-gray-300 hover:bg-gray-500 font-bold py-1 px-1 rounded"
      >
        <FiTrash />
      </button>
    </li>
  );
};

const TodoList: React.FC = () => {
  const [viewType, setViewType] = useState<periodType>('day');
  const [currentDate, setCurrentDate] = useState(new Date());
  const [input, setInput] = useState('');
  const [themeInput, setThemeInput] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [refresh, setRefresh] = useState(false);
  const { collections, setCollection, delCollection } = useStore(state => state);

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
  }, [viewType, currentDate, setCollection, refresh]);

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
    const { pid, gid } = api.goalKeyToPidGid(key);
    try {
      await api.deleteGoal(pid, gid);
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

  const handleToggleComplete = async (id: string) => {
    const { pid, gid } = api.goalKeyToPidGid(id);
    try {
      const isCompleted = await api.getGoalComplete(pid, gid);
      await api.setGoalComplete(pid, gid, !isCompleted);
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
    const pid = "/~niblyx-malnus/~2024.2.10..15.45.57..8116";
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