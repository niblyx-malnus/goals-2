import React, { useState, useEffect } from 'react';
import api from '../api';
import { Goal } from '../types';
import { FaSitemap, FaTimes } from 'react-icons/fa';

interface FieldFilter {
  field: string;
  value: string;
  includeInherited: boolean; // New flag to indicate whether to include inherited fields
}

function IncludeInherited({
  includeInherited,
  setIncludeInherited,
}: {
  includeInherited: boolean;
  setIncludeInherited: (include: boolean) => void;
}) {
  const toggleOperation = () => {
    setIncludeInherited(!includeInherited);
  };

  const buttonStyle = includeInherited
    ? "bg-green-400 hover:bg-green-500 text-white" // Vibrant green when on
    : "bg-gray-400 hover:bg-gray-500 text-white"; // Faded gray when off

  return (
    <div className="flex items-center rounded">
      <button
        className={`p-2 rounded ${buttonStyle}`}
        onClick={toggleOperation}
      >
        <FaSitemap />
      </button>
    </div>
  );
}

function OperationToggle({
  tagsOperation,
  setTagsOperation,
}: {
  tagsOperation: 'some' | 'every',
  setTagsOperation: (operation: 'some' | 'every') => void,
}) {
  const toggleOperation = () => {
    setTagsOperation(tagsOperation === 'some' ? 'every' : 'some');
  };

  return (
    <div className="flex items-center rounded bg-blue-400">
      <button
        className={`p-1 rounded ${tagsOperation === 'every' ? 'bg-blue-500 text-white' : 'bg-transparent'}`}
        onClick={toggleOperation}
      >
        ∩
      </button>
      <button
        className={`p-1 rounded ${tagsOperation === 'some' ? 'bg-blue-500 text-white' : 'bg-transparent'}`}
        onClick={toggleOperation}
      >
        ∪
      </button>
    </div>
  );
}

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

function FieldFilterRow({
  existingFields,
  fieldFilters,
  setFieldFilters,
}: {
  existingFields: { name: string; attributeType: any }[];
  fieldFilters: FieldFilter[];
  setFieldFilters: (filters: FieldFilter[]) => void;
}) {
  const [newField, setNewField] = useState('');

  const handleAddFilter = () => {
    if (newField && !fieldFilters.some(filter => filter.field === newField)) {
      const fieldObj = existingFields.find(field => field.name === newField);
      const defaultValue = fieldObj && fieldObj.attributeType && fieldObj.attributeType.options && fieldObj.attributeType.options.length > 0 
                           ? fieldObj.attributeType.options[0] 
                           : '';
      setFieldFilters([...fieldFilters, { field: newField, value: defaultValue, includeInherited: true }]);
      setNewField('');
    }
  };

  const toggleIncludeInherited = (index: number) => {
    const updatedFilters = [...fieldFilters];
    updatedFilters[index].includeInherited = !updatedFilters[index].includeInherited;
    setFieldFilters(updatedFilters);
  };

  const handleOptionChange = (index: number, fieldOrValue: 'field' | 'value', newValue: string) => {
    const updatedFilters = [...fieldFilters];
    if (fieldOrValue === 'field') {
      updatedFilters[index].field = newValue;
      // Automatically set the first option as the value when the field changes
      const fieldOptions = existingFields.find(field => field.name === newValue)?.attributeType.options[0] || '';
      updatedFilters[index].value = fieldOptions;
    } else {
      updatedFilters[index].value = newValue;
    }
    setFieldFilters(updatedFilters);
  };

  const handleRemoveFilter = (index: number) => {
    setFieldFilters(fieldFilters.filter((_, filterIndex) => index !== filterIndex));
  };

  return (
    <div>
      <div className="mt-2 flex justify-center space-x-2">
        <select
          className="p-1 border rounded"
          value={newField}
          onChange={(e) => setNewField(e.target.value)}
        >
          <option value="">Choose a field...</option>
          {existingFields.map((field, index) => (
            <option key={index} value={field.name}>{field.name}</option>
          ))}
        </select>
        <button
          onClick={handleAddFilter}
          className="bg-blue-600 hover:bg-blue-700 text-white py-1 px-2 rounded"
        >
          Add Field Filter
        </button>
      </div>
      {fieldFilters.map((filter, index) => (
        <div key={index} className="flex items-center mt-2 space-x-2">
          <div className="mx-1">
            <IncludeInherited
              includeInherited={filter.includeInherited}
              setIncludeInherited={() => toggleIncludeInherited(index)}
            />
          </div>
          <select
            value={filter.field}
            onChange={(e) => handleOptionChange(index, 'field', e.target.value)}
            className="p-1 w-28 border rounded"
          >
            <option value="">Choose a field...</option>
            {existingFields.map((field, fieldIndex) => (
              <option key={fieldIndex} value={field.name}>
                {field.name}
              </option>
            ))}
          </select>
          <span>Equals: </span>
          <select
            value={filter.value}
            onChange={(e) => handleOptionChange(index, 'value', e.target.value)}
            className="w-28 p-1 border rounded"
          >
            <option value="">Choose an option...</option>
            {existingFields.find(field => field.name === filter.field)?.attributeType.options.map((option: string, optionIndex: number) => (
              <option key={optionIndex} value={option}>
                {option}
              </option>
            ))}
          </select>
          <button onClick={() => handleRemoveFilter(index)} className="bg-red-500 hover:bg-red-700 text-white p-1 rounded">
            <FaTimes />
          </button>
        </div>
      ))}
    </div>
  );
}

