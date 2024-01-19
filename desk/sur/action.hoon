/-  *goals
|%
+$  action  $%(pool-action goal-action local-action)
+$  local-action
  $%  [%slot-above dis=id dat=id]  :: slot dis above dat
      [%slot-below dis=id dat=id]  :: slot dis below dat
  ==
++  pool-action
  $%  [%create-pool title=@t]
      [%delete-pool =pin]
      [%yoke =pin yoks=(list plex)]
      [%set-pool-title =pin title=@t]
      [%update-pool-perms =pin new=perms]
      [%update-pool-property =pin p=(each [@t @t] @t)]
      [%update-pool-tag-property =pin tag=@t p=(each [@t @t] @t)]
      [%update-pool-field-property =pin field=@t p=(each [@t @t] @t)]
      [%pools-slot-above dis=pin dat=pin]
      [%pools-slot-below dis=pin dat=pin]
      [%goals-slot-above dis=id dat=id]
      [%goals-slot-below dis=id dat=id]
  ==
++  goal-action
  =<  goal-action
  |%
  +$  goal-action  $%(create mutate local)
  +$  create
    $%  [%create-goal =pin upid=(unit id) summary=@t actionable=?]
        [%create-goal-with-tag =pin upid=(unit id) summary=@t actionable=? tag=@t]
    ==
  ++  mutate
    =<  mutate
    |%
    +$  mutate  $%(life-cycle nexus hitch)
    +$  life-cycle
      $%  [%archive-goal =id]
          [%restore-goal =id]
          [%delete-goal =id]
      ==
    +$  nexus
      $%  [%move cid=id upid=(unit id)] :: should probably be in nexus:pool-action
          [%set-kickoff =id kickoff=(unit @da)]
          [%set-deadline =id deadline=(unit @da)]
          [%set-summary =id summary=@t]
          [%mark-actionable =id]
          [%unmark-actionable =id]
          [%mark-complete =id]
          [%unmark-complete =id]
          [%update-goal-perms =id chief=ship rec=_| =deputies]
          [%roots-slot-above dis=id dat=id]
          [%roots-slot-below dis=id dat=id]
          [%young-slot-above pid=id dis=id dat=id]
          [%young-slot-below pid=id dis=id dat=id]
      ==
    +$  hitch
      $%  [%update-goal-tags =id p=(each (set @t) (set @t))]
          [%update-goal-field =id p=(each [@t @t] @t)]
      ==
    --
  +$  local
    $%  [%update-local-goal-tags =id p=(each (set @t) (set @t))]
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
  $%  [%prio-rend lid=id rid=id]
      [%prio-yoke lid=id rid=id]
      [%prec-rend lid=id rid=id]
      [%prec-yoke lid=id rid=id]
      [%nest-rend lid=id rid=id]
      [%nest-yoke lid=id rid=id]
      [%hook-rend lid=id rid=id]
      [%hook-yoke lid=id rid=id]
      [%held-rend lid=id rid=id]
      [%held-yoke lid=id rid=id]
  ==
::
+$  nuke
  $%  [%nuke-prio-left =id]
      [%nuke-prio-ryte =id]
      [%nuke-prio =id]
      [%nuke-prec-left =id]
      [%nuke-prec-ryte =id]
      [%nuke-prec =id]
      [%nuke-prio-prec =id]
      [%nuke-nest-left =id]
      [%nuke-nest-ryte =id]
      [%nuke-nest =id]
  ==
::
+$  harvest-type
  $%  [%main ~]
      [%pool =pin]
      [%goal =id]
  ==
::
+$  goal-view
  $%  [%pool-roots =pin]   :: id, summary, cmp, axn
      [%goal-young =id] :: id, summary, cmp, axn
      [%harvest type=harvest-type]
      [%pool-tag-goals =pin tag=@t]
      [%pool-tag-harvest =pin tag=@t]
      [%pools-index ~]
      [%pool-title =pin]
      [%pool-note =pin]
      [%pool-tag-note =pin tag=@t]
      [%goal-summary =id]
      [%goal-note =id]
      [%goal-tags =id]
      [%local-goal-tags =id]
      [%goal-parent =id]
      [%goal-actionable =id]
      [%goal-complete =id]
      [%setting setting=@t]
      [%pool-tags =pin]
      [%all-local-goal-tags ~]
  ==
::
+$  tags  (list (pair ? @t)) :: local/public tags
::
+$  goal-vent
  $@  ~
  $%  [%pool-roots roots=(list [id @t ? ? tags])]   :: id, summary, cmp, axn, tags
      [%goal-young young=(list [id ? @t ? ? tags])] :: id, summary, cmp, axn, tags
      [%harvest harvest=(list [id @t ? ? tags])]   :: id, summary, cmp, axn, tags
      [%pool-tag-goals goals=(list [id @t ? ? tags])]   :: id, summary, cmp, axn, tags
      [%pool-tag-harvest harvest=(list [id @t ? ? tags])]   :: id, summary, cmp, axn, tags
      [%pools-index pools=(list [pin @t])]
      [%tags =tags]
      [%uid id=(unit id)]
      [%cord p=@t]
      [%ucord p=(unit @t)]
      [%loob p=?]
  ==
--
