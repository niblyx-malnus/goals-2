/-  *goals
:: a view is a distorted view of the store, a perspective, a transformation
::
:: TODO:
:: - include sorting as a parameter
|%
+$  vid  @uv
+$  views  (map vid [ack=_| =view])
+$  ask  [pid=@ pok=parm:views]
+$  say  [=path =data:views]
+$  view
  $%  [%tree =parm:tree =data:tree]
      [%harvest =parm:harvest =data:harvest]
      [%list-view =parm:list-view =data:list-view]
      [%page =parm:page =data:page]
  ==
+$  parm
  $%  [%tree parm:tree]
      [%harvest parm:harvest]
      [%list-view parm:list-view]
      [%page parm:page]
  ==
+$  data
  $%  [%tree data:tree]
      [%harvest data:harvest]
      [%list-view data:list-view]
      [%page data:page]
  ==
+$  view-vent  $@(~ data)
:: dots must be acked
::
++  tree
  |%
  +$  parm  $:(=type)
  +$  type  $%([%main ~] [%pool =pid] [%goal =gid])
  +$  data  $:(pools=tree-pools cache=tree-pools)
  :: trying to slowly sever this from underlying DS
  ::
  +$  tree-pool   pool
  +$  tree-pools  (map pid tree-pool)
  --
++  harvest
  |%
  +$  parm
    $:  =type
        method=?(%any %all)
        tags=(set @t)
    ==
  +$  type  $%([%main ~] [%pool =pid] [%goal =gid])
  +$  data  $:(goals=(list [gid pack]))
  +$  pack
    $:  =pid
        pool-role=(unit role)
        par=(unit gid)
        kids=(set gid)
        kickoff=node
        deadline=node
        complete=_|
        actionable=?
        chief=ship
        deputies=(set ship)
        tags=(set @t)
        fields=(map @t @t)
        =stock
        =ranks
        young=(list [gid virtual=?])
        young-by-precedence=(list [gid virtual=?])
        young-by-kickoff=(list [gid virtual=?])
        young-by-deadline=(list [gid virtual=?])
        progress=[complete=@ total=@]
        prio-left=(set gid)
        prio-ryte=(set gid)
        prec-left=(set gid)
        prec-ryte=(set gid)
        nest-left=(set gid)
        nest-ryte=(set gid)
    ==
  --
++  list-view
  |%
  +$  parm
    $:  =type
        first-gen-only=_|
        actionable-only=_|
        method=?(%any %all)
        tags=(set @t)
    ==
  +$  type
    $%  [%main ~]
        [%pool =pid]
        [%goal =gid ignore-virtual=_|]
    ==
  +$  data  $:(goals=(list [gid pack]))
  +$  pack
    $:  =pid
        pool-role=(unit role)
        par=(unit gid)
        kids=(set gid)
        kickoff=node
        deadline=node
        complete=_|
        actionable=?
        chief=ship
        deputies=(set ship)
        tags=(set @t)
        fields=(map @t @t)
        =stock
        =ranks
        young=(list [gid virtual=?])
        young-by-precedence=(list [gid virtual=?])
        young-by-kickoff=(list [gid virtual=?])
        young-by-deadline=(list [gid virtual=?])
        progress=[complete=@ total=@]
        prio-left=(set gid)
        prio-ryte=(set gid)
        prec-left=(set gid)
        prec-ryte=(set gid)
        nest-left=(set gid)
        nest-ryte=(set gid)
    ==
  --
++  page
  |%
  +$  parm  $:(=type)
  +$  type  $%([%main ~] [%pool =pid] [%goal =gid])
  +$  data  pack
  +$  pack
    $%  [%main ~]
        $:  %pool
            title=@t
            note=@t
        ==
        $:  %goal
            par-pool=pid
            par-goal=(unit gid)
            desc=@t
            note=@t
            tags=(set @t)
        ==
    ==
  --
--
