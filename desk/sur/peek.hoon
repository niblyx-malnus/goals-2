/-  *views
|%
+$  peek
  $%  [%store =store]
      [%views =views]
      [%pools-index pools=(list [pin @t])]
      [%pool-roots roots=(list [id @t ? ?])]
      [%goal-young young=(list [id ? @t ? ?])]
      [%pool-title title=@t]
      [%pool-note note=@t]
      [%goal-desc desc=@t]
      [%goal-note note=@t]
      [%uid id=(unit id)]
      [%loob loob=?]
  ==
--
