:+  'Monthly nth Weekday'
  :~  ['Start' %dt]
      ['Ordinal' %od]
      ['Weekday' %wd]
  ==
'''
|=  args=(map @t arg)
=/  sd=[[a=? y=@ud] m=@ud d=@ud]
               +:;;($>(%dt arg) (~(got by args) 'Start'))
=/  =ord       +:;;($>(%od arg) (~(got by args) 'Ordinal'))
=/  =wkd       +:;;($>(%wd arg) (~(got by args) 'Weekday'))
^-  $-(@ud (each fuld rule-exception))
|=  idx=@ud
[%& ((monthly-nth-weekday-after sd ord wkd) idx)]
'''
