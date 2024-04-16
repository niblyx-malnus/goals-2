/+  vio=ventio, dbug, verb, default-agent
:: There is no way around this. Threads cannot do state.
:: The venter needs STATE in order to enforce uniqueness on its vent-ids.
::
:: %venter is also responsible for warming this desk's tubes....
:: improves vent performance when using /ted/vent.hoon
:: https://github.com/tinnus-napbus/tube-warmer
::
:: %venter also maintains data about who can "pilot" this ship's venting
::
|%
+$  state-0
  $:  %0
      =pilots:vio
      =vents:vio
      desks=(set desk)  :: tube-warming targets
      tube-verb=$~(| ?)
  ==
::
+$  card       card:agent:gall
+$  vent-id    vent-id:vio
--
::
%-  agent:dbug
%+  verb  |
=|  state-0
=*  state  -
::
=>  |_  =bowl:gall
    ++  revision-number
      |=  =desk
      ^-  @ud
      +(ud:.^(cass:clay %cw /(scot %p our.bowl)/[desk]/(scot %da now.bowl)))
    ::
    ++  watch-next
      |=  =desk
      ^-  card
      =/  =@ud  (revision-number desk)
      [%pass /next/[desk] %arvo %c %warp our.bowl desk ~ %many %.y ud+ud ud+ud /]
    ::
    ++  run-tube-warmer
      |=  =desk
      [%pass /tube-warmer/[desk] %arvo %k %fard desk %tube-warmer noun+!>(`[desk tube-verb])]
    ::
    ++  handle-desk
      |=  =desk
      ^-  (list card)
      :~  (watch-next desk)
          (run-tube-warmer desk)
      ==
    ::
    ++  handle-desks
      |=  desks=(set desk)
      ^-  (list card)
      (zing (turn ~(tap in desks) handle-desk))
    --
::
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    hc    ~(. +> bowl)
++  on-init
  ^-  (quip card _this)
  [(handle-desks:hc desks) this]
::
++  on-save   !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  =/  old=state-0  !<(state-0 ole)
  =.  state  old
  [(handle-desks:hc desks) this]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src our):bowl
  ?+    mark  (on-poke:def mark vase)
    %noun  `this(tube-verb (tail !<([%verb ?] vase)))
    ::
    %moons  ~&(pilot-moons+!moons.pilots `this(moons.pilots !moons.pilots))
    
      %uni-ships
    =+  !<(ships=(set ship) vase)
    ~&  pilot-ships+(~(uni in ships.pilots) ships)
    `this(ships.pilots (~(uni in ships.pilots) ships))
    ::
      %dif-ships
    =+  !<(ships=(set ship) vase)
    ~&  pilot-ships+(~(dif in ships.pilots) ships)
    `this(ships.pilots (~(dif in ships.pilots) ships))
    
      %uni-desks
    =+  !<(dex=(set desk) vase)
    ~&  desks+(~(uni in desks) dex)
    [(handle-desks:hc dex) this(desks (~(uni in desks) dex))]
    
      %dif-desks
    =+  !<(dex=(set desk) vase)
    ~&  desks+(~(dif in desks) dex)
    `this(desks (~(dif in desks) dex))
    ::
      %tally-vent
    :: ~&  %venter-tallying
    =+  !<([=dock vid=vent-id] vase)
    `this(vents (~(put ju vents) dock vid))
    ::
      %clear-vent
    :: ~&  %venter-clearing
    =+  !<([=dock vid=vent-id] vase)
    `this(vents (~(del ju vents) dock vid))
    ::
      %clear-dead
    =+  .^(pats=(list path) %gx /(scot %p our.bowl)/spider/(scot %da now.bowl)/tree/noun)
    =/  tids=(set tid:rand)  (~(gas in *(set tid:rand)) (turn pats rear))
    :-  ~
    %=    this
        vents
      %-  ~(gas by *vents:vio)
      %+  murn  ~(tap by vents)
      |=  [=dock vids=(set vent-id)]
      =;  new=(set vent-id)
        ?:(?=(~ new) ~ `[dock new])
      %-  ~(gas in *(set vent-id))
      %+  murn  ~(tap in vids)
      |=  vid=vent-id
      ?.((~(has in tids) q.vid) ~ `vid)
    ==
    :: gives a vent response directly from this agent
    ::
      %vent-request
    =+  !<([vid=vent-id:vio req=page] vase)
    =/  =path  (en-path:vio vid)
    ?+    p.req  (on-poke:def mark vase)
        %scry
      =+  ;;(scry=^path q.req)
      ?>  ?=([@ ^] scry)
      =+  .^(p=* i.scry (scot %p our.bowl) i.t.scry (scot %da now.bowl) t.t.scry)
      :_  this
      :~  [%give %fact ~[path] noun+!>(p)]
          [%give %kick ~[path] ~]
      ==
    ==
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %vents ~]   ``noun+!>(vents)
    [%x %pilots ~]  ``noun+!>(pilots)
    [%x %desks ~]   ``noun+!>(desks)
    [%x %verb ~]    ``noun+!>(tube-verb)
  ==
::
++  on-watch
  |=  =(pole knot)
  ^-  (quip card _this)
  ?+    pole  (on-watch:def pole)
    [%vent @ @ @ ~]  ?>(=(src our):bowl [~ this])
  ==
::
++  on-leave  on-leave:def
++  on-agent  on-agent:def
::
++  on-arvo
  |=  [=(pole knot) sign=sign-arvo]
  ^-  (quip card _this)
  ?+    pole  (on-arvo:def pole sign)
      [%tube-warmer desk=@tas ~]
    ?.  ?=([%khan %arow *] sign)  (on-arvo:def pole sign)
    %-  (slog ?:(?=(%.y -.p.sign) ~ [desk.pole p.p.sign]))
    [~ this]
    ::
      [%next desk=@tas ~]
    ?.  ?=([%clay %writ ~] sign)
      [~ this]
    ?.  (~(has in desks) desk.pole)
      [~ this]
    [(handle-desk:hc desk.pole) this]
  ==
::
++  on-fail   on-fail:def
--
