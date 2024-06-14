/+  htmx, tu=time-utils
|%
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
  
      const formattedTime = [
        hours.toString().padStart(2, '0'),
        minutes.toString().padStart(2, '0'),
        seconds.toString().padStart(2, '0')
      ].join(':');
  
      timer.textContent = formattedTime;
    }
  
    setInterval(updateTime, 1000);
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
