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
  
  return {
    navigateToPeriod,
    navigateToLabel,
    navigateToTag,
  };
};

export default useCustomNavigation;