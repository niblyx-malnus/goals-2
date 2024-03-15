import memoize from "lodash/memoize";
import Urbit from "@urbit/http-api";
import { goalKeyToPidGid, gidFromKey } from './utils';

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
  goalView: async (ship: string, json: any) => {
    return await api.vent({
      ship: ship,
      dude: 'goals', // the agent to poke
      inputDesk: 'goals', // where does the input mark live
      inputMark: 'goal-view', // name of input mark
      outputDesk: 'goals', // where does the output mark live
      outputMark: 'json', // name of output mark
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
      outputMark: 'json', // name of output mark
      body: json, // the actual poke content
    }, 'goals');
  },
  jsonTreeAction: async (json: any) => {
    return await api.vent({
      ship: live ? (window as any).ship : ship,
      dude: 'json-tree', // the agent to poke
      inputDesk: 'goals', // where does the input mark live
      inputMark: 'json-tree-action', // name of input mark
      outputDesk: 'goals', // where does the output mark live
      outputMark: 'json', // name of output mark
      body: json, // the actual poke content
    }, 'goals');
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
  mainEmptyGoals: async () => {
    const json = {
      'empty-goals': { type: { main: null } }
    };
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, json);
  },
  poolEmptyGoals: async (pid: string) => {
    const json = {
      'empty-goals': { type: { pool: pid } }
    };
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, json);
  },
  goalEmptyGoals: async (key: string) => {
    const json = {
      'empty-goals': { type: { goal: key } }
    };
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, json);
  },
  mainHarvest: async () => {
    const json = {
      harvest: { type: { main: null } }
    };
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, json);
  },
  poolHarvest: async (pid: string) => {
    const json = {
      harvest: { type: { pool: pid } }
    };
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, json);
  },
  goalHarvest: async (key: string) => {
    const json = {
      harvest: { type: { goal: key } }
    };
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, json);
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
  createGoal: async (pid: string, upid: string | null, summary: string, actionable: boolean, active: boolean) => {
    const json = {
        'create-goal': {
          pid: pid,
          upid: upid,
          summary: summary,
          actionable: actionable,
          active: active
        }
      };
    return await api.goalAction(json);
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
  addGoalLabel: async (key: string, label: string, labels: string[]) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = {
        'update-goal-metadata': {
          pid: pid,
          gid: gid,
          method: 'put',
          field: 'labels',
          data: JSON.stringify([label, ...labels]),
        }
      }
    return await api.goalAction(json);
  },
  addGoalTag: async (key: string, tag: string, tags: string[]) => {
    console.log(key);
    const json = {
        'update-local-goal-metadata': {
          key: key,
          method: 'put',
          field: 'labels',
          data: JSON.stringify([tag, ...tags]),
        }
      }
    return await api.goalAction(json);
  },
  delGoalLabel: async (key: string, label: string, labels: string[]) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = {
        'update-goal-metadata': {
          pid: pid,
          gid: gid,
          method: 'put',
          field: 'labels',
          data: JSON.stringify(labels.filter(l => l !== label)),
        }
      }
    return await api.goalAction(json);
  },
  delGoalTag: async (key: string, tag: string, tags: string[]) => {
    console.log(key);
    const json = {
        'update-local-goal-metadata': {
          key: key,
          method: 'put',
          field: 'labels',
          data: JSON.stringify(tags.filter(t => t !== tag)),
        }
      }
    return await api.goalAction(json);
  },
  editPoolTitle: async (pid: string, title: string) => {
    const json = {
        'update-pool-property': {
          pid: pid,
          method: 'put',
          property: 'title',
          data: title,
        }
      };
    return await api.goalAction(json);
  },
  editPoolNote: async (pid: string, note: string) => {
    const json = {
        'update-pool-property': {
          pid: pid,
          method: 'put',
          property: 'note',
          data: note,
        }
      };
    return await api.goalAction(json);
  },
  editPoolTagNote: async (pid: string, tag: string, note: string) => {
    const json = {
        'update-pool-tag-property': {
          pid: pid,
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
  setGoalSummary: async (key: string, summary: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = {
        'set-summary': {
          pid: pid,
          gid: gid,
          summary: summary,
        }
      };
    return await api.goalAction(json);
  },
  reorderArchive: async (pid: string, context: string | null, archive: string[]) => {
    const json = { 'reorder-archive': { pid: pid, context: context, archive: archive }};
    return await api.goalAction(json);
  },
  reorderRoots: async (pid: string, roots: string[]) => {
    const json = { 'reorder-roots': { pid: pid, roots: roots }};
    return await api.goalAction(json);
  },
  reorderChildren: async (key: string, children: string[]) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'reorder-children': { pid: pid, gid: gid, children: children }};
    return await api.goalAction(json);
  },
  reorderBorrowed: async (key: string, borrowed: string[]) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'reorder-borrowed': { pid: pid, gid: gid, borrowed: borrowed }};
    return await api.goalAction(json);
  },
  reorderBorrowedBy: async (key: string, borrowedBy: string[]) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'reorder-borrowed-by': { pid: pid, gid: gid, 'borrowed-by': borrowedBy }};
    return await api.goalAction(json);
  },
  setPoolTitle: async (pid: string, title: string) => {
    const json = {
        'set-pool-title': {
          pid: pid,
          title: title,
        }
      };
    return await api.goalAction(json);
  },
  addLocalFieldProperty: async (field: string, property: string, data: any) => {
    const json = {
        'update-local-metadata-field': {
          field: field,
          method: 'put',
          property: property,
          data: data,
        }
      };
    return await api.goalAction(json);
  },
  putLocalFieldProperty: async (field: string, property: string, data: any) => {
    const json = {
        'update-local-metadata-field': {
          field: field,
          method: 'put',
          property: property,
          data: data,
        }
      };
    return await api.goalAction(json);
  },
  delLocalFieldProperty: async (field: string, property: string) => {
    const json = {
        'update-local-metadata-field': {
          field: field,
          method: 'del',
          property: property,
        }
      };
    return await api.goalAction(json);
  },
  putPoolFieldProperty: async (field: string, property: string, data: any) => {
    const json = {
        'update-pool-field-property': {
          field: field,
          method: 'put',
          property: property,
          data: data,
        }
      };
    return await api.goalAction(json);
  },
  delPoolFieldProperty: async (field: string, property: string) => {
    const json = {
        'update-pool-field-property': {
          field: field,
          method: 'del',
          property: property,
        }
      };
    return await api.goalAction(json);
  },
  putLocalGoalField: async (key: string, field: string, data: any) => {
    const json = {
        'update-local-goal-metadata': {
          key: key,
          method: 'put',
          field: field,
          data: data,
        }
      };
    return await api.goalAction(json);
  },
  delLocalGoalField: async (key: string, field: string) => {
    const json = {
        'update-local-goal-metadata': {
          key: key,
          method: 'del',
          field: field,
        }
      };
    return await api.goalAction(json);
  },
  delLocalField: async (field: string) => {
    const json = { 'delete-local-metadata-field': { field: field, } };
    return await api.goalAction(json);
  },
  putGoalField: async (key: string, field: string, data: any) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = {
        'update-goal-metadata': {
          pid: pid,
          gid: gid,
          method: 'put',
          field: field,
          data: data,
        }
      };
    return await api.goalAction(json);
  },
  delGoalField: async (key: string, field: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = {
        'update-goal-metadata': {
          pid: pid,
          gid: gid,
          method: 'del',
          field: field,
        }
      };
    return await api.goalAction(json);
  },
  editGoalNote: async (key: string, note: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = {
        'update-goal-field': {
          pid: pid,
          gid: gid,
          method: 'put',
          field: 'note',
          data: note,
        }
      };
    return await api.goalAction(json);
  },
  setGoalComplete: async (key: string, complete: boolean) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'set-complete': { pid: pid, gid: gid, val: complete } };
    return await api.goalAction(json);
  },
  setGoalActive: async (key: string, active: boolean) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'set-active': { pid: pid, gid: gid, val: active } };
    return await api.goalAction(json);
  },
  setGoalActionable: async (key: string, actionable: boolean) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'set-actionable': {pid: pid, gid: gid, val: actionable } };
    return await api.goalAction(json);
  },
  archiveGoal: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'archive-goal': { pid: pid, gid: gid } };
    return await api.goalAction(json);
  },
  restoreGoal: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'restore-goal': { pid: pid, gid: gid } };
    return await api.goalAction(json);
  },
  restoreToRoot: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'restore-to-root': { pid: pid, gid: gid } };
    return await api.goalAction(json);
  },
  deleteFromArchive: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'delete-from-archive': { pid: pid, gid: gid } };
    return await api.goalAction(json);
  },
  deleteGoal: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'delete-goal': { pid: pid, gid: gid } };
    return await api.goalAction(json);
  },
  deletePool: async (pid: string) => {
    const json = { 'delete-pool': { pid: pid } };
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
  move: async (key: string, upid: string | null) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const par = upid ? gidFromKey(upid) : null;
    const json = { 'move': { pid: pid, cid: gid, upid: par } };
    return await api.goalAction(json);
  },
  loan: async (lKey: string, rKey: string) => {
    const { pid, gid } = goalKeyToPidGid(lKey);
    const rid = gidFromKey(rKey);
    const json = {
        'yoke': {
          pid: pid,
          yoks: [
            { yoke: 'nest-yoke', lid: gid, rid: rid },
          ],
        }
      }
    return await api.goalAction(json);
  },
  unloan: async (lKey: string, rKey: string) => {
    const { pid, gid } = goalKeyToPidGid(lKey);
    const rid = gidFromKey(rKey);
    const json = {
        'yoke': {
          pid: pid,
          yoks: [
            { yoke: 'nest-rend', lid: gid, rid: rid },
          ],
        }
      }
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
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "goal-data": { "keys": keys } });
  },
  getSingleGoal: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "goal": {pid: pid, gid: gid} })
  },
  getSingleArchiveGoal: async (pid: string, rid: string, gid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "archive-goal": {pid: pid, rid: rid, gid: gid} })
  },
  getCollections: async () => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "collections": null });
  },
  getCollection: async (path: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "path": path });
  },
  getPoolsIndex: async () => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "pools-index": null });
  },
  getPoolRoots: async (pid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "pool-roots": { pid: pid } });
  },
  getPoolArchive: async (pid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "pool-archive": { pid: pid } });
  },
  getArchiveGoalChildren: async (pid:string, rid: string, gid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "archive-goal-children": { pid: pid, rid: rid, gid: gid } });
  },
  getArchiveGoalBorrowed: async (pid:string, rid: string, gid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "archive-goal-borrowed": { pid: pid, rid: rid, gid: gid } });
  },
  getArchiveGoalBorrowedBy: async (pid:string, rid: string, gid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "archive-goal-borrowed-by": { pid: pid, rid: rid, gid: gid } });
  },
  getArchiveGoalLineage: async (pid:string, rid: string, gid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "archive-goal-lineage": { pid: pid, rid: rid, gid: gid } });
  },
  getArchiveGoalProgress: async (pid:string, rid: string, gid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "archive-goal-progress": { pid: pid, rid: rid, gid: gid } });
  },
  getArchiveGoalHarvest: async (pid:string, rid: string, gid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "archive-goal-harvest": { pid: pid, rid: rid, gid: gid } });
  },
  getArchiveGoalEmptyGoals: async (pid:string, rid: string, gid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "archive-goal-empty-goals": { pid: pid, rid: rid, gid: gid } });
  },
  getGoalChildren: async (pid:string, gid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "goal-children": { pid: pid, gid: gid } });
  },
  goalLineage: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "goal-lineage": { pid: pid, gid: gid } });
  },
  goalProgress: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "goal-progress": { pid: pid, gid: gid } });
  },
  getGoalBorrowed: async (pid:string, gid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "goal-borrowed": { pid: pid, gid: gid } });
  },
  getGoalArchive: async (pid:string, gid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "goal-archive": { pid: pid, gid: gid } });
  },
  getGoalBorrowedBy: async (pid:string, gid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "goal-borrowed-by": { pid: pid, gid: gid } });
  },
  getLabelGoals: async (pid: string, label: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "pool-tag-goals": { pid: pid, tag: label } });
  },
  getLabelHarvest: async (pid: string, label: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "pool-tag-harvest": { pid: pid, tag: label } });
  },
  getTagGoals: async (tag: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "local-tag-goals": { tag: tag } });
  },
  getTagHarvest: async (tag: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "local-tag-harvest": { tag: tag } });
  },
  getPoolTitle: async (pid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "pool-title": { pid: pid } });
  },
  getPoolNote: async (pid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "pool-note": { pid: pid } });
  },
  getPoolPerms: async (pid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "pool-perms": { pid: pid } });
  },
  getLabelNote: async (pid: string, label: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "pool-tag-note": { pid: pid, tag: label } });
  },
  getTagNote: async (tag: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "local-tag-note": { tag: tag } });
  },
  getGoalParent: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "goal-parent": { pid: pid, gid: gid } });
  },
  getSetting: async (setting: string) => {
    console.log(`getting setting: ${setting}`)
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "setting": { setting: setting } });
  },
  getPoolLabels: async (pid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "pool-tags": { pid: pid } });
  },
  getPoolAttributes: async (pid: string) => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "pool-tags": { pid: pid } });
  },
  getAllTags: async () => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "local-goal-tags": null });
  },
  getAllFields: async () => {
    const patp = live ? (window as any).ship : ship;
    return await api.goalView(patp, { "local-goal-fields": null });
  },
};

export default api;