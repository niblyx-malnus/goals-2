import { create } from 'zustand';
import { WeeklyGoal } from './types';

export interface StoreState {
  weeklyGoals: Record<string, WeeklyGoal>;
}

export interface StoreActions {
  setWeeklyGoal: (id: string, state: WeeklyGoal) => void;
  delWeeklyGoal: (id: string) => void;
  getAllTags: () => string[];
}

const useStore = create<StoreState & StoreActions>((set, get) => ({
  weeklyGoals: {},
  setWeeklyGoal: (id, weeklyGoal) => set((weeklyGoalObj) => ({
    weeklyGoals: { ...weeklyGoalObj.weeklyGoals, [id]: weeklyGoal }
  })),
  delWeeklyGoal: (id) => set((weeklyGoalObj) => {
    const newWeeklyGoals = { ...weeklyGoalObj.weeklyGoals };
    delete newWeeklyGoals[id];
    return { weeklyGoals: newWeeklyGoals };
  }),
  getAllTags: () => {
    const allTags = new Set<string>();
    const states = get().weeklyGoals; // Accessing the current state

    Object.values(states).forEach(weeklyGoal => {
      weeklyGoal.tags.forEach(tag => {
        allTags.add(tag);
      });
    });

    return Array.from(allTags);
  }
}));

export default useStore;