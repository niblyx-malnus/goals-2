/-  *action
/+  j=gol-cli-json
|_  vyu=goal-view
++  grow
  |%
  ++  noun  vyu
  --
++  grab
  |%
  ++  noun  goal-view
  ++  json
    =,  dejs:j
    |^
    ^-  $-(json goal-view)
    %-  of
    :~  [%pool-roots (ot ~[pid+pid])]
        [%pool-archive (ot ~[pid+pid])]
        [%goal-children (ot ~[pid+pid gid+gid])]
        [%archive-goal-children (ot ~[pid+pid rid+gid gid+gid])]
        [%goal-borrowed (ot ~[pid+pid gid+gid])]
        [%archive-goal-borrowed (ot ~[pid+pid rid+gid gid+gid])]
        [%goal-lineage (ot ~[pid+pid gid+gid])]
        [%archive-goal-lineage (ot ~[pid+pid rid+gid gid+gid])]
        [%goal-progress (ot ~[pid+pid gid+gid])]
        [%archive-goal-progress (ot ~[pid+pid rid+gid gid+gid])]
        [%goal-archive (ot ~[pid+pid gid+gid])]
        [%goal-borrowed-by (ot ~[pid+pid gid+gid])]
        [%archive-goal-borrowed-by (ot ~[pid+pid rid+gid gid+gid])]
        [%harvest (ot ~[type+type])]
        [%archive-goal-harvest (ot ~[pid+pid rid+gid gid+gid])]
        [%empty-goals (ot ~[type+type])]
        [%archive-goal-empty-goals (ot ~[pid+pid rid+gid gid+gid])]
        [%pool-tag-goals (ot ~[pid+pid tag+so])]
        [%pool-tag-harvest (ot ~[pid+pid tag+so])]
        [%pool-title (ot ~[pid+pid])]
        [%pool-note (ot ~[pid+pid])]
        [%pool-perms (ot ~[pid+pid])]
        [%pool-graylist (ot ~[pid+pid])]
        [%pool-tag-note (ot ~[pid+pid tag+so])]
        [%goal (ot ~[pid+pid gid+gid])]
        [%archive-goal (ot ~[pid+pid rid+gid gid+gid])]
        [%pool-tags (ot ~[pid+pid])]
        [%pool-fields (ot ~[pid+pid])]
        [%goal-data (ot ~[keys+(ar key)])]
        [%outgoing-invites (ot ~[pid+pid])]
        [%incoming-requests (ot ~[pid+pid])]
        [%pools-index ul]
        [%pool-status (ot ~[pid+pid])]
        [%local-tag-goals (ot ~[tag+so])]
        [%local-tag-harvest (ot ~[tag+so])]
        [%local-tag-note (ot ~[tag+so])]
        [%local-goal-tags ul]
        [%local-goal-fields ul]
        [%local-blocked ul]
        [%incoming-invites ul]
        [%outgoing-requests ul]
        [%setting (ot ~[setting+so])]
    ==
    ++  type
      %-  of
      :~  main+|=(jon=json ?>(?=(~ jon) ~))
          pool+pid:dejs:j
          goal+key:dejs:j
      ==
    --
  --
++  grad  %noun
--
