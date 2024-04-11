/-  *goals, p=pools
|%
+$  exposed-yoke  
  $%  [%prio-rend lid=gid rid=gid] :: start-to-start
      [%prio-yoke lid=gid rid=gid] :: start-to-start
      [%prec-rend lid=gid rid=gid] :: end-to-start
      [%prec-yoke lid=gid rid=gid] :: end-to-start
      [%nest-yoke lid=gid rid=gid] :: end-to-end
      [%nest-rend lid=gid rid=gid] :: end-to-end
      [%hook-rend lid=gid rid=gid] :: start-to-end
      [%hook-yoke lid=gid rid=gid] :: start-to-end
      [%held-rend lid=gid rid=gid] :: start-to-start and end-to-end (containment)
      [%held-yoke lid=gid rid=gid] :: start-to-start and end-to-end (containment)
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
+$  plex  $%(exposed-yoke nuke) :: complex yoke
::
+$  transition
  $%  [%goal-order p=(each [idx=@ keys=(list key)] keys=(list key))]
      [%pool-order p=(each [idx=@ pids=(list pid)] pids=(list pid))]
      [%goal-metadata =key p=(each [@t json] @t)]
      [%pool-metadata =pid p=(each [@t json] @t)]
      [%metadata-properties field=@t p=(unit (each [@t json] @t))]
      [%settings p=(each [@t json] @t)]
      [%create-pool =pid title=@t]
      [%delete-pool =pid]
      [%update-pool =pid mod=ship p=pool-transition]
  ==
::
+$  pool-transition
  $%  [%init-pool =pool] 
      [%reorder-roots roots=(list gid)]
      [%reorder-children =gid children=(list gid)]
      [%reorder-archive context=(unit gid) archive=(list gid)]
      [%create-goal =gid upid=(unit gid) summary=@t now=@da]
      [%archive-goal =gid]
      [%restore-goal =gid]
      [%restore-to-root =gid]
      [%delete-from-archive =gid]
      [%delete-goal =gid]
      [%move cid=gid upid=(unit gid)]
      [%yoke yoks=(list plex)]
      [%set-actionable =gid val=?]
      [%mark-done =nid now=@da]
      [%unmark-done =nid now=@da]
      [%set-summary =gid summary=@t]
      [%set-pool-title title=@t]
      [%set-start =gid start=(unit @da)]
      [%set-end =gid end=(unit @da)]
      [%set-pool-role =ship role=(unit role)]
      [%set-chief =gid chief=ship rec=?]
      [%set-open-to =gid =open-to]
      [%update-goal-metadata =gid p=(each [@t json] @t)]
      [%update-pool-metadata p=(each [@t json] @t)]
      [%update-pool-metadata-field field=@t p=(each [@t json] @t)]
      [%delete-pool-metadata-field field=@t]
  ==
::
+$  compound-transition
  $%  [%pool-order-slot p=(each [dis=pid dat=pid] [dis=pid dat=pid])]
      [%goal-order-slot p=(each [dis=key dat=key] [dis=key dat=key])]
      [%update-pool =pid mod=ship p=compound-pool-transition]
  ==
::
+$  compound-pool-transition
  $%  [%set-active =gid val=?]
      [%set-complete =gid val=?]
  ==
::
+$  local-action
  $%  [%pool-order-slot p=(each [dis=pid dat=pid] [dis=pid dat=pid])]
      [%goal-order-slot p=(each [dis=key dat=key] [dis=key dat=key])]
      [%goal-metadata =key p=(each [@t json] @t)]
      [%pool-metadata =pid p=(each [@t json] @t)]
      [%metadata-properties field=@t p=(unit (each [@t json] @t))]
      [%settings p=(each [@t json] @t)]
      [%create-pool title=@t]
      [%delete-pool =pid]
      :: [%update-pool =pid axn=pool-action]
  ==
::
+$  pool-action :: sent with a pid
  $%  [%yoke yoks=(list plex)]
      [%set-pool-title title=@t]
      [%create-goal upid=(unit gid) summary=@t actionable=? active=?]
      [%archive-goal =gid]
      [%restore-goal =gid]
      [%restore-to-root =gid]
      [%delete-from-archive =gid]
      [%delete-goal =gid]
      [%move cid=gid upid=(unit gid)]
      [%set-start =gid start=(unit @da)]
      [%set-end =gid end=(unit @da)]
      [%set-summary =gid summary=@t]
      [%set-chief =gid chief=ship rec=?]
      [%set-open-to =gid =open-to]
      [%set-actionable =gid val=?]
      [%set-complete =gid val=?]
      [%set-active =gid val=?]
      [%reorder-roots roots=(list gid)]
      [%reorder-children =gid children=(list gid)]
      [%reorder-archive context=(unit gid) archive=(list gid)]
      [%update-goal-metadata =gid p=(each [@t json] @t)]
      [%update-pool-metadata p=(each [@t json] @t)]
      [%update-pool-metadata-field field=@t p=(each [@t json] @t)]
      [%delete-pool-metadata-field field=@t]
  ==
::
+$  local-membership-action
  $%  [%watch-pool =pid]
      [%leave-pool =pid]
      [%update-blocked p=(each blocked:p blocked:p)]
      [%extend-request =pid]
      [%cancel-request =pid]
      [%accept-invite =pid]
      [%reject-invite =pid]
      [%delete-invite =pid]
  ==
::
+$  pool-membership-action :: sent with pid
  $%  [%kick-member member=ship]
      [%set-pool-role member=ship =role]
      [%update-graylist fields=(list graylist-field:p)]
      [%extend-invite invitee=ship]
      [%cancel-invite invitee=ship]
      [%accept-request requester=ship]
      [%reject-request requester=ship]
      [%delete-request requester=ship]
  ==
::
+$  goal-perms-check
  $%  [%check-pool-edit-perm =pid mod=ship]
      [%check-root-create-perm =pid mod=ship]
      [%stock-root =gid]
      [%check-goal-master =pid =gid mod=ship]
      [%get-ancestral-deputies =gid]
      [%check-goal-super =pid =gid mod=ship]
      [%check-goal-edit-perm =pid =gid mod=ship]
      [%check-goal-create-perm =pid =gid mod=ship]
      [%check-move-to-root-perm =pid =gid mod=ship]
      [%nearest-common-ancestor a=gid b=gid]
      [%check-move-to-goal-perm kid=gid dad=gid mod=ship]
      [%check-pool-role-mod member=ship mod=ship]
      [%check-open-to =gid mod=ship]
      [%check-goal-chief-mod-perm =gid mod=ship]
      [%check-goal-deputies-mod-perm =pid =gid mod=ship]
      [%check-goal-open-to-mod-perm =pid =gid mod=ship]
      [%get-goal-permission-level =gid mod=ship]
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
      [%pools-index ~]
      [%pool-status =pid]
      [%local-tag-goals tag=@t]
      [%local-tag-harvest tag=@t]
      [%local-tag-note tag=@t]
      [%local-goal-tags ~]
      [%local-goal-fields ~]
      [%local-blocked ~]
      [%incoming-invites ~]
      [%outgoing-requests ~]
      [%setting setting=@t]
  == 
--
