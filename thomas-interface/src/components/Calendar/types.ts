import { Event as CalendarEvent } from 'react-big-calendar';

export interface MyEvent extends CalendarEvent {
  id: number;
  title: string;
  start: Date;
  end: Date;
}