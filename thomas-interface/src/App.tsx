import { BrowserRouter as Router, Route, Routes, useParams, Link, Navigate } from 'react-router-dom';
import Pools from './components/Pools';
import PoolPage from './components/PoolPage';
import GoalPage from './components/GoalPage';
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
import { getCurrentDayDateKey } from './components/Periods/utils';
import { periodType } from './types';

function BackToHome() {
  return (
    <div className="mb-4">
      <Link to="/" className="inline-block bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded transition duration-150 ease-in-out">
        ← Back to Home
      </Link>
    </div>
  );
}

function Home() {
  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <h2 className="text-2xl font-semibold mb-4">Modules</h2>
      <ul className="list-none m-0 p-0">
        <li className="mb-2"><Link to="/pools" className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">Pools</Link></li>
        <li className="mb-2"><Link to="/jsons" className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">FileSystem</Link></li>
        <li className="mb-2"><Link to="/mileage" className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">Mileage</Link></li>
        <li className="mb-2"><Link to="/states" className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">State List</Link></li>
        <li className="mb-2"><Link to="/weekly_targets" className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">Weekly Targets</Link></li>
        <li className="mb-2"><Link to="/calendar" className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">Calendar</Link></li>
        <li className="mb-2"><Link to="/periods" className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">Todo List</Link></li>
        <li className="mb-2"><Link to="/draggable" className="inline-block bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out">Draggable List</Link></li>
      </ul>
    </div>
  );
}

function PoolPageWrapper() {
  let { host, name } = useParams();
  return (
    <div>
      <BackToHome />
      <PoolPage host={host} name={name} />
    </div>
  );
}

function GoalPageWrapper() {
  let { host, name, goalId } = useParams();
  return (
    <div>
      <BackToHome />
      <GoalPage host={host} name={name} goalId={goalId} />
    </div>
  );
}

function LabelPageWrapper() {
  let { host, name, tag } = useParams();
  return (
    <div>
      <BackToHome />
      <LabelPage host={host} name={name} tag={tag} />
    </div>
  );
}

function TagPageWrapper() {
  let { tag } = useParams();
  return (
    <div>
      <BackToHome />
      <TagPage tag={tag} />
    </div>
  );
}

function WeeklyTargetPageWrapper() {
  let { id } = useParams();
  return (
    <div>
      <BackToHome />
      <WeeklyTargetPage id={id as string} />
    </div>
  );
}

function TodoListWrapper() {
  let { periodType, dateKey } = useParams();
  return (
    <div>
      <BackToHome />
      <TodoList periodType={periodType as periodType} dateKey={dateKey as string} />
    </div>
  );
}

function App() {
  return (
    <Router basename="/apps/goals">
      <div>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/pools" element={<div><BackToHome /><Pools /></div>} />
          <Route path="/pool/:host/:name" element={<PoolPageWrapper />} />
          <Route path="/goal/:host/:name/:goalId" element={<GoalPageWrapper />} />
          <Route path="/label/:host/:name/:tag" element={<LabelPageWrapper />} />
          <Route path="/tag/:tag" element={<TagPageWrapper />} />
          <Route path="/jsons" element={<div><BackToHome /><FileSystem /></div>} />
          <Route path="/mileage" element={<div><BackToHome /><Mileage /></div>} />
          <Route path="/states" element={<div><BackToHome /><StateList /></div>} />
          <Route path="/weekly_targets" element={<div><BackToHome /><WeeklyTargetList /></div>} />
          <Route path="/weekly_targets/:id" element={<WeeklyTargetPageWrapper />} />
          <Route path="/calendar" element={<div><BackToHome /><CalendarApp /></div>} />
          <Route path="/periods" element={<Navigate to={`/periods/day/${getCurrentDayDateKey()}`} />} />
          <Route path="/periods/:periodType/:dateKey" element={<TodoListWrapper />} />
          <Route path="/draggable" element={<div><BackToHome /><ListComponent /></div>} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
