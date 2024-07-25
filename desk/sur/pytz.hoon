/+  *time-utils
|%
+$  rule   [offset=delta name=@t]
+$  zone   ((mop jump rule) lth)
+$  zones  (map @t zone)
++  zon    ((on jump rule) lth)
::
+$  action
  $%  [%put-zone name=@t data=(list [jump rule])]
  ==
--
