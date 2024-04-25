/-  act=action, p=pools
/+  webui-main, vent, htmx, bind, bout, dbug, verb, default-agent, default-subs
/=  x  /ted/vines/goals-ui
::
|%
+$  card        card:agent:gall
++  agent-bind  (agent:bind & ~[[`/htmx/goals &]])
++  agent-htmx  (agent:htmx ~m5)
++  htmx-timer  |=(now=@da `card`[%pass /htmx-timer %arvo %b %wait (add now ~s1)])
+$  state-0  [%0 ~]
--
::
=|  state-0
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
    uhc   ~(. agent:webui-main bowl ~)
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
  =+  !<(old=state-0 old-vase)
  :_  this(state old)
  ;:  weld
    subscribe-to-pools-agent:uhc
    subscribe-to-goals-agent:uhc
    :: [(htmx-timer now.bowl)]~
  ==
::
++  on-poke   on-poke:dus
++  on-peek   on-peek:dus
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
      =/  cards=(list card)
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
      =/  cards=(list card)
        abet:(handle-goals-transition:uhc !<(transition:act q.cage.sign))
      [cards this]
    ==
  ==
::
++  on-leave  on-leave:dus
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+    wire  (on-arvo:dus wire sign-arvo)
      [%htmx-timer ~]
    ?+    sign-arvo  (on-arvo:dus wire sign-arvo)
        [%behn %wake *]
      ?^  error.sign-arvo
        (on-arvo:dus wire sign-arvo)
      :_  this
      :~  :: (htmx-timer now.bowl)
          :*  %pass  /htmx-refresh  %agent  [our dap]:bowl  %poke
          htmx-refresh+!>(["#current-time" "/htmx/goals/current-time" ~ "#hello-world"]~)
          ==
      ==
    ==
  ==
::
++  on-fail   on-fail:dus
--
