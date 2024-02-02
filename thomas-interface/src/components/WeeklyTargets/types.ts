export type Weekday = 'monday'    |
                      'tuesday'   |
                      'wednesday' |                
                      'thursday'  |
                      'friday'    |
                      'saturday'  |
                      'sunday';

export interface Week {
  type: '==' | '<=' | '>=';
  target: number | null;
  entries: Record<Weekday, number>;
}

export interface WeeklyTarget {
  timestamp: number; // creation time
  description: string;
  weeks: Record<string, Week>;
  tags: string[];
} 

interface Target {
  timestamp: number; // creation time
  target: number;
  type: '>=' | '<=' | '==';
  description: string;
  start: number; // left bound of target period
  end: number;   // right bound of target period
}

export interface NumericTarget {
  timestamp: number; // creation time
  description: string;
  entries: string; // a csv file with timed entries
  targets: Target[]; //a collection of targets
}