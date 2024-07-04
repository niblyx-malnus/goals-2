/+  htmx, tu=time-utils
|%
++  position-cursor
  |=  [id=tape offset=delta:tu]
  ^-  tape
  =/  offset-tape=tape
    %+  weld  
      ?:(sign.offset "" "-")
    (numb:htmx (div d.offset ~s1))
  """
  function positionCursor() \{
    const cursor = document.getElementById('{id}');
  
    // Function to update the time
    function updateTime() \{
      const now = new Date(); // Current date and time
      const utcTime = Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), 
                              now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds(), now.getUTCMilliseconds());
      const offsetTime = new Date(utcTime + {offset-tape} * 1000);
  
      const hours = offsetTime.getUTCHours();
      const minutes = offsetTime.getUTCMinutes();
      const seconds = offsetTime.getUTCSeconds();
      const dayOfWeek = offsetTime.getUTCDay();

      // Calculate vertical position (0px at 12:00 AM, 1200px at 11:59 PM)
      const totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
      const verticalPosition = Math.round((totalSeconds / 86400) * 1200);

      // Calculate horizontal position based on the day of the week
      const horizontalPosition = `col-start-$\{dayOfWeek + 1} col-end-$\{dayOfWeek + 2}`;

      // Update cursor position
      cursor.className = `absolute top-[$\{verticalPosition}px] z-50 w-full pointer-events-none $\{horizontalPosition}`;
    }
  
    // Every 36 seconds (moves at most 1 pixel)
    setInterval(updateTime, 36000);
    updateTime();
  }
  positionCursor();
  """
::
++  start-timer
  |=  [id=tape offset=delta:tu]
  ^-  tape
  =/  offset-tape=tape
    %+  weld  
      ?:(sign.offset "" "-")
    (numb:htmx (div d.offset ~s1))
  """
  function startTimer() \{
    const timer = document.getElementById('{id}');
  
    // Function to update the time
    function updateTime() \{
      const now = new Date(); // Current date and time
      const utcTime = Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), 
                              now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds(), now.getUTCMilliseconds());
      const offsetTime = new Date(utcTime + {offset-tape} * 1000);
  
      const hours = offsetTime.getUTCHours();
      const minutes = offsetTime.getUTCMinutes();
      const seconds = offsetTime.getUTCSeconds();

      const formattedTime = new Date(1970, 0, 1, hours, minutes, seconds).toLocaleTimeString('en-US', \{
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: true
      });
  
      timer.textContent = formattedTime;
    }
  
    setInterval(updateTime, 1000);
    updateTime();
  }
  startTimer();
  """
::
++  scroll-up-down
  ^~  %-  trip
  '''
  let wheelThrottled = false, wheelThrottleDelay = 1400;
  window.addEventListener('wheel', function(event) {
      if  (!wheelThrottled) {
          if (event.deltaY < 0) {
              console.log('Scrolled up');
              document.querySelectorAll('[hx-trigger]').forEach(element => {
                  htmx.trigger(element, 'scrollUpTrigger');
              });
          } else if (event.deltaY > 0) {
              console.log('Scrolled down');
              document.querySelectorAll('[hx-trigger]').forEach(element => {
                  htmx.trigger(element, 'scrollDownTrigger');
              });
          }
          wheelThrottled = true;
          setTimeout(function() {
              wheelThrottled = false;
          }, wheelThrottleDelay);
      }
  });
  '''
--
