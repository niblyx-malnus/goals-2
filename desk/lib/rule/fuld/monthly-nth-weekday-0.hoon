:+  'Monthly nth Weekday'
  :~  ['Start' %dt]
      ['Ordinal' %od]
      ['Weekday' %wd]
  ==
'''
|=  args=(map @t arg)
=/  sd=[y=@ud m=@ud d=@ud]
               +:;;($>(%dt arg) (~(got by args) 'Start'))
=/  =ord       +:;;($>(%od arg) (~(got by args) 'Ordinal'))
=/  =wkd       +:;;($>(%wd arg) (~(got by args) 'Weekday'))
^-  $-(@ud (each fullday rule-exception))
|=  idx=@ud
=/  start=@da  (year [& y.sd] m.sd d.sd 0 0 0 ~)
=/  day=(unit @da)  ((monthly-nth-weekday start ord wkd) idx)
?~  day
  [%| %rule-error 'This day does not exist in this month.']
[%& (sane-fd u.day)]
'''
