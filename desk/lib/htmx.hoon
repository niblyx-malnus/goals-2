/+  *ventio, server, bind
|%
++  give-html-manx
  |=  [=dock eyre-id=@ta =manx cache=?]
  =/  m  (strand ,vase)
  ^-  form:m
  %^    give-simple-payload:vine:bind
      dock
    eyre-id
  %-  %*(. html-response:gen:server cache cache)
  (manx-to-octs:server manx)
::
++  give-svg-manx
  |=  [=dock eyre-id=@ta =manx cache=?]
  =/  m  (strand ,vase)
  ^-  form:m
  %^    give-simple-payload:vine:bind
      dock
    eyre-id
  %-  %*(. svg-response:gen:server cache cache)
  (manx-to-octs:server manx)
::
++  kv
  |%
  +$  key-value-list  (list [key=@t value=@t])
  ::
  ++  get-key
    |=  [key=@t =key-value-list]
    ^-  (unit @t)
    (get-header:http key key-value-list)
  ::
  ++  set-key
    |=  [key=@t value=@t =key-value-list]
    ^+  key-value-list
    (set-header:http key value key-value-list)
  ::
  ++  parse-body
    |=  body=(unit octs)
    ^-  key-value-list
    %-  fall  :_  ~
    %+  rush
      `@t`(tail (fall body [0 '']))
    yquy:de-purl:html
  --
:: stolen from rudder library
::
++  decap  ::  strip leading base from full site path
  |=  [base=(list @t) site=(list @t)]
  ^-  (unit (list @t))
  ?~  base  `site
  ?~  site  ~
  ?.  =(i.base i.site)  ~
  $(base t.base, site t.site)
::
++  numb :: adapted from numb:enjs:format
  |=  a=@u
  ^-  tape
  ?:  =(0 a)  "0"
  %-  flop
  |-  ^-  tape
  ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])
::
+$  hx-refresh
  $:  hx-target=tape
      hx-get=tape
      hx-indicator=(unit tape)
  ==
+$  refresh-history  ((mop @da hx-refresh) gth)
++  hon              ((on @da hx-refresh) gth)
::
++  agent
  =<  agent
  |%
  +$  card  card:agent:gall
  +$  sign  sign:agent:gall
  :: STATE DOES NOT PERSIST BETWEEN RELOADS
  ::
  +$  state-0  [%0 =refresh-history unique=(map hx-refresh @da)]
  ::
  ++  agent
    |=  interval=@dr :: clear history outside recent interval
    =|  state-0
    =*  state  -
    |=  =agent:gall
    ^-  agent:gall
    ::  !.
    |_  =bowl:gall
    +*  this  .
        def   ~(. (default-agent this %.n) bowl)
        ag    ~(. agent bowl)
    ::
    ++  on-poke
      |=  [=mark =vase]
      ^-  (quip card agent:gall)
      ?+    mark
        =^  cards  agent  (on-poke:ag mark vase)
        [cards this]
        ::
          %htmx-fast-refresh
        ?>  =(src our):bowl
        :_(this [%give %fact ~[/htmx/fast-refresh] noun+!>(~)]~)
        ::
          %htmx-refresh
        ?>  =(src our):bowl
        =+  !<(refresh-list=(list hx-refresh) vase)
        :: delete non-unique
        ::
        =.  refresh-history
          |-
          ?~  refresh-list
            refresh-history
          ?~  get=(~(get by unique) i.refresh-list)
            $(refresh-list t.refresh-list)
          %=  $
            refresh-list     t.refresh-list
            unique           (~(del by unique) i.refresh-list)
            refresh-history  (tail (del:hon refresh-history u.get))
          ==
        :: add unique hx-refreshes
        ::
        =/  pairs=(list [@da hx-refresh])
          |-
          ?:  (has:hon refresh-history now.bowl)
            $(now.bowl +(now.bowl))
          ?~  refresh-list
            ~
          :_  $(refresh-list t.refresh-list)
          [now.bowl i.refresh-list]
        =.  unique          
          %-  ~(gas by *(map hx-refresh @da))
          (turn pairs |=([a=@da b=hx-refresh] [b a]))
        =.  refresh-history  (gas:hon refresh-history pairs)

        :: clear old refreshes
        ::
        =.  refresh-history
          (lot:hon refresh-history ~ `(sub now.bowl interval))
        ::
        [~ this]
        ::
          %htmx-delete-refresh
        ?>  =(src our):bowl
        =+  !<(delete=(list @da) vase)
        =.  refresh-history
          |-
          ?~  delete
            refresh-history
          %=  $
            delete           t.delete
            refresh-history  (tail (del:hon refresh-history i.delete))
          ==
        :: clear old refreshes
        ::
        =.  refresh-history
          (lot:hon refresh-history ~ `(sub now.bowl interval))
        ::
        [~ this]
      ==
    ::
    ++  on-peek
      |=  =(pole knot)
      ^-  (unit (unit cage))
      ?.  ?=([@ %htmx *] pole)
        (on-peek:ag pole)
      ?+  pole  [~ ~]
        [%x %htmx %state ~]              ``noun+!>(state)
        [%x %htmx %refresh-history ~]    ``noun+!>(refresh-history)
      ==
    ::
    ++  on-init
      ^-  (quip card agent:gall)
      =^  cards  agent  on-init:ag
      [cards this]
    :: STATE DOES NOT PERSIST BETWEEN RELOADS
    ::
    ++  on-save   on-save:ag
    ::
    ++  on-load
      |=  old-state=vase
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-load:ag old-state)
      [cards this]
    ::
    ++  on-watch
      |=  =path
      ^-  (quip card agent:gall)
      ?+    path
        =^  cards  agent  (on-watch:ag path)
        [cards this]
        [%htmx %fast-refresh ~]  ?>(=(src our):bowl `this)
      ==
    ::
    ++  on-leave
      |=  =path
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-leave:ag path)
      [cards this]
    ::
    ++  on-agent
      |=  [=wire =sign:agent:gall]
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-agent:ag wire sign)
      [cards this]
    ::
    ++  on-arvo
      |=  [=wire =sign-arvo]
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-arvo:ag wire sign-arvo)
      [cards this]
    ::
    ++  on-fail
      |=  [=term =tang]
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-fail:ag term tang)
      [cards this]
    --
  --
