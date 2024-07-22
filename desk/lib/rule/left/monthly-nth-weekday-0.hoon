:+  'Monthly nth Weekday'
  :~  ['Start Date' %dt]
      ['Clocktime' %ct]
      ['Ordinal' %od]
      ['Weekday' %wd]
  ==
'''
|=  args=(map @t arg)
=/  sd=[y=@ud m=@ud d=@ud]
               +:;;($>(%dt arg) (~(got by args) 'Start Date'))
=/  ct=@dr     +:;;($>(%ct arg) (~(got by args) 'Clocktime'))
=/  =ord       +:;;($>(%od arg) (~(got by args) 'Ordinal'))
=/  =wkd       +:;;($>(%wd arg) (~(got by args) 'Weekday'))
^-  $-(@ud (each dext rule-exception))
|=  idx=@ud
=/  start=@da  (year [& y.sd] m.sd d.sd 0 0 0 ~)
=/  day=(unit @da)  ((monthly-nth-weekday start ord wkd) idx)
?~  day
  [%| %rule-error 'This day does not exist in this month.']
[%& 0 (add u.day ct)]
'''
