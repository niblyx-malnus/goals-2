import { useNavigate } from 'react-router-dom';

const useCustomNavigation = () => {
  const navigate = useNavigate();

  const navigateToPeriod = (periodType: string, dateKey: string) => {
    navigate(`/periods/${periodType}/${dateKey}`);
  };

  const navigateToLabel = (pid: string, label: string) => {
    navigate(`/label${pid}/${label}`);
  };

  const navigateToTag = (tag: string) => {
    navigate(`/tag/${tag}`);
  };

  const navigateToGoal = (key: string) => {
    navigate(`/goal${key}`);
  };

  const navigateToPool = (pid: string) => {
    navigate(`/pool${pid}`);
  };

  const navigateToPools = () => {
    navigate(`/pools`);
  };
  
  return {
    navigateToPeriod,
    navigateToLabel,
    navigateToTag,
    navigateToGoal,
    navigateToPool,
    navigateToPools,
  };
};

export default useCustomNavigation;