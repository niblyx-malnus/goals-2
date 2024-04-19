/-  p=pools
/+  j=pools-json
|_  act=[id:p pool-action:p]
++  grow
  |%
  ++  noun  act
  --
++  grab
  |%
  ++  noun  ,[id:p pool-action:p]
  ++  json  (ot:dejs:format ~[id+id:dejs:j axn+pool-action:dejs:j])
  --
++  grad  %noun
--

