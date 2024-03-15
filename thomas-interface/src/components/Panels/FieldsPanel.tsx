import React, { useState, useEffect } from 'react';
import { FiX } from 'react-icons/fi';
import api from '../../api';
import { Goal } from '../../types';

const FieldsPanel: React.FC<{
  goal: Goal,
  exit: () => void,
  refresh: () => void,
}> = ({
  goal,
  exit,
  refresh,
}) => {
  const [activeTab, setActiveTab] = useState<'add' | 'edit' | 'view'>('view');
  const [selectedField, setSelectedField] = useState('');
  const [editField, setEditField] = useState<string>('');
  const [durationInSeconds, setDurationInSeconds] = useState<number>(0);
  const [editDurationInSeconds, setEditDurationInSeconds] = useState<number>(0);
  const [selectedOption, setSelectedOption] = useState('');
  const [existingFields, setExistingFields] = useState<{ name: string; attributeType: any }[]>([]);
  const [stringValue, setStringValue] = useState('');
  const [booleanValue, setBooleanValue] = useState(false); // Note: Using boolean here for simplicity
  const [labels, setLabels] = useState<string[]>([]);
  const [labelInput, setLabelInput] = useState('');
  const [editableValues, setEditableValues] = useState<{ [key: string]: any }>({});
  const [editDuration, setEditDuration] = useState({ days: 0, hours: 0, minutes: 0, seconds: 0 });
  const selectedFieldType = existingFields.find(field => field.name === selectedField)?.attributeType.type;

  useEffect(() => {
    if (editField && existingFields.find(field => field.name === editField)?.attributeType.display === 'duration') {
      const totalSeconds = editableValues[editField] || 0;
      const days = Math.floor(totalSeconds / 86400);
      const hours = Math.floor((totalSeconds % 86400) / 3600);
      const minutes = Math.floor((totalSeconds % 3600) / 60);
      const seconds = totalSeconds % 60;
      setEditDuration({ days, hours, minutes, seconds });
    }
  }, [editField, editableValues, existingFields]);

  // Update editableValues when editDuration changes
  useEffect(() => {
    const totalSeconds = editDuration.days * 86400 + editDuration.hours * 3600 + editDuration.minutes * 60 + editDuration.seconds;
    setEditableValues(prev => ({ ...prev, [editField]: totalSeconds }));
  }, [editDuration, editField]);

  // Handler for editDuration fields
  const handleEditDurationChange = (value: string, field: 'days' | 'hours' | 'minutes' | 'seconds') => {
    setEditDuration(prev => ({
      ...prev,
      [field]: Math.max(0, parseInt(value, 10))
    }));
  };

  const [days, setDays] = useState(0);
  const [hours, setHours] = useState(0);
  const [minutes, setMinutes] = useState(0);
  const [seconds, setSeconds] = useState(0);

  const setCappedDays = (days: string) => { setDays(Math.max(0, parseInt(days, 10))); }
  const setCappedHours = (hours: string) => { setHours(Math.max(0, Math.min(23, parseInt(hours, 10)))); }
  const setCappedMinutes = (minutes: string) => { setMinutes(Math.max(0, Math.min(59, parseInt(minutes, 10)))); }
  const setCappedSeconds = (seconds: string) => { setSeconds(Math.max(0, Math.min(59, parseInt(seconds, 10)))); }
  
  // Call updateDurationInSeconds in the effect hook whenever days, hours, minutes, or seconds change
  useEffect(() => {
    const totalSeconds = days * 86400 + 
                         hours * 3600 + 
                         minutes * 60 + 
                         seconds;
    setDurationInSeconds(totalSeconds);
  }, [days, hours, minutes, seconds]);

  const [editDays, setEditDays] = useState(0);
  const [editHours, setEditHours] = useState(0);
  const [editMinutes, setEditMinutes] = useState(0);
  const [editSeconds, setEditSeconds] = useState(0);

  const setCappedEditDays = (days: string) => { setEditDays(Math.max(0, parseInt(days, 10))); }
  const setCappedEditHours = (hours: string) => { setEditHours(Math.max(0, Math.min(23, parseInt(hours, 10)))); }
  const setCappedEditMinutes = (minutes: string) => { setEditMinutes(Math.max(0, Math.min(59, parseInt(minutes, 10)))); }
  const setCappedEditSeconds = (seconds: string) => { setEditSeconds(Math.max(0, Math.min(59, parseInt(seconds, 10)))); }
  
  // Call updateDurationInSeconds in the effect hook whenever days, hours, minutes, or seconds change
  useEffect(() => {
    const totalSeconds = editDays * 86400 + 
                         editHours * 3600 + 
                         editMinutes * 60 + 
                         editSeconds;
    setEditDurationInSeconds(totalSeconds);
  }, [editDays, editHours, editMinutes, editSeconds]);

  // Step 1: Effect hook to parse seconds to components when the edit field changes
  useEffect(() => {
    // Check if we are in the "edit" tab and the selected field is of type 'duration'
    if (editField && existingFields.find(field => field.name === editField)?.attributeType.display === 'duration') {
      // Directly use the value from goal.fields for the selected editField to initialize our states
      const currentFieldValue = goal.fields[editField] || 0; // Default to 0 if not found
      const days = Math.floor(currentFieldValue / 86400);
      const hours = Math.floor((currentFieldValue % 86400) / 3600);
      const minutes = Math.floor((currentFieldValue % 3600) / 60);
      const seconds = currentFieldValue % 60;
      
      // Set the states for each time component
      setEditDays(days);
      setEditHours(hours);
      setEditMinutes(minutes);
      setEditSeconds(seconds);
    }
  }, [editField, goal.fields, existingFields]);
  
  // Step 2: Effect hook to convert components back to total seconds whenever any of them changes
  useEffect(() => {
    const totalSeconds = editDays * 86400 + editHours * 3600 + editMinutes * 60 + editSeconds;
    setEditDurationInSeconds(totalSeconds);
  }, [editDays, editHours, editMinutes, editSeconds]);
  
  // Step 3: Include editDurationInSeconds in your saving logic
  const handleSaveEdits = async () => {
    try {
      const updatedValues = { ...editableValues, [editField]: editDurationInSeconds };
      // Assuming you have a method to update the field with new values
      await api.putLocalGoalField(goal.key, editField, updatedValues[editField]);
      refresh();
      setActiveTab('view'); // Optionally switch back to view mode after saving
    } catch (error) {
      console.error('Error updating goal fields: ', error);
    }
  };


  useEffect(() => {
    if (activeTab === 'edit') {
      setEditableValues(goal.fields);
    }
  }, [activeTab, goal.fields]);

  // When edit tab is activated, initialize editableValues with goal.fields
  useEffect(() => {
    if (activeTab === 'edit') {
      setEditableValues(goal.fields);
    }
  }, [activeTab, goal.fields]);

  const formatDuration = (totalSeconds: number) => {
    const days = Math.floor(totalSeconds / 86400);
    totalSeconds %= 86400;
    const hours = Math.floor(totalSeconds / 3600);
    totalSeconds %= 3600;
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
  
    return `${days}d ${hours}h ${minutes}m ${seconds}s`;
  };

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

  const handleAddExistingField = async () => {
    let value;
  
    // Check if the attributeType of the selected field is 'number' and display is 'duration'
    const attributeDetails = existingFields.find(field => field.name === selectedField)?.attributeType;
    if (attributeDetails.type === 'number' && attributeDetails.display === 'duration') {
      // For 'number' type with 'duration' display, use durationInSeconds as the value
      value = durationInSeconds;
    } else {
      // Other types use their respective state values
      switch (selectedFieldType) {
        case 'string':
          value = stringValue;
          break;
        case 'boolean':
          value = booleanValue;
          break;
        case 'labels':
          value = labels;
          break;
        default:
          value = selectedOption;
      }
    }
  
    try {
      await api.putLocalGoalField(goal.key, selectedField, value);
      refresh();
      // Reset input states after successful submission
      resetInputStates();
    } catch (error) {
      console.error('Error adding field to goal: ', error);
    }
  };
  
  // Helper function to reset input states
  const resetInputStates = () => {
    setStringValue('');
    setBooleanValue(false);
    setLabels([]);
    // Reset duration input fields as well, if necessary
    setDurationInSeconds(0);
  };

  // New function to handle the deletion of an field
  const handleDeleteField = async (field: string) => {
    try {
      await api.delLocalGoalField(goal.key, field);
      refresh(); // Refresh to reflect the deletion
    } catch (error) {
      console.error("Error deleting field: ", error);
    }
  };

  const handleFieldSelectionChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setSelectedField(e.target.value);
    setSelectedOption(''); // Reset option when changing field
  };

  const capitalizeFirstLetter = (string: string) => string.charAt(0).toUpperCase() + string.slice(1);

  // Add a label if it's unique
  const addLabel = (label: string) => {
    const trimmedLabel = label.trim();
    if (trimmedLabel && !labels.includes(trimmedLabel)) {
      setLabels([...labels, trimmedLabel]);
    }
  };
  
  // Remove a label
  const removeLabel = (index: number) => {
    setLabels(labels.filter((_, i) => i !== index));
  };
  
  // Handle label input key down event
  const handleLabelKeyDown = (e: { key: string; preventDefault: () => void; }) => {
    if (e.key === 'Enter') {
      addLabel(labelInput);
      setLabelInput(''); // Clear the input after adding
      e.preventDefault(); // Prevent default form submit behavior
    }
  };

  // Formats the labels array into a readable string
  const formatLabels = (labels: string[]) => {
    return labels.join(', '); // Joins all labels with a comma and a space
  };
  
  // Converts boolean value to a readable string
  const formatBoolean = (booleanValue: boolean) => {
    return booleanValue ? 'True' : 'False'; // Converts boolean to "True" or "False"
  };

  // Handlers for edit form
  const handleEditFormChange = (e: React.ChangeEvent<HTMLSelectElement | HTMLInputElement>, type: string) => {
    const value = type === 'boolean' ? e.target.value === 'true' : e.target.value;
    setEditableValues(prev => ({ ...prev, [editField]: value }));
  };

  const handleFieldSelectChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setEditField(e.target.value);
  };

  return (
    <div className="flex flex-col p-4 bg-white shadow-md rounded-lg">
      <div className="flex mb-4">
        <button
          className={`flex-1 py-2 rounded-tl-lg ${activeTab === 'add' ? 'bg-blue-500 text-white' : 'bg-gray-200 text-black'}`}
          onClick={() => setActiveTab('add')}
        >
          Add
        </button>
        <button
          className={`flex-1 py-2 ${activeTab === 'edit' ? 'bg-blue-500 text-white' : 'bg-gray-200 text-black'}`}
          onClick={() => setActiveTab('edit')}
        >
          Edit
        </button>
        <button
          className={`flex-1 py-2 rounded-tr-lg ${activeTab === 'view' ? 'bg-blue-500 text-white' : 'bg-gray-200 text-black'}`}
          onClick={() => setActiveTab('view')}
        >
          View
        </button>
      </div>
      {activeTab === 'add' && (
        <div>
          <select
            className="p-2 border rounded mb-2 w-full"
            value={selectedField}
            onChange={handleFieldSelectionChange}
          >
            <option value="" className="text-gray-400 font-italic">Select Attribute</option>
            {existingFields.map((field, index) => (
              <option key={index} value={field.name}>{field.name}</option>
            ))}
          </select>
          {selectedFieldType && <div className="mb-2"><strong>Type:</strong> {selectedFieldType.charAt(0).toUpperCase() + selectedFieldType.slice(1)}</div>}
          {selectedFieldType === 'number' && (
            <div className="mb-2">
              <strong>Display:</strong> {capitalizeFirstLetter(existingFields.find(field => field.name === selectedField)?.attributeType.display)}
            </div>
          )}

          {selectedFieldType === 'number' && existingFields.find(field => field.name === selectedField)?.attributeType.display === 'duration' && (
            <div className="flex justify-around text-center mb-2" style={{ maxWidth: '100%' }}>
              <div className="flex flex-col items-center" style={{ flex: '1 1 0' }}>
                <label htmlFor="days" className="font-bold">DD</label>
                <input
                  id="days"
                  type="number"
                  value={days}
                  className="py-2 px-1 border rounded"
                  onChange={(e) => setCappedDays(e.target.value)}
                  placeholder="0"
                  style={{ width: '100%' }}
                />
              </div>
              <div className="flex flex-col items-center mx-1" style={{ flex: '1 1 0' }}>
                <label htmlFor="hours" className="font-bold">HH</label>
                <input
                  id="hours"
                  type="number"
                  value={hours}
                  className="py-2 px-1 border rounded"
                  onChange={(e) => setCappedHours(e.target.value)}
                  placeholder="0"
                  style={{ width: '100%' }}
                />
              </div>
              <div className="flex flex-col items-center mx-1" style={{ flex: '1 1 0' }}>
                <label htmlFor="minutes" className="font-bold">MM</label>
                <input
                  id="minutes"
                  type="number"
                  value={minutes}
                  className="py-2 px-1 border rounded"
                  onChange={(e) => setCappedMinutes(e.target.value)}
                  placeholder="0"
                  style={{ width: '100%' }}
                />
              </div>
              <div className="flex flex-col items-center mx-1" style={{ flex: '1 1 0' }}>
                <label htmlFor="seconds" className="font-bold">SS</label>
                <input
                  id="seconds"
                  type="number"
                  value={seconds}
                  className="py-2 px-1 border rounded"
                  onChange={(e) => setCappedSeconds(e.target.value)}
                  placeholder="0"
                  style={{ width: '100%' }}
                />
              </div>
            </div>
          )}

          {selectedField && (
            existingFields.find(field => field.name === selectedField)?.attributeType.type === 'categorical' && (
              <select
                className="p-2 border rounded mb-4 w-full"
                value={selectedOption}
                onChange={(e) => setSelectedOption(e.target.value)}
                disabled={!selectedField}
              >
                <option value="" className="text-gray-400">Select Option</option>
                {existingFields
                  .find((field) => field.name === selectedField)?.attributeType.options.map((option: string, index: number) => (
                    <option key={index} value={option} className="text-gray-700">
                      {option}
                    </option>
                  ))}
              </select>
            )
          )}

          {/* String input */}
          {selectedFieldType === 'string' && (
            <input
              type="text"
              value={stringValue}
              onChange={(e) => setStringValue(e.target.value)}
              className="p-2 border rounded mb-2 w-full"
              placeholder="Enter string value"
            />
          )}
          
          {/* Boolean input */}
          {selectedFieldType === 'boolean' && (
            <select
              value={String(booleanValue)}
              onChange={(e) => setBooleanValue(e.target.value === 'true')}
              className="p-2 border rounded mb-2 w-full"
            >
              <option value="true">True</option>
              <option value="false">False</option>
            </select>
          )}
          
          {/* Labels input */}
          {
            selectedFieldType === 'labels' && (
              <>
                <input
                  type="text"
                  value={labelInput}
                  onChange={(e) => setLabelInput(e.target.value)}
                  className="p-2 border rounded mb-2 w-full"
                  placeholder="Enter label"
                  onKeyDown={handleLabelKeyDown}
                />
                <div className="flex flex-wrap mb-2">
                  {labels.map((label, index) => (
                    <span key={index} className="bg-blue-100 rounded-full px-2 py-1 text-sm font-semibold text-blue-700 mr-2 mb-2">
                      {label}
                      <button onClick={() => removeLabel(index)} className="ml-2 text-red-500 hover:text-red-700">
                        <FiX />
                      </button>
                    </span>
                  ))}
                </div>
              </>
            )
          }
          <button
            onClick={handleAddExistingField}
            className="w-full py-2 px-4 rounded font-bold bg-blue-500 hover:bg-blue-700 text-white"
            disabled={!selectedField || !(selectedOption || existingFields.find(field => field.name === selectedField)?.attributeType.type !== 'categorical')}
          >
            Add Attribute
          </button>
        </div>
      )}
      {activeTab === 'edit' && (
        <div>
          <select
            className="mb-2 p-2 border rounded w-full"
            value={editField}
            onChange={handleFieldSelectChange}
          >
            <option value="" className="text-gray-400 font-italic">Select Attribute</option>
            {Object.keys(goal.fields).map((field, index) => (
              <option key={index} value={field}>{field}</option>
            ))}
          </select>
      
          {/* Directly integrated edit interface */}
          {editField && existingFields.find(field => field.name === editField) && (
            <>
              {existingFields.find(field => field.name === editField)?.attributeType.type === 'string' && (
                <input
                  type="text"
                  value={editableValues[editField] || ''}
                  onChange={(e) => handleEditFormChange(e, 'string')}
                  className="p-2 border rounded mb-2 w-full"
                  placeholder="Enter value"
                />
              )}
      
              {existingFields.find(field => field.name === editField)?.attributeType.type === 'boolean' && (
                <select
                  className="p-2 border rounded mb-2 w-full"
                  value={String(editableValues[editField])}
                  onChange={(e) => handleEditFormChange(e, 'boolean')}
                >
                  <option value="true">True</option>
                  <option value="false">False</option>
                </select>
              )}
      
              {existingFields.find(field => field.name === editField)?.attributeType.type === 'categorical' && (
                <select
                  className="p-2 border rounded mb-2 w-full"
                  value={editableValues[editField]}
                  onChange={(e) => handleEditFormChange(e, 'categorical')}
                >
                  {existingFields.find(field => field.name === editField)?.attributeType.options.map((option: string, index: number) => (
                    <option key={index} value={option}>{option}</option>
                  ))}
                </select>
              )}

              {existingFields.find(field => field.name === editField)?.attributeType.type === 'labels' && (
                <>
                  <div className="flex flex-wrap mb-2">
                    {(editableValues[editField] || []).map((label: string, index: number) => (
                      <span key={index} className="bg-blue-100 rounded-full px-2 py-1 text-sm font-semibold text-blue-700 mr-2 mb-2">
                        {label}
                        <button 
                          onClick={() => {
                            const updatedLabels = [...(editableValues[editField] || [])];
                            updatedLabels.splice(index, 1);
                            setEditableValues(prev => ({ ...prev, [editField]: updatedLabels }));
                          }} 
                          className="ml-2 text-red-500 hover:text-red-700">
                          <FiX />
                        </button>
                      </span>
                    ))}
                  </div>
                  <input
                    type="text"
                    value={labelInput}
                    onChange={(e) => setLabelInput(e.target.value)}
                    onKeyDown={(e) => {
                      if (e.key === 'Enter' && labelInput) {
                        const updatedLabels = [...(editableValues[editField] || []), labelInput];
                        setEditableValues(prev => ({ ...prev, [editField]: updatedLabels }));
                        setLabelInput('');
                        e.preventDefault();
                      }
                    }}
                    className="p-2 border rounded mb-4 w-full"
                    placeholder="Add label and press enter"
                  />
                </>
              )}

              {existingFields.find(field => field.name === editField)?.attributeType.display === 'duration' && (
                <div className="flex justify-around text-center mb-2" style={{ maxWidth: '100%' }}>
                  <div className="flex flex-col items-center" style={{ flex: '1 1 0' }}>
                    <label htmlFor="days" className="font-bold">DD</label>
                    <input
                      id="days"
                      type="number"
                      value={editDays}
                      className="py-2 px-1 border rounded"
                      onChange={(e) => setCappedEditDays(e.target.value)}
                      placeholder="0"
                      style={{ width: '100%' }}
                    />
                  </div>
                  <div className="flex flex-col items-center mx-1" style={{ flex: '1 1 0' }}>
                    <label htmlFor="hours" className="font-bold">HH</label>
                    <input
                      id="hours"
                      type="number"
                      value={editHours}
                      className="py-2 px-1 border rounded"
                      onChange={(e) => setCappedEditHours(e.target.value)}
                      placeholder="0"
                      style={{ width: '100%' }}
                    />
                  </div>
                  <div className="flex flex-col items-center mx-1" style={{ flex: '1 1 0' }}>
                    <label htmlFor="minutes" className="font-bold">MM</label>
                    <input
                      id="minutes"
                      type="number"
                      value={editMinutes}
                      className="py-2 px-1 border rounded"
                      onChange={(e) => setCappedEditMinutes(e.target.value)}
                      placeholder="0"
                      style={{ width: '100%' }}
                    />
                  </div>
                  <div className="flex flex-col items-center mx-1" style={{ flex: '1 1 0' }}>
                    <label htmlFor="seconds" className="font-bold">SS</label>
                    <input
                      id="seconds"
                      type="number"
                      value={editSeconds}
                      className="py-2 px-1 border rounded"
                      onChange={(e) => setCappedEditSeconds(e.target.value)}
                      placeholder="0"
                      style={{ width: '100%' }}
                    />
                  </div>
                </div>
              )}

            </>
          )}
      
          <div>
            <button
              onClick={handleSaveEdits}
              className="w-full py-2 px-4 rounded font-bold bg-blue-500 hover:bg-blue-700 text-white"
            >
              Save Changes
            </button>
          </div>
        </div>
      )}
      {activeTab === 'view' && (
        <div>
          {Object.keys(goal.fields).length > 0 ? (
            <ul>
              {Object.entries(goal.fields).map(([name, value], index) => {
                const fieldDetails = existingFields.find(field => field.name === name);
                const fieldType = fieldDetails?.attributeType.type;
                const attributeDisplay = fieldDetails?.attributeType.display;
                
                let displayValue = value;
                
                if (fieldType === 'boolean') {
                  displayValue = formatBoolean(value);
                } else if (fieldType === 'labels') {
                  displayValue = formatLabels(value);
                } else if (fieldType === 'number' && attributeDisplay === 'duration') {
                  displayValue = formatDuration(Number(value));
                } // Assume formatLabels function handles 'labels' and other types don't need special formatting
    
                return (
                  <li key={index} className="flex justify-between items-center mb-1 p-2 border-b">
                    <span className="font-semibold">
                      {name}: {displayValue}
                    </span>
                    <button onClick={() => handleDeleteField(name)} className="ml-2 text-red-500 hover:text-red-700">
                      <FiX />
                    </button>
                  </li>
                );
              })}
            </ul>
          ) : (
            <p className="text-gray-600">No attributes set for this goal.</p>
          )}
        </div>
      )}
    </div>
  );
};

export default FieldsPanel;