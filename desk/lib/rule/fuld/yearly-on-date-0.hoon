:+  'Yearly on Date'
  :~  ['Start' %dt]
  ==
'''
|=  args=(map @t arg)
=/  start=fuld  +:;;($>(%dt arg) (~(got by args) 'Start'))
^-  $-(@ud (each fuld rule-exception))
|=  idx=@ud
=/  fuld=(unit fuld)  ((yearly-on-date start) idx)
?~  fuld
  [%| %rule-error 'This date does not exist.']
[%& u.fuld]
'''
