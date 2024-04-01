/-  *goals, p=pools
|%
+$  transition
  $%  [%create-pool =pid title=@t]
      [%delete-pool =pid]
  ==
::
+$  local-transition
  $%  [%goal-order p=(each [dis=key dat=key] [dis=key dat=key])]
      [%pool-order p=(each [dis=pid dat=pid] [dis=pid dat=pid])]
      [%goal-metadata =key p=(each [@t json] @t)]
      [%pool-metadata =pid p=(each [@t json] @t)]
      [%metadata-properties field=@t p=(unit (each [@t json] @t))]
      [%settings p=(each [@t json] @t)]
  ==
::
+$  pool-transition
  %+  pair  pid
  $%  [%create-pool title=@t]
      [%delete-pool ~]
      [%update-pool mod=ship =pool-update] 
  ==
::
+$  pool-update
  $%  [%title title=@t]
      [%perms new=perms]
      [%yoke yoks=(list plex)]
      [%update-goal =gid =goal-update]
      [%reorder-archive archive=(list gid)]
      [%reorder-roots roots=(list gid)]
      [%metadata p=(each [@t json] @t)]
      [%metadata-properties field=@t p=(unit (each [@t json] @t))]
  ==
::
+$  goal-update
    $%  [%create upid=(unit gid) summary=@t]
        [%delete ~]
        [%archive ~]
        [%restore ~]
        [%restore-to-root ~]
        [%delete-from-archive ~]
        [%move upid=(unit gid)]
        [%start-moment =moment]
        [%end-moment =moment]
        [%summary summary=@t]
        [%chief chief=ship rec=?]
        [%open-to =open-to]
        [%actionable p=?]
        [%complete p=?]
        [%active p=?]
        [%perms p=(each [ship role] ship)]
        [%reorder-children children=(list gid)]
        [%reorder-archive archive=(list gid)]
        [%metadata p=(each [@t json] @t)]
    ==
::
+$  action  $%(pool-action goal-action)
++  pool-action
  $%  [%create-pool title=@t]
      [%delete-pool =pid]
      [%yoke =pid yoks=(list plex)]
      [%set-pool-title =pid title=@t]
      [%update-pool-perms =pid new=perms]
      [%update-pool-metadata =pid p=(each [@t json] @t)]
      [%update-pool-metadata-field =pid field=@t p=(each [@t json] @t)]
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
          [%set-chief =pid =gid chief=ship rec=?]
          [%set-open-to =pid =gid =open-to]
          [%set-actionable =pid =gid val=?]
          [%set-complete =pid =gid val=?]
          [%set-active =pid =gid val=?]
          [%update-goal-perms =pid =gid chief=ship rec=_| =deputies]
          [%reorder-roots =pid roots=(list gid)]
          [%reorder-children =pid =gid children=(list gid)]
          [%reorder-archive =pid context=(unit gid) archive=(list gid)]
          [%update-goal-metadata =pid =gid p=(each [@t json] @t)]
      ==
    --
  --
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
      [%pool-title =pid]
      [%pool-note =pid]
      [%pool-perms =pid]
      [%pool-graylist =pid]
      [%goal =pid =gid]
      [%archive-goal =pid rid=gid =gid]
      [%pool-tags =pid]
      [%pool-fields =pid]
      [%goal-data keys=(list key)]
      [%outgoing-invites =pid]
      [%incoming-requests =pid]
  ==
::
+$  pool-view
  $:  =pid
  $%  [%test ~]
  ==  ==
::
+$  local-view
  $%  [%pools-index ~]
      [%local-tag-goals tag=@t]
      [%local-tag-harvest tag=@t]
      [%local-tag-note tag=@t]
      [%local-goal-tags ~]
      [%local-goal-fields ~]
      [%local-blocked ~]
      [%remote-pools ~]
      [%incoming-invites ~]
      [%outgoing-requests ~]
      [%setting setting=@t]
  == 
::
+$  membership-action
  $%  [%join =pid]
      [%kick-member =pid member=ship]
      [%leave-pool =pid]
      [%extend-invite =pid invitee=ship]
      [%cancel-invite =pid invitee=ship]
      [%accept-invite =pid]
      [%reject-invite =pid]
      [%delete-invite =pid]
      [%extend-request =pid]
      [%cancel-request =pid]
      [%accept-request =pid requester=ship]
      [%reject-request =pid requester=ship]
      [%delete-request =pid requester=ship]
      [%update-blocked p=(each blocked:p blocked:p)]
      [%update-graylist =pid fields=(list graylist-field:p)]
  ==
--
