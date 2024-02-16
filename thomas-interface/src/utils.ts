export const goalKeyToPidGid = (path: string) => {
  console.log(`Splitting path: ${path}`);
  const parts = path.split('/').filter(Boolean);
  if (parts.length !== 3) {
    throw new Error('Path must be in the format of /{host}/{name}/{id}');
  }
  const [host, name, gid] = parts;
  return { pid: `/${host}/${name}`, gid: `/${gid}` };
}