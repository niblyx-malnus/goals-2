export const goalKeyToPidGid = (key: string) => {
  console.log(`Splitting key: ${key}`);
  const parts = key.split('/').filter(Boolean);
  if (parts.length !== 3) {
    throw new Error('key must be in the format of /{host}/{name}/{id}');
  }
  const [host, name, gid] = parts;
  return { pid: `/${host}/${name}`, gid: `/${gid}` };
}

export const pidFromKey = (key: string) => {
  const { pid } = goalKeyToPidGid(key);
  return pid;
}

export const hostAndNameFromPid = (pid: string) => {
  console.log(`Splitting pid: ${pid}`);
  const parts = pid.split('/').filter(Boolean);
  if (parts.length !== 2) {
    throw new Error('pid must be in the format of /{host}/{name}');
  }
  const [host, name] = parts;
  return { host: host, name: name };
}

export const gidFromKey = (key: string) => {
  const { gid } = goalKeyToPidGid(key);
  return gid;
}