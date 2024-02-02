import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { WeeklyTarget, Week, Weekday } from './types';
import useStore, { StoreState, StoreActions } from './store';
import api from '../../api';

const weekDays: Weekday[] = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

const WeeklyTargetPage = ({ id }: { id: string }) => {
  const [activeWeek, setActiveWeek] = useState<string>('');
  const [currentWeek, setCurrentWeek] = useState<string>('');
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [target, setTarget] = useState<number | null>(null);
  const [entries, setEntries] = useState({} as Record<Weekday, number>);
  const [comparisonType, setComparisonType] = useState<'==' | '>=' | '<='>('>=');

  const navigate = useNavigate(); // Initialize useNavigate

  useEffect(() => {
    // Set the current week on component mount
    const today = new Date();
    const currentWeekKey = getWeekKey(today);
    setCurrentWeek(currentWeekKey);
    setActiveWeek(currentWeekKey);
  }, []);

  // Correctly typed from the useStore hook
  const weeklyTarget: WeeklyTarget | undefined = useStore((state: StoreState) => state.weeklyTargets[id ?? '']);
  const setWeeklyTarget = useStore((state: StoreActions) => state.setWeeklyTarget);

  useEffect(() => {
    const weekKey = getWeekKey(new Date());
    setActiveWeek(weekKey);
  }, []);

  useEffect(() => {
    const weekKey = getWeekKey(new Date());
    setActiveWeek(weekKey);
  }, []);
  
  useEffect(() => {
    const loadWeeklyTarget = async (targetId: string) => {
      setIsLoading(true);
      try {
        const weeklyTargetData: WeeklyTarget | null = await api.jsonRead(`/weekly_goals/${targetId}.json`);
        if (weeklyTargetData) {
          setWeeklyTarget(targetId, weeklyTargetData);
          // Check if the week exists, otherwise initialize with defaults
          const weekData = weeklyTargetData.weeks[activeWeek];
          if (weekData) {
            setTarget(weekData.target || null);
            setComparisonType(weekData.type);
            setEntries(weekData.entries || {});
          } else {
            // Initialize with defaults for a non-existent week
            setTarget(null);
            setComparisonType('>=');
            setEntries({} as Record<string, number>);
          }
        }
        setIsLoading(false);
      } catch (error) {
        console.error('Error loading weekly targets:', error);
        setIsLoading(false);
      }
    };
    if (id) {
      loadWeeklyTarget(id);
    }
  }, [id, activeWeek, setWeeklyTarget]);

  const navigateWeeks = (direction: 'previous' | 'next') => {
    // Convert the active week to a Date object assuming it's in local time
    const localDate = new Date(activeWeek + 'T00:00:00');
    
    // Convert the local date to UTC to avoid DST issues
    const utcDate = Date.UTC(localDate.getFullYear(), localDate.getMonth(), localDate.getDate());
    const date = new Date(utcDate);
    
    // Adjust by 7 days in UTC
    date.setUTCDate(date.getUTCDate() + (direction === 'next' ? 7 : -7));
    
    // Format the new week key in YYYY-MM-DD format
    const newWeekKey = date.toISOString().split('T')[0];
    
    setActiveWeek(newWeekKey);
  };

  const navigateToCurrentWeek = () => {
    const currentWeekKey = getWeekKey(new Date());
    setActiveWeek(currentWeekKey);
  };

  const getWeekKey = (date: Date): string => {
    // Adjust the date to the nearest Monday as the start of the week
    const dayOfWeek = date.getDay();
    const diff = dayOfWeek === 0 ? -6 : 1 - dayOfWeek; // Calculate difference to last Monday
    date.setDate(date.getDate() + diff);
    
    // Format date in YYYY-MM-DD in local time
    const year = date.getFullYear();
    const month = date.getMonth() + 1; // getMonth() is zero-based
    const day = date.getDate();
    return `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;
  };

  const cumulativeValues = weekDays.reduce<Record<Weekday, number>>((acc, day, index) => {
    const currentValue = entries[day] ?? 0;
    acc[day] = (index === 0 ? 0 : acc[weekDays[index - 1]]) + currentValue;
    return acc;
  }, {} as Record<Weekday, number>);

  const determineCumulativeTextColor = (cumulative: number, target: number | null) => {
    if (target === null) return 'text-gray-900'; // Default color when target is not set
  
    let isValid = false;
    switch (comparisonType) {
      case '==':
        isValid = cumulative === target;
        break;
      case '>=':
        isValid = cumulative >= target;
        break;
      case '<=':
        isValid = cumulative <= target;
        break;
      default:
        isValid = false;
        break;
    }
  
    return isValid ? 'text-green-600' : 'text-gray-900'; // Green when valid, default color otherwise
  };

  const handleTargetChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const newTarget = e.target.value ? parseFloat(e.target.value) : null;
    setTarget(newTarget);
    await saveChanges(newTarget, comparisonType, entries);
  };
  
  const handleTypeChange = async (e: React.ChangeEvent<HTMLSelectElement>) => {
    const newType = e.target.value as '==' | '>=' | '<=';
    setComparisonType(newType);
    await saveChanges(target, newType, entries);
  };

  const handleEntryChange = async (day: Weekday, value: string) => {
    const newEntries = {
      ...entries,
      [day]: value ? parseFloat(value) : null,
    };
    setEntries(newEntries);
    await saveChanges(target, comparisonType, newEntries);
  };

  const saveChanges = async (newTarget: number | null, newType: '==' | '>=' | '<=', newEntries: Record<Weekday, number>) => {
    const updatedWeek: Week = { target: newTarget, type: newType, entries: newEntries };
    
    // Determine if the week should be deleted
    const shouldDeleteWeek = newTarget === null && Object.values(newEntries).every(entry => entry === null);
    if (shouldDeleteWeek && weeklyTarget?.weeks[activeWeek]) {
      delete weeklyTarget.weeks[activeWeek];
    } else {
      weeklyTarget.weeks[activeWeek] = updatedWeek;
    }
  
    // Perform API call to save the updated weekly target
    try {
      await api.jsonPut(`/weekly_goals/${id}.json`, weeklyTarget);
      setWeeklyTarget(id, { ...weeklyTarget }); // Ensure state updates to trigger re-render
    } catch (error) {
      console.error('Error saving changes:', error);
      // Handle error (e.g., show notification to the user)
    }
  };

  const displayCumulativeValues = (day: Weekday) => {
    if (!weeklyTarget?.weeks[activeWeek]) {
      return '- / -'; // Week does not exist
    }
    const cumulative = weekDays.slice(0, weekDays.indexOf(day) + 1).reduce((acc, curDay) => {
      return acc + (entries[curDay] || 0);
    }, 0);
    const targetValue = target !== null ? target : '-';
    return `${cumulative} / ${targetValue}`;
  };

  return (
    <div className="mt-4 flex flex-col items-center space-y-4">
      <div className="flex items-center">
        <button
          onClick={navigateToCurrentWeek}
          className="mx-1 px-2 py-1 bg-gray-300 rounded"
        >
          This Week
        </button>
        <button
          onClick={() => navigate('/weekly_targets')}
          className="mx-1 px-2 py-1 bg-gray-300 rounded"
        >
          Back to Weekly Targets
        </button>
      </div>
      <h1 className="text-2xl font-bold">{weeklyTarget?.description}</h1>
      { isLoading && (
        <div className="flex justify-center mt-20">
          <div className="animate-spin rounded-full h-16 w-16 border-b-8 border-t-transparent border-blue-500"></div>
        </div>
      )}      
      { !isLoading && (
        <div className="w-full max-w-md p-4 border border-gray-300 shadow-lg rounded-lg">
          <div className="pb-4 flex justify-between items-center">
            <button
              onClick={() => navigateWeeks('previous')}
              className="mx-2 px-2 py-1 bg-gray-300 rounded"
            >
              <span>&larr;</span>
            </button>
            <h3 className="font-bold text-lg leading-6 text-gray-900">
              {activeWeek === currentWeek ? `Current Week: ${activeWeek}` : `Week of ${activeWeek}`}
            </h3>
            <button
              onClick={() => navigateWeeks('next')}
              className="mx-2 px-2 py-1 bg-gray-300 rounded"
            >
              <span>&rarr;</span>
            </button>
          </div>
          <div className="flex items-center">
            <div className="font-bold text-lg p-1">Target:</div>
            <input
              type="number"
              step="any"
              id="target"
              value={target || ''}
              onChange={handleTargetChange}
              className="mx-2 p-1 border border-gray-300 rounded w-1/4"
            />
            <div className="font-bold text-lg p-1">Type:</div>
            <select
              value={comparisonType}
              onChange={handleTypeChange}
              className="ml-2 p-1 border border-gray-300 rounded"
            >
              <option value="==">{'=='}</option>
              <option value=">=">{'>='}</option>
              <option value="<=">{'<='}</option>
            </select>
          </div>
          <div className="mt-4">
            <div className="font-bold grid grid-cols-3 text-center mb-2">
              <div>Day</div>
              <div>Tally</div>
              <div>Cumulative</div>
            </div>
            {weekDays.map((day) => (
              <div key={day} className="grid grid-cols-3 gap-4 items-center">
                <div>{day.charAt(0).toUpperCase() + day.slice(1)}</div>
                <input
                  type="number"
                  step="any"
                  value={entries[day] ?? ''}
                  onChange={(e) => handleEntryChange(day, e.target.value)}
                  className="p-1 border border-gray-300 rounded"
                />
              <div className={`text-center ${determineCumulativeTextColor(cumulativeValues[day], target)}`}>
                {displayCumulativeValues(day)}
              </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>

  );
};

export default WeeklyTargetPage;