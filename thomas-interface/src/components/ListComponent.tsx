// Import React and necessary hooks
import React, { useState, Fragment } from 'react';

interface Item {
  id: number;
  value: string;
}

const ListComponent: React.FC = () => {
  const [items, setItems] = useState<Item[]>([]);
  const [inputValue, setInputValue] = useState('');
  const [selectedIndex, setSelectedIndex] = useState<number | null>(null);

  const handleAddItem = () => {
    if (inputValue.trim() !== '') {
      const newItem = { id: Date.now(), value: inputValue };
      setItems((prevItems) => [...prevItems, newItem]);
      setInputValue('');
    }
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setInputValue(e.target.value);
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      handleAddItem();
    }
  };

  const selectItem = (index: number) => {
    setSelectedIndex(index);
  };

  const moveItem = (targetIndex: number) => {
    if (selectedIndex === null || selectedIndex === targetIndex || selectedIndex === targetIndex - 1) {
      return;
    }
    const newItems = [...items];
    const itemToMove = newItems.splice(selectedIndex, 1)[0];
    if (selectedIndex < targetIndex) {
      newItems.splice(targetIndex - 1, 0, itemToMove);
    } else {
      newItems.splice(targetIndex, 0, itemToMove);
    }
    setItems(newItems);
    setSelectedIndex(null); // Reset selection
  };

  return (
    <div className="flex flex-col items-center">
      <div className="my-4">
        <input
          type="text"
          value={inputValue}
          onChange={handleInputChange}
          onKeyDown={handleKeyDown}
          className="border-2 border-gray-200 p-2"
          placeholder="Type item and press Enter"
        />
        <button onClick={handleAddItem} className="bg-blue-500 text-white p-2 ml-2">
          Add
        </button>
      </div>
      <ul className="list-none">
        {selectedIndex !== null && (
          <li
            onClick={() => moveItem(0)}
            className="cursor-pointer h-1 bg-blue-500"
          />
        )}
        {items.map((item, index) => (
          <Fragment key={item.id}>
            {index !== 0 && selectedIndex !== null && (
              <li
                onClick={() => moveItem(index)}
                className="cursor-pointer h-1 bg-blue-500"
              />
            )}
            <li
              onClick={() => selectItem(index)}
              className={`p-2 ${selectedIndex === index ? 'outline-none border-t-2 border-b-2 border-blue-500' : 'cursor-pointer'}`}
            >
              {item.value}
            </li>
          </Fragment>
        ))}
        {items.length > 0 && selectedIndex !== null && (
          <li
            onClick={() => moveItem(items.length)}
            className="cursor-pointer h-1 bg-blue-500"
          />
        )}
      </ul>
    </div>
  );
};

export default ListComponent;
