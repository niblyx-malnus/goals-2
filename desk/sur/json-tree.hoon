|%
+$  json-tree  (axal (map @ta json))
+$  transition
  $%  [%put paths=(list [=path =json])]
      [%del paths=(list path)]
  ==
+$  action
  $%  [%put paths=(list [=path =json])]
      [%del paths=(list path)]
      [%read paths=(list path)]
      [%tree =path]
  ==
--
