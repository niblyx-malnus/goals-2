|%
:: TODO: error and settings collapsed into nooks
::
+$  error  [text=tape code=tape]
+$  error-messages  (map tape error)
+$  settings  (map @t json)
+$  nooks  (axal vase)
+$  state-0
  $:  %0
      =nooks
      =error-messages
      =settings
  ==
+$  transition
  $%  [%put-msg id=tape =error]
      [%del-msg id=tape]
      [%put-setting key=@t setting=json]
      [%del-setting key=@t]
  ==
--
