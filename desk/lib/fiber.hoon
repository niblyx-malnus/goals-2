::  fiber: agent wrapper for ....
::
/+  default-agent
:: first off a special kind of poke needs to trigger
:: a fiber 
::
::
|%
+$  card  card:agent:gall
+$  sign  sign:agent:gall
::
+$  vid   @tavid
::
+$  intake
  $%  [%poke =cage]
  ==
::
++  spool
  |*  state=mold
  |%
  ++  input-raw
    |*  state=mold
    $:(=bowl:gall =state in=(unit intake))
  ::
  ++  output-raw
    |*  [state=mold value=mold]
    $~  [~ %done *value]
    $:  cards=(list card)
        =state
        $=  next
        $%  [%wait ~]
            [%skip ~]
            [%cont self=(form-raw value)]
            [%fail err=(pair term tang)]
            [%done =value]
        ==
    ==
  ::
  ++  form-raw
    |*  [state=mold value=mold]
    $-((input-raw state) (output-raw state value))
  ::
  ++  fiber
    |*  value=mold
    |%
    +$  input   (input-raw state)
    +$  output  (output-raw state value)
    +$  form    (form-raw state value)
    ::
    ++  pure
      |=  arg=value
      ^-  form
      |=  input
      [~ state %done arg]
    ::
    ++  bind
      |*  b=mold
      |=  [m-b=(form-raw state b) fun=$-(b form)]
      ^-  form
      |=  =input
      =/  b-res=(output-raw state b)  (m-b input)
      ^-  output
      :-  cards.b-res
      :-  state.b-res
      ?-    -.next.b-res
        %wait  [%wait ~]
        %skip  [%skip ~]
        %cont  [%cont ..$(m-b self.next.b-res)]
        %fail  [%fail err.next.b-res]
        %done  [%cont (fun value.next.b-res)]
      ==
    ::
    ++  eval
      |%
      +$  result
        $%  [%next ~]
            [%fail err=(pair term tang)]
            [%done =value]
        ==
      ::
      ++  take
        =|  cards=(list card)
        |=  [=form =input]
        ^-  [[(list card) state result] _form]
        =/  =output  (form input)
        =.  cards  (weld cards cards.output)
        ?:  ?=(%cont -.next.output)
          %=  $
            form   self.next.output
            input  [bowl.input state.output ~]
          ==
        :_  form
        :-  cards  :-  state.output
        ?-  -.next.output
            %wait  [%next ~]
            %skip  [%next ~]
            %fail  [%fail err.next.output]
            %done  [%done value.next.output]
        ==
      --
    --
  --
::
++  vine-agent
  |*  state-type=mold
  $_  ^|
  |_  bowl:gall
  ++  on-vine   |~(cage *form:(fiber:(spool state-type) ,cage))
  :: standard gall agent arms
  ::
  ++  on-init   *(quip card _^|(..on-init))
  ++  on-save   *vase
  ++  on-load   |~(vase *(quip card _^|(..on-init)))
  ++  on-poke   |~([mark vase] *(quip card _^|(..on-init)))
  ++  on-watch  |~(path *(quip card _^|(..on-init)))
  ++  on-leave  |~(path *(quip card _^|(..on-init)))
  ++  on-peek   |~(path *(unit (unit cage)))
  ++  on-agent  |~([wire sign:agent:gall] *(quip card _^|(..on-init)))
  ++  on-arvo   |~([wire sign-arvo] *(quip card _^|(..on-init)))
  ++  on-fail   |~([term tang] *(quip card _^|(..on-init)))
  --
