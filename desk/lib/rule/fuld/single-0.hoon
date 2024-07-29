:+  'Single'
  ['Date' %dt]~
'''
|=  args=(map @t arg)
=/  [y=@ud m=@ud d=@ud]  +:;;($>(%dt arg) (~(got by args) 'Date'))
^-  $-(@ud (each fuld rule-exception))
|=(@ud [%& [& y] m d])
'''
