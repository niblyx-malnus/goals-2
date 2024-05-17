/-  act=action, p=pools, ui=goals-ui
/+  webui-main, vent, htmx, bind, bout, dbug, verb, default-agent, default-subs,
    j=json-utils
/=  x  /ted/vines/goals-ui
/=  x  /mar/goals-ui/transition
::
|%
+$  card        $+(gall-card card:agent:gall)
++  agent-bind  (agent:bind & ~[[`/htmx/goals &]])
++  agent-htmx  (agent:htmx ~m5)
++  htmx-timer  |=(now=@da `card`[%pass /htmx-timer %arvo %b %wait (add now ~s1)])
--
::
=|  state-0:ui
=*  state  -
::
%+  verb  |
:: %-  agent:bout
%-  agent:dbug
%-  agent-htmx
%-  agent-bind
%-  agent:vent
^-  agent:gall
|_  =bowl:gall
+*  this  .
    dus   ~(. (default-subs this %.n %.y %.n) bowl)
    uhc   ~(. agent:webui-main bowl ~ state)
::
++  on-init
  ^-  (quip card _this)
  :_  this
  ;:  weld
    subscribe-to-pools-agent:uhc
    subscribe-to-goals-agent:uhc
    :: [(htmx-timer now.bowl)]~
  ==
::
++  on-save   !>(state)
::
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  :: =+  !<(old=state-0:ui old-vase)
  :: :_  this(state old)
  :_  this(state *state-0:ui)
  ;:  weld
    subscribe-to-pools-agent:uhc
    subscribe-to-goals-agent:uhc
    :: [(htmx-timer now.bowl)]~
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src our):bowl
  ~&  "poke to {<dap.bowl>} agent with mark {<mark>}"
  ?+    mark  (on-poke:dus mark vase)
      %noun
    =/  jon=json
      %-  need  %-  de:json:html
      '''
      {
        "a": {
          "c": 1,
          "d": [1, 2, 3]
        },
        "b": 2
      }
      '''
    ~&  (~(get jo:j jon) /a/d/2)
    ~&  (~(deg jo:j jon) /a/d/2 ni:dejs:format)
    ~&  (~(deg jo:j jon) /a/d/2 ni:dejs-soft:format)
    ~&  (~(dug jo:j jon) /a/d/2 ni:dejs:format 4)
    ~&  (~(dug jo:j jon) /a/d/3 ni:dejs:format 4)
    ~&  (~(del jo:j jon) /a)
    ~&  (~(del jo:j jon) /a/d)
    ~&  (~(put jo:j jon) /a/hello s+%test)
    ~&  (~(put jo:j jon) /a/hello/3/jello/4/good s+%woop)
    ~&  (~(put jo:j jon) /a/hello/['!3']/jello/4/good s+%woop)
    ~&  (~(dog jo:j jon) /a/d/2 ni:dejs:format)
    [~ this]
    ::
      %nooks-put
    =+  !<(=path (slot 2 vase))
    [~ this(nooks (~(put of nooks) path (slot 3 vase)))]
    ::
      %nooks-del
    =+  !<(=path vase)
    [~ this(nooks (~(del of nooks) path))]
    ::
      %nooks-lop
    =+  !<(=path vase)
    [~ this(nooks (~(lop of nooks) path))]
    ::
      %goals-ui-transition
    =+  !<(tan=transition:ui vase)
    ~&  received-transition+tan
    =^  cards  state
      abet:(handle-transition:uhc tan)
    [cards this]
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:dus pole)
    [%x %nooks ~]             ``noun+!>(nooks)
    [%x %nooks %get rest=*]   ``noun+!>((~(get of nooks) rest.pole))
    [%x %nooks %fit rest=*]   ``noun+!>((~(fit of nooks) rest.pole))
    [%x %nooks %dip rest=*]   ``noun+!>((~(dip of nooks) rest.pole))
    [%x %settings ~]          ``noun+!>(settings)
    [%x %error-messages ~]    ``noun+!>(error-messages)
  ==
::
++  on-watch  on-watch:dus
::
++  on-agent
  |=  [=(pole knot) =sign:agent:gall]
  ^-  (quip card _this)
  ?+    pole  (on-agent:dus pole sign)
      [%pools-transitions ~]
    ?+    -.sign  (on-agent:dus pole sign)
        %kick
      %-  (slog leaf+"{<dap.bowl>} got kick from {<src.bowl>} on wire {<wire>}" ~)
      :_  this  :_  ~
      :*  %pass  /pools-transitions  %agent
          [our.bowl %pools]  %watch  /transitions
      ==
      ::
        %fact
      ?.  =(p.cage.sign %pools-transition)
        (on-agent:dus pole sign)
      =^  cards  state
        abet:(handle-pools-transition:uhc !<(transition:p q.cage.sign))
      [cards this]
    ==
    ::
      [%goals-transitions ~]
    ?+    -.sign  (on-agent:dus pole sign)
        %kick
      %-  (slog leaf+"{<dap.bowl>} got kick from {<src.bowl>} on wire {<wire>}" ~)
      :_  this  :_  ~
      :*  %pass  /goals-transitions  %agent
          [our.bowl %goals]  %watch  /transitions
      ==
      ::
        %fact
      ?.  =(p.cage.sign %goals-transition)
        (on-agent:dus pole sign)
      =^  cards  state
        abet:(handle-goals-transition:uhc !<(transition:act q.cage.sign))
      [cards this]
    ==
  ==
::
++  on-leave  on-leave:dus
::
++  on-arvo   on-arvo:dus
  :: |=  [=wire =sign-arvo]
  :: ^-  (quip card _this)
  :: ?+    wire  (on-arvo:dus wire sign-arvo)
  ::     [%htmx-timer ~]
  ::   ?+    sign-arvo  (on-arvo:dus wire sign-arvo)
  ::       [%behn %wake *]
  ::     ?^  error.sign-arvo
  ::       (on-arvo:dus wire sign-arvo)
  ::     :_  this
  ::     :~  (htmx-timer now.bowl)
  ::         :*  %pass  /htmx-refresh  %agent  [our dap]:bowl  %poke
  ::             htmx-refresh+!>(["#current-time" "/htmx/goals/current-time" ~ "#hello-world"]~)
  ::         ==
  ::     ==
  ::   ==
  :: ==
::
++  on-fail   on-fail:dus
--
