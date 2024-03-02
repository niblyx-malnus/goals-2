import React, { useState, useEffect } from 'react';
import useStore from '../../store';
import api from '../../api';
import { periodType } from '../../types';
import { Goal } from '../../types';
import { ourPool } from '../../constants';
import { getAdjacentPeriod, formatDateKeyDisplay, getCurrentPeriod, isPeriodType, formatNowDisplay } from './utils';
import { useNavigate } from 'react-router-dom';
import TodoRow from './TodoRow';
import { FaSitemap } from 'react-icons/fa';
import { ActiveIcon } from '../CustomIcons';
import { TagFilter, filterGoalsByTags, getUniqueTags } from '../TagFilter';

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
  const [tags, setTags] = useState<string[]>([]);
  const [selectedOperation, setSelectedOperation] = useState<'some' | 'every'>('every');
  const [includeInherited, setIncludeInherited] = useState(true);
  const [tagOrLabel, setTagOrLabel] = useState<'both' | 'tag' | 'label'>('both');
  const [displayList, setDisplayList] = useState<Goal[]>([]);
  const [uniqueTags, setUniqueTags] = useState<string[]>([]);
  const [activeNewGoal, setActiveNewGoal] = useState(true);

  const { collections, setCollection, getCurrentTreePage } = useStore(state => state);
  const {
    setCurrentPeriodType,
    currentDay,
    setCurrentDay,
    currentWeek,
    setCurrentWeek,
    currentMonth,
    setCurrentMonth,
    currentQuarter,
    setCurrentQuarter,
    currentYear,
    setCurrentYear,
  } = useStore(state => state);

  const navigate = useNavigate();

  const jsonPath = `/periods/${periodType}/${dateKey}.json`;
  
  const today = getCurrentPeriod(periodType);

  useEffect(() => {
    const fetchDataAndUpdateState = async () => {
      setIsLoading(true);
      try {
        const data = await api.jsonRead(jsonPath);
        const goals = await api.getGoalData(data.keys);
        const uniqueTags = getUniqueTags(goals, includeInherited, tagOrLabel);
        setUniqueTags(uniqueTags);
        setCollection(jsonPath, { themes: data.themes, goals });
        const filteredArray = filterGoalsByTags(tagOrLabel, goals, tags, selectedOperation, includeInherited);
        setDisplayList(filteredArray);
      } catch (error) {
        console.error("Failed to fetch data:", error);
        setCollection(jsonPath, { goals: [], themes: [] });
        setUniqueTags([]);
        setDisplayList([]);
      }
      setIsLoading(false);
    };
  
    fetchDataAndUpdateState();
  }, [periodType, setCollection, refresh, jsonPath, tags, selectedOperation, tagOrLabel, includeInherited]);

  const moveGoal = (aboveGoalKey: string | null, belowGoalKey: string | null) => {
    if (selectedGoalKey !== null) {
      let keys = collections[jsonPath]?.goals.map(goal => goal.key) ?? [];
      const currentIndex = keys.indexOf(selectedGoalKey);
  
      // Early exit if the goal isn't found
      if (currentIndex === -1) return;

      // if the below goal is above me, I'm moving up
      const isMovingUp = (belowGoalKey && keys.indexOf(belowGoalKey) < currentIndex);
      // if the above goal is below me, I'm moving down
      const isMovingDown = (aboveGoalKey && keys.indexOf(aboveGoalKey) > currentIndex);
  
      const isMovingToSamePosition = 
        (aboveGoalKey && currentIndex - 1 === keys.indexOf(aboveGoalKey)) ||
        (aboveGoalKey && currentIndex === keys.indexOf(aboveGoalKey)) ||
        (belowGoalKey && currentIndex + 1 === keys.indexOf(belowGoalKey)) ||
        (belowGoalKey && currentIndex === keys.indexOf(belowGoalKey));
      if (isMovingToSamePosition) { return; }

      // Remove the selected goal from its current position
      keys.splice(currentIndex, 1);

      let newIndex = 0;
      // If we're moving up, we go above the belowGoalKey
      if (isMovingUp) {
        newIndex = keys.indexOf(belowGoalKey);
      // If we're moving down, we go below the aboveGoalKey
      } else if (isMovingDown) {
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
      const key = await api.createGoal(ourPool, null, input, true, activeNewGoal);
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
      setCurrentPeriodType(e.target.value);
      switch (e.target.value) {
        case 'day':
          navigate(`/periods/${e.target.value}/${currentDay}`);
          break;
        case 'week':
          navigate(`/periods/${e.target.value}/${currentWeek}`);
          break;
        case 'month':
          navigate(`/periods/${e.target.value}/${currentMonth}`);
          break;
        case 'quarter':
          navigate(`/periods/${e.target.value}/${currentQuarter}`);
          break;
        case 'year':
          navigate(`/periods/${e.target.value}/${currentYear}`);
          break;
      }
    } else {
      console.error(`${e.target.value} is not a valid periodType`);
    }
  };

  const handleNavigation = (direction: 'prev' | 'next') => {
    const newDateKey = getAdjacentPeriod(periodType, dateKey, direction);
    switch (periodType) {
      case 'day':
        setCurrentDay(newDateKey);
        break;
      case 'week':
        setCurrentWeek(newDateKey);
        break;
      case 'month':
        setCurrentMonth(newDateKey);
        break;
      case 'quarter':
        setCurrentQuarter(newDateKey);
        break;
      case 'year':
        setCurrentYear(newDateKey);
        break;
    }
    navigate(`/periods/${periodType}/${newDateKey}`);
  };

  return (
    <div className="max-w-xl mx-auto my-10 p-4">
      <div className="flex justify-center mb-3">
        <button
          onClick={ () => navigate(getCurrentTreePage()) }
          className="p-2 mr-2 border border-gray-300 bg-gray-100 rounded hover:bg-gray-200 flex items-center justify-center"
          style={{ height: '2rem', width: '2rem' }} // Adjust the size as needed
        >
          <FaSitemap />
        </button>
      </div>
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
            className="w-72 text-center font-bold py-2 px-4 bg-gray-200 text-gray-700 rounded"
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
      { false && isLoading && (
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
        <button
          onClick={() => setActiveNewGoal(!activeNewGoal)} 
          className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-l"
        >
          {ActiveIcon(activeNewGoal)}
        </button>
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          className="border border-gray-300 p-2 w-full"
          placeholder="Add a new task"
          onKeyDown={(e) => e.key === 'Enter' && handleCreate()}
        />
        <button onClick={handleCreate} className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-r">Add</button>
      </div>
      <TagFilter
        uniqueTags={uniqueTags}
        tags={tags}
        setTags={setTags}
        tagOrLabel={tagOrLabel}
        setTagOrLabel={setTagOrLabel}
        selectedOperation={selectedOperation}
        setSelectedOperation={setSelectedOperation}
        includeInherited={includeInherited}
        setIncludeInherited={setIncludeInherited}
      />
      { isLoading && (
        <div className="flex justify-center mt-10">
          <div className="animate-spin rounded-full h-16 w-16 border-b-8 border-t-transparent border-blue-500"></div>
        </div>
      )}
      {
        !isLoading && (
          displayList.length === 0 && (
            <div className="text-center mt-5 text-lg text-gray-600">No todos found.</div>
          )
        )
      }
      { !isLoading && (
        <ul>
        {displayList.map((goal, index) => (
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