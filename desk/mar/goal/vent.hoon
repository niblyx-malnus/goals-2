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
    ==
  --
++  grab
  |%
  ++  noun  goal-vent
  --
++  grad  %noun
--

