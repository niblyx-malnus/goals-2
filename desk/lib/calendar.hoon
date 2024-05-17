/-  c=calendar, r=rules, t=timezones
/+  vlib=event
::
=|  =cache:r
=|  =zones:t
=|  tans=(list calendar-transition:c)
|_  =calendar:c
+*  this  .
++  abet  [(flop tans) calendar]
++  teba  [tans calendar] :: unflopped effects
++  apex
  |=  [=calendar:c =cache:r =zones:t]
  %=    this
    tans      ~
    cache     cache
    zones     zones
    calendar  calendar
  ==
++  emit  |=(tan=calendar-transition:c this(tans [tan tans]))
++  emil  |=(tanz=(list calendar-transition:c) this(tans (weld tanz tans)))
::
++  handle-transition
  |=  tan=calendar-transition:c
  ^-  _this
  ?-    -.tan
    %init-calendar  this(calendar calendar.tan)
    ::
      %create-event
    ?<  (~(has by events.calendar) eid.tan)
    =|  =event:c
    =:  eid.event        eid.tan
        ruledata.event   (~(put by ruledata.event) '0v0' [~ %skip ''] [%skip ~] ~)
        instances.event  (~(put by instances.event) 0 %skip ~)
      ==
    this(events.calendar (~(put by events.calendar) eid.tan event))
    ::
      %delete-event
    this(events.calendar (~(del by events.calendar) eid.tan))
    ::
      %update-event
    (handle-event-transition [eid p]:tan)
  ==
::
++  handle-event-transition
  |=  [=eid:c tan=event-transition:c]
  ^-  _this
  =/  =event:c  (~(gut by events.calendar) eid *event:c)
  =.  event   event:(handle-transition:(apex:vlib event cache zones) tan)
  this(events.calendar (~(put by events.calendar) eid event))
--
