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
      [%update-pool-perms =pin new=perms]
      [%update-pool-property =pin p=(each [@t @t] @t)]
  ==
++  goal-action
  =<  goal-action
  |%
  +$  goal-action  $%(spawn mutate local)
  +$  spawn  [%spawn-goal =pin upid=(unit id) desc=@t actionable=?]
  ++  mutate
    =<  mutate
    |%
    +$  mutate  $%(life-cycle nexus hitch)
    +$  life-cycle
      $%  [%cache-goal =id]
          [%renew-goal =id]
          [%trash-goal =id]
      ==
    +$  nexus
      $%  [%move cid=id upid=(unit id)] :: should probably be in nexus:pool-action
          [%set-kickoff =id kickoff=(unit @da)]
          [%set-deadline =id deadline=(unit @da)]
          [%mark-actionable =id]
          [%unmark-actionable =id]
          [%mark-complete =id]
          [%unmark-complete =id]
          [%update-goal-perms =id chief=ship rec=_| =deputies]
      ==
    +$  hitch
      $%  [%update-goal-tags =id p=(each (set @t) (set @t))]
          [%update-goal-field =id p=(each [@t @t] @t)]
      ==
    --
  +$  local
    $%  [%put-private-tags =id tags=(set @t)]
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
  $%  [%harvest type=harvest-type]
      [%pools-index ~]
      [%pool-roots =pin]   :: id, desc, cmp, axn
      [%goal-young =id] :: id, desc, cmp, axn
      [%pool-title =pin]
      [%pool-note =pin]
      [%goal-description =id]
      [%goal-note =id]
      [%goal-tags =id]
      [%goal-parent =id]
      [%goal-actionable =id]
      [%goal-complete =id]
      [%setting setting=@t]
  ==
::
+$  goal-vent
  $@  ~
  $%  [%harvest harvest=(list [id @t ? ? (list @t)])]   :: id, desc, cmp, axn, tags
      [%pools-index pools=(list [pin @t])]
      [%pool-roots roots=(list [id @t ? ? (list @t)])]   :: id, desc, cmp, axn, tags
      [%goal-young young=(list [id ? @t ? ? (list @t)])] :: id, desc, cmp, axn, tags
      [%goal-tags tags=(list @t)]
      [%uid id=(unit id)]
      [%cord p=@t]
      [%ucord p=(unit @t)]
      [%loob p=?]
  ==
::
--
