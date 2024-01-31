import React, { useState } from 'react';
import useStore from './store';

interface ToggleButtonProps {
  includeNullState?: boolean;
  currentValue?: { timestamp: number; value: boolean }[];
  onChange?: (value: boolean) => void;
}

type ButtonState = 'null' | 'true' | 'false';

const ToggleButton: React.FC<ToggleButtonProps> = ({ currentValue = [], includeNullState = true, onChange }) => {
  const initialButtonState = currentValue.length === 0 ? 'null' : currentValue[currentValue.length - 1].value ? 'true' : 'false';
  const [state, setState] = useState<ButtonState>(initialButtonState);

  const handleClick = (event: { currentTarget: any; clientX: number; }) => {
    const button = event.currentTarget;
    const { left, width } = button.getBoundingClientRect();
    const isLeftSideClick = event.clientX < left + width / 2;

    let nextState = state;
    if (includeNullState && state === 'null') {
      nextState = isLeftSideClick ? 'false' : 'true';
    } else if (!includeNullState || state !== 'null') {
      nextState = isLeftSideClick ? 'false' : 'true';
    }

    setState(nextState);
    onChange?.(nextState === 'true');
  };

  const circlePosition = state === 'null' ? 'left-1/2 transform -translate-x-1/2' :
                        state === 'true' ? 'right-1' :
                        'left-1';

  const backgroundColor = state === 'null' ? 'bg-gray-500' :
                        state === 'true' ? 'bg-green-500' :
                        'bg-red-500';

  return (
    <div 
      className={`m-1 w-8 flex-shrink-0 h-5 bg-gray-200 rounded-full relative cursor-pointer flex items-center justify-center ${backgroundColor}`} 
      onClick={handleClick}
    >
      <div className={`w-4 h-4 rounded-full absolute bg-gray-100 ${circlePosition}`}></div>
    </div>
  );
};

export default ToggleButton;