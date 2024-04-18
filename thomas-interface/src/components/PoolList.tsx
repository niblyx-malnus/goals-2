import React, { useState, useEffect } from 'react';
import PoolRow from './PoolRow';
import { Pool } from '../types';
import api from '../api';
import _ from 'lodash';

function PoolList({
  destination,
  pools,
  refresh,
  isLoading,
} : {
  destination: string,
  pools: Pool[];
  refresh: () => void;
  isLoading: boolean;
}) {

  return (
    <div>
      {pools.length > 0 && (
        <ul>
          {pools.map((pool, index) => (
            <div
              key={pool.pid}
              className="block text-current no-underline hover:no-underline"
            >
              <PoolRow destination={destination} pool={pool} refresh={refresh} movePoolUp={() => console.log()} movePoolDown={() => console.log()}/>
            </div>
          ))}
        </ul>
      )}
      {isLoading && (
        <div className="flex justify-center m-20">
          <div className="animate-spin rounded-full h-16 w-16 border-b-8 border-t-transparent border-blue-500"></div>
        </div>
      )}
      {pools.length == 0 && !isLoading && (
        <div className="text-center m-5 text-lg text-gray-600">No pools found.</div>
      )}
    </div>
  );
}

export default PoolList;