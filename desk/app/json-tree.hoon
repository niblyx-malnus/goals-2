/-  *json-tree
/+  vent, bout, dbug, default-agent, verb
:: import during development to force compilation
::
/=  x  /mar/json-tree-action
/=  x  /mar/json-tree-transition
/=  x  /mar/mimex
/=  x  /ted/vines/json-tree
::
|%
+$  card     card:agent:gall
+$  state-0  [%0 =json-tree]
--
::
=|  state-0
=*  state  -
::
%+  verb  |
:: %-  agent:bout
%-  agent:dbug
%-  agent:vent
^-  agent:gall
|_  =bowl:gall
+*  this    .
    def   ~(. (default-agent this %.n) bowl)
::
++  on-init   on-init:def
++  on-save   !>(state)
::
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  [~ this(state !<(state-0 old-vase))]
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src our):bowl
  ~&  "%json-tree app: receiving mark {(trip mark)}"
  ?+    mark  (on-poke:def mark vase)
      %json-tree-transition
    =+  !<(tan=transition vase)
    ~&  "%json-tree app: receiving transition {(trip -.tan)}"
    ?-    -.tan
        %put
      |-
      ?~  paths.tan
        `this
      =/  jons=(map @ta json)
        (fall (~(get of json-tree) (snip path.i.paths.tan)) ~)
      =.  jons  (~(put by jons) (rear path.i.paths.tan) json.i.paths.tan)
      =.  json-tree
        (~(put of json-tree) (snip path.i.paths.tan) jons)
      $(paths.tan t.paths.tan)
      ::
        %del
      |-
      ?~  paths.tan
        `this
      =/  jons=(map @ta json)
        (fall (~(get of json-tree) (snip i.paths.tan)) ~)
      =.  jons  (~(del by jons) (rear i.paths.tan))
      =.  json-tree
        ?~  jons
          (~(del of json-tree) (snip i.paths.tan))
        (~(put of json-tree) (snip i.paths.tan) jons)
      $(paths.tan t.paths.tan)
    ==
  ==
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
    [%x %json-tree ~]  ``noun+!>(json-tree)
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
