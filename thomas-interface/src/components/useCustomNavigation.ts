import { useNavigate } from 'react-router-dom';

const useCustomNavigation = () => {
  const navigate = useNavigate();

  const navigateToPeriod = (destination: string, periodType: string, dateKey: string) => {
    navigate(`/${destination}/periods/${periodType}/${dateKey}`);
  };

  const navigateToLabel = ( destination: string, pid: string, label: string) => {
    navigate(`/${destination}/label${pid}/${label}`);
  };

  const navigateToTag = (destination: string, tag: string) => {
    navigate(`/${destination}/tag/${tag}`);
  };

  const navigateToGoal = (destination: string, key: string) => {
    navigate(`/${destination}/goal${key}`);
  };

  const navigateToArchive = (destination: string, pid: string, rid: string, gid: string) => {
    navigate(`/${destination}/archive${pid}${rid}${gid}`);
  };

  const navigateToPool = (destination: string, pid: string) => {
    navigate(`/${destination}/pool${pid}`);
  };

  const navigateToPools = (destination: string) => {
    navigate(`/${destination}/pools`);
  };
  
  return {
    navigateToPeriod,
    navigateToLabel,
    navigateToTag,
    navigateToGoal,
    navigateToArchive,
    navigateToPool,
    navigateToPools,
  };
};

export default useCustomNavigation;