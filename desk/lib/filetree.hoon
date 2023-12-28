/+  vio=ventio, vent, bind, server, multipart, tarball, webui
|%
+$  card    card:agent:gall
+$  sign    sign:agent:gall
++  strand  strand:vio
+$  twig    [fil=(list (pair @ta mark)) dir=(list @ta)]
+$  branch  (each cage twig)
::
++  max-1-da  max-1-da:gen:server
++  max-1-wk  max-1-wk:gen:server
:: from ~paldev's /lib/rudder.hoon
::
++  frisk  ::  parse url-encoded form args
  |=  body=@t
  %-  ~(gas by *(map @t @t))
  (fall (rush body yquy:de-purl:html) ~)
::
++  mime-response
  =|  cache=(unit ?(%d %w))
  |=  =mime
  ^-  simple-payload:http
  :_  `q.mime
  :-  200
  :-  ['content-type' `@t`(rsh [3 1] (spat p.mime))]
  ?-(cache ~ ~, [~ %d] [max-1-da ~], [~ %w] [max-1-wk ~])
::
+$  filetree-action
  $%  [%put-directory =path contents=(map path cage)]
      [%put-file =path =cage]
      [%del =path]
  ==
::  filetree
::
::  +filetree: gall agent core with extra arms
::
++  filetree
  $_  ^|
  |_  bowl:gall
  ++  on-tree  |~(path *branch)
  ::NOTE  standard gall agent arms below
  ::
  ++  on-init
    *(quip card _^|(..on-init))
  ::
  ++  on-save
    *vase
  ::
  ++  on-load
    |~  vase
    *(quip card _^|(..on-init))
  ::
  ++  on-poke
    |~  [mark vase]
    *(quip card _^|(..on-init))
  ::
  ++  on-watch
    |~  path
    *(quip card _^|(..on-init))
  ::
  ++  on-leave
    |~  path
    *(quip card _^|(..on-init))
  ::
  ++  on-peek
    |~  path
    *(unit (unit cage))
  ::
  ++  on-agent
    |~  [wire sign]
    *(quip card _^|(..on-init))
  ::
  ++  on-arvo
    |~  [wire sign-arvo]
    *(quip card _^|(..on-init))
  ::
  ++  on-fail
    |~  [term tang]
    *(quip card _^|(..on-init))
  --
::  +default: bare-minimum implementations of filetree arms
::
++  default
  |_  =bowl:gall
  ++  on-tree  |=(=path ~|("filetree: {(spud path)} is not defined" !!))
  --
:: assumes unique non-file args
::
++  parts-and-args
  |=  [name=@t parts=(list [name=@t =part:multipart])]
  ^-  [(list part:multipart) (map @t @t)]
  =|  =(list part:multipart)
  =|  =(map @t @t)
  |-
  ?~  parts
    [list map]
  ?:  =(name name.i.parts)
    $(parts t.parts, list [part.i.parts list])
  %=  $
    parts  t.parts
    map    (~(put by map) [name body.part]:i.parts)
  ==
::
++  part-to-mime
  |=(=part:multipart `mime`(need type.part)^(met 3 body.part)^body.part)
::
++  vine
  |=  =vine:vio
  =<
  ^-  vine:vio
  |=  [=gowl:vio vid=vent-id:vio =mark =vase]
  =*  hc  ~(. +> gowl)
  =/  m  (strand ,^vase)
  ^-  form:m
  ?+    mark  (vine gowl vid mark vase) :: delegate to original
      %handle-http-request
    =+  !<([eyre-id=@ta req=inbound-request:eyre] vase)
    :: exposes ext, site and args
    ::
    =+  (parse-request-line:server url.request.req)
    =+  ;;(=path +>.site)
    ::
    ?+    [site ext]  (vine gowl vid mark vase)
      ::
        [[%filetree @ta *] *]
      ?>  =(dap.gowl +<.site)
      ?>  =(src our):gowl
      ?+    method.request.req  (just-poke:vio [our dap]:gowl mark vase)
          %'POST'
        ?~  cot=(get-header:http 'content-type' header-list:request.req)
          ~|("no content-type header" !!)
        :: multipart upload
        ::
        ?:  =('multipart/form-data; boundary=' (end 3^30 u.cot))
          =/  parts=(list [name=@t =part:multipart])
            (fall (de-request:multipart [header-list body]:request.req) ~)
          =/  [patz=(list =part:multipart) args=(map @t @t)]
            (parts-and-args 'file' parts)
          =/  curr=^path    (rash (~(got by args) 'current-page') stap)
          =/  file-type=@t  (~(got by args) 'file-type')
          ?~  patz  ~|("no files uploaded" !!)
          ?:  =('directory' file-type)
            =/  [=^path contents=(map ^path cage)]
              (parts-to-contents:hc (~(has by args) 'create') path patz)
            =/  put=filetree-action  [%put-directory path contents]
            ;<  p=*  bind:m  (poke-soft:vio [our dap]:gowl filetree-action+!>(put))
            ;<  [curr=^^path =twig]  bind:m  (get-curr-or-root:hc curr)
            =;  =message:webui
              (give-message:hc message eyre-id curr twig)
            ?^  p
              `[%| "Directory upload to {(spud path)} failed..."]
            `[%& "Directory upload to {(spud path)} succeeded!"]
            ::
          =/  [=^path =cage]
            (part-to-cage:hc (~(has by args) 'create') path part.i.patz)
          =/  put=filetree-action  [%put-file path cage]
          ;<  p=*  bind:m  (poke-soft:vio [our dap]:gowl filetree-action+!>(put))
          ;<  [curr=^^path =twig]  bind:m  (get-curr-or-root:hc curr)
          =;  =message:webui
            (give-message:hc message eyre-id curr twig)
          ?^  p
            `[%| "File upload to {(spud path)} failed..."]
          `[%& "File upload to {(spud path)} succeeded!"]
        ::
        ?.  =('application/x-www-form-urlencoded' u.cot)
          ~|("unsupported content type: {(trip u.cot)}" !!)
        ?~  body.request.req
          ~|("no body in http-request" !!)
        =/  args=(map @t @t)  (frisk q.u.body.request.req)
        =/  name=^path  (rash (~(got by args) 'delete') stap)
        =/  del=filetree-action  [%del name]
        ;<  p=*  bind:m  (poke-soft:vio [our dap]:gowl filetree-action+!>(del))
        ;<  [curr=^path =twig]  bind:m  (get-curr-or-root:hc path)
        =;  =message:webui
          (give-message:hc message eyre-id curr twig)
        ?^  p
          `[%| "Delete {(spud name)} failed..."]
        `[%& "Delete {(spud name)} succeeded!"]
        :: TODO: create %mimex mark or equivalent solution for
        ::       files which come with both a mime type and a
        ::       file extension but don't match a mark
        :: TODO: actually get the whole create/delete flow working
        ::       on a real state example (%goals)
      ==
    ==
  ==
  ::
  |_  =gowl:vio
  +*  targ  ~(. gen:tarball gowl)
  ++  part-to-cage
    |=  [root=? =path =part:multipart]
    ^-  [^path cage]
    ?>  ?=(^ file.part)
    =+  (parse-request-line:server (cat 3 '/' u.file.part))
    ?>  ?=(^ site)
    :-  ?.(root path (weld path [i.site (fall ext '') ~]))
    %+  mime-to-cage:targ
      (part-to-mime part)
    (fall ext '')
  ::
  ++  parts-to-contents
    |=  [root=? =path parts=(list part:multipart)]
    ^-  [^path contents=(map ^path cage)]
    =;  [dir=@t cages=(list [^path cage])]
      :-  ?.(root path (snoc path dir))
      (~(gas by *(map ^path cage)) cages)
    =|  cages=(list [^path cage])
    |-
    ?>  ?=(^ parts)
    ?>  ?=(^ file.i.parts)
    =+  (parse-request-line:server (cat 3 '/' u.file.i.parts))
    ?>  ?=(^ site)
    ?~  t.parts
      [i.site cages]
    %=    $
      parts  t.parts
        cages
      :_  cages
      :-  (snoc t.site (fall ext ''))
      %+  mime-to-cage:targ
        (part-to-mime i.parts)
      (fall ext '')
    ==
    ::
    ++  get-curr-or-root
      |=  curr=path
      =/  m  (strand ,[path twig])
      ^-  form:m
      ?:  =(/ curr)
        =/  =path  [%gx dap.gowl %filetree %branch %noun ~]
        ;<  =twig  bind:m  (scry-hard:vio ,twig path)
        (pure:m [/ twig])
      =/  =path
        (welp [%gx dap.gowl %filetree %branch curr] /noun)
      ;<  utwig=(unit twig)  bind:m  (unit-scry:vio ,twig path)
      ?~  utwig
        $(curr /)
      (pure:m [curr u.utwig])
    ::
    ++  give-message
      |=  [=message:webui eyre-id=@ta curr=path =twig]
      =/  m  (strand ,vase)
      ^-  form:m
      %^    give-simple-payload:vine:bind
          [our dap]:gowl
        eyre-id
      %-  %*(. html-response:gen:server cache |)
      %-  manx-to-octs:server
      (page:webui message dap.gowl curr twig)
  --
::
++  agent-bind  (agent:bind & ~[[`/filetree/'.dap' &]])
::  +agent: creates wrapper core
::
++  agent
  |=  tree=filetree
  =<
  %-  agent-bind
  %-  agent:vent
  ^-  agent:gall
  !.
  |_  =bowl:gall
  +*  this  .
      vnt   ~(. (utils:vent this) bowl)
      tg    ~(. tree bowl)
      hc    ~(. +> bowl)
  ::
  ++  on-init
    ^-  (quip card agent:gall)
    =^  cards  tree  on-init:tg
    [cards this]
  ::
  ++  on-save   on-save:tg
  ::
  ++  on-load
    |=  old-state=vase
    =^  cards  tree  (on-load:tg old-state)
    [cards this]
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card agent:gall)
    ?+    mark
      =^  cards  tree  (on-poke:tg mark vase)
      [cards this]
    ::
        %handle-http-request
      =+  !<([eyre-id=@ta req=inbound-request:eyre] vase)
      :: exposes ext, site and args
      ::
      =+  (parse-request-line:server url.request.req)
      =+  ;;(=path +>.site)
      ::
      ?+    [site ext]
        =^  cards  tree  (on-poke:tg mark vase)
        [cards this]
        ::
          [[%filetree @ta *] *]
        ?>  =(dap.bowl +<.site)
        ?>  =(src our):bowl
        ?+    method.request.req  (poke-to-vent:vnt mark vase)
            %'GET'
          ?^  ext
            :_  this
            %+  give-simple-payload:app:server
              eyre-id
            ?>  ((sane %tas) u.ext)
            (mime-response (tree-mime:hc path u.ext))
          ::
          =/  =branch  (on-tree:tg path)
          ?>  ?=(%| -.branch)
          :_  this
          %+  give-simple-payload:app:server
            eyre-id
          %-  %*(. html-response:gen:server cache |)
          %-  manx-to-octs:server
          (page:webui ~ dap.bowl path p.branch)
        ==
      ==
    ==
  ::
  ++  on-watch
    |=  =path
    ^-  (quip card agent:gall)
    =^  cards  tree  (on-watch:tg path)
    [cards this]
  ::
  ++  on-leave
    |=  =path
    ^-  (quip card agent:gall)
    =^  cards  tree  (on-leave:tg path)
    [cards this]
  ::
  ++  on-peek
    |=  =(pole knot)
    ^-  (unit (unit cage))
    ?+    pole  (on-peek:tg pole)
        [%x %filetree rest=*]
      ?+    rest.pole  (on-peek:tg pole)
          [%tar rest=*]
        =/  =branch  (on-tree:tg rest.rest.pole)
        ?>  ?=(%& -.branch)
        ``noun+!>((convert-simple-ball:tarball (tree-ball pole)))
        ::
          [%branch rest=*]
        =/  =branch  (on-tree:tg rest.rest.pole)
        ?-  -.branch
          %&  ``p.branch
          %|  ``noun+!>(p.branch)
        ==
      ==
    ==
  ::
  ++  on-agent
    |=  [=wire =sign]
    ^-  (quip card agent:gall)
    =^  cards  tree  (on-agent:tg wire sign)
    [cards this]
  ::
  ++  on-arvo
    |=  [=wire =sign-arvo]
    ^-  (quip card agent:gall)
    =^  cards  tree  (on-arvo:tg wire sign-arvo)
    [cards this]
  ::
  ++  on-fail
    |=  [=term =tang]
    ^-  (quip card agent:gall)
    =^  cards  tree  (on-fail:tg term tang)
    [cards this]
  --
  ::
  |_  =bowl:gall
  +*  this  .
      tg    ~(. tree bowl)
      targ  ~(. gen:tarball bowl)
  ::
  ++  tree-mime
    |=  [=path =mark]
    ^-  mime
    ?:  ?=(%tar mark)
      =/  =branch  (on-tree:tg path)
      ?>  ?=(%| -.branch)
      (simple-ball-to-mime:targ (tree-ball path))
    =/  =branch  (on-tree:tg (snoc path mark))
    ?>  ?=(%& -.branch)
    (cage-to-mime:targ (recage:targ p.branch mark))
  ::
  ++  tree-ball
    =/  max=@   100
    =|  idx=@
    |=  =path
    ^-  simple-ball:tarball
    :: catch loops
    ::
    ?:  (gte idx max)
      ~|("filetree: directory depth exceeding {(trip (numb:tarball max))}. Loop likely." !!)
    :: get tree branch
    ::
    =/  =branch  (on-tree:tg path)
    :: assert directory
    ::
    ?:  ?=(%& -.branch)
      ~|("filetree: {(spud path)} is not a directory" !!)
    :: iterate over files
    ::
    :-  :-  ~
        %-  ~(gas by *simple-lump:tarball)
        %+  turn  fil.p.branch
        |=  [name=@ta =mark]
        =.  path  (weld path [name mark ~])
        =/  =^branch  (on-tree:tg path)
        ?.  ?=(%& -.branch)
          ~|("filetree: {(spud path)} is not a file" !!)
        [name p.branch]
    :: recursively iterate over directories
    ::
    %-  ~(gas by *(map @ta simple-ball:tarball))
    %+  turn  dir.p.branch
    |=  name=@ta
    =.  path  (weld path [name ~])
    [name (%*(. tree-ball idx +(idx)) path)]
  --
--
