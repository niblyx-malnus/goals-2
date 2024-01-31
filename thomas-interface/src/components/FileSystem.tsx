import React, { useState, useEffect } from 'react';
import FileModal from './FileModal';
import { FiTrash } from 'react-icons/fi';
import api from '../api';

// Interfaces
interface FileSystemNode {
  name: string;
  type: 'file' | 'folder';
  path: string;
  children: { [key: string]: FileSystemNode };
}

interface FileSystemComponentProps {
  fileStructure: { [key: string]: FileSystemNode };
  setFileStructure: React.Dispatch<React.SetStateAction<{ [key: string]: FileSystemNode }>>;
}

interface FolderComponentProps {
  folder: FileSystemNode;
  onNavigate: (path: string) => void;
}

interface FileComponentProps {
  file: FileSystemNode;
}

// Functions
const buildTree = (paths: string[]): { [key: string]: FileSystemNode } => {
  const root: { [key: string]: FileSystemNode } = {};

  paths.forEach((path) => {
    const parts = path.split('/').slice(1); // Remove the leading empty part from splitting
    let current: { [key: string]: FileSystemNode } = root;

    parts.forEach((part, index) => {
      if (!current[part]) {
        current[part] = {
          name: part,
          type: index === parts.length - 1 ? 'file' : 'folder',
          path: '/' + parts.slice(0, index + 1).join('/'),
          children: {}
        };
      }
      current = current[part].children;
    });
  });

  return root;
};

// Components
const FileSystemComponent: React.FC<FileSystemComponentProps> = ({ fileStructure, setFileStructure }) => {
  const [currentPath, setCurrentPath] = useState('/');

  useEffect(() => {
    const pathParts = currentPath.split('/').filter(Boolean);
    let node = fileStructure;
    for (const part of pathParts) {
      if (!node[part]) {
        setCurrentPath('/');
        return;
      }
      node = node[part].children;
    }
  }, [currentPath, fileStructure]);

  const navigateTo = (path: string) => {
    setCurrentPath(path);
  };

  const handleDeleteFile = async (path: string) => {
    try {
      await api.jsonDel(path); // Actually delete the file
      const updatedPaths = await api.jsonTree('/'); // Fetch the updated paths
      setFileStructure(buildTree(updatedPaths)); // Rebuild the file structure
    } catch (error) {
      console.error('Error deleting file:', error);
    }
  };

  const renderTree = (node: { [key: string]: FileSystemNode }) => {
    let items = Object.values(node).map((item) => {
      return item.type === 'folder' ? (
        <FolderComponent key={item.path} folder={item} onNavigate={navigateTo} />
      ) : (
        <FileComponent key={item.path} file={item} onDelete={handleDeleteFile}/>
      );
    });

    // Conditionally add special entries for root and parent if not at root
    if (currentPath !== '/') {
      items = [
        <FolderComponent 
          key="root" 
          folder={{ name: '/', path: '/', type: 'folder', children: {} }} 
          onNavigate={navigateTo}
        />,
        <FolderComponent 
          key="parent" 
          folder={{ name: '..', path: currentPath.split('/').slice(0, -1).join('/') || '/', type: 'folder', children: {} }} 
          onNavigate={navigateTo}
        />,
        ...items
      ];
    }

    return items;
  };

  const currentFolder = currentPath.split('/').reduce((acc, cur) => {
    return (cur && acc[cur]) ? acc[cur].children : acc;
  }, fileStructure);

  return (
    <div className="container mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">File Explorer</h1>
      <div className="bg-gray-100 p-3 rounded-lg">
        <div className="font-medium">Current Path: {currentPath}</div>
        <div className="mt-2">{renderTree(currentFolder)}</div>
      </div>
    </div>
  );
};

const FolderComponent: React.FC<FolderComponentProps> = ({ folder, onNavigate }) => {
  return (
    <div 
      onClick={() => onNavigate(folder.path)}
      className="cursor-pointer p-2 hover:bg-blue-100 rounded-lg flex items-center"
    >
      <span className="text-blue-600 mr-2">📁</span>
      <span>{folder.name}</span>
    </div>
  );
};

