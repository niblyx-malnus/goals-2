import React, { useEffect, useState } from 'react';
import { FiX, FiTrash2, FiPlus, FiMinus, FiEdit, FiArrowUp, FiArrowDown } from 'react-icons/fi';
import api from '../../api'; // Adjust the import path as necessary

interface AttributeModalProps {
  isOpen: boolean;
  toggleModal: () => void;
}

const AttributeModal: React.FC<AttributeModalProps> = ({ isOpen, toggleModal }) => {
  const [existingAttributes, setExistingAtributes] = useState<{ name: string; attributeType: any }[]>([]);
  const [newAttributeName, setNewAttributeName] = useState('');
  const [attributeType, setAttributeType] = useState<'categorical' | 'number' | 'labels' | 'string' | 'boolean'>('categorical');
  const [newAttributeOptions, setNewAttributeOptions] = useState<string[]>(['']); // For categorical
  const [display, setDisplay] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const [isEditing, setIsEditing] = useState(false);
  const [editingField, setEditingField] = useState<{ name: string; attributeType: any } | null>(null);
  const [editingOptions, setEditingOptions] = useState<string[]>([]);
  const [refresh, setRefresh] = useState(false);

  const [sortField, setSortField] = useState<string>('name'); // 'name' or 'type'
  const [sortOrder, setSortOrder] = useState<string>('asc'); // 'asc' or 'desc'


  useEffect(() => {
    const fetchFields = async () => {
      if (isOpen) {
        setIsLoading(true);
        try {
          const fetchedFields = await api.getAllFields();
          const fieldsArray = Object.keys(fetchedFields).map(name => ({
            name,
            attributeType: fetchedFields[name].attributeType,
          }));
          setExistingAtributes(fieldsArray);
        } catch (error) {
          console.error("Error fetching existingAttributes: ", error);
        } finally {
          setIsLoading(false);
        }
      }
    };

    fetchFields();
  }, [isOpen, refresh]);

  const handleDeleteField = async (fieldName: string) => {
    try {
      await api.delLocalField(fieldName);
      const updatedFields = existingAttributes.filter(field => field.name !== fieldName);
      setExistingAtributes(updatedFields);
    } catch (error) {
      console.error("Error deleting field: ", error);
    }
  };

  const handleAddNewAttributeOption = () => {
    setNewAttributeOptions([...newAttributeOptions, '']);
  };

  const handleNewAttributeOptionChange = (value: string, index: number) => {
    const updatedOptions = [...newAttributeOptions];
    updatedOptions[index] = value;
    setNewAttributeOptions(updatedOptions);
  };

  const handleSaveNewAttribute = async () => {
    let attributePayload;
  
    if (attributeType === 'categorical') {
      const filteredOptions = newAttributeOptions.filter(option => option.trim() !== '');
      if (filteredOptions.length === 0) {
        alert("Please add at least one option for a categorical attribute.");
        return;
      }
      attributePayload = {
        type: 'categorical',
        version: 0,
        options: filteredOptions,
      };
    } else if (attributeType === 'number') {
      attributePayload = {
        type: 'number',
        version: 0,
        display: display.trim(),
      };
    } else if (attributeType === 'labels') {
      attributePayload = {
        type: 'labels',
        version: 0,
      };
    } else if (attributeType === 'string') {
      attributePayload = {
        type: 'string',
        version: 0,
      };
    } else if (attributeType === 'boolean') {
      attributePayload = {
        type: 'boolean',
        version: 0,
      };
    }
  
    try {
      if (newAttributeName.trim()) {
        await api.putLocalFieldProperty(newAttributeName, 'attributeType', attributePayload);
        // After successful API call, reset states and refresh existingAttributes list
        setNewAttributeName('');
        setAttributeType('categorical');
        setNewAttributeOptions(['']);
        setDisplay('');
        setRefresh(!refresh); // Trigger refresh
      } else {
        alert("Please provide an attribute name.");
      }
    } catch (error) {
      console.error("Error saving new attribute: ", error);
    }
  };

  const handleRemoveNewAttributeOption = (index: number) => {
    if (newAttributeOptions.length > 1) { // Ensure at least one option remains
      const updatedOptions = newAttributeOptions.filter((_, optionIndex) => optionIndex !== index);
      setNewAttributeOptions(updatedOptions);
    }
  };

  const handleEditField = (fieldName: string) => {
    const field = existingAttributes.find(field => field.name === fieldName);
    if (field) {
      setEditingField(field);
      // Check if the attribute type is categorical and set editingOptions accordingly
      if (field.attributeType.type === 'categorical') {
        setEditingOptions(field.attributeType.options || []);
      } else {
        // For number types, ensure editingOptions does not cause errors
        setEditingOptions([]); // Or consider not using editingOptions at all for number types
      }
      setAttributeType(field.attributeType.type);
      if (field.attributeType.type === 'number' && field.attributeType.display) {
        setDisplay(field.attributeType.display); // Set the display value for number attributes
      } else {
        setDisplay(''); // Reset display value for safety
      }
      setIsEditing(true);
    }
  };

  // Save edited field
  const handleSaveEditedField = async () => {
    if (editingField) {
      try {
        const attributeType = {
          type: 'categorical',
          version: 0,
          options: editingOptions.filter(option => option.trim() !== ''),
        }
        await api.putLocalFieldProperty(editingField.name, 'attributeType', attributeType);
        // Optionally, refresh existingAttributes here
        setIsEditing(false);
        setEditingField(null);
        setEditingOptions([]);
        setRefresh(!refresh);
      } catch (error) {
        console.error("Error saving edited field: ", error);
      }
    }
  };

  // Cancel editing
  const handleCancelEditing = () => {
    setIsEditing(false);
    setEditingField(null);
    setEditingOptions([]);
  };

  const capitalizeFirstLetter = (string: string) => {
    return string.charAt(0).toUpperCase() + string.slice(1);
  };

  if (isEditing && editingField) {
    return (
      <div className="fixed inset-0 z-40 bg-black bg-opacity-50 flex justify-center items-center px-4">
        <div className="bg-gray-300 p-5 rounded-lg shadow-xl w-full max-w-lg mx-auto my-4">
          <button onClick={() => { toggleModal(); handleCancelEditing(); }} className="absolute top-0 right-0 mt-2 mr-2 text-gray-600 hover:text-gray-800">
            <FiX size={24} />
          </button>
          <h2 className="text-lg font-semibold mb-4">Edit Attribute: {editingField.name}</h2>
  
          {/* Display the attribute type directly */}
          <div className="mb-4">
            <strong>Type:</strong> {editingField.attributeType.type.charAt(0).toUpperCase() + editingField.attributeType.type.slice(1)}
          </div>
  
          {/* Conditional rendering based on the attribute type */}
          {editingField.attributeType.type === 'categorical' && editingOptions.map((option, index) => (
            <div key={index} className="flex mb-2 items-center">
              <input 
                type="text" 
                value={option}
                className="border p-1 rounded flex-grow bg-gray-100"
                onChange={(e) => {
                  let updatedOptions = [...editingOptions];
                  updatedOptions[index] = e.target.value;
                  setEditingOptions(updatedOptions);
                }}
              />
              {index === editingOptions.length - 1 && (
                <button 
                  onClick={() => setEditingOptions([...editingOptions, ''])}
                  className="ml-2 text-green-500 hover:text-green-700"
                >
                  <FiPlus />
                </button>
              )}
              {editingOptions.length > 1 && (
                <button 
                  onClick={() => {
                    let updatedOptions = editingOptions.filter((_, optionIndex) => optionIndex !== index);
                    setEditingOptions(updatedOptions);
                  }} 
                  className="ml-2 text-red-500 hover:text-red-700"
                >
                  <FiMinus />
                </button>
              )}
            </div>
          ))}
  
          {editingField.attributeType.type === 'number' && (
            <select 
              value={display} 
              onChange={(e) => setDisplay(e.target.value)}
              className="border p-2 mb-4 rounded w-full"
            >
              <option>Select Display Type</option>
              <option value="duration">Duration</option>
            </select>
          )}
  
          <div className="mt-4 flex justify-around">
            <button 
              onClick={handleSaveEditedField}
              className="py-2 px-4 rounded bg-blue-500 text-white hover:bg-blue-700"
            >
              Save
            </button>
            <button 
              onClick={handleCancelEditing}
              className="py-2 px-4 rounded bg-gray-500 text-white hover:bg-gray-700"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    );
  }

  if (!isOpen) return null;

  // Sorting function
  const sortAttributes = (a: { name: string, attributeType: any }, b: { name: string, attributeType: any }) => {
    if (sortField === 'name') {
      return sortOrder === 'asc' ? a.name.localeCompare(b.name) : b.name.localeCompare(a.name);
    } else {
      return sortOrder === 'asc' ? a.attributeType.type.localeCompare(b.attributeType.type) : b.attributeType.type.localeCompare(a.attributeType.type);
    }
  };

  // Handler to update sort state
  const handleSortChange = (field: 'name' | 'type') => {
    if (sortField === field) {
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    } else {
      setSortField(field);
      setSortOrder('asc');
    }
  };

  const sortedAttributes = [...existingAttributes].sort(sortAttributes);

  const getSortIcon = (field: 'name' | 'type') => {
    if (sortField !== field) return null; // No icon if not the current sort field
    return sortOrder === 'asc' ? <FiArrowDown /> : <FiArrowUp />;
  };

  return (
    <div className="fixed inset-0 z-40 bg-black bg-opacity-50 flex justify-center items-center p-2">
      <div className="bg-gray-200 p-5 rounded-lg shadow-xl relative max-w-lg mx-auto my-4 w-auto">
        <button onClick={toggleModal} className="absolute top-0 right-0 mt-2 mr-2 text-gray-600 hover:text-gray-800">
          <FiX size={24} />
        </button>
        <h2 className="text-lg font-semibold mb-4">Private Attributes</h2>
        <div className="mb-4">
          <div className="mb-2 flex items-center">
            <input 
              type="text" 
              placeholder="New Attribute Name" 
              value={newAttributeName}
              onChange={(e) => setNewAttributeName(e.target.value)}
              className="border-2 mx-1 p-1 rounded w-full"
            />
            <select
              value={attributeType}
              onChange={(e) => setAttributeType(e.target.value as 'categorical' | 'number')}
              className="border mx-1 p-2 rounded"
            >
              <option value="string">String</option>
              <option value="number">Number</option>
              <option value="boolean">Boolean</option>
              <option value="categorical">Categorical</option>
              <option value="labels">Labels</option>
            </select>
          </div>
          {attributeType === "categorical" && newAttributeOptions.map((option, index) => (
            <div key={index} className="flex mb-2 items-center">
              <input 
                type="text" 
                placeholder={`Option ${index + 1}`} 
                value={option}
                onChange={(e) => handleNewAttributeOptionChange(e.target.value, index)}
                className="border p-1 rounded flex-grow bg-gray-100"
                onKeyDown={(e) => {
                  if (e.key === 'Enter') {
                    e.preventDefault(); // Prevents the default action of the enter key
                    handleAddNewAttributeOption(); // Call the function that handles the submission of the new option
                  }
                }}
              />
              {index === newAttributeOptions.length - 1 && ( // Show add button next to the last option input
                <button 
                  onClick={handleAddNewAttributeOption}
                  className="ml-2 text-green-500 hover:text-green-700"
                >
                  <FiPlus />
                </button>
              )}
              {newAttributeOptions.length > 1 && ( // Only show delete button if more than one option exists
                <button 
                  onClick={() => handleRemoveNewAttributeOption(index)}
                  className="ml-2 text-red-500 hover:text-red-700"
                >
                  <FiMinus />
                </button>
              )}
            </div>
          ))}
          {attributeType === 'number' && (
            <select 
              value={display} 
              onChange={(e) => setDisplay(e.target.value)}
              className="border p-2 mb-4 rounded w-full"
            >
              <option value="">Select Display Type</option>
              <option value="duration">Duration</option>
            </select>
          )}
          <div className="flex justify-center">
            <button 
              onClick={handleSaveNewAttribute}
              className="py-2 px-4 rounded bg-blue-500 text-white hover:bg-blue-700 disabled:bg-gray-500 disabled:cursor-not-allowed"
              disabled={!newAttributeName.trim() || 
                (attributeType === 'categorical' && !newAttributeOptions.some(option => option.trim())) ||
                (attributeType === 'number' && !display.trim())}
            >
              Add Attribute
            </button>
          </div>
        </div>
        {isLoading ? (
          <div className="flex justify-center">
            <div className="animate-spin rounded-full h-16 w-16 border-b-8 border-t-transparent border-blue-500"></div>
          </div>
        ) : (
          <div className="relative rounded-lg bg-white">
            <div className="">
              {/* Column Headers */}
              <div className="sticky top-0 z-10 bg-gray-300 rounded-t-lg">
                <div className="p-2 grid grid-cols-4 gap-4 items-center text-center my-3 font-bold">
                  <div
                    onClick={() => handleSortChange('name')}
                    className="cursor-pointer flex justify-center items-center mx-1"
                  >
                    Name <span className="ml-2">{getSortIcon('name')}</span>
                  </div>
                  <div
                    className="col-span-2 cursor-pointer flex justify-center items-center mx-1"
                    onClick={() => handleSortChange('type')}
                  >
                    Attribute Type <span className="ml-2">{getSortIcon('type')}</span>
                  </div>
                  {/* Fourth column intentionally left without a header */}
                </div>
              </div>
              {/* Existing Attributes Rows */}
              <div className="max-h-96 overflow-x-hidden">
                {sortedAttributes.length > 0 ? (
                  sortedAttributes.map((attribute, index) => (
                    <div key={index} className="grid grid-cols-[1.5fr_1fr_1.5fr_12px] gap-4 items-center p-3 border-b">
                      {/* Attribute Name */}
                      <div className="truncate">
                        <span className="">{attribute.name}</span>
                      </div>

                      <div className="flex items-center justify-between">
                        <span className="font-medium text-gray-700">{attribute.attributeType.type.charAt(0).toUpperCase() + attribute.attributeType.type.slice(1)}</span>
                      </div>

                      <div className="flex items-center justify-between">
                        {attribute.attributeType.type === 'categorical' && (
                          <select className="w-full border-gray-300 rounded shadow-sm">
                            <option>Options</option>
                            {attribute.attributeType.options.map((option: string, optionIndex: number) => (
                              <option key={optionIndex} value={option}>{option}</option>
                            ))}
                          </select>
                        )}
                        {attribute.attributeType.type === 'number' && (
                          <span className="text-gray-600">Display: <span className="">{attribute.attributeType.display ? capitalizeFirstLetter(attribute.attributeType.display) : 'N/A'}</span></span>
                        )}
                      </div>
              
                      {/* Edit and Trash Buttons */}
                      <div className="text-right">
                        {attribute.attributeType.type !== 'labels' && attribute.attributeType.type !== 'string' && attribute.attributeType.type !== 'boolean' ? (
                          <button
                            onClick={() => handleEditField(attribute.name)}
                            className="inline-flex items-center justify-center text-blue-500 hover:text-blue-700 mr-2"
                          >
                            <FiEdit />
                          </button>
                        ) : (
                          // Render a disabled edit button for 'labels', 'string', and 'boolean' types for visual consistency
                          <button
                            disabled
                            className="inline-flex items-center justify-center text-gray-500 cursor-not-allowed mr-2"
                          >
                            <FiEdit />
                          </button>
                        )}
                        <button
                          onClick={() => handleDeleteField(attribute.name)}
                          className="inline-flex items-center justify-center text-red-500 hover:text-red-700"
                        >
                          <FiTrash2 />
                        </button>
                      </div>
                    </div>
                  ))
                ) : (
                  <p className="p-2">No attributes to display.</p>
                )}
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default AttributeModal;

