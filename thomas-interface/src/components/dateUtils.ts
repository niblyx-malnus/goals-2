export const getWeekDay = (date: Date): string => {
  const weekDays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  return weekDays[date.getDay()];
};

export const getMonday = (date: Date): Date => {
  const result = new Date(date);
  const day = result.getDay(),
        diff = result.getDate() - day + (day === 0 ? -6 : 1); // Adjust when day is Sunday
  result.setDate(diff);
  return new Date(result.setHours(0, 0, 0, 0));
};

export const formatDate = (date: Date): string => {
  return date.toISOString().split('T')[0];
};

export const getMonth = (date: Date): string => {
  const year = date.getFullYear();
  const month = date.getMonth() + 1; // getMonth() is zero-indexed, add 1 for human-readable format
  return `${year}-${month.toString().padStart(2, '0')}`; // Formats to YYYY-MM
};

export const getQuarter = (date: Date): string => {
  const year = date.getFullYear();
  const quarter = Math.floor(date.getMonth() / 3) + 1;
  return `${year}-Q${quarter}`; // Formats to YYYY-Q#
};

export const getYear = (date: Date): string => {
  return date.getFullYear().toString();
};