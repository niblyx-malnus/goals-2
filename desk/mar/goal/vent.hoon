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
      :~  [%key (enjs-key key)]
          [%summary s+summary]
          [%tags a+(turn tags |=([b=? =@t] (pairs ~[['isPublic' b+b] tag+s/t])))]
          [%active b+active]
          [%complete b+complete]
          [%actionable b+actionable]
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
      %collection   !!
      %collections  !!
    ==
  --
++  grab
  |%
  ++  noun  goal-vent
  --
++  grad  %noun
--
