/-  *goals
|%
+$  action  $%(local-action pool-action goal-action)
++  local-action
  $%  [%pools-slot-above dis=pid dat=pid]
      [%pools-slot-below dis=pid dat=pid]
      [%goals-slot-above dis=key dat=key]
      [%goals-slot-below dis=key dat=key]
      [%update-local-goal-metadata =key p=(each [@t @t] @t)]
      [%update-local-pool-metadata =pid p=(each [@t @t] @t)]
      [%update-local-metadata-field field=@t p=(each [@t @t] @t)]
      [%delete-local-metadata-field field=@t]
      [%update-setting p=(each [@t @t] @t)]
  ==
++  pool-action
  $%  [%create-pool title=@t]
      [%delete-pool =pid]
      [%yoke =pid yoks=(list plex)]
      [%set-pool-title =pid title=@t]
      [%update-pool-perms =pid new=perms]
      [%update-pool-metadata =pid p=(each [@t @t] @t)]
      [%update-pool-metadata-field =pid field=@t p=(each [@t @t] @t)]
      [%delete-pool-metadata-field =pid field=@t]
  ==
++  goal-action
  =<  goal-action
  |%
  +$  goal-action  $%(create mutate)
  +$  create
    $%  [%create-goal =pid upid=(unit gid) summary=@t actionable=? active=?]
    ==
  ++  mutate
    =<  mutate
    |%
    +$  mutate  $%(life-cycle nexus)
    +$  life-cycle
      $%  [%archive-goal =pid =gid]
          [%restore-goal =pid =gid]
          [%restore-to-root =pid =gid]
          [%delete-from-archive =pid =gid]
          [%delete-goal =pid =gid]
      ==
    +$  nexus
      $%  [%move =pid cid=gid upid=(unit gid)] :: should probably be in nexus:pool-action
          [%set-start =pid =gid start=(unit @da)]
          [%set-end =pid =gid end=(unit @da)]
          [%set-summary =pid =gid summary=@t]
          [%set-actionable =pid =gid val=?]
          [%set-complete =pid =gid val=?]
          [%set-active =pid =gid val=?]
          [%update-goal-perms =pid =gid chief=ship rec=_| =deputies]
          [%reorder-roots =pid roots=(list gid)]
          [%reorder-children =pid =gid children=(list gid)]
          [%reorder-archive =pid context=(unit gid) archive=(list gid)]
          [%update-goal-metadata =pid =gid p=(each [@t @t] @t)]
      ==
    --
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
  $%  [%pool-roots =pid]
      [%pool-archive =pid]
      [%goal-children =pid =gid]
      [%archive-goal-children =pid rid=gid =gid]
      [%goal-borrowed =pid =gid]
      [%archive-goal-borrowed =pid rid=gid =gid]
      [%goal-borrowed-by =pid =gid]
      [%archive-goal-borrowed-by =pid rid=gid =gid]
      [%goal-lineage =pid =gid]
      [%archive-goal-lineage =pid rid=gid =gid]
      [%goal-progress =pid =gid]
      [%archive-goal-progress =pid rid=gid =gid]
      [%goal-archive =pid =gid]
      [%harvest type=harvest-type]     :: frontier
      [%archive-goal-harvest =pid rid=gid =gid]
      [%empty-goals type=harvest-type]
      [%archive-goal-empty-goals =pid rid=gid =gid]
      [%pool-tag-goals =pid tag=@t]
      [%pool-tag-harvest =pid tag=@t]
      [%pool-tag-note =pid tag=@t]
      [%local-tag-goals tag=@t]
      [%local-tag-harvest tag=@t]
      [%local-tag-note tag=@t]
      [%pools-index ~]
      [%pool-title =pid]
      [%pool-note =pid]
      [%goal =pid =gid]
      [%archive-goal =pid rid=gid =gid]
      [%setting setting=@t]
      [%pool-tags =pid]
      [%pool-fields =pid]
      [%local-goal-tags ~]
      [%local-goal-fields ~]
      [%goal-data keys=(list key)]
  ==
--
