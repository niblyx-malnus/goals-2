import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import { FiEye, FiEyeOff } from 'react-icons/fi';

function TagSearchBar({ poolId }: { poolId: string | null }) {
  const [allTags, setAllTags] = useState<string[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [filteredTags, setFilteredTags] = useState<string[]>([]);
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const [tagIsPublic, setTagIsPublic] = useState(false);
  
  const navigate = useNavigate();

  useEffect(() => {
    const fetchTags = async () => {
      try {
        if (poolId !== null) {
          const fetchedTags = await api.getPoolLabels(poolId);
          setAllTags(fetchedTags);
          setFilteredTags(fetchedTags); // Initialize with all tags
        }
      } catch (error) {
        console.error("Error fetching tags: ", error);
      }
    };
    fetchTags();
  }, [poolId, dropdownOpen]);

  useEffect(() => {
    const filtered = allTags.filter(tag => tag.toLowerCase().includes(searchTerm.toLowerCase()));
    setFilteredTags(filtered);
  }, [searchTerm, allTags]);

  const navigateToTagPage = (tag: string) => {
    setDropdownOpen(false);
    navigate(`/pool-tag${poolId}/${tag}`);
  };

  const handleInputFocus = async () => {
    setDropdownOpen(true);
  };

  const handleInputBlur = () => {
    setTimeout(() => {
      setDropdownOpen(false);
    }, 100);
  };

  return (
  <div className="flex items-center tag-search-dropdown relative">
    <button
      onClick={() => setTagIsPublic(!tagIsPublic)}
      className="p-2 mr-2 border border-gray-300 bg-gray-200 rounded hover:bg-gray-200 flex items-center justify-center"
      style={{ height: '2rem', width: '2rem' }} // Adjust the size as needed
    >
      {tagIsPublic ? <FiEye /> : <FiEyeOff />}
    </button>
    <input
      type="text"
      placeholder="Search Pool Tags"
      value={searchTerm}
      onChange={(e) => setSearchTerm(e.target.value)}
      onFocus={handleInputFocus}
      onBlur={handleInputBlur}
      className="p-2 border box-border rounded text-sm"
      style={{ width: '200px', height: '2rem' }}
    />
    {dropdownOpen && (
      <div className="tag-list absolute top-full right-0 bg-gray-100 border rounded mt-1 w-48 max-h-60 overflow-auto">
        {filteredTags.map((tag, index) => (
          <div
            key={index}
            className="tag-item flex items-center p-1 hover:bg-gray-200 cursor-pointer"
            onClick={() => navigateToTagPage(tag)}
            style={{ lineHeight: '1.5rem' }}
          >
            {tag}
          </div>
        ))}
      </div>
    )}
  </div>
  );
}

export default TagSearchBar;
