:+  'Yearly on Date'
  :~  ['Start Date' %dt]
      ['Clocktime' %ct]
  ==
'''
|=  args=(map @t arg)
=/  start=fuld  +:;;($>(%dt arg) (~(got by args) 'Start Date'))
=/  ct=@dr      +:;;($>(%ct arg) (~(got by args) 'Clocktime'))
^-  $-(@ud (each dext rule-exception))
|=  idx=@ud
=/  fuld=(unit fuld)  ((yearly-on-date start) idx)
?~  fuld
  [%| %rule-error 'This date does not exist.']
[%& 0 (add (fuld-to-da u.fuld) ct)]
'''
