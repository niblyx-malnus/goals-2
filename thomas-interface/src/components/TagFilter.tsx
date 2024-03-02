import React, { useState } from 'react';
import { Goal } from '../types';

function TagSearchBar({ tags, onTagSelected }: { tags: string[], onTagSelected: (tag: string) => void}) {
  const [searchTerm, setSearchTerm] = useState('');
  const [dropdownOpen, setDropdownOpen] = useState(false);

  const handleInputFocus = () => {
    setDropdownOpen(true);
  };

  const handleInputBlur = () => {
    setTimeout(() => {
      setDropdownOpen(false);
    }, 100);
  };

  return (
    <div className="flex items-center tag-search-dropdown relative">
      <input
        type="text"
        placeholder="Add tag/label filter..."
        value={searchTerm}
        onChange={(e) => setSearchTerm(e.target.value)}
        onFocus={handleInputFocus}
        onBlur={handleInputBlur}
        className="p-2 border box-border rounded text-sm"
        style={{ width: '150px', height: '2rem' }}
      />
      {dropdownOpen && tags.length > 0 && (
        <div className="tag-list absolute top-full right-0 bg-gray-100 border rounded mt-1 w-48 max-h-60 overflow-auto">
        {tags.filter(tag => tag.toLowerCase().includes(searchTerm.toLowerCase())).map((tag, index) => (
            <div
              key={index}
              className="tag-item flex items-center p-1 hover:bg-gray-200 cursor-pointer"
              onClick={() => onTagSelected(tag)}
              style={{ lineHeight: '1.5rem' }}
            >
              {tag}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export function TagFilter({
  uniqueTags,
  tags,
  setTags,
  tagOrLabel,
  setTagOrLabel,
  selectedOperation,
  setSelectedOperation,
  includeInherited,
  setIncludeInherited,
}: {
  uniqueTags: string[],
  tags: string[],
  setTags: (tags: string[]) => void,
  tagOrLabel: 'both' | 'tag' | 'label',
  setTagOrLabel: (op: 'both' | 'tag' | 'label') => void,
  selectedOperation: 'some' | 'every',
  setSelectedOperation: (op: 'some' | 'every') => void,
  includeInherited: boolean,
  setIncludeInherited: (i: boolean) => void,
}) {

  const addFilterTag = async (tag: string) => {
    const cleanTag = tag.trim().toLowerCase();
    if (!tags.includes(cleanTag)) {
      setTags([...tags, cleanTag ]);
    }
  }

  return (
    <div className="flex flex-col items-center h-auto">
      <div className="relative group w-full mb-1">
        <div className="p-2 flex flex-row justify-center items-center">
          <select
            className="p-1 border rounded ml-2"
            value={selectedOperation}
            onChange={(e) => setSelectedOperation(e.target.value as 'some' | 'every')}
          >
            <option value="every">Intersection</option>
            <option value="some">Union</option>
          </select>
          <label className="p-2 flex items-center space-x-2">
            <input 
              type="checkbox" 
              checked={includeInherited} 
              onChange={(e) => setIncludeInherited(e.target.checked)} 
              className="form-checkbox rounded"
            />
            <span>Include Inherited</span>
          </label>
        </div>
        <div className="flex flex-row justify-center items-center">
          <select
            className="p-1 border rounded mr-2"
            value={tagOrLabel}
            onChange={(e) => setTagOrLabel(e.target.value as 'both' | 'tag' | 'label')}
          >
            <option value="both">Tags/Labels</option>
            <option value="label">Labels</option>
            <option value="tag">Tags (Private)</option>
          </select>
          <TagSearchBar
            // uniqueTags
            tags={uniqueTags}
            onTagSelected={addFilterTag}
          />
        </div>
      </div>
      <div className="flex flex-wrap justify-center mb-1">
        {tags.map((tag, index) => (
          <div key={index} className="flex items-center bg-gray-200 rounded px-2 py-1 m-1">
            {tag}
            <button 
              className="ml-2"
              onClick={() => setTags(tags.filter((_, i) => i !== index))}
            >
              ×
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}

export const filterGoalsByTags = (
  tagOrLabel: 'both' | 'tag' | 'label',
  goals: Goal[],
  tags: string[],
  operation: string,
  includeInherited: boolean
): Goal[] => {
  if (tags.length === 0) return goals;

  const filteredGoals: Goal[] = [];

  goals.forEach(goal => {
    let tagSet = new Set();
    let goalTags: string[];
    let goalLabels: string[];
    if (includeInherited) {
      goalTags = [...goal.tags, ...goal.inheritedTags];
      goalLabels = [...goal.labels, ...goal.inheritedLabels];
    } else {
      goalTags = goal.tags;
      goalLabels = goal.labels;
    }
    if (tagOrLabel === 'both') {
      tagSet = new Set([...goalTags, ...goalLabels]);
    } else if (tagOrLabel === 'tag') {
      tagSet = new Set(goalTags);
    } else if (tagOrLabel === 'label') {
      tagSet = new Set(goalLabels);
    }
    const isMatch = operation === 'some' 
      ? tags.some(tag => tagSet.has(tag)) 
      : tags.every(tag => tagSet.has(tag));
    if (isMatch) {
      filteredGoals.push(goal);
    }
  });

  return filteredGoals;
};

export const getUniqueTags = (
  goals: Goal[],
  includeInherited: boolean,
  tagOrLabel: 'both' | 'tag' | 'label',
): string[] => {
  // Calculate the union of all tags
  const allTags: string[] = goals.reduce((acc: any[], goal: Goal) => {
    let goalTags: string[];
    let goalLabels: string[];
    if (includeInherited) {
      goalTags = [...goal.tags, ...goal.inheritedTags];
      goalLabels = [...goal.labels, ...goal.inheritedLabels];
    } else {
      goalTags = goal.tags;
      goalLabels = goal.labels;
    }
    if (tagOrLabel === 'both') {
      acc.push(...goalLabels, ...goalTags);
      return acc;
    } else if (tagOrLabel === 'tag') {
      acc.push(...goalTags);
      return acc;
    } else {
      acc.push(...goalLabels);
      return acc;
    }
  }, []);
  return [...new Set(allTags)];
}