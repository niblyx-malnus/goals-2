export interface State {
  timestamp: number;
  description: string;
  value: { timestamp: number; value: boolean }[];
  shelflife: number | null; // time to next expiration in unix seconds
  expiration: number | null; // time of next expiration in unix seconds
  tags: string[];
}

export interface StoreState {
  states: Record<string, State>;
}

export interface StoreActions {
  setState: (id: string, state: State) => void;
  delState: (id: string) => void;
}