export function GoalFilter({
  goals,
  setFiltered,
}: {
  goals: Goal[],
  setFiltered: (filtered: Goal[]) => void,
}) {
  const [uniqueTags, setUniqueTags] = useState<string[]>([]);
  const [tags, setTags] = useState<string[]>([]);
  const [mergeMethod, setMergeMethod] = useState<'some' | 'every'>('every');
  const [tagsOperation, setTagsOperation] = useState<'some' | 'every'>('every');
  const [includeInherited, setIncludeInherited] = useState(true);
  const [tagOrLabel, setTagOrLabel] = useState<'both' | 'tag' | 'label'>('both');
  const [existingFields, setExistingFields] = useState<{ name: string; attributeType: any }[]>([]);
  const [fieldFilters, setFieldFilters] = useState<FieldFilter[]>([]);

  useEffect(() => {
    const fetchFields = async () => {
      try {
        const fetchFields = await api.getAllFields();
        console.log("fields");
        console.log(fetchFields);
        const fields = Object.keys(fetchFields).map(name => ({
          name,
          attributeType: fetchFields[name].attributeType,
        }));
        setExistingFields(fields);
      } catch (error) {
        console.error("Error fetching fields: ", error);
      }
    };

    fetchFields();
  }, []);

  useEffect(() => {
    // Filter based on tags/labels
    const filteredByTags = filterGoalsByTags(tagOrLabel, goals, tags, tagsOperation, includeInherited);
    // Filter based on fields with respect to the mergeMethod
    const filteredByFields = filterGoalsByFields(goals, fieldFilters, mergeMethod);
    let finalFilteredGoals;
    if (mergeMethod === 'every') {
      // Intersection: Combine by finding common goals in both filtered sets
      finalFilteredGoals = filteredByTags.filter(tagFilteredGoal => filteredByFields.includes(tagFilteredGoal));
    } else {
      // Union: Combine both sets of filtered goals without duplication
      const combinedSet = new Set([...filteredByTags, ...filteredByFields]);
      finalFilteredGoals = Array.from(combinedSet);
    }
    setFiltered(finalFilteredGoals);
  }, [goals, includeInherited, tagsOperation, setFiltered, tagOrLabel, tags, fieldFilters, mergeMethod]);

  useEffect(() => {
    const uniqueTags = getUniqueTags(goals, includeInherited, tagOrLabel);
    setUniqueTags(uniqueTags);
  }, [goals, includeInherited, tagOrLabel]);

  const addFilterTag = async (tag: string) => {
    const cleanTag = tag.trim().toLowerCase();
    if (!tags.includes(cleanTag)) {
      setTags([...tags, cleanTag ]);
    }
  }

  return (
    <div className="flex flex-col items-center h-auto">
      <div className="">
        <OperationToggle
          tagsOperation={mergeMethod}
          setTagsOperation={setMergeMethod}
        />
      </div>
      <div className="relative group w-full mb-1">
        <div className="p-2 flex flex-row justify-center items-center">
        </div>
        <div className="flex flex-row justify-center items-center">
          <select
            className="p-1 border rounded mx-1"
            value={tagOrLabel}
            onChange={(e) => setTagOrLabel(e.target.value as 'both' | 'tag' | 'label')}
          >
            <option value="both">Tags/Labels</option>
            <option value="label">Labels</option>
            <option value="tag">Tags (Private)</option>
          </select>
          <div className="mx-1">
            <OperationToggle
              tagsOperation={tagsOperation}
              setTagsOperation={setTagsOperation}
            />
          </div>
          <div className="mx-1">
            <IncludeInherited
              includeInherited={includeInherited}
              setIncludeInherited={setIncludeInherited}
            />
          </div>
          <div className="mx-1">
            <TagSearchBar
              // uniqueTags
              tags={uniqueTags}
              onTagSelected={addFilterTag}
            />
          </div>
        </div>
      </div>
      <FieldFilterRow
        existingFields={existingFields}
        fieldFilters={fieldFilters}
        setFieldFilters={setFieldFilters}
      />
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

export const filterGoalsByFields = (
  goals: Goal[],
  fieldFilters: FieldFilter[],
  mergeMethod: 'some' | 'every'
): Goal[] => {
  return goals.filter(goal => {
    const filterResults = fieldFilters.map(filter => {
      // Check both direct and inherited fields if includeInherited is true
      const directValue = goal.fields[filter.field];
      const inheritedValue = goal.inheritedFields[filter.field];
      const valuesToCheck = filter.includeInherited ? [directValue, inheritedValue] : [directValue];
      
      // Return true if any of the valuesToCheck matches the filter value
      return valuesToCheck.some(value => value === filter.value);
    });

    // Determine how to apply these results based on the mergeMethod
    return mergeMethod === 'every' ? filterResults.every(Boolean) : filterResults.some(Boolean);
  });
};

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