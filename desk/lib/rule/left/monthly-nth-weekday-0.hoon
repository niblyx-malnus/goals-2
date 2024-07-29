:+  'Monthly nth Weekday'
  :~  ['Start Date' %dt]
      ['Clocktime' %ct]
      ['Ordinal' %od]
      ['Weekday' %wd]
  ==
'''
|=  args=(map @t arg)
=/  sd=[[a=? y=@ud] m=@ud d=@ud]
               +:;;($>(%dt arg) (~(got by args) 'Start Date'))
=/  ct=@dr     +:;;($>(%ct arg) (~(got by args) 'Clocktime'))
=/  =ord       +:;;($>(%od arg) (~(got by args) 'Ordinal'))
=/  =wkd       +:;;($>(%wd arg) (~(got by args) 'Weekday'))
^-  $-(@ud (each dext rule-exception))
|=  idx=@ud
=/  =fuld  ((monthly-nth-weekday-after sd ord wkd) idx)
=/  day=@da  (fuld-to-da fuld)
[%& 0 (add day ct)]
'''
