import React, { useState, useEffect } from 'react';
import ArchiveGoalRow from './ArchiveGoalRow';
import { Goal } from '../types';
import { TagFilter, filterGoalsByTags, getUniqueTags } from './TagFilter';
import { arch } from 'os';

function ArchiveGoalList({
  goals,
  rid,
  moveGoal,
  atPoolRoot,
  isLoading,
  refresh,
  completeTab = false,
  defaultCompleteTab = 'Incomplete',
}: {
  goals: Goal[];
  rid?: string,
  moveGoal?: (selectedGoalKey: string, aboveGoalKey: string | null, belowGoalKey: string | null) => void;
  atPoolRoot?: boolean;
  archivedAncestor?: boolean,
  isLoading: boolean;
  refresh: () => void;
  completeTab?: boolean;
  defaultCompleteTab?: 'Incomplete' | 'Complete';
}) {
  const [selectedGoalKey, setSelectedGoalKey] = useState<string | null>(null);
  const [tags, setTags] = useState<string[]>([]);
  const [selectedOperation, setSelectedOperation] = useState<'some' | 'every'>('every');
  const [includeInherited, setIncludeInherited] = useState(true);
  const [tagOrLabel, setTagOrLabel] = useState<'both' | 'tag' | 'label'>('both');
  const [displayList, setDisplayList] = useState<Goal[]>([]);
  const [uniqueTags, setUniqueTags] = useState<string[]>([]);
  const [activeTab, setActiveTab] = useState<'Incomplete' | 'Complete'>(defaultCompleteTab);

  useEffect(() => {
    const uniqueTags = getUniqueTags(goals, includeInherited, tagOrLabel);
    setUniqueTags(uniqueTags);
    let filteredArray = filterGoalsByTags(tagOrLabel, goals, tags, selectedOperation, includeInherited);
    switch (activeTab) {
      case 'Incomplete':
        filteredArray = filteredArray.filter(goal => !goal.complete);
        break;
      case 'Complete':
        filteredArray = filteredArray.filter(goal => goal.complete);
        break;
    }
    setDisplayList(filteredArray);
  }, [activeTab, goals, includeInherited, selectedOperation, tagOrLabel, tags]);

  return (
      <div>
        <div className="">
          { completeTab && (
            <ul className="flex justify-center -mb-px">
              <li className={`${activeTab === 'Incomplete' ? 'border-blue-500' : ''}`}>
                <button 
                  className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                    activeTab === 'Incomplete' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
                  }`} 
                  onClick={() => setActiveTab('Incomplete')}
                >
                  Incomplete
                </button>
              </li>
              <li className={`${activeTab === 'Complete' ? 'border-blue-500' : ''}`}>
                <button 
                  className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                    activeTab === 'Complete' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
                  }`} 
                  onClick={() => setActiveTab('Complete')}
                >
                  Complete
                </button>
              </li>
            </ul>
          )}
        </div>
        { isLoading && (
          <div className="flex justify-center m-20">
            <div className="animate-spin rounded-full h-16 w-16 border-b-8 border-t-transparent border-blue-500"></div>
          </div>
        )}
        { !isLoading && goals.length > 0 && (
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
        )}
        {!isLoading && displayList.length === 0 && (
            <div className="text-center m-5 text-lg text-gray-600">No goals found.</div>
        )}
        { !isLoading && displayList.length > 0 && (
          <ul>
            {displayList.map((goal, index) => (
              <React.Fragment key={index}>
                {/* Insert separator before the first goal for moving to the start */}
                {selectedGoalKey !== null && index === 0 && (
                  <li
                    onClick={
                      () => {
                        if (moveGoal) {
                          moveGoal(selectedGoalKey, null, goal.key);
                        }
                      }
                    }
                    className="cursor-pointer my-2 h-3 rounded-full bg-blue-200"
                  />
                )}
                <div
                  key={goal.key}
                  className="block text-current no-underline hover:no-underline"
                >
                  <ArchiveGoalRow
                    atPoolRoot={atPoolRoot}
                    rid={rid}
                    goal={goal}
                    refresh={refresh}
                    toggleMove={
                      () => {
                        if (moveGoal) {
                          console.log(selectedGoalKey);
                          if (selectedGoalKey === goal.key) {
                            setSelectedGoalKey(null);
                          } else {
                            setSelectedGoalKey(goal.key);
                          }
                        }
                      }
                    }
                    moveState={moveGoal && selectedGoalKey === goal.key}
                  />
                </div>
                {/* Separator between goals or after the last goal */}
                {selectedGoalKey !== null && (
                  <li
                    onClick={
                      () => {
                        if (moveGoal) {
                          moveGoal(selectedGoalKey, goal.key, goals[index + 1]?.key || null);
                        }
                      }
                    }
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

export default ArchiveGoalList;