export type Tag = {
  isPublic: boolean;
  tag: string;
};

export type Goal = {
  key: string,
  summary: string,
  tags: Tag[],
  active: boolean,
  complete: boolean,
  actionable: boolean
};