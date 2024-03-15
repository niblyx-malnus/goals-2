import { FiCheckSquare, FiSquare, FiTag, FiLock, FiTriangle, FiCircle, FiPause, FiPlay } from 'react-icons/fi';
import { FaTable } from 'react-icons/fa'; 

export const CompleteIcon = ({ complete, style }: { complete: boolean, style?: React.CSSProperties }) => {
  return complete ? <FiCheckSquare style={style} /> : <FiSquare style={style} />;
};

export const TagIcon = () => {
  return (
    <div>
      <FiTag />
      <span className="p-1 absolute bottom-[-3px] right-[-3px] rounded-full text-xs">
        <FiLock />
      </span>
    </div>
  );
};

// Create an attribute
// name
// options (list of text)

export const AttributeIcon = () => {
  return (
    <div className="inline-flex items-center justify-center relative">
      <FaTable className="text-gray-800" />
      <span className="absolute bottom-0 right-0 transform translate-x-2 translate-y-2">
        <FiLock className="text-xs" />
      </span>
    </div>
  );
};

export const ActionableIcon = (actionable: boolean) => {
  if (actionable) {
    return <FiTriangle />;
  } else {
    return <FiCircle />;
  }
};

export const ActiveIcon = (active: boolean) => {
  if (active) {
    return <FiPause />;
  } else {
    return <FiPlay />;
  }
};
