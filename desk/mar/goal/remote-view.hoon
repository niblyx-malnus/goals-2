/-  *action
/+  j=gol-cli-json
|_  vyu=remote-view
++  grow
  |%
  ++  noun  vyu
  --
++  grab
  |%
  ++  noun  remote-view
  ++  json
    =,  dejs:j
    ^-  $-(json remote-view)
    %-  ot
    :~  [%dst (su fed:ag)]
        :-  %vyu
        %-  of
        :~  [%pools-data (ot ~[pids+(ar pid)])]
        ==
    ==
  --
++  grad  %noun
--


