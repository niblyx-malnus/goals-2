import { create } from 'zustand';
import { Collection, periodType } from './types';
import { getCurrentPeriod } from './components/Periods/utils';

interface StoreState {
  placeholderLabel: string;
  
  // when swapping between period types
  currentPeriodType: periodType;
  currentDay: string;
  currentWeek: string;
  currentMonth: string;
  currentQuarter: string;
  currentYear: string;

  showCompleted: boolean;
  collections: Record<string, Collection>;
}

interface StoreActions {
  setPlaceholderLabel: (tag: string) => void;
  
  // when swapping between period types
  setCurrentPeriodType: (periodType: periodType) => void;
  setCurrentDay: (period: string) => void;
  setCurrentWeek: (period: string) => void;
  setCurrentMonth: (period: string) => void;
  setCurrentQuarter: (period: string) => void;
  setCurrentYear: (period: string) => void;
  getCurrentPeriod: () => string;

  setShowCompleted: (show: boolean) => void;
  setCollection: (path: string, collection: Collection) => void;
  delCollection: (path: string) => void;
}

const useStore = create<StoreState & StoreActions>((set, get) => ({
  placeholderLabel: 'today',
  currentPeriodType: 'day',
  currentDay: getCurrentPeriod('day'),
  currentWeek: getCurrentPeriod('week'),
  currentMonth: getCurrentPeriod('month'),
  currentQuarter: getCurrentPeriod('quarter'),
  currentYear: getCurrentPeriod('year'),
  setPlaceholderLabel: (tag: string) => set({ placeholderLabel: tag }),
  setCurrentPeriodType: (periodType: periodType) => set({ currentPeriodType: periodType }),
  setCurrentDay: (period: string) => set({ currentDay: period }),
  setCurrentWeek: (period: string) => set({ currentWeek: period }),
  setCurrentMonth: (period: string) => set({ currentMonth: period }),
  setCurrentQuarter: (period: string) => set({ currentQuarter: period }),
  setCurrentYear: (period: string) => set({ currentYear: period }),
  getCurrentPeriod: () => {
    const state = get();
    switch (state.currentPeriodType) {
      case 'day':
        return state.currentDay;
      case 'week':
        return state.currentWeek;
      case 'month':
        return state.currentMonth;
      case 'quarter':
        return state.currentQuarter;
      case 'year':
        return state.currentYear;
      default:
        return '';
    }
  },
  showCompleted: false,
  setShowCompleted: (show: boolean) => set({ showCompleted: show }),
  collections: {},
  setCollection: (path, collection) => set((stateObj) => ({
    collections: { ...stateObj.collections, [path]: collection }
  })),
  delCollection: (path) => set((stateObj) => {
    const newCollection = { ...stateObj.collections };
    delete newCollection[path];
    return { collections: newCollection };
  })
}));

export default useStore;
