:+  'Single'
  ['Date' %dt]~
'''
|=  args=(map @t arg)
=/  [y=@ud m=@ud d=@ud]  +:;;($>(%dt arg) (~(got by args) 'Date'))
^-  $-(@ud (each fullday rule-exception))
|=(@ud [%& (year [& y] m d 0 0 0 ~)])
'''
