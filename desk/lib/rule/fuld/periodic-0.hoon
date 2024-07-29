:+  'Periodic'
  :~  ['Start' %dt]
      ['Period' %dr]
  ==
'''
|=  args=(map @t arg)
=/  sd=[y=@ud m=@ud d=@ud]
                +:;;($>(%dt arg) (~(got by args) 'Start'))
=/  period=@dr  +:;;($>(%dr arg) (~(got by args) 'Period'))
=/  start=@da  (year [& y.sd] m.sd d.sd 0 0 0 ~)
^-  $-(@ud (each fuld rule-exception))
|=(idx=@ud [%& (da-to-fuld (add (sane-fd start) (mul idx period)))])
'''
