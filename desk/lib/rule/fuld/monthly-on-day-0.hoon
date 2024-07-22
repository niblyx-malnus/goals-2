:+  'Monthly on Day'
  :~  ['Start' %dt]
  ==
'''
|=  args=(map @t arg)
=/  sd=[y=@ud m=@ud d=@ud]  +:;;($>(%dt arg) (~(got by args) 'Start'))
^-  $-(@ud (each fullday rule-exception))
|=  idx=@ud
=/  start=@da  (year [& y.sd] m.sd d.sd 0 0 0 ~)
=/  day=(unit @da)  ((monthly-on-day start) idx)
?~  day
  [%| %rule-error (crip "This day does not exist in this month.")]
[%& (sane-fd u.day)]
'''

