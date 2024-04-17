/-  *action
/+  *goals-json
|_  act=[pid pool-action]
++  grow
  |%
  ++  noun  act
  --
++  grab
  |%
  ++  noun  ,[pid pool-action]
  ++  json  (ot:dejs:format ~[pid+pid:dejs axn+pool-action:dejs])
  --
++  grad  %noun
--
