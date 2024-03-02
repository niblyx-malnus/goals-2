export type Goal = {
  key: string,
  summary: string,
  note: string,
  labels: string[],
  tags: string[],
  inheritedLabels: string[],
  inheritedTags: string[],
  parent: string | null,
  active: boolean,
  complete: boolean,
  actionable: boolean
};

export type periodType = 'day' | 'week' | 'month' | 'quarter' | 'year';

export type Collection = {
  goals: Goal[]
  themes: string[],
}