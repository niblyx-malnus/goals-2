import React, { useState, useEffect } from 'react';
import { Goal } from '../../types';
import api from '../../api';
import useCustomNavigation from '../useCustomNavigation';

const InfoPanel: React.FC<{
  goal: Goal,
}> = ({
  goal,
}) => {
  const [lineage, setLineage] = useState<Goal[]>([]);
  const [progress, setProgress] = useState({ complete: 0, total: 0 });
  const [lineageLoading, setLineageLoading] = useState(true);
  const [progressLoading, setProgressLoading] = useState(true);
  const [currentIndex, setCurrentIndex] = useState(0);

  const { navigateToGoal } = useCustomNavigation();

  useEffect(() => {
    const fetchLineage = async () => {
      try {
        setLineageLoading(true);
        const fetchedLineage = await api.goalLineage(goal.key);
        setLineage(fetchedLineage);
        setLineageLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchLineage();
  }, [goal]);

  useEffect(() => {
    const fetchProgress = async () => {
      try {
        setProgressLoading(true);
        const fetchedProgress = await api.goalProgress(goal.key);
        setProgress(fetchedProgress);
        setProgressLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchProgress();
  }, [goal]);

  const handleNext = () => {
    if (currentIndex > 0) {
      setCurrentIndex(currentIndex - 1);
    }
  };

  const handlePrevious = () => {
    if (currentIndex < lineage.length - 1) {
      setCurrentIndex(currentIndex + 1);
    }
  };

  // Calculate progress percentage
  const progressPercentage = progress.total > 0 ? Math.round((progress.complete / progress.total) * 100) : 0;

  return (
    <div className="p-4 bg-white shadow rounded-lg">
      <div className="mb-4">
        <div className="text-md font-semibold text-center mb-2">
          Progress
        </div>
        {progressLoading ? (
          <div className="flex justify-center items-center">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
          </div>
        ) : (
          <div>
            <div className="text-sm text-gray-700 text-center mb-1">
              {progress.complete} / {progress.total}
            </div>
            <div className="bg-gray-200 rounded-full h-2.5 dark:bg-gray-700">
              <div className="bg-blue-600 h-2.5 rounded-full" style={{ width: `${progressPercentage}%` }}></div>
            </div>
          </div>
        )}
      </div>
      <div className="mb-4">
        <div className="text-md font-semibold text-center mb-2">
          Lineage
        </div>
        {lineageLoading ? (
          <div className="flex justify-center items-center">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
          </div>
        ) : lineage.length === 0 ? (
          <div className="text-sm text-center text-gray-500">
              Goal has no parent.
          </div>
        ) : (
          <div className="flex items-center justify-center">
            <span className="px-2 text-gray-400">
              {currentIndex < lineage.length - 1 ? (
                <button className="text-blue-500 hover:text-blue-700" onClick={handlePrevious}>
                  {'<'}
                </button>
              ) : '|'}
            </span>
            <button
              className="px-4 py-2 truncate bg-blue-100 text-blue-500 rounded hover:bg-blue-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
              onClick={() => navigateToGoal(api.destination, lineage[currentIndex].key)}
            >
              {lineage[currentIndex].summary}
            </button>
            <span className="px-2 text-gray-400">
              {currentIndex > 0 ? (
                <button className="text-blue-500 hover:text-blue-700" onClick={handleNext}>
                  {'>'}
                </button>
              ) : '|'}
            </span>
          </div>
        )}
      </div>
    </div>
  );
};

export default InfoPanel;
