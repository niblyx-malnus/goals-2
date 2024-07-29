:+  'Monthly on Day'
  :~  ['Start Date' %dt]
      ['Clocktime' %ct]
  ==
'''
|=  args=(map @t arg)
=/  sd=[[a=? y=@ud] m=@ud d=@ud]
               +:;;($>(%dt arg) (~(got by args) 'Start Date'))
=/  ct=@dr     +:;;($>(%ct arg) (~(got by args) 'Clocktime'))
^-  $-(@ud (each dext rule-exception))
|=  idx=@ud
=/  start=@da  (year [a y]:sd m.sd d.sd 0 0 0 ~)
=/  day=(unit @da)  ((monthly-on-day start) idx)
?~  day
  [%| %rule-error (crip "This day does not exist in this month.")]
[%& 0 (add u.day ct)]
'''
