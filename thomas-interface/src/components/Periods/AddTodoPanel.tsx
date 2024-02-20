import React, { useState } from 'react';
import { Goal, periodType } from '../../types';
import { getCurrentPeriod, getAdjacentPeriod, isPeriodType, formatDateKeyDisplay, formatNowDisplay } from './utils';
import useStore from '../../store';
import api from '../../api';
import useCustomNavigation from '../useCustomNavigation';

const AddTodoPanel = ({
  goalKey,
  exit,
}: {
  goalKey: string,
  exit: () => void,
}) => {
  const [periodType, setPeriodType] = useState<periodType>('day');
  const [dateKey, setDateKey] = useState(getCurrentPeriod(periodType));
  const [currentDay, setCurrentDay] = useState(getCurrentPeriod('day'));
  const [currentWeek, setCurrentWeek] = useState(getCurrentPeriod('week'));
  const [currentMonth, setCurrentMonth] = useState(getCurrentPeriod('month'));
  const [currentQuarter, setCurrentQuarter] = useState(getCurrentPeriod('quarter'));
  const [currentYear, setCurrentYear] = useState(getCurrentPeriod('year'));

  const jsonPath = `/periods/${periodType}/${dateKey}.json`;

  const today = getCurrentPeriod(periodType);

  const { setCollection } = useStore(state => state);

  const { navigateToPeriod } = useCustomNavigation();

  const readTodoList = async (jsonPath: string) => {
    try {
      return await api.jsonRead(jsonPath);
    } catch (error) {
      return { keys: [], themes: [] };
    }
  }

  const handleClickText = (e: React.MouseEvent<HTMLSpanElement>) => {
    exit();
    navigateToPeriod(periodType, dateKey);
  }

  const onAddToTodoList = async (jsonPath: string) => {
    try {
      const todos = await readTodoList(jsonPath);
      if (!todos.keys.includes(goalKey)) {
        await api.jsonPut(jsonPath, { themes: todos.themes, keys: [...todos.keys, goalKey] });
        const goals: Goal[] = await api.getGoalData([...todos.keys, goalKey]);
        setCollection(jsonPath, { themes: todos.themes, goals: goals });
      } else {
        console.log("Key already exists in todo list.")
      }
    } catch (error) {
      console.error("Failed to create a new goal:", error);
    }
  }

  const handlePeriodTypeChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const newPeriod = e.target.value;
    if (isPeriodType(newPeriod)) {
      setPeriodType(newPeriod);
      let newDateKey;
      switch (newPeriod) {
        case 'day':
          newDateKey = currentDay;
          break;
        case 'week':
          newDateKey = currentWeek;
          break;
        case 'month':
          newDateKey = currentMonth;
          break;
        case 'quarter':
          newDateKey = currentQuarter;
          break;
        case 'year':
          newDateKey = currentYear;
          break;
      }
      setDateKey(newDateKey);
    } else {
      console.error(`${newPeriod} is not a valid periodType`);
    }
  };

  const handleNavigation = (direction: 'prev' | 'next') => {
    const newDateKey = getAdjacentPeriod(periodType, dateKey, direction);
    switch (periodType) {
      case 'day':
        setCurrentDay(dateKey);
        break;
      case 'week':
        setCurrentWeek(dateKey);
        break;
      case 'month':
        setCurrentMonth(dateKey);
        break;
      case 'quarter':
        setCurrentQuarter(dateKey);
        break;
      case 'year':
        setCurrentYear(dateKey);
        break;
    }
    setDateKey(newDateKey);
  };
  
  return (
    <div>
      <div className="flex justify-center mb-4">
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
          className={`w-28 px-3 py-1 text-sm font-medium rounded-md ${(today === dateKey) ? 'bg-gray-400 text-white' : 'bg-blue-500 text-white'}`}
          onClick={() => !(today === dateKey) && setDateKey(today)}
          disabled={(today === dateKey)}>
          {formatNowDisplay(periodType)}
        </button>
      </div>
      <div className="flex items-center justify-between mb-4">
        <button 
          className="p-2 rounded-md bg-gray-200 text-gray-800" 
          onClick={() => handleNavigation('prev')}>
          ←
        </button>
        <span
          onClick={handleClickText}
          className="cursor-pointer text-sm text-center font-medium"
        >
          {formatDateKeyDisplay(periodType, dateKey)}
        </span>
        <button 
          className="p-2 rounded-md bg-gray-200 text-gray-800" 
          onClick={() => handleNavigation('next')}>
          →
        </button>
      </div>
      <button 
        className="w-full px-4 py-2 bg-blue-500 text-white rounded-md text-sm font-medium hover:bg-blue-600" 
        onClick={() => onAddToTodoList(jsonPath)}>
        Add to {periodType} list
      </button>
    </div>
  );
};

export default AddTodoPanel;