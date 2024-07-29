:+  'Yearly First Weekday After Date'
  :~  ['Start Date' %dt]
      ['Weekday' %wd]
      ['Clocktime' %ct]
      ['Offset' %dl] :: as if we were in this offset from UTC
  ==
'''
|=  args=(map @t arg)
=/  sd=[[a=? y=@ud] m=@ud d=@ud]
               +:;;($>(%dt arg) (~(got by args) 'Start Date'))
=/  =wkd       +:;;($>(%wd arg) (~(got by args) 'Weekday'))
=/  time=@dr   +:;;($>(%ct arg) (~(got by args) 'Clocktime'))
=/  =delta     +:;;($>(%dl arg) (~(got by args) 'Offset'))
^-  $-(@ud (each jump rule-exception))
|=  idx=@ud
=/  =fuld  [(shift-anum [a y]:sd & idx) [m d]:sd]
?.  (valid-fuld fuld)
  [%| %rule-error 'This day does not exist.']
=/  day=@da  (fuld-to-da (first-weekday-after fuld wkd))
[%& (apply-invert-delta (add day time) delta)]
'''
