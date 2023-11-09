/-  gol=goals, vyu=views, pyk=peek, spider
/+  *ventio, gol-cli-view, gol-cli-traverse, gol-cli-etch
=,  strand=strand:spider
=>  |%
    +$  gowl  bowl:gall
    +$  sowl  bowl:spider
    --
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
::
=+  !<(req=(unit [gowl request]) arg)
?~  req  (strand-fail %no-arg ~)
=/  [=gowl vid=vent-id =mark =noun]  u.req
;<  =vase  bind:m  (unpage mark noun)
::
;<  ~  bind:m  (trace %running-goals-vine ~)
::
|^
?+    mark  (just-poke [our dap]:gowl mark vase) :: poke normally
    %goal-view
  =+  !<(=parm:vyu vase)
  ;<  =store:gol  bind:m  get-store
  =*  vw  ~(. gol-cli-view store gowl)
  (pure:m !>((view-data:vw parm)))
==
::
++  get-store
  =/  m  (strand ,store:gol)
  ^-  form:m
  ~&  %getting-store
  ;<  =peek:pyk  bind:m
    (scry-hard ,peek:pyk /gx/goals/store/noun)
  ?>(?=(%store -.peek) (pure:m store.peek))
--
