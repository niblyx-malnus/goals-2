/-  *goals
|%
+$  action  $%(local-action pool-action goal-action)
++  local-action
  $%  [%pools-slot-above dis=pid dat=pid]
      [%pools-slot-below dis=pid dat=pid]
      [%goals-slot-above dis=key dat=key]
      [%goals-slot-below dis=key dat=key]
      [%update-local-goal-tags =key p=(each (set @t) (set @t))]
      [%update-local-tag-property tag=@t p=(each [@t @t] @t)]
      [%update-setting p=(each [@t @t] @t)]
      [%put-collection =path =collection]
      [%del-collection =path]
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
  +$  goal-action  $%(create mutate)
  +$  create
    $%  [%create-goal =pid upid=(unit gid) summary=@t actionable=? active=?]
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
          [%mark-active =pid =gid]
          [%unmark-active =pid =gid]
          [%update-goal-perms =pid =gid chief=ship rec=_| =deputies]
          [%reorder-roots =pid roots=(list gid)]
          [%reorder-children =pid =gid children=(list gid)]
      ==
    +$  hitch
      $%  [%update-goal-tags =key p=(each (set @t) (set @t))]
          [%update-goal-field =pid =gid p=(each [@t @t] @t)]
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
  $%  [%pool-roots =pid]   :: gid, summary, cmp, axn
      [%goal-children =pid =gid] :: gid, summary, cmp, axn
      [%goal-borrowed =pid =gid]
      [%goal-borrowed-by =pid =gid]
      [%goal-lineage =pid =gid]
      [%goal-progress =pid =gid]
      [%harvest type=harvest-type]     :: frontier
      [%empty-goals type=harvest-type]
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
      [%setting setting=@t]
      [%pool-tags =pid]
      [%all-local-goal-tags ~]
      [%goal-data keys=(list key)]
  ==
--
