import React, { useState, useRef, useEffect } from 'react';
import { FiPlay, FiPause, FiTriangle, FiArchive, FiCircle, FiTag, FiX, FiInfo, FiCopy, FiPlus, FiLock } from 'react-icons/fi';
import AddTodoPanel from './Periods/AddTodoPanel';
import LabelPanel from './Panels/LabelPanel';
import TagPanel from './Panels/TagPanel';
import { Goal } from '../types';

const TagIcon = () => {
  return (
    <div>
      <FiTag />
      <span className="p-1 absolute bottom-[-2px] right-[-2px] rounded-full text-xs">
        <FiLock />
      </span>
    </div>
  );
};

const ActionableIcon = (actionable: boolean) => {
  if (actionable) {
    return <FiTriangle />;
  } else {
    return <FiCircle />;
  }
};

const ActiveIcon = (active: boolean) => {
  if (active) {
    return <FiPause />;
  } else {
    return <FiPlay />;
  }
};

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
    console.log("Opening add panel...");
    console.log(goal);
    if (panel === 'add') {
      setPanel('');
    } else {
      setPanel('add');
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

  const InfoPanel = () => {
    return (
      <div>
        <p>Info Panel</p>
        {/* Place your info content here */}
      </div>
    );
  };

  const copyToClipboard = () => {
    setPanel('');
    navigator.clipboard.writeText(goal.key);
  }
  
  return (
    <div ref={barRef} className="p-1 relative group bg-gray-200 flex items-center">
      <button
        className="p-2 rounded bg-gray-100"
        onClick={copyToClipboard}
      >
        <FiCopy />
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
          {goal.tags.length > 0 && (
            <span className="absolute top-0 right-0 bg-gray-300 rounded-full text-xs px-1">
              {goal.tags.length}
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
          {goal.labels.length > 0 && (
            <span className="absolute top-0 right-0 bg-gray-300 rounded-full text-xs px-1">
              {goal.labels.length}
            </span>
          )}
        </button>
      </div>
      <button
        className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
      >
        {ActionableIcon(goal.actionable)}
      </button>
      <button
        className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
      >
        {ActiveIcon(goal.active)}
      </button>
      <button
        className="p-2 rounded bg-gray-100 relative justify-center flex items-center"
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
            { panel === 'add' && <AddTodoPanel goalKey={goal.key} /> }
            { panel === 'label' && <LabelPanel goal={goal} exit={() => setPanel('')} refresh={refresh}/> }
            { panel === 'tag' && <TagPanel goal={goal} exit={() => setPanel('')} refresh={refresh}/> }
            { panel === 'info' && <InfoPanel /> }
          </div>
        )}
      </div>
    </div>
  );
};

export default GoalActionBar;