:+  'Yearly on Date'
  :~  ['Start' %dt]
  ==
'''
|=  args=(map @t arg)
=/  sd=[y=@ud m=@ud d=@ud]  +:;;($>(%dt arg) (~(got by args) 'Start'))
=/  start=@da  (year [& y.sd] m.sd d.sd 0 0 0 ~)
^-  $-(@ud (each fuld rule-exception))
|=  idx=@ud
=/  day=(unit @da)  ((yearly-on-date start) idx)
?~  day
  [%| %rule-error (crip "This date does not exist.")]
[%& (da-to-fuld u.day)]
'''
