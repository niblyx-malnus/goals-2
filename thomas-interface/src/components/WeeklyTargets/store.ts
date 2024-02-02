import { create } from 'zustand';
import { WeeklyTarget } from './types';

export interface StoreState {
  weeklyTargets: Record<string, WeeklyTarget>;
}

export interface StoreActions {
  setWeeklyTarget: (id: string, state: WeeklyTarget) => void;
  delWeeklyTarget: (id: string) => void;
  getAllTags: () => string[];
}

const useStore = create<StoreState & StoreActions>((set, get) => ({
  weeklyTargets: {},
  setWeeklyTarget: (id, weeklyTarget) => set((weeklyTargetObj) => ({
    weeklyTargets: { ...weeklyTargetObj.weeklyTargets, [id]: weeklyTarget }
  })),
  delWeeklyTarget: (id) => set((weeklyTargetObj) => {
    const newWeeklyTargets = { ...weeklyTargetObj.weeklyTargets };
    delete newWeeklyTargets[id];
    return { weeklyTargets: newWeeklyTargets };
  }),
  getAllTags: () => {
    const allTags = new Set<string>();
    const states = get().weeklyTargets; // Accessing the current state

    Object.values(states).forEach(weeklyTarget => {
      weeklyTarget.tags.forEach(tag => {
        allTags.add(tag);
      });
    });

    return Array.from(allTags);
  }
}));

export default useStore;