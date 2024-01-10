import memoize from "lodash/memoize";
import Urbit from "@urbit/http-api";

const live = false;
const ship = "niblyx-malnus";
const api = {
  createApi: memoize(() => {
      const urb = live
        ? new Urbit("")
        : new Urbit(
          "http://localhost:8080", // process.env.REACT_APP_SHIP_URL
          "" // process.env.REACT_APP_SHIP_CODE
        );
      urb.ship = live ? (window as any).ship : ship; // process.env.REACT_APP_SHIP_NAME;
      urb.onError = (message) => console.log("onError: " + message);
      urb.onOpen = () => console.log("urbit onOpen");
      urb.onRetry = () => console.log("urbit onRetry");
      urb.subscribe({
        app: 'goals',
        path: '/settings',
        event: (update: any) => console.log(update),
        quit: () => console.log('quit'),
        err: () => console.log('err'),
      });
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
      ship: live ? (window as any).ship : ship, // process.env.REACT_APP_SHIP_NAME,
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
  createPool: async (title: string) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: { 'create-pool': { title: title } },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  createGoal: async (poolId: string, parentId: string | null, summary: string, actionable: boolean) => {
    console.log("poolId");
    console.log(poolId);
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: {
        'create-goal': {
          pin: poolId,
          upid: parentId,
          summary: summary,
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
        'update-goal-tags': {
          id: goalId,
          method: 'uni',
          tags: [text]
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
        'update-goal-tags': {
          id: goalId,
          method: 'dif',
          tags: [text]
        }
      },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  editPoolTitle: async (poolId: string, title: string) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: {
        'update-pool-property': {
          pin: poolId,
          method: 'put',
          property: 'title',
          data: title,
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
        'update-pool-property': {
          pin: poolId,
          method: 'put',
          property: 'note',
          data: note,
        }
      },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  editPoolTagNote: async (poolId: string, tag: string, note: string) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: {
        'update-pool-tag-property': {
          pin: poolId,
          tag: tag,
          method: 'put',
          property: 'note',
          data: note,
        }
      },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  setGoalSummary: async (goalId: string, summary: string) => {
    console.log("goalId");
    console.log(goalId);
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: {
        'set-summary': {
          id: goalId,
          summary: summary,
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
        'update-goal-field': {
          id: goalId,
          method: 'put',
          field: 'note',
          data: note,
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
      json: { 'delete-goal': { id: goalId } },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  youngSlotAbove: async (parentId: string, dis: string, dat: string) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: { 'young-slot-above': { pid: parentId, dis: dis, dat: dat } },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  youngSlotBelow: async (parentId: string, dis: string, dat: string) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: { 'young-slot-below': { pid: parentId, dis: dis, dat: dat } },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  rootsSlotAbove: async (dis: string, dat: string) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: { 'roots-slot-above': { dis: dis, dat: dat } },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  rootsSlotBelow: async (dis: string, dat: string) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: { 'roots-slot-below': { dis: dis, dat: dat } },
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
  updateSetting: async (method: string, setting: string, contents: string) => {
    try {
    return api.createApi().poke({
      app: 'goals',
      mark: 'goal-action',
      json: {
        'update-setting': {
          method: method,
          setting: setting,
          contents: contents
        }
      },
    });
    } catch (e) {
      console.log("poke error");
    }
  },
  getPoolsIndex: async () => {
    return await api.goalView({ "pools-index": null });
  },
  getPoolRoots: async (id: string) => {
    return await api.goalView({ "pool-roots": { pin: id } });
  },
  getGoalYoung: async (id: string) => {
    return await api.goalView({ "goal-young": { id: id } });
  },
  getPoolTitle: async (id: string) => {
    return await api.goalView({ "pool-title": { pin: id } });
  },
  getPoolNote: async (id: string) => {
    return await api.goalView({ "pool-note": { pin: id } });
  },
  getPoolTagNote: async (id: string, tag: string) => {
    return await api.goalView({ "pool-tag-note": { pin: id, tag: tag } });
  },
  getGoalSummary: async (id: string) => {
    return await api.goalView({ "goal-summary": { id: id } });
  },
  getGoalNote: async (id: string) => {
    return await api.goalView({ "goal-note": { id: id } });
  },
  getGoalTags: async (id: string) => {
    return await api.goalView({ "goal-tags": { id: id } });
  },
  getGoalParent: async (id: string) => {
    return await api.goalView({ "goal-parent": { id: id } });
  },
  getGoalActionable: async (id: string) => {
    return await api.goalView({ "goal-actionable": { id: id } });
  },
  getGoalComplete: async (id: string) => {
    return await api.goalView({ "goal-complete": { id: id } });
  },
  getSetting: async (setting: string) => {
    return await api.goalView({ "setting": { setting: setting } });
  },
  getPoolTags: async (id: string) => {
    return await api.goalView({ "pool-tags": { pin: id } });
  },
};

export default api;