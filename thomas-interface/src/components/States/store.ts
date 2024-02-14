import { create } from 'zustand';
import { State } from './types';

export interface StoreState {
  states: Record<string, State>;
}

export interface StoreActions {
  setState: (id: string, state: State) => void;
  delState: (id: string) => void;
  getAllTags: () => string[];
}

const useStore = create<StoreState & StoreActions>((set, get) => ({
  states: {}, // Initial state
  setState: (id, state) => set((stateObj) => ({
    states: { ...stateObj.states, [id]: state }
  })),
  delState: (id) => set((stateObj) => {
    const newState = { ...stateObj.states };
    delete newState[id];
    return { states: newState };
  }),
  getAllTags: () => {
    const allTags = new Set<string>();
    const states = get().states; // Accessing the current state

    Object.values(states).forEach(state => {
      state.tags.forEach(tag => {
        allTags.add(tag);
      });
    });

    return Array.from(allTags);
  }
}));

export default useStore;