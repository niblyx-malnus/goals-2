export interface State {
  timestamp: number;
  description: string;
  value: { timestamp: number; value: boolean }[];
  shelflife: number | null; // time to next expiration in unix seconds
  expiration: number | null; // time of next expiration in unix seconds
  tags: string[];
}