::
++  agent
  |*  state-type=mold
  =<  agent
  |%
  ++  sp    (spool state-type)
  +$  reed  _*form:(fiber:sp ,cage)
  +$  vine  $-(cage reed)
  +$  tack
    $:  =reed                       :: active continuation
        take=(set (pair dock wire)) :: outgoing requests
        give=(pair dock wire)       :: return address
    ==
  :: STATE DOES NOT PERSIST BETWEEN RELOADS
  ::
  +$  state-0  [%0 reef=(map vid tack)]
  ++  agent
    |=  agent=(vine-agent state-type)
    ^-  agent:gall
    :: !.
    =|  state-0
    =*  state  -
    =<
    |_  =bowl:gall
    +*  this  .
        def   ~(. (default-agent this %.n) bowl)
        og    ~(. agent bowl)
        hc    ~(. +> bowl)
    ::
    ++  on-poke
      |=  [=mark =vase]
      ^-  (quip card agent:gall)
      ?+  mark
        =^  cards  agent  (on-poke:og mark vase)
        [cards this]
        ::
          %fiber-input
        !!
        ::
          %fiber-make-request
        ?>  =(our src):bowl
        =+  !<([=vid =dock =cage] vase)
        =/  =tack  (~(got by reef) vid) 
        =.  take.tack
          |-
          =/  =wire  /vine/[vid]/(scot %uv (sham eny.bowl))
          ?:  (~(has in take.tack) dock wire)
            $(eny.bowl +(eny.bowl))
          (~(put in take.tack) dock wire)
        :_  this  :_  ~
        :*  %pass  /  %agent  dock  %poke
            fiber-take-request+!>([wire cage])
        ==
        ::
          %fiber-take-request
        ?>  ?=([%gall @ta ~] sap.bowl)
        =/  sap=dude:gall  i.t.sap.bowl
        =+  !<([=wire =cage] vase)
        =/  =dock  [src.bowl sap]
        =/  res  (mule |.((on-vine:og cage)))
        ?:  ?=(%| -.res)
          :_  this  :_  ~
          :*  %pass  /  %agent  dock  %poke
              fiber-response+!>([wire %| %false-start p.res])
          ==
        =/  =tack  [p.res ~ dock wire]
        =.  reef
          |-
          =/  =vid  (scot %uv (sham eny.bowl))
          ?:  (~(has by reef) vid)
            $(eny.bowl +(eny.bowl))
          (~(put by reef) vid tack)
        =^  cards  state
          (ingest vid ~)
        [cards state]
        ::
          %fiber-take-response
        =/  =pith  [p/src.bowl (pave sap.bowl)]
        =+  !<([=wire arow=(each cage goof)] vase)
        :: /vine/
        !!
      ==

    ::
    ++  on-peek
      |=  =path
      ^-  (unit (unit cage))
      (on-peek:og path)
    ::
    ++  on-init
      ^-  (quip card agent:gall)
      =^  cards  agent  on-init:og
      [cards this]
    ::
    ++  on-save   on-save:og
    ::
    ++  on-load
      |=  old-state=vase
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-load:og old-state)
      [cards this]
    ::
    ++  on-watch
      |=  =path
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-watch:og path)
      [cards this]
    ::
    ++  on-leave
      |=  =path
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-leave:og path)
      [cards this]
    ::
    ++  on-agent
      |=  [=wire =sign:agent:gall]
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-agent:og wire sign)
      [cards this]
    ::
    ++  on-arvo
      |=  [=wire =sign-arvo]
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-arvo:og wire sign-arvo)
      [cards this]
    ::
    ++  on-fail
      |=  [=term =tang]
      ^-  (quip card agent:gall)
      =^  cards  agent  (on-fail:og term tang)
      [cards this]
    --
    ::
    |_  =bowl:gall
    ++  ingest
      |=  [=vid intake=(unit intake)]
      ^-  (quip card _state)
      =/  f  (fiber:sp ,cage)
      =/  =reed  reed:(~(got by reef) vid)
      =/  [[cards=(list card) new-state=state-0 =result:eval:f] =^reed]
        =+  (mule |.((take:eval:f reed bowl state intake)))
        ?-(-< %& p, %| [[~ state [%fail %crash p]] reed])
      [cards new-state]
    --
  --
--
