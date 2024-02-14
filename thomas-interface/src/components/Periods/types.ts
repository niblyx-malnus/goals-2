import { Tag } from '../../types';

export type periodType = 'day' | 'week' | 'month' | 'quarter' | 'year';
    
    // Utility function to check if a string is a periodType
export const isPeriodType = (value: any): value is periodType => {
  return ['day', 'week', 'month', 'quarter', 'year'].includes(value);
};

export type Goal = {
  key: string,
  summary: string,
  tags: Tag[],
  active: boolean,
  complete: boolean,
  actionable: boolean
};
export type Collection = {
  goals: Goal[]
  themes: string[],
}