/-  gol=goals
|%
++  v5
  =,  v5:gol
  |%
  +$  pool-nexus-update
    $%  [%yoke =pex =nex]
    ==
  ::
  +$  pool-hitch-update
    $%  [%title title=@t]
        [%note note=@t]
        [%add-field-type field=@t =field-type]
        [%del-field-type field=@t]
    ==
  ::
  +$  goal-hitch-update
    $%  [%desc desc=@t]
        [%note note=@t]
        [%add-tag =tag]
        [%del-tag =tag]
        [%put-tags tags=(set tag)]
        [%add-field-data field=@t =field-data]
        [%del-field-data field=@t]
    ==
  ::
  +$  goal-togls-update
    $%  [%complete complete=_|]
        [%actionable actionable=_|]
    ==
  ::
  +$  unver-update  :: underlying data structures have changed
    $%  [%spawn-pool =pool]
        [%cache-pool =pin]
        [%renew-pool =pin =pool]
        [%waste-pool ~]
        [%trash-pool ~]
        [%spawn-goal =pex =nex =id =goal]
        [%waste-goal =pex =nex =id waz=(set id)]
        [%cache-goal =pex =nex =id cas=(set id)]
        [%renew-goal =pex =id ren=goals]
        [%trash-goal =pex =id tas=(set id)]
        [%pool-perms =pex =nex new=pool-perms]
        [%pool-hitch pool-hitch-update]
        [%pool-nexus pool-nexus-update]
        [%goal-dates =pex =nex]
        [%goal-perms =pex =nex]
        [%goal-roots =pex]
        $:  %goal-young  =id
            young=(list [id virtual=?])
            young-by-precedence=(list [id virtual=?])
            young-by-kickoff=(list [id virtual=?])
            young-by-deadline=(list [id virtual=?])
        ==
        [%goal-hitch =id goal-hitch-update]
        [%goal-togls =id goal-togls-update]
        [%poke-error =tang]
    ==
  +$  update        [%5 unver-update]
  +$  away-update   [[mod=ship pid=@] update]
  --
::
++  v4
  =,  v4:gol
  |%
  +$  pool-hitch-update
    $%  [%title title=@t]
    ==
  ::
  +$  pool-nexus-update
    $%  [%yoke =nex]
    ==
  ::
  +$  goal-hitch-update
    $%  [%desc desc=@t]
    ==
  ::
  +$  goal-togls-update
    $%  [%complete complete=_|]
        [%actionable actionable=_|]
    ==
  ::
  +$  unver-update
    $%  [%spawn-pool =pool]
        [%cache-pool =pin]
        [%renew-pool =pin =pool]
        [%waste-pool ~]
        [%trash-pool ~]
        [%spawn-goal =nex =id =goal]
        [%waste-goal =nex =id waz=(set id)]
        [%cache-goal =nex =id cas=(set id)]
        [%renew-goal =id ren=goals]
        [%trash-goal =id tas=(set id)]
        [%pool-perms =nex new=pool-perms]
        [%pool-hitch pool-hitch-update]
        [%pool-nexus pool-nexus-update]
        [%goal-dates =nex]
        [%goal-perms =nex]
        [%goal-hitch =id goal-hitch-update]
        [%goal-togls =id goal-togls-update]
        [%poke-error =tang]
    ==
  ::
  +$  update  [%4 unver-update]
  ::
  +$  away-update  [[mod=ship pid=@] update]
  +$  home-update  [[=pin mod=ship pid=@] update]
  ::
  +$  log-update
    $%  [%updt upd=home-update]
        [%init =store]
    ==
  +$  log  ((mop @ log-update) lth)
  +$  logged  (pair @ log-update)
  --
--
