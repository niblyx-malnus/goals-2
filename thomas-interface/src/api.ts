import memoize from "lodash/memoize";
import Urbit from "@urbit/http-api";

const ship = "pittyp-fogsyt-niblyx-malnus";

const api = {
  createApi: memoize(() => {
      const urb = new Urbit("http://localhost:8080", "");
      urb.ship = ship;
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
  vent: async (vnt: any, desk: string) => {
    const result: any = await api.createApi().thread({
      inputMark: 'vent-package', // input to thread, contains poke
      outputMark: 'json',
      threadName: 'venter',
      body: {
        dock: {
          ship: vnt.ship,
          dude: vnt.dude,
        },
        input: {
          desk: vnt.inputDesk,
          mark: vnt.inputMark, // mark of the poke itself
        },
        output: {
          desk: vnt.outputDesk,
          mark: vnt.outputMark,
        },
        body: vnt.body,
      },
      desk: desk,
    });
    if (
      result !== null &&
      result.term &&
      result.tang &&
      Array.isArray(result.tang)
    ) {
      throw new Error(`\n${result.term}\n${result.tang.join('\n')}`);
    } else {
      return result;
    }
  },
  goalView: async (json: any) => {
    return await api.vent({
      ship: ship, // the ship to poke
      dude: 'goals', // the agent to poke
      inputDesk: 'goals', // where does the input mark live
      inputMark: 'goal-view', // name of input mark
      outputDesk: 'goals', // where does the output mark live
      outputMark: 'goal-vent', // name of output mark
      body: json, // the actual poke content
    }, 'goals');
  },
  allPoolsHarvest: async (method: string, tags: string[]) => {
    const json = {
      harvest: {
        type: { main: null },
        method: method,
        tags: tags,
      }
    };
    console.log(json);
    return await api.goalView(json);
  },
  poolHarvest: async (poolId: string, method: string, tags: string[]) => {
    const json = {
      harvest: {
        type: { pool: poolId },
        method: method,
        tags: tags,
      }
    };
    console.log(json);
    return await api.goalView(json);
  },
  goalHarvest: async (goalId: string, method: string, tags: string[]) => {
    const json = {
      harvest: {
        type: { goal: goalId },
        method: method,
        tags: tags,
      }
    };
    console.log(json);
    return await api.goalView(json);
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
    console.log("poolId");
    console.log(poolId);
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
  addGoalTag: async (goalId: string, text: string) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: {
        'add-goal-tag': {
          id: goalId,
          tag: text
        }
      },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  delGoalTag: async (goalId: string, text: string) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: {
        'del-goal-tag': {
          id: goalId,
          tag: text
        }
      },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  editPoolNote: async (poolId: string, note: string) => {
    console.log("poolId");
    console.log(poolId);
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
  editGoalDescription: async (goalId: string, description: string) => {
    console.log("goalId");
    console.log(goalId);
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: {
        'edit-goal-desc': {
          id: goalId,
          desc: description,
        }
      },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  editGoalNote: async (goalId: string, note: string) => {
    console.log("goalId");
    console.log(goalId);
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: {
        'edit-goal-note': {
          id: goalId,
          note: note,
        }
      },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  setGoalComplete: async (goalId: string, complete: boolean) => {
    console.log("goalId");
    console.log(goalId);
    try {
      if (complete) {
        return api.createApi().poke({
          app: 'goals',
          mark: 'goal-action',
          json: { 'mark-complete': { id: goalId } },
        });
      } else {
        return api.createApi().poke({
          app: 'goals',
          mark: 'goal-action',
          json: { 'unmark-complete': { id: goalId } },
        });
      }
    } catch (e) {
      console.log("poke error");
    }
  },
  setGoalActionable: async (goalId: string, actionable: boolean) => {
    console.log("goalId");
    console.log(goalId);
    try {
      if (actionable) {
        return api.createApi().poke({
          app: 'goals',
          mark: 'goal-action',
          json: { 'mark-actionable': { id: goalId } },
        });
      } else {
        return api.createApi().poke({
          app: 'goals',
          mark: 'goal-action',
          json: { 'unmark-actionable': { id: goalId } },
        });
      }
    } catch (e) {
      console.log("poke error");
    }
  },
  deleteGoal: async (goalId: string) => {
    console.log("goalId");
    console.log(goalId);
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: { 'trash-goal': { id: goalId } },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  reorderYoung: async (parentId: string, newYoung: string[]) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: { 'reorder-young': { id: parentId, young: newYoung } },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  reorderRoots: async (poolId: string, newRoots: string[]) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: { 'reorder-roots': { pin: poolId, roots: newRoots } },
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
      json: { 'reorder-pools': { pools: pools, } },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  move: async (cid: string, upid: string | null) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: { 'move': { cid: cid, upid: upid } },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  getPoolsIndex: async () => {
    return await api.createApi().scry( { app: "goals", path: "/pools/index"} );
  },
  getPoolRoots: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/pool/roots${id}`} );
  },
  getGoalYoung: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/goal/young${id}`} );
  },
  getPoolTitle: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/pool/title${id}`} );
  },
  getPoolNote: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/pool/note${id}`} );
  },
  getGoalDesc: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/goal/desc${id}`} );
  },
  getGoalNote: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/goal/note${id}`} );
  },
  getGoalTags: async (id: string) => {
    return await api.createApi().scry({ app: "goals", path: `/goal/tags${id}`});
  },
  getGoalParent: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/goal/parent${id}`} );
  },
  getGoalActionable: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/goal/actionable${id}`} );
  },
  getGoalComplete: async (id: string) => {
    return await api.createApi().scry( { app: "goals", path: `/goal/complete${id}`} );
  },
};

export default api;