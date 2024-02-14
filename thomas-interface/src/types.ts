export type Tag = {
  isPublic: boolean;
  tag: string;
};

export type Goal = {
  gid: string,
  description: string,
  tags: Tag[],
  active: boolean,
  complete: boolean,
  actionable: boolean
};