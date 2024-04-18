import { BrowserRouter as Router, Route, Routes, useParams, Link, Navigate } from 'react-router-dom';
import Pools from './components/Pools';
import PoolPage from './components/PoolPage';
import GoalPage from './components/GoalPage';
import ArchiveGoalPage from './components/ArchiveGoalPage';
import LabelPage from './components/LabelPage';
import TagPage from './components/TagPage';
import FileSystem from './components/FileSystem/FileSystem';
import Mileage from './components/Mileage';
import StateList from './components/States/StateList';
import WeeklyTargetList from './components/WeeklyTargets/WeeklyTargetList';
import WeeklyTargetPage from './components/WeeklyTargets/WeeklyTargetPage';
import CalendarApp from './components/Calendar/CalendarApp';
import TodoList from './components/Periods/TodoList';
import ListComponent from './components/ListComponent';
import MembershipPools from './components/MembershipPools';
import { getCurrentDayDateKey } from './components/Periods/utils';
import { periodType } from './types';

const live = process.env.REACT_APP_LIVE;
const proxy = live ? (window as any).ship : "mitpub-molreb-niblyx-malnus";

function BackToHome(destination: string) {
  if (live) {
    return (<div></div>);
  } else {
    return (
      <div className="mb-4">
        <Link to={`/${destination}`} className="inline-block bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded transition duration-150 ease-in-out">
          ← Back to Home
        </Link>
      </div>
    );
  }
}

function Home(destination: string) {
  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <h2 className="text-2xl font-semibold mb-4">Modules</h2>
      <ul className="list-none m-0 p-0">
        <li className="mb-2"><Link to={`/${destination}/pools`} className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">Pools</Link></li>
        <li className="mb-2"><Link to={`/${destination}/jsons`} className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">FileSystem</Link></li>
        <li className="mb-2"><Link to={`/${destination}/mileage`} className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">Mileage</Link></li>
        <li className="mb-2"><Link to={`/${destination}/states`} className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">State List</Link></li>
        <li className="mb-2"><Link to={`/${destination}/weekly_targets`} className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">Weekly Targets</Link></li>
        <li className="mb-2"><Link to={`/${destination}/calendar`} className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">Calendar</Link></li>
        <li className="mb-2"><Link to={`/${destination}/periods`} className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">Todo List</Link></li>
        <li className="mb-2"><Link to={`/${destination}/draggable`} className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">Draggable List</Link></li>
        <li className="mb-2"><Link to={`/${destination}/memberdestination_pools`} className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">Membership Pools</Link></li>
      </ul>
    </div>
  );
}

function HomeWrapper() {
  let { destination } = useParams();
  return Home(destination as string);
}

function PoolPageWrapper() {
  let { destination, host, name } = useParams();
  return (
    <div>
      {BackToHome(destination as string)}
      <PoolPage destination={destination as string} host={host as string} name={name as string} />
    </div>
  );
}

function GoalPageWrapper() {
  let { destination, host, name, goalId } = useParams();
  return (
    <div>
      {BackToHome(destination as string)}
      <GoalPage destination={destination as string} host={host as string} name={name as string} goalId={goalId as string} />
    </div>
  );
}

function ArchiveGoalPageWrapper() {
  let { destination, host, name, rootId, goalId } = useParams();
  return (
    <div>
      {BackToHome(destination as string)}
      <ArchiveGoalPage host={host as string} name={name as string} rootId={rootId as string} goalId={goalId as string} />
    </div>
  );
}

function LabelPageWrapper() {
  let { destination, host, name, tag } = useParams();
  return (
    <div>
      {BackToHome(destination as string)}
      <LabelPage host={host} name={name} tag={tag} />
    </div>
  );
}

function TagPageWrapper() {
  let { destination, tag } = useParams();
  return (
    <div>
      {BackToHome(destination as string)}
      <TagPage tag={tag} />
    </div>
  );
}

function WeeklyTargetPageWrapper() {
  let { destination, id } = useParams();
  return (
    <div>
      {BackToHome(destination as string)}
      <WeeklyTargetPage id={id as string} />
    </div>
  );
}

function TodoListWrapper() {
  let { destination, periodType, dateKey } = useParams();
  return (
    <div>
      {BackToHome(destination as string)}
      <TodoList periodType={periodType as periodType} dateKey={dateKey as string} />
    </div>
  );
}

function PoolsWrapper() {
  let { destination } = useParams();
  return (<div>{BackToHome(destination as string)}<Pools destination={destination as string} /></div>);
}

function FileSystemWrapper() {
  let { destination } = useParams();
  return (<div>{BackToHome(destination as string)}<FileSystem /></div>);
}

function MileageWrapper() {
  let { destination } = useParams();
  return (<div>{BackToHome(destination as string)}<Mileage /></div>);
}

function StatesWrapper() {
  let { destination } = useParams();
  return (<div>{BackToHome(destination as string)}<StateList /></div>);
}

function WeeklyTargetListWrapper() {
  let { destination } = useParams();
  return (<div>{BackToHome(destination as string)}<WeeklyTargetList /></div>);
}

function CalendarAppWrapper() {
  let { destination } = useParams();
  return (<div>{BackToHome(destination as string)}<CalendarApp /></div>);
}

function ListComponentWrapper() {
  let { destination } = useParams();
  return (<div>{BackToHome(destination as string)}<ListComponent /></div>);
}

function MembershipPoolsWrapper() {
  let { destination } = useParams();
  return (<div>{BackToHome(destination as string)}<MembershipPools /></div>);
}

function App() {
  return (
    <Router basename="/apps/goals">
      <div>
        <Routes>
          <Route path="/" element={<Navigate replace to={`/${proxy}${live ? '/pools' : ''}`} />} />
          <Route path=":destination/" element={<HomeWrapper />} />
          <Route path=":destination/pools" element={<PoolsWrapper />} />
          <Route path=":destination/pool/:host/:name" element={<PoolPageWrapper />} />
          <Route path=":destination/goal/:host/:name/:goalId" element={<GoalPageWrapper />} />
          <Route path=":destination/archive/:host/:name/:rootId/:goalId" element={<ArchiveGoalPageWrapper />} />
          <Route path=":destination/label/:host/:name/:tag" element={<LabelPageWrapper />} />
          <Route path=":destination/tag/:tag" element={<TagPageWrapper />} />
          <Route path=":destination/jsons" element={<FileSystemWrapper />} />
          <Route path=":destination/mileage" element={<MileageWrapper />} />
          <Route path=":destination/states" element={<StatesWrapper />} />
          <Route path=":destination/weekly_targets" element={<WeeklyTargetListWrapper />} />
          <Route path=":destination/weekly_targets/:id" element={<WeeklyTargetPageWrapper />} />
          <Route path=":destination/calendar" element={<CalendarAppWrapper />} />
          <Route path=":destination/periods" element={<Navigate to={`/periods/day/${getCurrentDayDateKey()}`} />} />
          <Route path=":destination/periods/:periodType/:dateKey" element={<TodoListWrapper />} />
          <Route path=":destination/draggable" element={<ListComponentWrapper />} />
          <Route path=":destination/membership_pools" element={<MembershipPoolsWrapper />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
