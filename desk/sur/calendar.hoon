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
      [%fuld p=fullday-instance]
      [%skip ~]
  ==
::
+$  event
  $:  =eid  =dom
      ruledata=(map aid ruledata)
      metadata=(map mid metadata)
      instances=(map @ud instance)
      default-ruledata=aid
      default-metadata=mid
      ruledata-map=(map @ud aid)
      metadata-map=(map @ud mid)
      rsvps=(map @ud rsvps)
  ==
+$  events  (map eid event)
::
+$  fullday-order  ((mop @da (set iref)) gth) :: timezone independent
+$  span-order     ((mop @da (set mome)) gth) 
::
+$  calendar
  $:  =cid
      title=@t
      =perms
      =events
      =rdates
      =fullday-order
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
  $%  [%create-calendar =cid title=@t]
      [%delete-calendar =cid]
      [%update-calendar =cid p=calendar-transition]
  ==
::
+$  calendar-transition
  $%  [%init-calendar =calendar] 
      [%create-event =eid]
      [%delete-event =eid]
      [%update-event =eid p=event-transition]
  ==
::
+$  event-transition
  $%  [%init-event =event]
      [%dom =dom]
      [%ruledata =aid =ruledata]
      [%metadata =mid =metadata]
      [%default-ruledata =aid]
      [%default-metadata =mid]
      [%ruledata-map i=@ud =aid]
      [%metadata-map i=@ud =mid]
      [%rsvp i=@ud =ship =rsvp]
      [%instantiate idx-list=(list @ud)]
  ==
::
:: single instance event:
::  dom [0 0]
:: =/  =rid   [~ %left %single-0]
:: =/  =kind  [%left ~ ~h1]
:: =/  args   (my ['Start' %dx [0 ~2010.1.5]]~)
:: ~&  ((get-to-span:ca:cal [~ %left %single-0] left+[~ ~h1] args) idx)
::
+$  compound-transition  *
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
+$  calendar-action
  %+  pair  cid
  $%  [%create title=@t description=@t]
      [%update fields=(list calendar-field)]
      [%delete ~]
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
+$  event-action
  %+  pair  [=cid =eid]
  $%  [%create =dom =aid =rid =kind =args =mid =metadata]
      [%create-until start=@ud until=@da =aid =rid =kind =args =mid =metadata]
      [%update fields=(list event-field)]
      [%delete ~]
      [%create-rule =aid =rid =kind =args]
      [%update-rule =aid =rid =kind =args]
      [%delete-rule =aid]
      [%create-metadata =mid metadata]
      [%update-metadata =mid fields=(list meta-field)]
      [%delete-metadata =mid]
      [%update-instances =dom fields=(list instance-field)]
      [%update-domain =dom]
  ==
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
          [%fuld p=fullday]
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
