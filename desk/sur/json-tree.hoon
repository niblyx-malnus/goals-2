|%
+$  json-tree  (axal (map @ta json))
+$  transition
  $%  [%put =path =json]
      [%del =path]
  ==
::
+$  action
  $%  [%put =path =json]
      [%del =path]
      [%read =path]
      [%tree ~]
  ==
::
+$  json-tree-vent
  $@  ~
  $%  [%json =json]
      [%tree paths=(list path)]
  ==
--
