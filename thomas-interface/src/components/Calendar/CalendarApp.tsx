import React, { useState, useEffect } from 'react';
import { Calendar, momentLocalizer, SlotInfo } from 'react-big-calendar';
import moment from 'moment';
import 'moment/locale/en-gb'; // Import the locale you want to use
import withDragAndDrop from 'react-big-calendar/lib/addons/dragAndDrop';
import 'react-big-calendar/lib/css/react-big-calendar.css';
import 'react-big-calendar/lib/addons/dragAndDrop/styles.css';
import { MyEvent } from './types';
import MyModal from './MyModal';

moment.locale('en-gb');

const localizer = momentLocalizer(moment);

const DnDCalendar = withDragAndDrop(Calendar) as React.ComponentType<any>;

const MyCalendar: React.FC = () => {
  const [events, setEvents] = useState<MyEvent[]>([]);
  const [eventsForDisplay, setEventsForDisplay] = useState<MyEvent[]>([]);
  const [showModal, setShowModal] = useState(false);
  const [modalType, setModalType] = useState('');
  const [selectedEvent, setSelectedEvent] = useState<MyEvent | null>(null);

  useEffect(() => {
    setEventsForDisplay(events.map(event => ({
      ...event,
      start: moment.utc(event.start).local().toDate(),
      end: moment.utc(event.end).local().toDate(),
    })));
  }, [events]);

  const handleSelectSlot = (slotInfo: SlotInfo) => {
    setShowModal(true);
    setSelectedEvent({ id: 0, title: 'hello', start: slotInfo.start, end: slotInfo.end });
    setModalType('');
  };

  const handleSelectEvent = (event: MyEvent) => {
    setShowModal(true);
    setSelectedEvent(event);
    setModalType('edit');
  };

  const handleAddEventClick = () => {
    setShowModal(true);
    setSelectedEvent(null);
    setModalType('add');
  };

  const handleCloseModal = () => setShowModal(false);

  const handleSaveEvent = (eventDetails: { title: string; start: Date; end: Date }) => {
    // Convert local times back to UTC for storing
    const startUTC = moment(eventDetails.start).utc().format();
    const endUTC = moment(eventDetails.end).utc().format();
  
    const eventToSave = {
      ...eventDetails,
      start: new Date(startUTC),
      end: new Date(endUTC),
    };
  
    if (modalType === 'add') {
      const newId = events.length > 0 ? Math.max(...events.map(e => e.id)) + 1 : 1;
      setEvents([...events, { ...eventToSave, id: newId }]);
    } else if (modalType === 'edit' && selectedEvent) {
      setEvents(events.map(e => e.id === selectedEvent.id ? { ...eventToSave, id: selectedEvent.id } : e));
    }
  
    handleCloseModal();
  };

  const moveEvent = ({ event, start, end }: { event: MyEvent; start: Date; end: Date }) => {
    const idx = events.findIndex((evt) => evt.id === event.id);
    const updatedEvent = { ...event, start, end };
    const updatedEvents = [...events];
    updatedEvents[idx] = updatedEvent;
    setEvents(updatedEvents);
  };

  const resizeEvent = ({ event, start, end }: { event: MyEvent; start: Date; end: Date }) => {
    moveEvent({ event, start, end });
  };

  return (
    <div className="p-5">
      <button
        onClick={handleAddEventClick}
        className="mb-4 p-2 bg-blue-500 text-white rounded hover:bg-blue-700 transition duration-150 ease-in-out">
        Add Goal
      </button>
      <DnDCalendar
        localizer={localizer}
        events={eventsForDisplay}
        onEventDrop={moveEvent}
        onEventResize={resizeEvent}
        resizable
        selectable
        onSelectSlot={handleSelectSlot}
        onSelectEvent={handleSelectEvent}
        startAccessor="start"
        endAccessor="end"
        style={{ height: 500, margin: '0px' }}
      />
      <MyModal
        isOpen={showModal}
        onClose={handleCloseModal}
        onSave={handleSaveEvent}
        event={selectedEvent}
        modalType={modalType}
      />
    </div>
  );
};

export default MyCalendar;