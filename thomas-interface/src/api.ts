import memoize from "lodash/memoize";
import Urbit from "@urbit/http-api";

const api = {
  createApi: memoize(() => {
      const urb = new Urbit("http://localhost:8080", "");
      urb.ship = "pittyp-fogsyt-niblyx-malnus";
      urb.onError = (message) => console.log("onError: " + message);
      urb.onOpen = () => console.log("urbit onOpen");
      urb.onRetry = () => console.log("urbit onRetry");
      urb.connect(); 
      return urb;
  }),
  scry: async (app: string, path: string) => {
    return api.createApi().scry({ app: app, path: path});
  },
  poke: async (app: string, mark: string, json: any) => {
    try {
    return api.createApi().poke({
      app: app,
      mark: mark,
      json: json,
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  spawnPool: async (title: string) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: {
        'spawn-pool': {
          title: title,
        }
      },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  spawnGoal: async (poolId: string, parentId: string | null, description: string, actionable: boolean) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: {
        'spawn-goal': {
          pin: poolId,
          upid: parentId,
          desc: description,
          actionable: actionable
        }
      },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  editPoolNote: async (poolId: string, note: string) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: {
        'edit-pool-note': {
          pin: poolId,
          note: note,
        }
      },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  setPoolsIndex: async (pools: string[]) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: {
        'reorder-pools': {
          pools: pools,
        }
      },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  getPoolsIndex: async () => {
    return await api.createApi().scry( { app: "goals", path: "/pools/index"} );
  },
  getPoolRoots: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/pool/roots/${id}`} );
  },
  getGoalKids: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/goal/kids/${id}`} );
  },
  getPoolTitle: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/pool/title/${id}`} );
  },
  getPoolNote: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/pool/note/${id}`} );
  },
  getGoalDesc: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/goal/desc/${id}`} );
  },
  getGoalNote: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/goal/note/${id}`} );
  },
};

export default api;