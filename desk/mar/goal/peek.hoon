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
      |=  [=id desc=@t] 
      %-  pairs
      :~  [%id s+(goal-id id)]
          [%description s+desc]
      ==
      ::
        %goal-kids
      :-  %a
      %+  turn  kids.pyk
      |=  [=id desc=@t] 
      %-  pairs
      :~  [%id s+(goal-id id)]
          [%description s+desc]
      ==
      ::
      %pool-title  s+title.pyk
      %pool-note   s+note.pyk
      %goal-desc   s+desc.pyk
      %goal-note   s+note.pyk
    ==
  --
++  grab
  |%
  ++  noun  peek
  --
++  grad  %noun
--
