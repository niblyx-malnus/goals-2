import { create } from 'zustand';

interface StoreState {
  placeholderTag: string;
}

interface StoreActions {
  setPlaceholderTag: (tag: string) => void;
}

const useStore = create<StoreState & StoreActions>(set => ({
  placeholderTag: 'today',
  setPlaceholderTag: (tag: string) => set({ placeholderTag: tag }),
}));

export default useStore;
