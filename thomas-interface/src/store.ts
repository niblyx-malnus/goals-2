import { create } from 'zustand';

interface StoreState {
  placeholderTag: string;
  showCompleted: boolean;
  showButtons: boolean;
}

interface StoreActions {
  setPlaceholderTag: (tag: string) => void;
  setShowCompleted: (show: boolean) => void;
  setShowButtons: (show: boolean) => void;
}

const useStore = create<StoreState & StoreActions>(set => ({
  placeholderTag: 'today',
  setPlaceholderTag: (tag: string) => set({ placeholderTag: tag }),
  showCompleted: false,
  setShowCompleted: (show: boolean) => set({ showCompleted: show }),
  showButtons: true,
  setShowButtons: (show: boolean) => set({ showButtons: show }),
}));

export default useStore;
