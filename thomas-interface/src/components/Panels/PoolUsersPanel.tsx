import React, { useEffect, useState } from 'react';
import { FiX } from 'react-icons/fi';
import api from '../../api';

interface PoolUsersPanelProps {
  pid: string;
  exit: () => void;
}

// Assuming the structure of permissions is something like:
// { "memberName": "role", ... }
interface Permissions {
  [key: string]: string;
}

const PoolUsersPanel: React.FC<PoolUsersPanelProps> = ({ pid, exit }) => {
  const poolHost = pid.split('/')[1];
  const [permissions, setPermissions] = useState<Permissions>({});
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchPermissions = async () => {
      setIsLoading(true);
      try {
        // Replace `api.getPoolPerms` with the actual API call to fetch permissions
        const perms = await api.getPoolPerms(pid);
        setPermissions(perms);
      } catch (error) {
        console.error("Error fetching pool permissions:", error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchPermissions();
  }, [pid]);

  return (
    <div className="z-10 fixed inset-0 bg-black bg-opacity-30 backdrop-blur-sm flex justify-center items-center p-4">
      <div className="bg-white shadow rounded-lg w-full max-w-md mx-auto overflow-hidden">
        <div className="flex justify-between items-center border-b p-4">
          <h2 className="text-lg font-semibold">Pool Membership and Permissions</h2>
          <button onClick={exit} className="text-gray-400 hover:text-gray-600">
            <FiX />
          </button>
        </div>
        <div className="p-4">
          <div className="mb-4">
            <h3 className="text-md font-semibold mb-2">Pool Host</h3>
            <div className="p-2 bg-blue-100 text-blue-500 rounded">
              {poolHost}
            </div>
          </div>
          <div className="mb-4">
            <h3 className="text-md font-semibold mb-2">Pool Members</h3>
            <div className="max-h-60 overflow-y-auto">
              {isLoading ? (
                <div>Loading permissions...</div>
              ) : (
                Object.entries(permissions).map(([member, role], index) => (
                  <div key={index} className="p-2 bg-gray-100 text-gray-700 rounded mb-2">
                    {member}: {role}
                  </div>
                ))
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default PoolUsersPanel;
