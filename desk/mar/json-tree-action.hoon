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
    :~  [%put (ot ~[path+pa json+same])]
        [%del (ot ~[path+pa])]
        [%read (ot ~[path+pa])]
        [%tree ul]
    ==
  --
++  grad  %noun
--
