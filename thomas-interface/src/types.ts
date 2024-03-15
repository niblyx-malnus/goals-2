export type Goal = {
  key: string,
  summary: string,
  note: string,
  labels: string[],
  tags: string[],
  inheritedLabels: string[],
  inheritedTags: string[],
  attributes: { [key: string]: any },
  fields: { [key: string]: any },
  inheritedAttributes: { [key: string]: any },
  inheritedFields: { [key: string]: any },
  parent: string | null,
  yourPerms: string,
  chief: string,
  deputies: { [key: string]: string },
  openTo: string | null,
  active: boolean,
  complete: boolean,
  actionable: boolean
};

export type periodType = 'day' | 'week' | 'month' | 'quarter' | 'year';

export type Collection = {
  goals: Goal[]
  themes: string[],
}