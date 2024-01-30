/-  jot=json-tree
|_  act=action:jot
++  grow
  |%
  ++  noun  act
  --
++  grab
  |%
  ++  noun  action:jot
  ++  json
    =,  dejs:format
    ^-  $-(json action:jot)
    %-  of
    :~  [%put (ot ~[paths+(ar (ot ~[path+pa json+same]))])]
        [%del (ot ~[paths+(ar pa)])]
        [%read (ot ~[paths+(ar pa)])]
        [%tree ul]
    ==
  --
++  grad  %noun
--
