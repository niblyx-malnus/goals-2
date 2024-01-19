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
        %pool-roots
      :-  %a
      %+  turn  roots.vnt
      |=  [=id desc=@t complete=? actionable=? tags=(list (pair ? @t))]
      %-  pairs
      :~  [%id (enjs-id id)]
          [%description s+desc]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags |=([b=? =@t] (pairs ~[is-public+b/b tag+s/t])))]
      ==
      ::
        %goal-young
      :-  %a
      %+  turn  young.vnt
      |=  [=id virtual=? desc=@t complete=? actionable=? tags=(list (pair ? @t))]
      %-  pairs
      :~  [%id (enjs-id id)]
          [%virtual b+virtual]
          [%description s+desc]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags |=([b=? =@t] (pairs ~[is-public+b/b tag+s/t])))]
      ==
      ::
        %harvest
      :-  %a
      %+  turn  harvest.vnt
      |=  [=id desc=@t complete=? actionable=? tags=(list (pair ? @t))]
      %-  pairs
      :~  [%id (enjs-id id)]
          [%description s+desc]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags |=([b=? =@t] (pairs ~[is-public+b/b tag+s/t])))]
      ==
      ::
        %pool-tag-goals
      :-  %a
      %+  turn  goals.vnt
      |=  [=id desc=@t complete=? actionable=? tags=(list (pair ? @t))]
      %-  pairs
      :~  [%id (enjs-id id)]
          [%description s+desc]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags |=([b=? =@t] (pairs ~[is-public+b/b tag+s/t])))]
      ==
      ::
        %pool-tag-harvest
      :-  %a
      %+  turn  harvest.vnt
      |=  [=id desc=@t complete=? actionable=? tags=(list (pair ? @t))]
      %-  pairs
      :~  [%id (enjs-id id)]
          [%description s+desc]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags |=([b=? =@t] (pairs ~[is-public+b/b tag+s/t])))]
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
