import memoize from "lodash/memoize";
import Urbit from "@urbit/http-api";
import { goalKeyToPidGid, gidFromKey, hostAndNameFromPid } from './utils';

const live = process.env.REACT_APP_LIVE;
const proxy = live ? (window as any).ship : "mitpub-molreb-niblyx-malnus";
const api = {
  destination: proxy,
  setDestination: (newDestination: string) => {
    api.destination = newDestination;
    return api;
  },
  createApi: memoize(() => {
      const urb = live ? new Urbit("") : new Urbit("http://localhost:80", "");
      urb.ship = proxy;
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
        'as-pilot': vnt.asPilot,
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
      asPilot: api.destination !== proxy,
      ship: api.destination,
      dude: 'goals', // the agent to poke
      inputDesk: 'goals', // where does the input mark live
      inputMark: 'goals-view', // name of input mark
      outputDesk: 'goals', // where does the output mark live
      outputMark: 'json', // name of output mark
      body: json, // the actual poke content
    }, 'goals');
  },
  goalPoolAction: async (pid: string, json: any) => {
    return await api.vent({
      asPilot: api.destination !== proxy,
      ship: api.destination,
      dude: 'goals', // the agent to poke
      inputDesk: 'goals', // where does the input mark live
      inputMark: 'goals-pool-action', // name of input mark
      outputDesk: 'goals', // where does the output mark live
      outputMark: 'json', // name of output mark
      body: { pid: pid, axn: json }, // the actual poke content
    }, 'goals');
  },
  goalLocalAction: async (json: any) => {
    return await api.vent({
      asPilot: api.destination !== proxy,
      ship: api.destination,
      dude: 'goals', // the agent to poke
      inputDesk: 'goals', // where does the input mark live
      inputMark: 'goals-local-action', // name of input mark
      outputDesk: 'goals', // where does the output mark live
      outputMark: 'json', // name of output mark
      body: json, // the actual poke content
    }, 'goals');
  },
  jsonTreeAction: async (json: any) => {
    return await api.vent({
      asPilot: api.destination !== proxy,
      ship: api.destination,
      dude: 'json-tree', // the agent to poke
      inputDesk: 'goals', // where does the input mark live
      inputMark: 'json-tree-action', // name of input mark
      outputDesk: 'goals', // where does the output mark live
      outputMark: 'json', // name of output mark
      body: json, // the actual poke content
    }, 'goals');
  },
  poolMembershipAction: async (pid: string, json: any) => {
    return await api.vent({
      asPilot: api.destination !== proxy,
      ship: api.destination,
      dude: 'goals', // the agent to poke
      inputDesk: 'goals', // where does the input mark live
      inputMark: 'goals-pool-membership-action', // name of input mark
      outputDesk: 'goals', // where does the output mark live
      outputMark: 'json', // name of output mark
      body: { pid: pid, axn: json }, // the actual poke content
    }, 'goals');
  },
  localMembershipAction: async (json: any) => {
    return await api.vent({
      asPilot: api.destination !== proxy,
      ship: api.destination,
      dude: 'goals', // the agent to poke
      inputDesk: 'goals', // where does the input mark live
      inputMark: 'goals-local-membership-action', // name of input mark
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
    return await api.goalView(json);
  },
  poolEmptyGoals: async (pid: string) => {
    const json = {
      'empty-goals': { type: { pool: pid } }
    };
    return await api.goalView(json);
  },
  goalEmptyGoals: async (key: string) => {
    const json = {
      'empty-goals': { type: { goal: key } }
    };
    return await api.goalView(json);
  },
  mainHarvest: async () => {
    const json = {
      harvest: { type: { main: null } }
    };
    return await api.goalView(json);
  },
  poolHarvest: async (pid: string) => {
    const json = {
      harvest: { type: { pool: pid } }
    };
    return await api.goalView(json);
  },
  goalHarvest: async (key: string) => {
    const json = {
      harvest: { type: { goal: key } }
    };
    return await api.goalView(json);
  },
  createPool: async (title: string) => {
    const json = { 'create-pool': { title: title } };
    return await api.goalLocalAction(json);
  },
  createGoal: async (pid: string, upid: string | null, summary: string, actionable: boolean, active: boolean) => {
    const json = {
        'create-goal': {
          upid: upid,
          summary: summary,
          actionable: actionable,
          active: active
        }
      };
    console.log(json);
    return await api.goalPoolAction(pid, json);
  },
  addGoalLabel: async (key: string, label: string, labels: string[]) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = {
        'update-goal-metadata': {
          gid: gid,
          method: 'put',
          field: 'labels',
          data: JSON.stringify([label, ...labels]),
        }
      }
    return await api.goalPoolAction(pid, json);
  },
  addGoalTag: async (key: string, tag: string, tags: string[]) => {
    console.log(key);
    const json = {
        'goal-metadata': {
          key: key,
          method: 'put',
          field: 'labels',
          data: JSON.stringify([tag, ...tags]),
        }
      }
    return await api.goalLocalAction(json);
  },
  delGoalLabel: async (key: string, label: string, labels: string[]) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = {
        'update-goal-metadata': {
          gid: gid,
          method: 'put',
          field: 'labels',
          data: JSON.stringify(labels.filter(l => l !== label)),
        }
      }
    return await api.goalPoolAction(pid, json);
  },
  delGoalTag: async (key: string, tag: string, tags: string[]) => {
    console.log(key);
    const json = {
        'goal-metadata': {
          key: key,
          method: 'put',
          field: 'labels',
          data: JSON.stringify(tags.filter(t => t !== tag)),
        }
      }
    return await api.goalLocalAction(json);
  },
  editPoolTitle: async (pid: string, title: string) => {
    const json = {
        'update-pool-property': {
          method: 'put',
          property: 'title',
          data: title,
        }
      };
    return await api.goalPoolAction(pid, json);
  },
  editPoolNote: async (pid: string, note: string) => {
    const json = {
        'update-pool-property': {
          method: 'put',
          property: 'note',
          data: note,
        }
      };
    return await api.goalPoolAction(pid, json);
  },
  editPoolTagNote: async (pid: string, tag: string, note: string) => {
    const json = {
        'update-pool-tag-property': {
          tag: tag,
          method: 'put',
          property: 'note',
          data: note,
        }
      };
    return await api.goalPoolAction(pid, json);
  },
  editLocalTagNote: async (tag: string, note: string) => {
    console.log("outdated");
  },
  setGoalSummary: async (key: string, summary: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = {
        'set-summary': {
          gid: gid,
          summary: summary,
        }
      };
    return await api.goalPoolAction(pid, json);
  },
  setGoalChief: async (key: string, chief: string, rec: boolean) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = {
        'set-chief': {
          gid: gid,
          chief: chief,
          rec: rec
        }
      };
    return await api.goalPoolAction(pid, json);
  },
  setGoalOpenTo: async (key: string, openTo: string | null) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'set-open-to': { gid: gid, 'open-to': openTo, } };
    return await api.goalPoolAction(pid, json);
  },
  reorderArchive: async (pid: string, context: string | null, archive: string[]) => {
    const json = { 'reorder-archive': { context: context, archive: archive }};
    return await api.goalPoolAction(pid, json);
  },
  reorderRoots: async (pid: string, roots: string[]) => {
    const json = { 'reorder-roots': { roots: roots }};
    return await api.goalPoolAction(pid, json);
  },
  reorderChildren: async (key: string, children: string[]) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'reorder-children': { gid: gid, children: children }};
    return await api.goalPoolAction(pid, json);
  },
  reorderBorrowed: async (key: string, borrowed: string[]) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'reorder-borrowed': { gid: gid, borrowed: borrowed }};
    return await api.goalPoolAction(pid, json);
  },
  reorderBorrowedBy: async (key: string, borrowedBy: string[]) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'reorder-borrowed-by': { gid: gid, 'borrowed-by': borrowedBy }};
    return await api.goalPoolAction(pid, json);
  },
  setPoolTitle: async (pid: string, title: string) => {
    const json = { 'set-pool-title': { title: title, } };
    return await api.goalPoolAction(pid, json);
  },
  putLocalFieldProperty: async (field: string, property: string, data: any) => {
    const json = {
        'metadata-properties': {
          field: field,
          method: 'put',
          property: property,
          data: data,
        }
      };
    return await api.goalLocalAction(json);
  },
  delLocalFieldProperty: async (field: string, property: string) => {
    const json = {
        'metadata-properties': {
          field: field,
          method: 'del',
          property: property,
        }
      };
    return await api.goalLocalAction(json);
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
    return await api.goalLocalAction(json);
  },
  delPoolFieldProperty: async (field: string, property: string) => {
    const json = {
        'update-pool-field-property': {
          field: field,
          method: 'del',
          property: property,
        }
      };
    return await api.goalLocalAction(json);
  },
  putLocalGoalField: async (key: string, field: string, data: any) => {
    const json = {
        'goal-metadata': {
          key: key,
          method: 'put',
          field: field,
          data: data,
        }
      };
    return await api.goalLocalAction(json);
  },
  delLocalGoalField: async (key: string, field: string) => {
    const json = {
        'goal-metadata': {
          key: key,
          method: 'del',
          field: field,
        }
      };
    return await api.goalLocalAction(json);
  },
  delLocalField: async (field: string) => {
    const json = { 'metadata-properties': { field: field, } };
    return await api.goalLocalAction(json);
  },
  putGoalField: async (key: string, field: string, data: any) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = {
        'update-goal-metadata': {
          gid: gid,
          method: 'put',
          field: field,
          data: data,
        }
      };
    return await api.goalPoolAction(pid, json);
  },
  delGoalField: async (key: string, field: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = {
        'update-goal-metadata': {
          gid: gid,
          method: 'del',
          field: field,
        }
      };
    return await api.goalPoolAction(pid, json);
  },
  editGoalNote: async (key: string, note: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = {
        'update-goal-field': {
          gid: gid,
          method: 'put',
          field: 'note',
          data: note,
        }
      };
    return await api.goalPoolAction(pid, json);
  },
  setGoalComplete: async (key: string, complete: boolean) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'set-complete': { gid: gid, val: complete } };
    return await api.goalPoolAction(pid, json);
  },
  setGoalActive: async (key: string, active: boolean) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'set-active': { gid: gid, val: active } };
    return await api.goalPoolAction(pid, json);
  },
  setGoalActionable: async (key: string, actionable: boolean) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'set-actionable': { gid: gid, val: actionable } };
    return await api.goalPoolAction(pid, json);
  },
  archiveGoal: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'archive-goal': { gid: gid } };
    return await api.goalPoolAction(pid, json);
  },
  restoreGoal: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'restore-goal': { gid: gid } };
    return await api.goalPoolAction(pid, json);
  },
  restoreToRoot: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'restore-to-root': { gid: gid } };
    return await api.goalPoolAction(pid, json);
  },
  deleteFromArchive: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'delete-from-archive': { gid: gid } };
    return await api.goalPoolAction(pid, json);
  },
  deleteGoal: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const json = { 'delete-goal': { gid: gid } };
    return await api.goalPoolAction(pid, json);
  },
  deletePool: async (pid: string) => {
    const json = { 'delete-pool': { pid: pid } };
    return await api.goalLocalAction(json);
  },
  poolsSlotAbove: async (dis: string, dat: string) => {
    const json = { 'pools-slot-above': { dis: dis, dat: dat } };
    return await api.goalLocalAction(json);
  },
  poolsSlotBelow: async (dis: string, dat: string) => {
    const json = { 'pools-slot-below': { dis: dis, dat: dat } };
    return await api.goalLocalAction(json);
  },
  goalsSlotAbove: async (dis: string, dat: string) => {
    const json = { 'goals-slot-above': { dis: dis, dat: dat } };
    return await api.goalLocalAction(json);
  },
  goalsSlotBelow: async (dis: string, dat: string) => {
    const json = { 'goals-slot-below': { dis: dis, dat: dat } };
    return await api.goalLocalAction(json);
  },
  setPoolsIndex: async (pools: string[]) => {
    const json = { 'reorder-pools': { pools: pools, } };
    return await api.goalLocalAction(json);
  },
  move: async (key: string, upid: string | null) => {
    const { pid, gid } = goalKeyToPidGid(key);
    const par = upid ? gidFromKey(upid) : null;
    const json = { 'move': { cid: gid, upid: par } };
    return await api.goalPoolAction(pid, json);
  },
  loan: async (lKey: string, rKey: string) => {
    const { pid, gid } = goalKeyToPidGid(lKey);
    const rid = gidFromKey(rKey);
    const json = {
        'yoke': {
          yoks: [
            { yoke: 'nest-yoke', lid: gid, rid: rid },
          ],
        }
      }
    return await api.goalPoolAction(pid, json);
  },
  unloan: async (lKey: string, rKey: string) => {
    const { pid, gid } = goalKeyToPidGid(lKey);
    const rid = gidFromKey(rKey);
    const json = {
        'yoke': {
          yoks: [
            { yoke: 'nest-rend', lid: gid, rid: rid },
          ],
        }
      }
    return await api.goalPoolAction(pid, json);
  },
  blockHost: async (ship: string) => {
    const json = {
        'update-blocked': {
          method: 'uni',
          pools: [],
          hosts: [ship],
        }
      };
    return await api.localMembershipAction(json);
  },
  unblockHost: async (ship: string) => {
    const json = {
        'update-blocked': {
          method: 'dif',
          pools: [],
          hosts: [ship.substring(1)],
        }
      };
    return await api.localMembershipAction(json);
  },
  blockPool: async (pid: string) => {
    const json = {
        'update-blocked': {
          method: 'uni',
          pools: [pid],
          hosts: [],
        }
      };
    return await api.localMembershipAction(json);
  },
  unblockPool: async (pid: string) => {
    const json = {
        'update-blocked': {
          method: 'dif',
          pools: [pid],
          hosts: [],
        }
      };
    return await api.localMembershipAction(json);
  },
  blacklistShip: async (pid: string, ship: string) => {
    const json = {
        'update-graylist': {
          fields: [ { ship: [{ ship: ship, auto: false }] }, ],
        }
      };
    return await api.poolMembershipAction(pid, json);
  },
  whitelistShip: async (pid: string, ship: string) => {
    const json = {
        'update-graylist': {
          fields: [ { ship: [{ ship: ship, auto: true }] }, ],
        }
      };
    return await api.poolMembershipAction(pid, json);
  },
  unlistShip: async (pid: string, ship: string) => {
    const json = {
        'update-graylist': {
          fields: [ { ship: [{ ship: ship.substring(1), auto: null }] }, ],
        }
      };
    return await api.poolMembershipAction(pid, json);
  },
  blacklistRank: async (pid: string, rank: string) => {
    const json = {
        'update-graylist': {
          fields: [ { rank: [{ rank: rank, auto: false }] }, ],
        }
      };
    return await api.poolMembershipAction(pid, json);
  },
  whitelistRank: async (pid: string, rank: string) => {
    const json = {
        'update-graylist': {
          fields: [ { rank: [{ rank: rank, auto: true }] }, ],
        }
      };
    return await api.poolMembershipAction(pid, json);
  },
  unlistRank: async (pid: string, rank: string) => {
    const json = {
        'update-graylist': {
          fields: [ { rank: [{ rank: rank, auto: null }] }, ],
        }
      };
    return await api.poolMembershipAction(pid, json);
  },
  setPoolPublic: async (pid: string) => {
    const json = {
        'update-graylist': {
          pid: pid,
          fields: [ { rest: true }, ],
        }
      };
    return await api.poolMembershipAction(pid, json);
  },
  setPoolPrivate: async (pid: string) => {
    const json = {
        'update-graylist': {
          pid: pid,
          fields: [ { rest: null }, ],
        }
      };
    return await api.poolMembershipAction(pid, json);
  },
  setPoolSecret: async (pid: string) => {
    const json = {
        'update-graylist': {
          pid: pid,
          fields: [ { rest: false }, ],
        }
      };
    return await api.poolMembershipAction(pid, json);
  },
  extendInvite: async (pid: string, invitee: string) => {
    const json = { 'extend-invite': { invitee: invitee, } }
    return await api.poolMembershipAction(pid, json);
  },
  cancelInvite: async (pid: string, invitee: string) => {
    const json = { 'cancel-invite': { invitee: invitee.substring(1), } }
    return await api.poolMembershipAction(pid, json);
  },
  rejectInvite: async (pid: string) => {
    const json = { 'reject-invite': { pid: pid } }
    return await api.localMembershipAction(json);
  },
  acceptInvite: async (pid: string) => {
    const json = { 'accept-invite': { pid: pid } }
    return await api.localMembershipAction(json);
  },
  deleteInvite: async (pid: string) => {
    const json = { 'delete-invite': { pid: pid } }
    return await api.localMembershipAction(json);
  },
  extendRequest: async ( pid: string) => {
    const json = { 'extend-request': { pid: pid } }
    return await api.localMembershipAction(json);
  },
  cancelRequest: async ( pid: string) => {
    const json = { 'cancel-request': { pid: pid } }
    return await api.localMembershipAction(json);
  },
  rejectRequest: async (pid: string, requester: string) => {
    const json = { 'reject-request': { requester: requester.substring(1) } }
    return await api.poolMembershipAction(pid, json);
  },
  acceptRequest: async (pid: string, requester: string) => {
    const json = { 'accept-request': { requester: requester.substring(1) } }
    return await api.poolMembershipAction(pid, json);
  },
  deleteRequest: async (pid: string, requester: string) => {
    const json = { 'delete-request': { requester: requester.substring(1) } }
    return await api.poolMembershipAction(pid, json);
  },
  kickMember: async (pid: string, member: string) => {
    const json = { 'kick-member': { member: member.substring(1) } }
    return await api.poolMembershipAction(pid, json);
  },
  setPoolRole: async (pid: string, member: string, role: string) => {
    const json = {
      'set-pool-role': {
        member: member.substring(1),
        role: role
      }
    }
    console.log(json);
    return await api.poolMembershipAction(pid, json);
  },
  leavePool: async (pid: string) => {
    const json = { 'leave-pool': { pid: pid } }
    return await api.localMembershipAction(json);
  },
  watchPool: async (pid: string) => {
    const json = { 'watch-pool': { pid: pid } }
    return await api.localMembershipAction(json);
  },
  updateSetting: async (method: string, setting: string, contents: string) => {
    const json = {
        'update-setting': {
          method: method,
          setting: setting,
          contents: contents
        }
      };
    return await api.goalLocalAction(json);
  },
  getGoalData: async (keys: string[]) => {
    return await api.goalView({ "goal-data": { "keys": keys } });
  },
  getSingleGoal: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    return await api.goalView({ "goal": {pid: pid, gid: gid} })
  },
  getSingleArchiveGoal: async (pid: string, rid: string, gid: string) => {
    return await api.goalView({ "archive-goal": {pid: pid, rid: rid, gid: gid} })
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
  getPoolRoots: async (pid: string) => {
    return await api.goalView({ "pool-roots": { pid: pid } });
  },
  getPoolArchive: async (pid: string) => {
    return await api.goalView({ "pool-archive": { pid: pid } });
  },
  getArchiveGoalChildren: async (pid:string, rid: string, gid: string) => {
    return await api.goalView({ "archive-goal-children": { pid: pid, rid: rid, gid: gid } });
  },
  getArchiveGoalBorrowed: async (pid:string, rid: string, gid: string) => {
    return await api.goalView({ "archive-goal-borrowed": { pid: pid, rid: rid, gid: gid } });
  },
  getArchiveGoalBorrowedBy: async (pid:string, rid: string, gid: string) => {
    return await api.goalView({ "archive-goal-borrowed-by": { pid: pid, rid: rid, gid: gid } });
  },
  getArchiveGoalLineage: async (pid:string, rid: string, gid: string) => {
    return await api.goalView({ "archive-goal-lineage": { pid: pid, rid: rid, gid: gid } });
  },
  getArchiveGoalProgress: async (pid:string, rid: string, gid: string) => {
    return await api.goalView({ "archive-goal-progress": { pid: pid, rid: rid, gid: gid } });
  },
  getArchiveGoalHarvest: async (pid:string, rid: string, gid: string) => {
    return await api.goalView({ "archive-goal-harvest": { pid: pid, rid: rid, gid: gid } });
  },
  getArchiveGoalEmptyGoals: async (pid:string, rid: string, gid: string) => {
    return await api.goalView({ "archive-goal-empty-goals": { pid: pid, rid: rid, gid: gid } });
  },
  getGoalChildren: async (pid:string, gid: string) => {
    return await api.goalView({ "goal-children": { pid: pid, gid: gid } });
  },
  goalLineage: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    return await api.goalView({ "goal-lineage": { pid: pid, gid: gid } });
  },
  goalProgress: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    return await api.goalView({ "goal-progress": { pid: pid, gid: gid } });
  },
  getGoalBorrowed: async (pid:string, gid: string) => {
    return await api.goalView({ "goal-borrowed": { pid: pid, gid: gid } });
  },
  getGoalArchive: async (pid:string, gid: string) => {
    return await api.goalView({ "goal-archive": { pid: pid, gid: gid } });
  },
  getGoalBorrowedBy: async (pid:string, gid: string) => {
    return await api.goalView({ "goal-borrowed-by": { pid: pid, gid: gid } });
  },
  getLabelGoals: async (pid: string, label: string) => {
    return await api.goalView({ "pool-tag-goals": { pid: pid, tag: label } });
  },
  getLabelHarvest: async (pid: string, label: string) => {
    return await api.goalView({ "pool-tag-harvest": { pid: pid, tag: label } });
  },
  getTagGoals: async (tag: string) => {
    return await api.goalView({ "local-tag-goals": { tag: tag } });
  },
  getTagHarvest: async (tag: string) => {
    return await api.goalView({ "local-tag-harvest": { tag: tag } });
  },
  getPoolTitle: async (pid: string) => {
    return await api.goalView({ "pool-title": { pid: pid } });
  },
  getPoolNote: async (pid: string) => {
    return await api.goalView({ "pool-note": { pid: pid } });
  },
  getPoolPerms: async (pid: string) => {
    return await api.goalView({ "pool-perms": { pid: pid } });
  },
  getLabelNote: async (pid: string, label: string) => {
    return await api.goalView({ "pool-tag-note": { pid: pid, tag: label } });
  },
  getTagNote: async (tag: string) => {
    return await api.goalView({ "local-tag-note": { tag: tag } });
  },
  getGoalParent: async (key: string) => {
    const { pid, gid } = goalKeyToPidGid(key);
    return await api.goalView({ "goal-parent": { pid: pid, gid: gid } });
  },
  getSetting: async (setting: string) => {
    console.log(`getting setting: ${setting}`)
    return await api.goalView({ "setting": { setting: setting } });
  },
  getPoolLabels: async (pid: string) => {
    return await api.goalView({ "pool-tags": { pid: pid } });
  },
  getPoolAttributes: async (pid: string) => {
    return await api.goalView({ "pool-tags": { pid: pid } });
  },
  getOutgoingInvites: async (pid: string) => {
    return await api.goalView({ "outgoing-invites": { pid: pid } });
  },
  getIncomingInvites: async () => {
    return await api.goalView({ "incoming-invites": null });
  },
  getIncomingRequests: async (pid: string) => {
    return await api.goalView({ "incoming-requests": { pid: pid } });
  },
  getOutgoingRequests: async () => {
    return await api.goalView({ "outgoing-requests": null });
  },
  getAllTags: async () => {
    return await api.goalView({ "local-goal-tags": null });
  },
  getAllFields: async () => {
    return await api.goalView({ "local-goal-fields": null });
  },
  getPoolGraylist: async (pid: string) => {
    return await api.goalView({ "pool-graylist": { pid: pid } });
  },
  getLocalBlocked: async () => {
    return await api.goalView({ "local-blocked": null });
  },
  getLocalPools: async () => {
    return await api.goalView({ "local-pools": null });
  },
  getRemotePools: async () => {
    return await api.goalView({ "remote-pools": null });
  },
  getAllPools: async () => {
    return await api.goalView({ "all-pools": null });
  },
  discover: async (ship: string) => {
    return await api.goalView({ "discover": { ship: ship } });
  },
  publicData: async (pid: string) => {
    return await api.goalView({ "public-data": { pid: pid } });
  },
  palsTargets: async () => {
    return await api.goalView({ "pals-targets": null });
  },
};

export default api;