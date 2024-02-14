import React, { useState, useEffect, FormEvent, useRef } from 'react';
import { MyEvent } from './types';
import moment from 'moment';

const MyModal = ({
    isOpen,
    onClose,
    event,
    onSave,
    modalType
}: {
    isOpen: boolean;
    onClose: () => void;
    event: MyEvent | null;
    onSave: (args: { title: string, start: Date, end: Date }) => void;
    modalType: string;
}) => {
  const [title, setTitle] = useState('');
  const [start, setStart] = useState('');
  const [end, setEnd] = useState('');

  useEffect(() => {
    if (modalType === 'edit' && event) {
      setTitle(event.title);
      setStart(moment.utc(event.start).local().format('YYYY-MM-DDTHH:mm'));
      setEnd(moment.utc(event.end).local().format('YYYY-MM-DDTHH:mm'));
    } else {
      resetForm();
    }
  }, [event, modalType, isOpen]);

  const resetForm = () => {
    setTitle('');
    setStart('');
    setEnd('');
  };

  const handleSubmit = (e: FormEvent) => { // Use FormEvent type for event parameter
    e.preventDefault();
    if (!start || !end) return; // Basic validation
    onSave({
      title,
      start: new Date(start),
      end: new Date(end),
    });
  };

  const modalRef = useRef<HTMLDivElement>(null); // Ref for the modal content

  const handleBackdropClick = (event: { target: any; }) => {
    // Assuming your modal content has a ref called modalRef
    if (modalRef.current && !modalRef.current.contains(event.target)) {
      onClose(); // Close the modal if the click is outside
    }
  };

  if (!isOpen) return null;
  return (
    <div className="fixed inset-0 bg-gray-600 bg-opacity-50 flex justify-center items-center z-50" onClick={handleBackdropClick}>
      <div className="bg-white p-5 rounded-lg" onClick={(e) => e.stopPropagation()}>
        <h2>{modalType === 'edit' ? 'Edit Event' : 'Add Event'}</h2>
        <form onSubmit={handleSubmit}>
          <input
            className="block w-full p-2 border border-gray-300 rounded mb-2"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="Event Title"
            required
          />
          <input
            className="block w-full p-2 border border-gray-300 rounded mb-2"
            type="datetime-local"
            value={start}
            onChange={(e) => setStart(e.target.value)}
            required
          />
          <input
            className="block w-full p-2 border border-gray-300 rounded mb-2"
            type="datetime-local"
            value={end}
            onChange={(e) => setEnd(e.target.value)}
            required
          />
          <button className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-700" type="submit">Save</button>
          <button className="px-4 py-2 ml-2 bg-gray-500 text-white rounded hover:bg-gray-700" onClick={onClose}>Cancel</button>
        </form>
      </div>
    </div>
  );
};

export default MyModal;