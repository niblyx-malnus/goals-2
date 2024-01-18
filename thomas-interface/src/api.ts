import memoize from "lodash/memoize";
import Urbit from "@urbit/http-api";

const live = process.env.REACT_APP_LIVE;
const ship = "niblyx-malnus";
const api = {
  createApi: memoize(() => {
      const urb = live ? new Urbit("") : new Urbit("http://localhost:8080", "");
      urb.ship = live ? (window as any).ship : ship;
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
      ship: live ? (window as any).ship : ship,
      dude: 'goals', // the agent to poke
      inputDesk: 'goals', // where does the input mark live
      inputMark: 'goal-view', // name of input mark
      outputDesk: 'goals', // where does the output mark live
      outputMark: 'goal-vent', // name of output mark
      body: json, // the actual poke content
    }, 'goals');
  },
  goalAction: async (json: any) => {
    return await api.vent({
      ship: live ? (window as any).ship : ship,
      dude: 'goals', // the agent to poke
      inputDesk: 'goals', // where does the input mark live
      inputMark: 'goal-action', // name of input mark
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
  mainHarvest: async (method: string, tags: string[]) => {
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
    const json = { 'create-pool': { title: title } };
    return await api.goalAction(json);
  },
  createGoal: async (poolId: string, parentId: string | null, summary: string, actionable: boolean) => {
    const json = {
        'create-goal': {
          pin: poolId,
          upid: parentId,
          summary: summary,
          actionable: actionable
        }
      };
    return await api.goalAction(json);
  },
  addGoalTag: async (goalId: string, text: string) => {
    const json = {
        'update-goal-tags': {
          id: goalId,
          method: 'uni',
          tags: [text]
        }
      };
    return await api.goalAction(json);
  },
  delGoalTag: async (goalId: string, text: string) => {
    const json = {
        'update-goal-tags': {
          id: goalId,
          method: 'dif',
          tags: [text]
        }
      };
    return await api.goalAction(json);
  },
  addLocalGoalTag: async (goalId: string, text: string) => {
    const json = {
        'update-local-goal-tags': {
          id: goalId,
          method: 'uni',
          tags: [text]
        }
      };
    return await api.goalAction(json);
  },
  delLocalGoalTag: async (goalId: string, text: string) => {
    const json = {
        'update-local-goal-tags': {
          id: goalId,
          method: 'dif',
          tags: [text]
        }
      };
    return await api.goalAction(json);
  },
  editPoolTitle: async (poolId: string, title: string) => {
    const json = {
        'update-pool-property': {
          pin: poolId,
          method: 'put',
          property: 'title',
          data: title,
        }
      };
    return await api.goalAction(json);
  },
  editPoolNote: async (poolId: string, note: string) => {
    const json = {
        'update-pool-property': {
          pin: poolId,
          method: 'put',
          property: 'note',
          data: note,
        }
      };
    return await api.goalAction(json);
  },
  editPoolTagNote: async (poolId: string, tag: string, note: string) => {
    const json = {
        'update-pool-tag-property': {
          pin: poolId,
          tag: tag,
          method: 'put',
          property: 'note',
          data: note,
        }
      };
    return await api.goalAction(json);
  },
  setGoalSummary: async (goalId: string, summary: string) => {
    const json = {
        'set-summary': {
          id: goalId,
          summary: summary,
        }
      };
    return await api.goalAction(json);
  },
  setPoolTitle: async (poolId: string, title: string) => {
    console.log(poolId);
    const json = {
        'set-pool-title': {
          pin: poolId,
          title: title,
        }
      };
    return await api.goalAction(json);
  },
  editGoalNote: async (goalId: string, note: string) => {
    const json = {
        'update-goal-field': {
          id: goalId,
          method: 'put',
          field: 'note',
          data: note,
        }
      };
    return await api.goalAction(json);
  },
  setGoalComplete: async (goalId: string, complete: boolean) => {
    const json = complete
      ? { 'mark-complete': { id: goalId } }
      : { 'unmark-complete': { id: goalId } }
    return await api.goalAction(json);
  },
  setGoalActionable: async (goalId: string, actionable: boolean) => {
    const json = actionable
      ? { 'mark-actionable': { id: goalId } }
      : { 'unmark-actionable': { id: goalId } }
    return await api.goalAction(json);
  },
  deleteGoal: async (goalId: string) => {
    const json = { 'delete-goal': { id: goalId } };
    return await api.goalAction(json);
  },
  deletePool: async (poolId: string) => {
    const json = { 'delete-pool': { pin: poolId } };
    return await api.goalAction(json);
  },
  youngSlotAbove: async (parentId: string, dis: string, dat: string) => {
    const json = { 'young-slot-above': { pid: parentId, dis: dis, dat: dat } };
    return await api.goalAction(json);
  },
  youngSlotBelow: async (parentId: string, dis: string, dat: string) => {
    const json = { 'young-slot-below': { pid: parentId, dis: dis, dat: dat } };
    return await api.goalAction(json);
  },
  rootsSlotAbove: async (dis: string, dat: string) => {
    const json = { 'roots-slot-above': { dis: dis, dat: dat } };
    return await api.goalAction(json);
  },
  rootsSlotBelow: async (dis: string, dat: string) => {
    const json = { 'roots-slot-below': { dis: dis, dat: dat } };
    return await api.goalAction(json);
  },
  poolsSlotAbove: async (dis: string, dat: string) => {
    const json = { 'pools-slot-above': { dis: dis, dat: dat } };
    return await api.goalAction(json);
  },
  poolsSlotBelow: async (dis: string, dat: string) => {
    const json = { 'pools-slot-below': { dis: dis, dat: dat } };
    return await api.goalAction(json);
  },
  goalsSlotAbove: async (dis: string, dat: string) => {
    const json = { 'goals-slot-above': { dis: dis, dat: dat } };
    return await api.goalAction(json);
  },
  goalsSlotBelow: async (dis: string, dat: string) => {
    const json = { 'goals-slot-below': { dis: dis, dat: dat } };
    return await api.goalAction(json);
  },
  setPoolsIndex: async (pools: string[]) => {
    const json = { 'reorder-pools': { pools: pools, } };
    return await api.goalAction(json);
  },
  move: async (cid: string, upid: string | null) => {
    const json = { 'move': { cid: cid, upid: upid } };
    return await api.goalAction(json);
  },
  updateSetting: async (method: string, setting: string, contents: string) => {
    const json = {
        'update-setting': {
          method: method,
          setting: setting,
          contents: contents
        }
      };
    return await api.goalAction(json);
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
  getLocalGoalTags: async (id: string) => {
    return await api.goalView({ "local-goal-tags": { id: id } });
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
  getPoolTags: async (poolId: string) => {
    return await api.goalView({ "pool-tags": { pin: poolId } });
  },
  getAllLocalGoalTags: async () => {
    return await api.goalView({ "all-local-goal-tags": null });
  },
};

export default api;