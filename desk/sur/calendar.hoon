/-  *rules, p=pools
|%
+$  cid    id:p :: permanently fixed to a pool
+$  eid  @taeid :: event id
+$  mid  @tamid :: metadata id
+$  aid  @taaid :: rule args id
::
+$  iref  [=eid i=@ud]      :: instance reference
+$  mome  [?(%l %r) =iref]  :: span moment
::
++  max-instances  10.000
::
+$  ruledata  [=rid =kind =args]
+$  metadata  (map @t json)
::
++  skip     [[~ %skip ''] [%skip ~] ~]
++  skip-id  (scot %uv (sham skip))
::
+$  rsvp   ?(%yes %no %maybe)
+$  rsvps  (map ship rsvp)
:: %host   host of pool, can do anything...
:: %admin  can create events, can modify
::         and delete any event, can invite
::         new members, can kick non-admins,
::         can modify the pool graylist
::         and can rsvp to events
:: %member can create events, can modify
::         and delete their own events
::         and rsvp to events
:: %guest  can only view the calendar
::         and rsvp to events
:: %viewer can only view the calendar
::
+$  role   ?(%host %admin %member %guest %viewer)
+$  perms  (map ship role)
:: recurrent date; birthdays, etc (consistent yearly MM/DD date)
::
+$  rdate   [date=[m=@ud d=@ud] =metadata]
+$  rdates  (map eid rdate)
:: TODO: should add jump instance
::
+$  instance
  $%  [%span p=span-instance]
      [%fuld p=fuld-instance]
      [%skip ~]
  ==
::
+$  event
  $:  =eid  =dom
      ruledata=(map aid ruledata)
      metadata=(map mid metadata)
      instances=(map @ud instance) :: TODO: should be mop
      default-ruledata=aid
      default-metadata=mid
      ruledata-map=(map @ud aid)   :: TODO: should be mop
      metadata-map=(map @ud mid)   :: TODO: should be mop
      rsvps=(map @ud rsvps)
  ==
+$  events  (map eid event)
::
+$  fuld-order  ((mop @da (set iref)) gth) :: timezone independent
+$  span-order  ((mop @da (set mome)) gth) 
::
+$  calendar
  $:  =cid
      title=@t
      =perms
      =events
      =rdates
      =fuld-order
      =span-order
      =metadata
      metadata-properties=(map @t metadata)
  ==
::
+$  calendars  (map cid calendar)
::
+$  state-0  [%0 =calendars]
::
+$  transition
  $+  transition
  $%  [%create-calendar =cid title=@t]
      [%delete-calendar =cid]
      [%update-calendar =cid p=calendar-transition]
  ==
::
+$  calendar-transition
  $+  calendar-transition
  $%  [%init-calendar =calendar] 
      [%create-event =eid]
      [%delete-event =eid]
      [%update-event =eid p=event-transition]
  ==
::
+$  event-transition
  $+  event-transition
  $%  [%init-event =event]
      [%dom =dom]
      [%ruledata =ruledata]
      [%metadata =metadata]
      [%default-ruledata =aid]
      [%default-metadata =mid]
      [%ruledata-map i=@ud aid=(unit aid)]
      [%metadata-map i=@ud mid=(unit mid)]
      [%rsvp i=@ud =ship =rsvp]
      [%instantiate idx-list=(list @ud)]
  ==
::
+$  compound-transition
  $+  compound-transition
  $%  [%update-calendar =cid mod=ship p=compound-calendar-transition]
  ==
::
+$  compound-calendar-transition
  $+  compound-calendar-transition
  $%  [%create-event =eid =dom =metadata =ruledata]
      [%delete-event =eid]
      [%update-event =eid p=compound-event-transition]
  ==
::
+$  compound-event-transition
  $%  [%init =dom =metadata =ruledata]
      [%update-metadata =dom mid=(unit mid)]
      [%update-ruledata =dom aid=(unit aid)]
      [%update-new =dom default=? =metadata =ruledata]
      [%update-domain =dom]
  ==
::
+$  calendar-action
  $%  [%create-event =dom title=@t =ruledata]
      [%delete-event =eid]
      [%update-event =eid p=event-action]
  ==
::
+$  event-action
  $%  [%update-metadata =dom mid=(unit mid)]
      [%update-ruledata =dom aid=(unit aid)]
      [%update-new =dom default=? =metadata =ruledata]
      [%update-domain =dom]
  ==
::
+$  calendar-field
  $%  [%title title=@t]
      [%description description=@t]
      [%role p=(each [=ship =role] ship)]
  ==
::
+$  meta-field
  $%  [%name name=@t]
      [%description description=@t]
      [%color color=@t]
  ==
::
+$  event-field
  $%  [%def-rule =aid]
      [%def-data =mid]
  ==
::
+$  instance-field
  $%  [%aid =aid]
      [%mid =mid]
  ==
::
:: +$  event-action
::   $%  [%create =dom =aid =rid =kind =args =mid =metadata]
::       [%create-until start=@ud until=@da =aid =rid =kind =args =mid =metadata]
::       [%update fields=(list event-field)]
::       [%delete ~]
::       [%create-rule =aid =rid =kind =args]
::       [%update-rule =aid =rid =kind =args]
::       [%delete-rule =aid]
::       [%create-metadata =mid metadata]
::       [%update-metadata =mid fields=(list meta-field)]
::       [%delete-metadata =mid]
::       [%update-instances =dom fields=(list instance-field)]
::       [%update-domain =dom]
::   ==
::
+$  rdate-action
  %+  pair  cid
  $%  [%create date=[m=@ud d=@ud] =metadata]
      [%update =eid]    :: (list date-field)
      [%delete =eid]
  ==
::
+$  real-instance
  $:  =ruledata
      =metadata
      $=  i
      $%  [%span p=span]
          [%fuld p=fuld]
      ==
  ==
::
+$  range  (map iref real-instance)
::
+$  calendar-update  *
::
+$  event-update
  $%  
      event-field
      [%dom =dom]
      [%rule p=(each [aid [rid kind args]] aid)]
      [%metadata p=(crud [mid meta] [mid meta-field] mid)]
      :: TODO: consolidate instances; untenable for large numbers of
      ::       instances generated at once (should use gas, not put)
      ::
      [%instance p=(each [idx=@ud =instance] @ud)]
  ==
--
