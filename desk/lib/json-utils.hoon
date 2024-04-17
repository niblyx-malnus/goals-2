|%
++  dejs
  =,  dejs:format
  |%
  :: json parsing for +each
  ::
  ++  ea
    |*  [a=mold b=mold]
    |=  [h=@ t=*]
    ?+  h  !!
      %y  ;;([%.y a] [%.y t])
      %n  ;;([%.n b] [%.n t])
    ==
  :: parse +each based on { "y": ... } vs { "n": ... }
  ::
  ++  ec
    |*  [a=mold b=mold]
    |*  [y=fist n=fist]
    (cu (ea a b) (of ~[y+y n+n]))
  :: parse +each based on
  :: { "method": "put", ... } vs { "method": "del", ... }
  ::
  ++  each-method
    |=  [ym=@t nm=@t]
    |*  [a=mold b=mold]
    |*  [y=fist n=fist]
    |=  jon=json
    ?>  ?=(%o -.jon)
    =;  l=?(%y %n)
      %-  ((ec a b) y n)
      o+(my [l o+(~(del by p.jon) 'method')]~)
    =/  met=json  (~(got by p.jon) 'method')
    ?>  ?=(%s -.met)
    ?:  =(p.met ym)  %y
    ?:  =(p.met nm)  %n
    !!
  --
--
