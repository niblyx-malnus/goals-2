export type Goal = {
  key: string,
  summary: string,
  note: string,
  labels: string[],
  attributes: { [key: string]: any },
  parent: string | null,
  yourPerms: string,
  chief: string,
  deputies: { [key: string]: string },
  openTo: string | null,
  active: boolean,
  complete: boolean,
  actionable: boolean
};

export type Pool = {
  pid: string,
  title: string,
  host: string,
  name: string,
  isValid: boolean,
  haveCopy: boolean,
  areWatching: boolean,
  requested: boolean,
};

export type PoolData = {
  private: any;
  public: any;
};

export type PoolsData = { [pid: string]: PoolData | null };

export type periodType = 'day' | 'week' | 'month' | 'quarter' | 'year';

export type Collection = {
  goals: Goal[]
  themes: string[],
}