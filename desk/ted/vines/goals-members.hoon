/-  gol=goals, axn=action, pyk=peek, spider
/+  *ventio
=,  strand=strand:spider
^-  thread:spider
::
=<
::
%-  vine-thread
%-  vine:tree
|=  [=gowl vid=vent-id =mark =vase]
=/  m  (strand ,^vase)
^-  form:m
?>  |(=(our src):gowl (moon:title [our src]:gowl))
~?  >>  (moon:title [our src]:gowl)
  "%goals vine: moon access from {(scow %p src.gowl)}"
;<  moon-as-planet=?  bind:m  (scry-hard ,? /gx/goals-members/moon-as-planet/noun)
~&  >>  moon-as-planet+moon-as-planet
=?  src.gowl  &(moon-as-planet (moon:title [our src]:gowl))  our.gowl
~&  "%goals vine: receiving mark {(trip mark)}"
;<  =store:gol  bind:m  (scry-hard ,store:gol /gx/goals/store/noun)
?+    mark  (just-poke [our dap]:gowl mark vase) :: poke normally
  :: 
    %membership-action
  =+  !<(act=membership-action:axn vase)
  ?-    -.act
      %join
    :: watch the pool path
    ::
    ;<  p=(unit tang)  bind:m
      %:  agent-watch-path-soft
        %goals
        /(scot %p host.pid.act)/[name.pid.act]
        [host.pid.act %goals]
        /(scot %p host.pid.act)/[name.pid.act]
      ==
    :: update subscription history
    ::
    =/  =cage
      membership-transition+!>([%pool-sub-event pid.act %watch-ack p])
    ;<  ~  bind:m  (poke [our.gowl %goals-members] cage)
    :: return or fail
    ::
    ?~  p
      (pure:m !>(~))
    (strand-fail %pool-subscription-fail u.p)
    ::
      %send-invite
    ?>  =(our.gowl host.pid.act)
    :: TODO: assert src.gowl has appropriate permissions wrt pool
    ;<  ~  bind:m
      %+  poke  [invitee.act %goals-members]
      membership-transition+!>([%add-incoming-invite pid.act src.gowl])
    ;<  ~  bind:m
      %+  poke  [our.gowl %goals-members]
      membership-transition+!>([%add-outgoing-invite pid.act src.gowl invitee.act])
    (pure:m !>(~))
  ==
==
::
|%
++  stub  ~
--

