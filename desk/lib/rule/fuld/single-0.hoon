:+  'Single'
  ['Date' %dt]~
'''
|=  args=(map @t arg)
=/  [[a=? y=@ud] m=@ud d=@ud]
  +:;;($>(%dt arg) (~(got by args) 'Date'))
^-  $-(@ud (each fuld rule-exception))
|=(@ud [%& [a y] m d])
'''
