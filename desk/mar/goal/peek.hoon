/-  *peek
/+  *gol-cli-json, v=gol-cli-view
|_  pyk=peek
++  grow
  |%
  ++  noun  pyk
  ++  json
    =,  enjs:format
    %.  pyk
    |=  pyk=peek
    ^-  ^json
    ?-    -.pyk
      %store  (frond %store (enjs-store store.pyk))
      %views  (frond %views (views:enjs:v views.pyk))
      ::
        %pools-index
      :-  %a
      %+  turn  pools.pyk
      |=  [=pin title=@t] 
      %-  pairs
      :~  [%pin s+(pool-id pin)]
          [%title s+title]
      ==
      ::
        %pool-roots
      :-  %a
      %+  turn  roots.pyk
      |=  [=id desc=@t complete=? actionable=?] 
      %-  pairs
      :~  [%id (enjs-id id)]
          [%description s+desc]
          [%complete b+complete]
          [%actionable b+actionable]
      ==
      ::
        %goal-young
      :-  %a
      %+  turn  young.pyk
      |=  [=id virtual=? desc=@t complete=? actionable=?] 
      %-  pairs
      :~  [%id (enjs-id id)]
          [%virtual b+virtual]
          [%description s+desc]
          [%complete b+complete]
          [%actionable b+actionable]
      ==
      ::
      %pool-title  s+title.pyk
      %pool-note   s+note.pyk
      %goal-desc   s+desc.pyk
      %goal-note   s+note.pyk
      %goal-tags   a+(turn tags.pyk enjs-tag)
      %uid         ?~(id.pyk ~ (enjs-id u.id.pyk))
      %loob        b+loob.pyk
    ==
  --
++  grab
  |%
  ++  noun  peek
  --
++  grad  %noun
--
