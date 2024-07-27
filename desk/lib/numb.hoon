:: common number formatting utilities
::
|%
++  numb :: adapted from numb:enjs:format
  |=  a=@u
  ^-  tape
  ?:  =(0 a)  "0"
  %-  flop
  |-  ^-  tape
  ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])
::
++  zfill
  |=  [w=@ud t=tape]
  ^-  tape
  ?:  (lte w (lent t))
    t
  $(t ['0' t])
--
