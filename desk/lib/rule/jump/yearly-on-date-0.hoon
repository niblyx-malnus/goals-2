:+  'Yearly On Date'
  :~  ['Start Date' %dt]
      ['Clocktime' %ct]
      ['Offset' %dl] :: as if we were in this offset from UTC
  ==
'''
|=  args=(map @t arg)
=/  sd=[[a=? y=@ud] m=@ud d=@ud]
               +:;;($>(%dt arg) (~(got by args) 'Start Date'))
=/  time=@dr   +:;;($>(%ct arg) (~(got by args) 'Clocktime'))
=/  =delta     +:;;($>(%dl arg) (~(got by args) 'Offset'))
^-  $-(@ud (each jump rule-exception))
|=  idx=@ud
=/  =fuld  [(shift-anum [a y]:sd & idx) [m d]:sd]
?.  (valid-fuld fuld)
  [%| %rule-error 'This date does not exist.']
=/  day=@da  (fuld-to-da fuld)
[%& (apply-invert-delta (add day time) delta)]
'''