++  dummy
  ;div#dummy(style "display: none;");
::
++  init-refresher  |=(base=(list @t) (refresher ~ base ~))
::
++  refresher
  |=  $:  since=(unit @da)
          base=(list @t)
          hx-refresh-list=(list hx-refresh)
      ==
  ^-  manx
  ;div#refresher
    =style  "display: none;"
    =hx-target         "this"
    =hx-get            :(weld (spud base) "/refresher" ?~(since "" "?since={(scow %da u.since)}"))
    =hx-trigger        "load"
    =hx-swap           "outerHTML"
    ;*  =|  id=@
        |-
        ?~  hx-refresh-list
           ~
        :_  $(hx-refresh-list t.hx-refresh-list)
        ;div
          =id            "refresh-fetcher-{(scow %ud id)}"
          =style         "display: none;"
          =hx-target     hx-target.i.hx-refresh-list
          =hx-get        hx-get.i.hx-refresh-list
          =hx-indicator  (fall hx-indicator.i.hx-refresh-list "")
          =hx-trigger    "load"
          =hx-swap       "outerHTML";
  ==
::
++  vine
  |=  [base=(list @t) interval=@dr]
  |=  =^vine
  ^+  vine
  |=  [=gowl vid=vent-id =mark =vase]
  =/  m  (strand ,^vase)
  ^-  form:m
  ?+    mark  (vine gowl vid mark vase) :: delegate to original
      %handle-http-request
    =+  !<([eyre-id=@ta req=inbound-request:eyre] vase)
    |^
    ::
    =/  [[ext=(unit @ta) site=(list @t)] args=key-value-list:kv]
      (parse-request-line:server url.request.req)
    =.  site  (need (decap base site))
    ::
    ?+    [method.request.req site ext]
      (vine gowl vid mark vase) :: delegate to original
      ::
        [%'GET' [%fast-refresh ~] *]
      ;<  ~  bind:m  (poke [our dap]:gowl htmx-fast-refresh+!>(~))
      (give-html-manx [our dap]:gowl eyre-id dummy |)
      ::
        [%'GET' [%refresher ~] *]
      =/  since=(unit @da)
        ?~(get=(get-key:kv 'since' args) ~ `(slav %da u.get))
      ;<  ~  bind:m  (watch /fast-refresh [our dap]:gowl /htmx/fast-refresh)
      ;<  ~  bind:m  (send-wait (add now.gowl interval))
      ;<  ~  bind:m  take-wake-or-fast-refresh
      (send-refresh-list since)
    ==
    ::
    ++  take-wake-or-fast-refresh
      =/  m  (strand ,~)
      ^-  form:m
      |=  tin=strand-input:strand
      ?+    in.tin  `[%skip ~]
        ~  `[%wait ~]
        ::
          [~ %sign [%wait @ ~] %behn %wake *]
        ?~  error.sign-arvo.u.in.tin
          `[%done ~]
        `[%fail %timer-error u.error.sign-arvo.u.in.tin]
        ::
          [~ %agent * %fact *]
        ?.  =(watch+/fast-refresh wire.u.in.tin)
          `[%skip ~]
        `[%done ~]
      ==
    ::
    ++  send-refresh-list
      |=  since=(unit @da)
      =/  m  (strand ,^vase)
      ^-  form:m
      ;<  =refresh-history  bind:m
        %+  scry-hard  ,refresh-history
        /gx/[dap.gowl]/htmx/refresh-history/noun
      ::
      =/  hx-refresh-list=(list hx-refresh)
        ?~  since  ~ :: don't refresh if no since
        (turn (tap:hon (lot:hon refresh-history ~ since)) tail)
      ::
     =/  new-since=(unit @da)
       ?~(pry=(pry:hon refresh-history) ~ `key.u.pry)
      =/  =manx  (refresher new-since base hx-refresh-list)
      (give-html-manx [our dap]:gowl eyre-id manx |)
    --
  ==
--
