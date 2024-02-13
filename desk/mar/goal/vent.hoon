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
        %goal-data
      :-  %a
      %+  turn  goals.vnt
      |=  goal-datum
      %-  pairs
      :~  [%gid (enjs-gid gid)]
          [%summary s+summary]
          [%tags a+(turn tags |=([b=? =@t] (pairs ~[['isPublic' b+b] tag+s/t])))]
          [%active b+active]
          [%complete b+complete]
          [%actionable b+actionable]
      ==
      ::
        %pool-roots
      :-  %a
      %+  turn  roots.vnt
      |=  [=gid desc=@t active=? complete=? actionable=? tags=(list (pair ? @t))]
      %-  pairs
      :~  [%gid (enjs-gid gid)]
          [%description s+desc]
          [%active b+active]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags |=([b=? =@t] (pairs ~[['isPublic' b+b] tag+s/t])))]
      ==
      ::
        %goal-young
      :-  %a
      %+  turn  young.vnt
      |=  [=gid virtual=? desc=@t active=? complete=? actionable=? tags=(list (pair ? @t))]
      %-  pairs
      :~  [%gid (enjs-gid gid)]
          [%virtual b+virtual]
          [%description s+desc]
          [%active b+active]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags |=([b=? =@t] (pairs ~[['isPublic' b+b] tag+s/t])))]
      ==
      ::
        %harvest
      :-  %a
      %+  turn  harvest.vnt
      |=  [=gid desc=@t active=? complete=? actionable=? tags=(list (pair ? @t))]
      %-  pairs
      :~  [%gid (enjs-gid gid)]
          [%description s+desc]
          [%active b+active]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags |=([b=? =@t] (pairs ~[['isPublic' b+b] tag+s/t])))]
      ==
      ::
        %pool-tag-goals
      :-  %a
      %+  turn  goals.vnt
      |=  [=gid desc=@t active=? complete=? actionable=? tags=(list (pair ? @t))]
      %-  pairs
      :~  [%gid (enjs-gid gid)]
          [%description s+desc]
          [%active b+active]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags |=([b=? =@t] (pairs ~[['isPublic' b+b] tag+s/t])))]
      ==
      ::
        %pool-tag-harvest
      :-  %a
      %+  turn  harvest.vnt
      |=  [=gid desc=@t active=? complete=? actionable=? tags=(list (pair ? @t))]
      %-  pairs
      :~  [%gid (enjs-gid gid)]
          [%description s+desc]
          [%active b+active]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags |=([b=? =@t] (pairs ~[['isPublic' b+b] tag+s/t])))]
      ==
      ::
        %local-tag-goals
      :-  %a
      %+  turn  goals.vnt
      |=  [=gid desc=@t active=? complete=? actionable=? tags=(list (pair ? @t))]
      %-  pairs
      :~  [%gid (enjs-gid gid)]
          [%description s+desc]
          [%active b+active]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags |=([b=? =@t] (pairs ~[['isPublic' b+b] tag+s/t])))]
      ==
      ::
        %local-tag-harvest
      :-  %a
      %+  turn  harvest.vnt
      |=  [=gid desc=@t active=? complete=? actionable=? tags=(list (pair ? @t))]
      %-  pairs
      :~  [%gid (enjs-gid gid)]
          [%description s+desc]
          [%active b+active]
          [%complete b+complete]
          [%actionable b+actionable]
          [%tags a+(turn tags |=([b=? =@t] (pairs ~[['isPublic' b+b] tag+s/t])))]
      ==
      ::
        %pools-index
      :-  %a
      %+  turn  pools.vnt
      |=  [=pid title=@t] 
      %-  pairs
      :~  [%pid s+(enjs-pid pid)]
          [%title s+title]
      ==
      ::
      %tags         a+(turn tags.vnt |=([b=? =@t] (pairs ~[['isPublic' b+b] tag+s/t])))
      %uid          ?~(gid.vnt ~ (enjs-gid u.gid.vnt))
      %cord         s+p.vnt
      %ucord        ?~(p.vnt ~ s+u.p.vnt)
      %loob         b+p.vnt
      %keys         a+(turn keys.vnt enjs-key)
      %collections  a+(turn paths.vnt |=(=^path s+(spat path)))
      ::
        %collection  
      %-  pairs
      :~  [%themes a+(turn ~(tap in themes.vnt) (lead %s))]
          :-  %goals
          :-  %a
          %+  turn  goals.vnt
          |=  [=key complete=? desc=@t]
          %-  pairs
          :~  [%key (enjs-key key)]
              [%complete b+complete]
              [%description s+desc]
          ==
      ==
    ==
  --
++  grab
  |%
  ++  noun  goal-vent
  --
++  grad  %noun
--
