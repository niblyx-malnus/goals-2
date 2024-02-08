/-  *goals
|%
+$  action  $%(local-action pool-action goal-action)
++  local-action
  $%  [%pools-slot-above dis=pid dat=pid]
      [%pools-slot-below dis=pid dat=pid]
      [%goals-slot-above dis=key dat=key]
      [%goals-slot-below dis=key dat=key]
  ==
++  pool-action
  $%  [%create-pool title=@t]
      [%delete-pool =pid]
      [%yoke =pid yoks=(list plex)]
      [%set-pool-title =pid title=@t]
      [%update-pool-perms =pid new=perms]
      [%update-pool-property =pid p=(each [@t @t] @t)]
      [%update-pool-tag-property =pid tag=@t p=(each [@t @t] @t)]
      [%update-pool-field-property =pid field=@t p=(each [@t @t] @t)]
      [%put-module =pid module=@t uuid=@t parent=(unit gid) version=@ud body=json]
      [%del-module =pid module=@t uuid=@t]
  ==
++  goal-action
  =<  goal-action
  |%
  +$  goal-action  $%(create mutate local)
  +$  create
    $%  [%create-goal =pid upid=(unit gid) summary=@t actionable=?]
        [%create-goal-with-tag =pid upid=(unit gid) summary=@t actionable=? tag=@t]
    ==
  ++  mutate
    =<  mutate
    |%
    +$  mutate  $%(life-cycle nexus hitch)
    +$  life-cycle
      $%  [%archive-goal =pid =gid]
          [%restore-goal =pid =gid]
          [%delete-goal =pid =gid]
      ==
    +$  nexus
      $%  [%move =pid cid=gid upid=(unit gid)] :: should probably be in nexus:pool-action
          [%set-start =pid =gid start=(unit @da)]
          [%set-end =pid =gid end=(unit @da)]
          [%set-summary =pid =gid summary=@t]
          [%mark-actionable =pid =gid]
          [%unmark-actionable =pid =gid]
          [%mark-complete =pid =gid]
          [%unmark-complete =pid =gid]
          [%update-goal-perms =pid =gid chief=ship rec=_| =deputies]
      ==
    +$  hitch
      $%  [%update-goal-tags =pid =gid p=(each (set @t) (set @t))]
          [%update-goal-field =pid =gid p=(each [@t @t] @t)]
      ==
    --
  +$  local
    $%  [%update-local-goal-tags =key p=(each (set @t) (set @t))]
        [%update-local-tag-property tag=@t p=(each [@t @t] @t)]
        [%update-setting p=(each [@t @t] @t)]
    ==
  --
::
+$  core-yoke
  $%  [%dag-yoke n1=nid n2=nid]
      [%dag-rend n1=nid n2=nid]
  ==
::
+$  plex  $%(exposed-yoke nuke)
::
+$  exposed-yoke  
  $%  [%prio-rend lid=gid rid=gid]
      [%prio-yoke lid=gid rid=gid]
      [%prec-rend lid=gid rid=gid]
      [%prec-yoke lid=gid rid=gid]
      [%nest-rend lid=gid rid=gid]
      [%nest-yoke lid=gid rid=gid]
      [%hook-rend lid=gid rid=gid]
      [%hook-yoke lid=gid rid=gid]
      [%held-rend lid=gid rid=gid]
      [%held-yoke lid=gid rid=gid]
  ==
::
+$  nuke
  $%  [%nuke-prio-left =gid]
      [%nuke-prio-ryte =gid]
      [%nuke-prio =gid]
      [%nuke-prec-left =gid]
      [%nuke-prec-ryte =gid]
      [%nuke-prec =gid]
      [%nuke-prio-prec =gid]
      [%nuke-nest-left =gid]
      [%nuke-nest-ryte =gid]
      [%nuke-nest =gid]
  ==
::
+$  harvest-type
  $%  [%main ~]
      [%pool =pid]
      [%goal =pid =gid]
  ==
::
+$  goal-view
  $%  [%pool-roots =pid]   :: gid, summary, cmp, axn
      [%goal-young =pid =gid] :: gid, summary, cmp, axn
      [%harvest type=harvest-type]
      [%pool-tag-goals =pid tag=@t]
      [%pool-tag-harvest =pid tag=@t]
      [%pool-tag-note =pid tag=@t]
      [%local-tag-goals tag=@t]
      [%local-tag-harvest tag=@t]
      [%local-tag-note tag=@t]
      [%pools-index ~]
      [%pool-title =pid]
      [%pool-note =pid]
      [%goal-summary =pid =gid]
      [%goal-note =pid =gid]
      [%goal-tags =pid =gid]
      [%local-goal-tags =pid =gid]
      [%goal-parent =pid =gid]
      [%goal-actionable =pid =gid]
      [%goal-complete =pid =gid]
      [%setting setting=@t]
      [%pool-tags =pid]
      [%all-local-goal-tags ~]
  ==
::
+$  tags  (list (pair ? @t)) :: local/public tags
::
+$  goal-vent
  $@  ~
  $%  [%pool-roots roots=(list [gid @t ? ? tags])]   :: gid, summary, cmp, axn, tags
      [%goal-young young=(list [gid ? @t ? ? tags])] :: gid, summary, cmp, axn, tags
      [%harvest harvest=(list [gid @t ? ? tags])]   :: gid, summary, cmp, axn, tags
      [%pool-tag-goals goals=(list [gid @t ? ? tags])]   :: gid, summary, cmp, axn, tags
      [%pool-tag-harvest harvest=(list [gid @t ? ? tags])]   :: gid, summary, cmp, axn, tags
      [%local-tag-goals goals=(list [gid @t ? ? tags])]   :: gid, summary, cmp, axn, tags
      [%local-tag-harvest harvest=(list [gid @t ? ? tags])]   :: gid, summary, cmp, axn, tags
      [%pools-index pools=(list [pid @t])]
      [%tags =tags]
      [%uid gid=(unit gid)]
      [%cord p=@t]
      [%ucord p=(unit @t)]
      [%loob p=?]
  ==
--
