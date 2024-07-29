:+  'Periodic'
  :~  ['Start Date' %dt]
      ['Clocktime' %ct]
      ['Period' %dr]
  ==
'''
|=  args=(map @t arg)
=/  sd=[[a=? y=@ud] m=@ud d=@ud]
                +:;;($>(%dt arg) (~(got by args) 'Start Date'))
=/  ct=@dr      +:;;($>(%ct arg) (~(got by args) 'Clocktime'))
=/  period=@dr  +:;;($>(%dr arg) (~(got by args) 'Period'))
^-  $-(@ud (each dext rule-exception))
|=  idx=@ud
=/  start=@da  (year [a y]:sd m.sd d.sd 0 0 0 ~)
=/  =time  (add (sane-fd start) (mul idx period))
[%& 0 (add time ct)]
'''
