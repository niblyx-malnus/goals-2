/+  *ventio, server, ebind=bind, html-utils
|%
++  mx  mx:html-utils
++  kv  kv:html-utils
::
++  give-empty-200
  |=  [=dock eyre-id=@ta]
  =/  m  (strand ,vase)
  ^-  form:m
  (give-simple-payload:vine:ebind dock eyre-id [200 ~] ~)
::
++  give-html-manx
  |=  [=dock eyre-id=@ta =manx cache=?]
  =/  m  (strand ,vase)
  ^-  form:m
  %^    give-simple-payload:vine:ebind
      dock
    eyre-id
  %-  %*(. html-response:gen:server cache cache)
  (manx-to-octs:server manx)
::
++  give-svg-manx
  |=  [=dock eyre-id=@ta =manx cache=?]
  =/  m  (strand ,vase)
  ^-  form:m
  %^    give-simple-payload:vine:ebind
      dock
    eyre-id
  %-  %*(. svg-response:gen:server cache cache)
  (manx-to-octs:server manx)
::
++  send-refresh
  |=  [=dock refresh=(list hx-refresh)]
  =/  m  (strand ,~)
  ^-  form:m
  %+  poke  dock
  htmx-refresh+!>(refresh)
::
++  dedot
  |=  =tape
  ^+  tape
  ?~  tape
    ~
  ?:  ?=(%'.' i.tape)
    $(tape t.tape)
  [i.tape $(tape t.tape)]
::
++  en-html-id
  |=  =path
  ^-  tape
  ['_' (dedot (scow %uv (sham path)))]
::
++  moup
  |=  [i=@ud =path] 
  ^+  path
  ?:  =(0 i)
    path
  %=  $
    i     (dec i)
    path  (snip path)
  ==
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
++  alphabetical
  |=  [a=tape b=tape]
  ^-  ?
  =.  a  (cass a)
  =.  b  (cass b)
  |-
  ?~  a  %.y
  ?~  b  %.n
  ?:  =(i.a i.b)
    $(a t.a, b t.b)
  :: Alphabetic characters come first
  ::
  ?+  [(rush i.a alf) (rush i.b alf)]  !!
    [^ ~]           %.y
    [~ ^]           %.n
    ?([^ ^] [~ ~])  (lth i.a i.b)
  ==
::
+$  hx-refresh
  $:  hx-target=tape
      hx-get=tape
      hx-swap=(unit tape)
      hx-indicator=(unit tape)
  ==
+$  refresh-history  ((mop @da hx-refresh) gth)
++  hon              ((on @da hx-refresh) gth)
+$  session  @uv :: these should expire after a day of inactivity
:: +$  refresh-history  (map session [expire=@da refresh=(map hx-refresh @da)])
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
    !.
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
        ~&  >>  %htmx-refreshing
        ?>  =(src our):bowl
        =+  !<(refresh-list=(list hx-refresh) vase)
        :: delete non-unique
        ::
        =.  refresh-list  ~(tap in (sy refresh-list))
        =.  refresh-history
          |-
          ?~  refresh-list
            refresh-history
          ?~  get=(~(get by unique) i.refresh-list)
            $(refresh-list t.refresh-list)
          %=  $
            refresh-list     t.refresh-list
            refresh-history  (tail (del:hon refresh-history u.get))
          ==
        :: add unique hx-refreshes
        ::
        =/  pairs=(list [@da hx-refresh])
         :: initialize to unused date
         ::
          =/  key=@da
            ?~  pry=(pry:hon refresh-history)
              now.bowl
            (max now.bowl +(key.u.pry))
          |-
          ?~  refresh-list
            ~
          :-  [key i.refresh-list]
          $(key +(key), refresh-list t.refresh-list) :: increment date!
        =.  unique          
          %-  ~(gas by unique)
          (turn pairs |=([a=@da b=hx-refresh] [b a]))
        =.  refresh-history  (gas:hon refresh-history pairs)

        :: clear old refreshes
        ::
        =.  refresh-history
          (lot:hon refresh-history ~ `(sub now.bowl interval))
        ~&  refresh-history+(tap:hon refresh-history)
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
++  refresher
  |=  $:  since=@da
          base=(list @t)
          hx-refresh-list=(list hx-refresh)
      ==
  ^-  manx
  ;div#refresher
    =style  "display: none;"
    =hx-target         "this"
    =hx-get            (weld (spud base) "/refresher?since={(scow %da since)}")
    =hx-trigger        "load, every 3s" :: backup with htmx polling
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
          =hx-swap       (fall hx-swap.i.hx-refresh-list "outerHTML")
          =hx-trigger    "load";
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
      =/  since=@da  (slav %da (need (get-key:kv 'since' args)))
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
      |=  since=@da
      =/  m  (strand ,^vase)
      ^-  form:m
      ;<  =refresh-history  bind:m
        %+  scry-hard  ,refresh-history
        /gx/[dap.gowl]/htmx/refresh-history/noun
      ::
      =/  hx-refresh-list=(list hx-refresh)
        (turn (tap:hon (lot:hon refresh-history ~ `since)) tail)
      ::
     =/  new-since=@da
       ?~(pry=(pry:hon refresh-history) now.gowl key.u.pry)
      =/  =manx  (refresher new-since base hx-refresh-list)
      (give-html-manx [our dap]:gowl eyre-id manx |)
    --
  ==
--
