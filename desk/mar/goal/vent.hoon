/-  *action
/+  *gol-cli-json
|_  vnt=goal-vent
++  grow
  |%
  ++  noun  vnt
  ++  json
    =,  enjs:format
    %.  vnt
    |=  vnt=goal-vent
    ^-  ^json
    ?~  vnt  ~
    ?-    -.vnt
        %harvest
      :-  %a
      %+  turn  harvest.vnt
      |=  [=id desc=@t complete=? actionable=? tags=(list @t)]
      %-  pairs
      :~  [%id (enjs-id id)]
          [%description s+desc]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags (lead %s))]
      ==
      ::
        %pools-index
      :-  %a
      %+  turn  pools.vnt
      |=  [=pin title=@t] 
      %-  pairs
      :~  [%pin s+(pool-id pin)]
          [%title s+title]
      ==
      ::
        %pool-roots
      :-  %a
      %+  turn  roots.vnt
      |=  [=id desc=@t complete=? actionable=? tags=(list @t)]
      %-  pairs
      :~  [%id (enjs-id id)]
          [%description s+desc]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags (lead %s))]
      ==
      ::
        %goal-young
      :-  %a
      %+  turn  young.vnt
      |=  [=id virtual=? desc=@t complete=? actionable=? tags=(list @t)]
      %-  pairs
      :~  [%id (enjs-id id)]
          [%virtual b+virtual]
          [%description s+desc]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags (lead %s))]
      ==
      ::
      %tags        a+(turn ~(tap in tags.vnt) (lead %s))
      %uid         ?~(id.vnt ~ (enjs-id u.id.vnt))
      %cord        s+p.vnt
      %ucord       ?~(p.vnt ~ s+u.p.vnt)
      %loob        b+p.vnt
    ==
  --
++  grab
  |%
  ++  noun  goal-vent
  --
++  grad  %noun
--

