import { useState, useEffect } from 'react';
import PoolList from './PoolList';
import GoalList from './GoalList';
import useStore from '../store';
import TagSearchBar from './TagSearchBar';
import LocalMembershipPanel from './Panels/LocalMembershipPanel';
import { Goal, Pool } from '../types';
import rawApi from '../api';
import { FiMail } from 'react-icons/fi';
import { FaListUl } from 'react-icons/fa';
import useCustomNavigation from './useCustomNavigation';

function Harvest({ destination } : { destination: string }) {
  const api = rawApi.setDestination(destination);
  const [refreshHarvest, setRefreshHarvest] = useState(false);
  const [refreshEmptyGoals, setRefreshEmptyGoals] = useState(false);
  const [harvest, setHarvest] = useState<Goal[]>([]);
  const [emptyGoals, setEmptyGoals] = useState<Goal[]>([]);
  const [harvestLoading, setHarvestLoading] = useState(true);
  const [emptyGoalsLoading, setEmptyGoalsLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<'Frontier' | 'Empty'>('Frontier');

  useEffect(() => {
    const fetchHarvest = async () => {
      try {
        setHarvestLoading(true);
        const fetchedHarvest = await api.mainHarvest();
        setHarvest(fetchedHarvest);
        setHarvestLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchHarvest();
  }, [refreshHarvest]);

  useEffect(() => {
    const fetchEmptyGoals = async () => {
      try {
        setEmptyGoalsLoading(true);
        const fetchedEmptyGoals = await api.mainEmptyGoals();
        setEmptyGoals(fetchedEmptyGoals);
        setEmptyGoalsLoading(false);
      } catch (error) {
        console.error("Error fetching goals: ", error);
      }
    };
    fetchEmptyGoals();
  }, [refreshEmptyGoals]);

  const triggerRefreshHarvest = () => {
    setRefreshHarvest(!refreshHarvest);
  };

  const triggerRefreshEmptyGoals = () => {
    setRefreshEmptyGoals(!refreshEmptyGoals);
  };

  return (
    <div>
      <div className="border-b">
        <ul className="flex justify-center -mb-px">
          <li className={`${activeTab === 'Frontier' ? 'border-blue-500' : ''}`}>
            <button 
              className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                activeTab === 'Frontier' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
              }`} 
              onClick={() => setActiveTab('Frontier')}
            >
              Frontier
            </button>
          </li>
          <li className={`${activeTab === 'Empty' ? 'border-blue-500' : ''}`}>
            <button 
              className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                activeTab === 'Empty' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
              }`} 
              onClick={() => setActiveTab('Empty')}
            >
              Empty
            </button>
          </li>
        </ul>
      </div>
      { activeTab === 'Frontier' && (
        <div>
          <div className="text-center mt-2 text-lg text-gray-600">
            The Frontier constitutes goals from this pool which can be tackled immediately.
          </div>
          <GoalList 
            goals={harvest}
            isLoading={harvestLoading}
            refresh={triggerRefreshHarvest}
          />
        </div>
      )}
      { activeTab === 'Empty' && (
        <div>
          <div className="text-center mt-2 text-lg text-gray-600">
            Non-actionable goals with no children;
            goals which require elaboration.
          </div>
          <GoalList
            goals={emptyGoals}
            isLoading={emptyGoalsLoading}
            refresh={triggerRefreshEmptyGoals}
          />
        </div>
      )}
    </div>
  );
}

function Pools({ destination } : { destination: string }) {
  const api = rawApi.setDestination(destination);
  const [newTitle, setNewTitle] = useState<string>('');
  const [refreshPools, setRefreshPools] = useState(false);
  const [activeTab, setActiveTab] = useState('Pools'); // New state for active tab
  const [allLocalTags, setAllLocalTags] = useState<string[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [pools, setPools] = useState<Pool[]>([]);
  const { navigateToPeriod, navigateToTag } = useCustomNavigation();
  const { currentPeriodType, getCurrentPeriod, setCurrentTreePage } = useStore(state => state);
  const [showLocalMembershipPanel, setShowLocalMembershipPanel] = useState(false);

  useEffect(() => {
    const fetchTags = async () => {
      try {
        const fetchedTags = await api.getAllTags();
        setAllLocalTags(fetchedTags);
      } catch (error) {
        console.error("Error fetching tags: ", error);
      }
    };
    fetchTags();
  }, []);

  useEffect(() => {
    const fetchPools = async () => {
      setIsLoading(true);
      try {
        const pools = await api.getPoolsIndex();
        console.log("pools");
        console.log(pools);
        setPools(pools);
      } catch (error) {
        console.error("Error fetching pools: ", error);
      } finally {
        setIsLoading(false);
      }
    };
    fetchPools();
  }, [refreshPools]);

  const triggerRefreshPools = () => {
    setRefreshPools(!refreshPools);
  };

  const handleAddTitle = async () => {
    if (newTitle.trim() !== '') {
      try {
        await api.createPool(newTitle);
        setRefreshPools(true);
      } catch (error) {
        console.error(error);
      }
      setNewTitle('');
    }
  };

  const toggleLocalMembershipPanel = () => setShowLocalMembershipPanel(!showLocalMembershipPanel);

  return (
    <div className="bg-gray-200 h-full flex justify-center items-center h-screen">
      <div className="bg-[#DFF7DC] p-6 rounded shadow-md w-full h-screen overflow-y-auto">
        <div className="flex justify-between items-center mb-4">
          <TagSearchBar poolId={null} />
          <button
            onClick={toggleLocalMembershipPanel}
            className="p-2 mr-2 border border-gray-300 bg-gray-100 rounded hover:bg-gray-200 flex items-center justify-center"
            style={{ height: '2rem', width: '2rem' }} // Adjust the size as needed
          >
            <FiMail />
          </button>
          {showLocalMembershipPanel && (
            <LocalMembershipPanel exit={() => setShowLocalMembershipPanel(false)} />
          )}
          <button
            onClick={
              () => {
                setCurrentTreePage(`/pools`);
                navigateToPeriod(api.destination, currentPeriodType, getCurrentPeriod());
              }
            }
            className="p-2 mr-2 border border-gray-300 bg-gray-100 rounded hover:bg-gray-200 flex items-center justify-center"
            style={{ height: '2rem', width: '2rem' }} // Adjust the size as needed
          >
            <FaListUl />
          </button>
        </div>
        <h1 className="text-2xl font-semibold text-blue-600 text-center mb-4">All Pools</h1>
        <div className="flex flex-wrap justify-center mb-4">
          {allLocalTags.map((tag, index) => (
            <div
              key={index}
              className="flex items-center bg-gray-200 rounded px-2 py-1 m-1 cursor-pointer"
              onClick={() => navigateToTag(api.destination, tag)}
            >
              {tag}
            </div>
          ))}
        </div>
        <ul className="flex justify-center -mb-px">
          <li className={`${activeTab === 'Pools' ? 'border-blue-500' : ''}`}>
            <button 
              className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                activeTab === 'Pools' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
              }`} 
              onClick={() => setActiveTab('Pools')}
            >
              Pools
            </button>
          </li>
          <li className={`${activeTab === 'Harvest' ? 'border-blue-500' : ''}`}>
            <button 
              className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
                activeTab === 'Harvest' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
              }`} 
              onClick={() => setActiveTab('Harvest')}
            >
              Harvest
            </button>
          </li>
        </ul>
        {activeTab === 'Pools' && (
          <>
            <div className="flex items-center mb-4">
              <input
                type="text"
                value={newTitle}
                onChange={(e) => setNewTitle(e.target.value)}
                onKeyDown={(e) => {
                    if (e.key === 'Enter') handleAddTitle();
                }}
                placeholder="Enter new title..."
                className="p-2 flex-grow border box-border rounded mr-2 w-full" // <-- Notice the flex-grow and w-full here
              />
              <button 
                onClick={handleAddTitle} 
                className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 focus:outline-none"
                style={{maxWidth: '100px'}} // This ensures button never grows beyond 100px.
              >
                Add
              </button>
            </div>
            <PoolList destination={destination} pools={pools} refresh={triggerRefreshPools} isLoading={isLoading}/>
          </>
        )}
        {activeTab === 'Harvest' && (
          <Harvest destination={destination}/>
        )}
      </div>
    </div>
  );
}

export default Pools;