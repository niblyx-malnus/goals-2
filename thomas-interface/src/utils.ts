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

export const gidFromKey = (key: string) => {
  const { gid } = goalKeyToPidGid(key);
  return gid;
}