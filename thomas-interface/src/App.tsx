import React, { useState } from 'react';
import { BrowserRouter as Router, Route, Link, Routes, useParams } from 'react-router-dom';
import Pools from './components/Pools';
import PoolPage from './components/PoolPage';
import GoalPage from './components/GoalPage';
import api from './api';

// Extend the Window interface to add the 'api' property
declare global {
  interface Window {
    api: any; // Replace 'any' with the actual type of 'api' if possible
  }
}

window.api = api;

function PoolPageWrapper() {
  let { host, name } = useParams();
  return <PoolPage host={host} name={name} />;
}

function GoalPageWrapper() {
  let { host, name, goalKey } = useParams();
  return <GoalPage host={host} name={name} goalKey={goalKey} />;
}

function App() {
  return (
    <Router>
      <div>
        {/* Route configuration */}
        <Routes>
          <Route path="/" element={<Pools />} />
          <Route path="/pools" element={<Pools />} />
          <Route path="/pool/:host/:name" element={<PoolPageWrapper />} />
          <Route path="/goal/:host/:name/:goalKey" element={<GoalPageWrapper />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
