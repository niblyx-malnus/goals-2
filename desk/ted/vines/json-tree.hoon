/-  *json-tree
/+  *ventio
=,  strand=strand:spider
^-  thread:spider
::
%-  vine-thread
|=  [=gowl vid=vent-id =mark =vase]
=/  m  (strand ,^vase)
^-  form:m
?>  |(=(our src):gowl (moon:title [our src]:gowl))
~?  >>  (moon:title [our src]:gowl)
  "%json-tree vine: moon access from {(scow %p src.gowl)}"
~&  "%json-tree vine: receiving mark {(trip mark)}"
?+    mark  (just-poke [our dap]:gowl mark vase) :: poke normally
    %json-tree-action
  =+  !<(act=action:jot vase)
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
      (fall (~(get of json-tree.store) (snip i.paths.act)) ~)
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
    %+  turn  ~(tap of (~(dip of json-tree.store) path.act))
    |=  [=path =(map @ta json)]
    %+  turn  ~(tap in ~(key by map))
    |=(=@ta (weld path ~[ta]))
  ==
==