const FileComponent: React.FC<FileComponentProps & { onDelete: (path: string) => void }> = ({ file, onDelete }) => {
  const [fileContent, setFileContent] = useState(null);
  const [showModal, setShowModal] = useState(false);

  const handleFileClick = async () => {
    try {
      const content = await api.jsonRead(file.path);
      setFileContent(content);
      setShowModal(true);
    } catch (error) {
      console.error('Error reading file:', error);
    }
  };

  const handleDelete = async () => {
    try {
      await api.jsonDel(file.path);
      onDelete(file.path);
    } catch (error) {
      console.error('Error deleting file:', error);
    }
  };

  const handleCloseModal = () => {
    setShowModal(false);
  };

  return (
    <div className="flex items-center justify-between p-2 hover:bg-green-100 rounded-lg">
      <div onClick={handleFileClick} className="flex items-center cursor-pointer">
        <span className="text-green-600 mr-2">📄</span>
        <span>{file.name}</span>
      </div>
      <button onClick={handleDelete} className="ml-2 text-gray-500 hover:text-gray-700">
        <FiTrash />
      </button>
      {showModal && <FileModal content={fileContent} onClose={handleCloseModal} />}
    </div>
  );
};


const NewFileComponent: React.FC<{ onCreate: (path: string, json: object) => void }> = ({ onCreate }) => {
  const [fileName, setFileName] = useState('');
  const [fileContent, setFileContent] = useState('');
  const [isCreating, setIsCreating] = useState(false);

  const handleCreate = () => {
    try {
      onCreate(`/${fileName}`, JSON.parse(fileContent));
      setFileName('');
      setFileContent('');
      setIsCreating(false);
    } catch (error) {
      console.error('Error creating file:', error);
    }
  };

  return (
    <div className="mb-4">
      {!isCreating && (
        <button
          onClick={() => setIsCreating(true)}
          className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
        >
          Create New File
        </button>
      )}

      {isCreating && (
        <div className="flex flex-col gap-3">
          <input
            type="text"
            placeholder="File Name"
            value={fileName}
            onChange={(e) => setFileName(e.target.value)}
            className="px-3 py-2 border border-gray-300 rounded shadow-sm"
          />
          <textarea
            placeholder="JSON Content"
            value={fileContent}
            onChange={(e) => setFileContent(e.target.value)}
            className="px-3 py-2 border border-gray-300 rounded shadow-sm h-32 resize-y"
          />
          <div className="flex gap-2">
            <button
              onClick={handleCreate}
              className="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded"
            >
              Create
            </button>
            <button
              onClick={() => setIsCreating(false)}
              className="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded"
            >
              Cancel
            </button>
          </div>
        </div>
      )}
    </div>
  );
};


const FileSystem: React.FC = () => {
  const [fileStructure, setFileStructure] = useState<{ [key: string]: FileSystemNode }>({});
  const [isLoading, setIsLoading] = useState(true); // New state to track loading status

  useEffect(() => {
    const fetchData = async () => {
      try {
        const paths = await api.jsonTree('/');
        setFileStructure(buildTree(paths));
      } catch (error) {
        console.error('Error fetching data:', error);
        // Handle the error appropriately
      } finally {
        setIsLoading(false); // Set loading to false regardless of success or failure
      }
    };

    fetchData();
  }, []);

  const handleCreateFile = async (path: string, json: object) => {
    try {
      await api.jsonPut(path, json);
      // Fetch the updated paths again
      const updatedPaths = await api.jsonTree('/');
      // Rebuild and set the file structure to reflect the new file
      setFileStructure(buildTree(updatedPaths));
    } catch (error) {
      console.error('Error creating file:', error);
    }
  };

  // Conditional rendering based on isLoading
  if (isLoading) {
    return <div>Loading...</div>; // Show loading screen while data is being fetched
  }

  return (
    <div>
      <NewFileComponent onCreate={handleCreateFile} />
      <FileSystemComponent fileStructure={fileStructure} setFileStructure={setFileStructure} />
    </div>
  );
};

export default FileSystem;