import { BrowserRouter as Router, Route, Routes, useParams } from 'react-router-dom';
import Pools from './components/Pools';
import PoolPage from './components/PoolPage';
import GoalPage from './components/GoalPage';
import PoolTagPage from './components/PoolTagPage';
import LocalTagPage from './components/LocalTagPage';

function PoolPageWrapper() {
  let { host, name } = useParams();
  return <PoolPage host={host} name={name} />;
}

function GoalPageWrapper() {
  let { host, name, goalKey } = useParams();
  return <GoalPage host={host} name={name} goalKey={goalKey} />;
}

function PoolTagPageWrapper() {
  let { host, name, tag } = useParams();
  return <PoolTagPage host={host} name={name} tag={tag} />;
}

function LocalTagPageWrapper() {
  let { host, name, tag } = useParams();
  return <LocalTagPage tag={tag} />;
}

function App() {
  return (
    <Router basename="/apps/goals">
      <div>
        <Routes>
          <Route path="/" element={<Pools />} />
          <Route path="/pools" element={<Pools />} />
          <Route path="/pool/:host/:name" element={<PoolPageWrapper />} />
          <Route path="/goal/:host/:name/:goalKey" element={<GoalPageWrapper />} />
          <Route path="/pool-tag/:host/:name/:tag" element={<PoolTagPageWrapper />} />
          <Route path="/local-tag/:tag" element={<LocalTagPageWrapper />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
