/+  *time-utils
|%
+$  rule-type  ?(%both %left %fuld %jump %skip)
:: source, type and name
:: null for source means the rule is hardcoded
:: versioning recommended but not enforced
::
+$  rule-flag  (trel (unit ship) rule-type term)
+$  rid        rule-flag
:: parameter structure for a given recurrence rule
:: order matters for frontend parameter display
::
+$  parm  (list (pair @t term))
+$  args  (map @t arg)
:: both: the rule determines both left and right ends
:: left: the rule determines the left end, and the
::       right end is determined by duration
:: fuld: fullday ([[a=? y=@ud] m=@ud d=@ud]
:: jump: instantaneous events
:: skip: a skip exception denoting a skipped instance
:: TODO: add jump
::
+$  kind  
  $%  [%both lz=@t rz=@t]
      [%left tz=@t d=@dr]
      [%fuld ~]
      [%skip ~]
  ==
::
+$  dom   [l=@ud r=@ud] :: instance domain
::
+$  rule  [name=@t =parm hoon=@t]
::
+$  rules  (map rid rule)
::
+$  span-exception
  $%  rule-exception
      [%bad-index l=(unit localtime) r=(unit localtime)]
      [%out-of-bounds tz=@t d=@da] :: right end out-of-bounds
      $:  %out-of-order 
          l=[loc=localtime utc=@da] 
          r=[loc=localtime utc=@da]
      ==
  ==
::
+$  span-instance  (each span span-exception)
+$  fuld-instance  (each fuld rule-exception)
+$  jump-instance  (each jump rule-exception)
:: types for basic recurrence rule functions
::
+$  to-both     $-(@ud (each [dext dext] rule-exception))
+$  to-left     $-(@ud (each dext rule-exception))
::
+$  to-span     $-(@ud span-instance)
+$  to-fuld     $-(@ud fuld-instance)
+$  to-jump     $-(@ud jump-instance)
::
+$  to-to-both  $-(args to-both)
+$  to-to-left  $-(args to-left)
+$  to-to-fuld  $-(args to-fuld)
+$  to-to-jump  $-(args to-jump)
::
+$  state-0  [%0 =rules]
::
+$  cache
  $:  to-to-boths=(map rid to-to-both)
      to-to-lefts=(map rid to-to-left)
      to-to-fulds=(map rid to-to-fuld)
      to-to-jumps=(map rid to-to-jump)
  ==
::
+$  rule-field
  $%  [%name name=@t]
      [%parm =parm]
      [%hoon hoon=@t]
  ==
::
+$  rule-update  $%(rule-field [%rule =rule])
::
+$  rule-action
  %+  pair  rid
  $%  [%create =rule]
      [%update fields=(list rule-field)]
      [%delete ~]
  ==
::
++  crud
  |$  [create update delete]
  $%  [%c p=create]
      [%u p=update]
      [%d p=delete]
  ==
--
