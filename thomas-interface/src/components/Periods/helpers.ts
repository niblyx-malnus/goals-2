import { getWeekDay, getMonday, addDays, formatDate, getMonth, getQuarter, getYear } from '../dateUtils';
import { periodType } from './types';

// Utility function to check if a string is a periodType
export const isPeriodType = (value: any): value is periodType => {
  return ['day', 'week', 'month', 'quarter', 'year'].includes(value);
};

export const determinePath = (periodType: periodType, date: Date) => {
  let dateKey;
  switch (periodType) {
    case 'day':
      dateKey = formatDate(date);
      break;
    case 'week':
      dateKey = formatDate(getMonday(date));
      break;
    case 'month':
      dateKey = getMonth(date);
      break;
    case 'quarter':
      dateKey = getQuarter(date);
      break;
    case 'year':
      dateKey = getYear(date);
      break;
    default:
      throw new Error(`Unknown listType: ${periodType}`);
  }
  return `/period/${periodType}/${dateKey}.json`;
};

export const formatDateDisplay = (periodType: periodType, date: Date) => {
  switch (periodType) {
    case 'day':
      return `${getWeekDay(date)}, ${formatDate(date)}`;
    case 'week':
      return `Week of ${formatDate(getMonday(date))}`;
    case 'month':
      // Assuming getMonth returns the month and year in format "YYYY-MM"
      return `${new Date(date).toLocaleString('default', { month: 'long' })} ${date.getFullYear()}`;
    case 'quarter':
      // Assuming getQuarter returns "YYYY-QX"
      const quarter = getQuarter(date).split('-')[1];
      return `${quarter} of ${date.getFullYear()}`;
    case 'year':
      return `${getYear(date)}`;
    default:
      return '';
  }
};

export const formatNowDisplay = (periodType: periodType) => {
  switch (periodType) {
    case 'day':
      return 'Today';
    case 'week':
      return 'This Week';
    case 'month':
      return 'This Month';
    case 'quarter': 
      return 'This Quarter';
    case 'year':
      return 'This Year';
    default:
      return '';
  }
}

export const navigateDate = (currentDate: Date, periodType: periodType, direction: 'prev' | 'next') => {
  let adjustment = 1; // Default for day
  if (periodType === 'week') {
    adjustment = 7;
  } else if (periodType === 'month') {
    adjustment = direction === 'next' ? 1 : -1;
    return new Date(currentDate.setMonth(currentDate.getMonth() + adjustment));
  } else if (periodType === 'quarter') {
    adjustment = direction === 'next' ? 3 : -3;
    return new Date(currentDate.setMonth(currentDate.getMonth() + adjustment));
  } else if (periodType === 'year') {
    adjustment = direction === 'next' ? 1 : -1;
    return new Date(currentDate.setFullYear(currentDate.getFullYear() + adjustment));
  }
  // For day and week navigation
  return addDays(currentDate, direction === 'next' ? adjustment : -adjustment);
};