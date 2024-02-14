import { create } from 'zustand';
import { Collection } from './types';

export interface StoreState {
  collections: Record<string, Collection>;
}

export interface StoreActions {
  setCollection: (path: string, collection: Collection) => void;
  delCollection: (path: string) => void;
}

const useStore = create<StoreState & StoreActions>((set, get) => ({
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