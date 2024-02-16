
import { FiCheckSquare, FiSquare, FiTag, FiLock, FiTriangle, FiCircle, FiPause, FiPlay } from 'react-icons/fi';

export const CompleteIcon = ({ complete }: { complete: boolean }) => {
  return complete ? <FiCheckSquare /> : <FiSquare />;
};

export const TagIcon = () => {
  return (
    <div>
      <FiTag />
      <span className="p-1 absolute bottom-[-2px] right-[-2px] rounded-full text-xs">
        <FiLock />
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
