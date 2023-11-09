/-  *views
|%
+$  peek
  $%  [%store =store]
      [%views =views]
      [%pools-index pools=(list [pin @t])]
      [%pool-roots roots=(list [id @t ? ?])]   :: id, desc, cmp, axn
      [%goal-young young=(list [id ? @t ? ?])] :: id, desc, cmp, axn
      [%pool-title title=@t]
      [%pool-note note=@t]
      [%goal-desc desc=@t]
      [%goal-note note=@t]
      [%goal-tags tags=(list tag)]
      [%uid id=(unit id)]
      [%loob loob=?]
  ==
--
