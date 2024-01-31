export interface Week {
  goal: number | null;
  entries: {
    'monday': number | null;
    'tuesday': number | null;
    'wednesday': number | null;
    'thursday': number | null;
    'friday': number | null;
    'saturday': number | null;
    'sunday': number | null;
  }
}

export interface WeeklyGoal {
  timestamp: number; // creation time
  description: string;
  weeks: Record<string, Week>;
  type: 'max' | 'min';
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