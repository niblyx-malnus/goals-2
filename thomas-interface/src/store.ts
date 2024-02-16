import { create } from 'zustand';
import { Collection } from './types';

interface StoreState {
  placeholderLabel: string;
  showCompleted: boolean;
  showButtons: boolean;
  collections: Record<string, Collection>;
}

interface StoreActions {
  setPlaceholderLabel: (tag: string) => void;
  setShowCompleted: (show: boolean) => void;
  setShowButtons: (show: boolean) => void;
  setCollection: (path: string, collection: Collection) => void;
  delCollection: (path: string) => void;
}

const useStore = create<StoreState & StoreActions>(set => ({
  placeholderLabel: 'today',
  setPlaceholderLabel: (tag: string) => set({ placeholderLabel: tag }),
  showCompleted: false,
  setShowCompleted: (show: boolean) => set({ showCompleted: show }),
  showButtons: true,
  setShowButtons: (show: boolean) => set({ showButtons: show }),
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
