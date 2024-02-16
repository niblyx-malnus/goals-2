import { DateTime } from 'luxon';
import { getMonday, getWeekDay, formatDate, getMonth, getQuarter, getYear } from '../dateUtils';
import { periodType } from '../../types';

export const getAdjacentPeriod = (periodType: string, dateKey: string, direction: string): string => {
  switch (periodType) {
    case 'day':
      const [yearD, monthD, dayD] = dateKey.split('-').map(Number);
      const dateD = new Date(Date.UTC(yearD, monthD - 1, dayD + (direction === 'prev' ? -1 : 1)));
      return formatDateKey(dateD);
    case 'week':
      const [yearW, monthW, dayW] = dateKey.split('-').map(Number);
      const dateW = new Date(Date.UTC(yearW, monthW - 1, dayW + (direction === 'prev' ? -7 : 7)));
      return formatDateKey(dateW);
    case 'month':
      const [yearM, monthM] = dateKey.split('-').map(Number);
      return adjustMonth(yearM, monthM, direction);
    case 'quarter':
      const [yearQ, quarter] = dateKey.split('-Q');
      return adjustQuarter(Number(yearQ), Number(quarter), direction);
    case 'year':
      return (Number(dateKey) + direction === 'prev' ? -1 : 1).toString();
    default:
      return "Invalid periodType";
  }
};

const adjustMonth = (year: number, month: number, direction: string): string => {
    const monthIncrement = direction === 'prev' ? -1 : 1;
    const newMonth = (month - 1 + monthIncrement + 12) % 12 + 1;
    const newYear = direction === 'prev' && month === 1 ? year - 1 :
                    direction === 'next' && month === 12 ? year + 1 :
                    year;
    return `${newYear}-${newMonth.toString().padStart(2, '0')}`;
};

const adjustQuarter = (year: number, quarter: number, direction: string): string => {
    const quarterIncrement = direction === 'prev' ? -1 : 1;
    const newQuarter = (quarter - 1 + quarterIncrement + 4) % 4 + 1;
    const newYear = direction === 'prev' && quarter === 1 ? year - 1 :
                    direction === 'next' && quarter === 4 ? year + 1 :
                    year;
    return `${newYear}-Q${newQuarter}`;
};

const formatDateKey = (date: Date): string => {
    return `${date.getUTCFullYear()}-${(date.getUTCMonth() + 1).toString().padStart(2, '0')}-${date.getUTCDate().toString().padStart(2, '0')}`;
};

export const convertDay = (dateKey: string, newPeriod: periodType): string => {
    const [year, month, day] = dateKey.split('-').map(Number);
    switch (newPeriod) {
      case 'day':
        return dateKey;
      case 'week':
        if (new Date(year, month - 1, day).getDay() === 1) {
          return dateKey; // Return the same date if it's a Monday
        } else {
          const monday = day - new Date(year, month - 1, day).getDay() + 1;
          return `${year}-${month.toString().padStart(2, '0')}-${monday.toString().padStart(2, '0')}`;
        }
      case 'month':
        return `${year}-${month.toString().padStart(2, '0')}`;
      case 'quarter':
        const quarter = Math.ceil(month / 3);
        return `${year}-Q${quarter}`;
      case 'year':
        return `${year}`;
    }
};

export const getFirstDay = (periodType: string, dateKey: string): string => {
    switch (periodType) {
        case 'day':
            return dateKey;
        case 'week':
            return dateKey; // Return the same date for the 'week' period type
        case 'month':
            return `${dateKey}-01`;
        case 'quarter':
            const [yearQ, quarter] = dateKey.split('-Q').map(Number);
            const quarterStartMonth = (quarter - 1) * 3 + 1;
            return `${yearQ}-${quarterStartMonth.toString().padStart(2, '0')}-01`;
        case 'year':
            return `${dateKey}-01-01`;
        default:
            return '';
    }
};

export const convertToPeriod = (currentPeriod: string, dateKey: string, newPeriod: periodType): string => {
    if (currentPeriod === 'day') {
        return convertDay(dateKey, newPeriod);
    } else {
        const firstDay = getFirstDay(currentPeriod, dateKey);
        return convertDay(firstDay, newPeriod);
    }
};

export const getCurrentDayDateKey = (): string => {
    const today = new Date();
    const year = today.getFullYear();
    const month = (today.getMonth() + 1).toString().padStart(2, '0');
    const day = today.getDate().toString().padStart(2, '0');
    return `${year}-${month}-${day}`;
};

export const getCurrentPeriod = (periodType: periodType) => {
  return convertDay(getCurrentDayDateKey(), periodType);
}

export const formatDateKeyDisplay = (periodType: string, dateKey: string): string => {
    const [year, month, day] = dateKey.split('-').map(Number);

    switch (periodType) {
        case 'day':
            const dayName = getWeekDayX(year, month, day);
            return `${dayName}, ${formatDateX(year, month, day)}`;
        case 'week':
            const monday = getMondayX(year, month, day);
            return `Week of ${formatDateX(monday.year, monday.month, monday.day)}`;
        case 'month':
            return `${getMonthName(month)} ${year}`;
        case 'quarter':
            const [quarterYear, quarter] = dateKey.split('-Q');
            return `Q${quarter} of ${quarterYear}`;
        case 'year':
            return dateKey;
        default:
            return '';
    }
};

export const getMonthName = (monthNumber: number): string => {
    const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[monthNumber - 1]; // Adjusting for zero-based indexing
};

const getWeekDayX = (year: number, month: number, day: number): string => {
    const weekDays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    const dayOfWeek = new Date(Date.UTC(year, month - 1, day)).getUTCDay();
    return weekDays[dayOfWeek];
};

const getMondayX = (year: number, month: number, day: number): { year: number, month: number, day: number } => {
    const monday = new Date(Date.UTC(year, month - 1, day));
    const mondayDate = monday.getUTCDate() - monday.getUTCDay() + (monday.getUTCDay() === 0 ? -6 : 1);
    return { year: monday.getUTCFullYear(), month: monday.getUTCMonth() + 1, day: mondayDate };
};

const formatDateX = (year: number, month: number, day: number): string => {
    return `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;
};

// Utility function to check if a string is a periodType
export const isPeriodType = (value: any): value is periodType => {
  return ['day', 'week', 'month', 'quarter', 'year'].includes(value);
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