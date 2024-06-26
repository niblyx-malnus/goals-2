/-  *json-tree
/+  *ventio
=,  strand=strand:spider
^-  thread:spider
::
=<
::
%-  vine-thread
|=  [=gowl vid=vent-id =mark =vase]
=/  m  (strand ,^vase)
^-  form:m
~&  "vent to {<dap.gowl>} vine with mark {<mark>}"
;<  =json-tree  bind:m  (scry-hard ,json-tree /gx/json-tree/json-tree/noun)
?+    mark  (strand-fail %bad-vent-request ~)
    %json-tree-action
  =+  !<(act=action vase)
  ~&  "%json-tree vine: receiving action {(trip -.act)}"
  ?-    -.act
      %put
    ;<  ~  bind:m  (poke [our dap]:gowl json-tree-transition+!>(act))
    (pure:m !>(~))
    ::
      %del
    ;<  ~  bind:m  (poke [our dap]:gowl json-tree-transition+!>(act))
    (pure:m !>(~))
    ::
      %read
    =|  jsons=(map path json)
    |-
    ?~  paths.act
      (pure:m !>((enjs-jsons jsons)))
    =/  jons=(map @ta json)
      (fall (~(get of json-tree) (snip i.paths.act)) ~)
    =/  =json  (~(got by jons) (rear i.paths.act))
    %=  $
      paths.act  t.paths.act
      jsons      (~(put by jsons) i.paths.act json)
    ==
    ::
      %tree
    =;  paths=(list path)
      (pure:m !>(a+(turn paths |=(=path s+(spat path)))))
    %-  zing
    %+  turn  ~(tap of (~(dip of json-tree) path.act))
    |=  [=path =(map @ta json)]
    %+  turn  ~(tap in ~(key by map))
    |=(=@ta (weld path ~[ta]))
  ==
==
::
|%
++  enjs-jsons
  =,  enjs:format
  |=  jsons=(map ^path ^json)
  o/(malt (turn ~(tap by jsons) |=([=^path =^json] [(spat path) json])))
--
