import React, { useState, useRef, useEffect } from 'react';
import { FiArchive, FiTag, FiInfo, FiCopy, FiPlus, FiUsers } from 'react-icons/fi';
import { FaArrowsAlt, FaTable } from 'react-icons/fa'; 
import { TagIcon, AttributeIcon, ActionableIcon, ActiveIcon } from './CustomIcons';
import AddTodoPanel from './Periods/AddTodoPanel';
import LabelPanel from './Panels/LabelPanel';
import TagPanel from './Panels/TagPanel';
import FieldsPanel from './Panels/FieldsPanel';
import MovePanel from './Panels/MovePanel';
import InfoPanel from './Panels/InfoPanel';
import { Goal } from '../types';
import api from '../api';

const GoalActionBar: React.FC<{
    goal: Goal,
    refresh: () => void,
  }> = ({
    goal,
    refresh,
  }) => {
  const [panel, setPanel] = useState('');
  const barRef = useRef<HTMLDivElement>(null);

  const toggleInfoPanel = () => {
    if (panel === 'info') {
      setPanel('');
    } else {
      setPanel('info');
    }
  };

  const toggleAddTodoPanel = () => {
    if (panel === 'add') {
      setPanel('');
    } else {
      setPanel('add');
    }
  };

  const toggleMovePanel = () => {
    if (panel === 'move') {
      setPanel('');
    } else {
      setPanel('move');
    }
  };

  const toggleLabelPanel = () => {
    if (panel === 'label') {
      setPanel('');
    } else {
      setPanel('label');
    }
  };

  const toggleTagPanel = () => {
    if (panel === 'tag') {
      setPanel('');
    } else {
      setPanel('tag');
    }
  };

  const toggleFieldsPanel = () => {
    if (panel === 'attribute') {
      setPanel('');
    } else {
      setPanel('attribute');
    }
  };

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (barRef.current && !barRef.current.contains(event.target as Node)) {
        setPanel('');
      }
    };

    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [barRef]);

  const copyToClipboard = () => {
    setPanel('');
    navigator.clipboard.writeText(goal.key);
  }

  const toggleActionable = async () => {
    try {
      await api.setGoalActionable(goal.key, !goal.actionable);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };

  const toggleActive = async () => {
    try {
      await api.setGoalActive(goal.key, !goal.active);
      refresh();
    } catch (error) {
      console.error(error);
    }
  };

  const archiveGoal = async () => {
    const isConfirmed = window.confirm("Are you sure you want to archive this goal?");
  
    // Only proceed if the user confirms
    if (isConfirmed) {
      try {
        await api.archiveGoal(goal.key);
        refresh();
      } catch (error) {
        console.error(error);
      }
    }
  };
  
  return (
    <div ref={barRef} className="p-1 relative group bg-gray-200 flex items-center">
      <button
        className="p-2 rounded bg-gray-100"
        onClick={() => console.log()}
      >
        <FiUsers />
      </button>
      <button
        className="p-2 rounded bg-gray-100"
        onClick={copyToClipboard}
      >
        <FiCopy />
      </button>
      <button
        className="p-2 rounded bg-gray-100"
        onClick={toggleMovePanel}
      >
        <FaArrowsAlt style={{ color: "#3d3d3e" }} />
      </button>
      <button
        onClick={toggleAddTodoPanel}
        className="p-2 rounded bg-gray-100"
      >
        <FiPlus />
      </button>
      <div className="relative group">
        <button
          className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
          onClick={toggleTagPanel}
        >
          <TagIcon />
          {goal.inheritedTags.length + goal.tags.length > 0 && (
            <span className="absolute top-0 right-0 bg-gray-300 rounded-full text-xs px-1">
              {goal.inheritedTags.length + goal.tags.length}
            </span>
          )}
        </button>
      </div>
      <div className="relative group">
        <button
          className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
          onClick={toggleLabelPanel}
        >
          <FiTag />
          {goal.inheritedLabels.length + goal.labels.length > 0 && (
            <span className="absolute top-0 right-0 bg-gray-300 rounded-full text-xs px-1">
              {goal.inheritedLabels.length + goal.labels.length}
            </span>
          )}
        </button>
      </div>
      <div className="relative group">
        <button
          className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
          onClick={toggleFieldsPanel}
        >
          <AttributeIcon />
        </button>
      </div>
      <div className="relative group">
        <button
          className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
        >
          <FaTable style={{ color: "#3d3d3e" }} />
        </button>
      </div>
      <button
        className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
        onClick={toggleActionable}
      >
        {ActionableIcon(goal.actionable)}
      </button>
      <button
        className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
        onClick={toggleActive}
      >
        {ActiveIcon(goal.active)}
      </button>
      <button
        className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
        onClick={archiveGoal}
      >
        <FiArchive />
      </button>
      <div className="relative group">
        <button
          className="p-2 rounded bg-gray-100"
          onClick={toggleInfoPanel}
        >
          <FiInfo />
        </button>
        { panel !== '' && (
          <div className="z-10 absolute right-0 bottom-full mt-2 w-64 bg-gray-100 border border-gray-200 shadow-2xl rounded-md p-2">
            { panel === 'add' && <AddTodoPanel goalKey={goal.key} exit={() => setPanel('')} /> }
            { panel === 'label' && <LabelPanel goal={goal} exit={() => setPanel('')} refresh={refresh}/> }
            { panel === 'tag' && <TagPanel goal={goal} exit={() => setPanel('')} refresh={refresh}/> }
            { panel === 'info' && <InfoPanel goal={goal} /> }
            { panel === 'move' && <MovePanel goalKey={goal.key} refresh={refresh} /> }
            { panel === 'attribute' && <FieldsPanel goal={goal} exit={() => setPanel('')} refresh={refresh}/> }
          </div>
        )}
      </div>
    </div>
  );
};

export default GoalActionBar;