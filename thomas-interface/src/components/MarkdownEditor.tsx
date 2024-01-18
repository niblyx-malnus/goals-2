import React, { useState, useEffect, ChangeEvent } from 'react';
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

//  List View, Harvest View, Markdown

  const handleTextChange = (e: ChangeEvent<HTMLTextAreaElement>): void => {
    setTempText(e.target.value);
  };

  return (
    <div className="p-2 border rounded bg-white">
      {isEditing ? (
        <div>
          <div className="flex justify-center mt-2 mb-4">
            <button className="mr-2 bg-teal-100 pl-4 pr-4 p-2 rounded" onClick={handleSave}>
              Save
            </button>
            <button className="bg-red-100 pl-4 pr-4 p-2 rounded" onClick={handleCancel}>
              Cancel
            </button>
          </div>
          <textarea
            className="border w-full p-1 rounded"
            rows={10}
            cols={50}
            value={tempText}
            onChange={handleTextChange}
          />
        </div>
      ) : (
        <div>
          <div className="flex justify-center">
            <button className="bg-gray-300 p-2 pl-4 pr-4 rounded mt-2" onClick={handleEdit}>
              Edit
            </button>
          </div>
          {markdownText && (
            <div className="p-6">
              <ReactMarkdown children={markdownText} />
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default MarkdownEditor;
