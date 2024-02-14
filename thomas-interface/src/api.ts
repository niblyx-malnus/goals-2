import memoize from "lodash/memoize";
import Urbit from "@urbit/http-api";
import { title } from "process";

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
  jsonTreeAction: async (json: any) => {
    return await api.vent({
      ship: live ? (window as any).ship : ship,
      dude: 'goals', // the agent to poke
      inputDesk: 'goals', // where does the input mark live
      inputMark: 'json-tree-action', // name of input mark
      outputDesk: 'goals', // where does the output mark live
      outputMark: 'json-tree-vent', // name of output mark
      body: json, // the actual poke content
    }, 'goals');
  },
  goalKeyToPidGid: (path: string) => {
    console.log(`Splitting path: ${path}`);
    const parts = path.split('/').filter(Boolean);
    if (parts.length !== 3) {
      throw new Error('Path must be in the format of /{host}/{name}/{id}');
    }
    const [host, name, gid] = parts;
    return { pid: `/${host}/${name}`, gid: `/${gid}` };
  },
  jsonTree: async (path: string) => {
    const json = { tree: { path: path } };
    return await api.jsonTreeAction(json);
  },
  jsonRead: async (path: string) => {
    const json = { read: { paths: [path] } };
    const map = await api.jsonTreeAction(json);
    return map[path];
  },
  jsonReadMany: async (paths: string[]) => {
    const json = { read: { paths: paths } };
    return await api.jsonTreeAction(json);
  },
  jsonPut: async (path: string, body: any) => {
    const json = { put: { paths: [{ path: path, json: body }] } };
    return await api.jsonTreeAction(json);
  },
  jsonDel: async (path: string) => {
    const json = { del: { paths: [path] } };
    return await api.jsonTreeAction(json);
  },
  mainHarvest: async () => {
    const json = {
      harvest: { type: { main: null } }
    };
    return await api.goalView(json);
  },
  poolHarvest: async (pid: string) => {
    const json = {
      harvest: { type: { pid: pid } }
    };
    return await api.goalView(json);
  },
  goalHarvest: async (pid: string, gid: string) => {
    const json = {
      harvest: { type: { pid: pid, gid: gid } }
    };
    return await api.goalView(json);
  },
  createPool: async (title: string) => {
    const json = { 'create-pool': { title: title } };
    return await api.goalAction(json);
  },
  putCollection: async (path: string, keys: string[], themes: string[]) => {
    const json = {
      'put-collection': {
        path: path,
        collection: {
          keys: keys,
          themes: themes
        }
      }
    };
    return await api.goalAction(json);
  },
  delCollection: async (path: string) => {
    const json = { 'del-collection': { path :path } };
    return await api.goalAction(json);
  },
  createGoal: async (pid: string, upid: string | null, summary: string, actionable: boolean) => {
    const json = {
        'create-goal': {
          pid: pid,
          upid: upid,
          summary: summary,
          actionable: actionable
        }
      };
    const gid: string = await api.goalAction(json);
    return `${pid}${gid}`;
  },
  createGoalWithTag: async (pid: string, upid: string | null, summary: string, actionable: boolean, tag: string) => {
    const json = {
        'create-goal-with-tag': {
          pid: pid,
          upid: upid,
          summary: summary,
          actionable: actionable,
          tag: tag
        }
      };
    return await api.goalAction(json);
  },
  addGoalTag: async (key: string, isPublic: boolean, text: string) => {
    console.log(key);
    const json = isPublic
      ?  {
          'update-goal-tags': {
            key: key,
            method: 'uni',
            tags: [text]
          }
        }
      :  {
          'update-local-goal-tags': {
            key: key,
            method: 'uni',
            tags: [text]
          }
        };
    return await api.goalAction(json);
  },
  delGoalTag: async (key: string, isPublic: boolean, text: string) => {
    console.log(key);
    const json = isPublic
      ?  {
          'update-goal-tags': {
            key: key,
            method: 'dif',
            tags: [text]
          }
        }
      :  {
          'update-local-goal-tags': {
            key: key,
            method: 'dif',
            tags: [text]
          }
        };
    return await api.goalAction(json);
  },
  addLocalGoalTag: async (key: string, text: string) => {
    console.log(key);
    const json = {
        'update-local-goal-tags': {
          key: key,
          method: 'uni',
          tags: [text]
        }
      };
    return await api.goalAction(json);
  },
  delLocalGoalTag: async (key: string, text: string) => {
    console.log(key);
    const json = {
        'update-local-goal-tags': {
          key: key,
          method: 'dif',
          tags: [text]
        }
      };
    return await api.goalAction(json);
  },
  editPoolTitle: async (poolId: string, title: string) => {
    const json = {
        'update-pool-property': {
          pid: poolId,
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
          pid: poolId,
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
          pid: poolId,
          tag: tag,
          method: 'put',
          property: 'note',
          data: note,
        }
      };
    return await api.goalAction(json);
  },
  editLocalTagNote: async (tag: string, note: string) => {
    const json = {
        'update-local-tag-property': {
          tag: tag,
          method: 'put',
          property: 'note',
          data: note,
        }
      };
    return await api.goalAction(json);
  },
  setGoalSummary: async (pid: string, gid: string, summary: string) => {
    const json = {
        'set-summary': {
          pid: pid,
          gid: gid,
          summary: summary,
        }
      };
    return await api.goalAction(json);
  },
  setPoolTitle: async (poolId: string, title: string) => {
    const json = {
        'set-pool-title': {
          pid: poolId,
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
  setGoalComplete: async (pid: string, gid: string, complete: boolean) => {
    const json = complete
      ? { 'mark-complete': { pid: pid, gid: gid } }
      : { 'unmark-complete': { pid: pid, gid: gid } }
    return await api.goalAction(json);
  },
  setGoalActive: async (pid: string, gid: string, active: boolean) => {
    const json = active
      ? { 'mark-active': { pid: pid, gid: gid } }
      : { 'unmark-active': { pid: pid, gid: gid } }
    return await api.goalAction(json);
  },
  setGoalActionable: async (goalId: string, actionable: boolean) => {
    const json = actionable
      ? { 'mark-actionable': { id: goalId } }
      : { 'unmark-actionable': { id: goalId } }
    return await api.goalAction(json);
  },
  deleteGoal: async (pid: string, gid: string) => {
    const json = { 'delete-goal': { pid: pid, gid: gid } };
    return await api.goalAction(json);
  },
  deletePool: async (poolId: string) => {
    const json = { 'delete-pool': { pid: poolId } };
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
  getGoalData: async (keys: string[]) => {
    return await api.goalView({ "goal-data": { "keys": keys } });
  },
  getCollections: async () => {
    return await api.goalView({ "collections": null });
  },
  getCollection: async (path: string) => {
    return await api.goalView({ "path": path });
  },
  getPoolsIndex: async () => {
    return await api.goalView({ "pools-index": null });
  },
  getPoolRoots: async (id: string) => {
    return await api.goalView({ "pool-roots": { pid: id } });
  },
  getGoalYoung: async (pid:string, gid: string) => {
    return await api.goalView({ "goal-young": { pid: pid, gid: gid } });
  },
  getPoolTagGoals: async (pid: string, tag: string) => {
    return await api.goalView({ "pool-tag-goals": { pid: pid, tag: tag } });
  },
  getPoolTagHarvest: async (pid: string, tag: string) => {
    return await api.goalView({ "pool-tag-harvest": { pid: pid, tag: tag } });
  },
  getLocalTagGoals: async (tag: string) => {
    return await api.goalView({ "local-tag-goals": { tag: tag } });
  },
  getLocalTagHarvest: async (tag: string) => {
    return await api.goalView({ "local-tag-harvest": { tag: tag } });
  },
  getPoolTitle: async (pid: string) => {
    return await api.goalView({ "pool-title": { pid: pid } });
  },
  getPoolNote: async (pid: string) => {
    return await api.goalView({ "pool-note": { pid: pid } });
  },
  getPoolTagNote: async (pid: string, tag: string) => {
    return await api.goalView({ "pool-tag-note": { pid: pid, tag: tag } });
  },
  getLocalTagNote: async (tag: string) => {
    return await api.goalView({ "local-tag-note": { tag: tag } });
  },
  getGoalSummary: async (pid: string, gid: string) => {
    return await api.goalView({ "goal-summary": { pid: pid, gid: gid } });
  },
  getGoalNote: async (pid: string, gid: string) => {
    return await api.goalView({ "goal-note": { pid: pid, gid: gid } });
  },
  getGoalTags: async (pid: string, gid: string) => {
    return await api.goalView({ "goal-tags": { pid: pid, gid: gid } });
  },
  getLocalGoalTags: async (pid: string, gid: string) => {
    return await api.goalView({ "local-goal-tags": { pid: pid, gid: gid } });
  },
  getGoalParent: async (pid: string, gid: string) => {
    return await api.goalView({ "goal-parent": { pid: pid, gid: gid } });
  },
  getGoalActionable: async (pid: string, gid: string) => {
    return await api.goalView({ "goal-actionable": { pid: pid, gid: gid } });
  },
  getGoalComplete: async (pid: string, gid: string) => {
    return await api.goalView({ "goal-complete": { pid: pid, gid: gid } });
  },
  getGoalActive: async (pid: string, gid: string) => {
    return await api.goalView({ "goal-active": { pid: pid, gid: gid } });
  },
  getSetting: async (setting: string) => {
    console.log(`getting setting: ${setting}`)
    return await api.goalView({ "setting": { setting: setting } });
  },
  getPoolTags: async (pid: string) => {
    return await api.goalView({ "pool-tags": { pid: pid } });
  },
  getAllLocalGoalTags: async () => {
    return await api.goalView({ "all-local-goal-tags": null });
  },
};

export default api;