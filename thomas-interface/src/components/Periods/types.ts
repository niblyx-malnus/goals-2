import { Goal } from '../../types';

export type periodType = 'day' | 'week' | 'month' | 'quarter' | 'year';

export type Collection = {
  goals: Goal[]
  themes: string[],
}