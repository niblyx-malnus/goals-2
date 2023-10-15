import React, { useState, useEffect, ChangeEvent, MouseEvent } from 'react';
import ReactMarkdown from 'react-markdown';
import 'github-markdown-css/github-markdown.css';

interface MarkdownEditorProps {
  initialMarkdown: string;
  onSave: (markdown: string) => void;
}

const MarkdownEditor: React.FC<MarkdownEditorProps> = ({ initialMarkdown, onSave }) => {
  const [isEditing, setIsEditing] = useState<boolean>(false);
  const [markdownText, setMarkdownText] = useState<string>(initialMarkdown);
  const [tempText, setTempText] = useState<string>(markdownText);

  useEffect(() => {
    setMarkdownText(initialMarkdown);
    setTempText(initialMarkdown);
  }, [initialMarkdown]);


  const handleEdit = (): void => {
    setTempText(markdownText);
    setIsEditing(true);
  };

  const handleSave = (): void => {
    setMarkdownText(tempText);
    setIsEditing(false);
    onSave(tempText);
  };

  const handleCancel = (): void => {
    setIsEditing(false);
  };

  const handleTextChange = (e: ChangeEvent<HTMLTextAreaElement>): void => {
    setTempText(e.target.value);
  };

  return (
    <div className="p-4 border rounded bg-white">
      {isEditing ? (
        <div>
          <textarea
            className="border w-full p-2 rounded"
            rows={10}
            cols={50}
            value={tempText}
            onChange={handleTextChange}
          />
          <div className="flex mt-2">
            <button className="mr-2 bg-blue-500 text-white p-2 rounded" onClick={handleSave}>
              Save
            </button>
            <button className="bg-red-500 text-white p-2 rounded" onClick={handleCancel}>
              Cancel
            </button>
          </div>
        </div>
      ) : (
        <div>
          <div className="markdown-body p-6">
            <ReactMarkdown children={markdownText} />
          </div>
          <button className="bg-green-500 text-white p-2 rounded mt-2" onClick={handleEdit}>
            Edit
          </button>
        </div>
      )}
    </div>
  );
};

export default MarkdownEditor;
