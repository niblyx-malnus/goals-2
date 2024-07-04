/-  c=calendar
/+  *ventio
|_  =gowl
++  dude  %calendar
:: compound transitions
::
++  cot
  |%
  ++  create-event
    |=  [=cid:c =eid:c =dom:c =metadata:c =ruledata:c]
    =/  m  (strand ,~)
    ^-  form:m
    %+  poke  [our.gowl dude]
    :-  %calendar-compound-transition  !>
    ^-  compound-transition:c
    [%update-calendar cid our.gowl %create-event eid dom metadata ruledata]
  ::
  ++  delete-event
    |=  [=cid:c =eid:c]
    =/  m  (strand ,~)
    ^-  form:m
    %+  poke  [our.gowl dude]
    :-  %calendar-compound-transition  !>
    ^-  compound-transition:c
    [%update-calendar cid our.gowl %delete-event eid]
  ::
  ++  update-event
    |=  [=cid:c =eid:c p=event-action:c]
    =/  m  (strand ,~)
    ^-  form:m
    %+  poke  [our.gowl dude]
    :-  %calendar-compound-transition  !>
    ^-  compound-transition:c
    [%update-calendar cid our.gowl %update-event eid p]
  --
--
