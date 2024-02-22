export type Goal = {
  key: string,
  summary: string,
  labels: string[],
  tags: string[],
  inheritedLabels: string[],
  inheritedTags: string[],
  active: boolean,
  complete: boolean,
  actionable: boolean
};

export type periodType = 'day' | 'week' | 'month' | 'quarter' | 'year';

export type Collection = {
  goals: Goal[]
  themes: string[],
}