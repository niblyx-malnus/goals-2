/+  *ventio, htmx, bind, server, fi=feather-icons
|_  =gowl
++  poll-interval  ~s1
++  handle-http-request
  |=  [eyre-id=@ta req=inbound-request:eyre]
  =/  m  (strand ,vase)
  ^-  form:m
  =/  [[ext=(unit @ta) site=(list @t)] args=key-value-list:kv:htmx]
    (parse-request-line:server url.request.req)
  ~&  >>  [site+site ext+ext args+args]
  ::
  ?+    [method.request.req site ext]
    (strand-fail %bad-http-request ~)
    ::
      [%'GET' [%htmx %goals %current-time ~] *]
    ;<  now=@da  bind:m  get-time
    =/  =manx
      ;div#current-time: Current Time {(scow %da now.gowl)}
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
    ::
      [%'GET' [%htmx %goals ~] *]
    ;<  =manx  bind:m  my-pools
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
    ::
      [%'GET' [%htmx %goals %target ~] [~ %svg]]
    (give-svg-manx:htmx [our dap]:gowl eyre-id target-svg |)
    ::
      [%'GET' [%htmx %goals %local-membership-panel ~] *]
    ;<  =manx  bind:m
      %-  local-membership-panel
      (fall (get-key:kv:htmx 'kind' args) 'hidden')
    (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
  ==
::
++  kv-to-action
  |=  =key-value-list:kv:htmx
  ^-  [dock cage]
  *[dock cage]
::
++  page-header
  |=  title=tape
  ;head
    ;title: {title}
    ;script(src "https://unpkg.com/htmx.org");
    ;script(src "https://cdn.tailwindcss.com");
    ;meta(charset "utf-8");
    ;meta
      =name     "viewport"
      =content  "width=device-width, initial-scale=1";
    ;link(rel "icon", href "/htmx/goals/target.svg", type "image/svg+xml");
  ==
::
++  local-membership-panel
  |=  kind=@t
  =/  m  (strand ,manx)
  ^-  form:m
  ?:  ?=(%hidden kind)
    %-  pure:m
    ;div#local-membership-panel.hidden;
  ;<  now=@da  bind:m  get-time
  %-  pure:m
  ;div#local-membership-panel.fixed.inset-0.z-10.overflow-y-auto
    ;div(class "flex items-center justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0")
      ;div.fixed.inset-0.transition-opacity
        ;div.absolute.inset-0.bg-gray-500.opacity-75;
      ==
      ;span(class "hidden sm:inline-block sm:align-middle sm:h-screen"): ​
      ;div
        =class            "inline-block overflow-hidden text-left align-bottom transition-all transform bg-white rounded-lg shadow-xl sm:my-8 sm:align-middle sm:max-w-lg sm:w-full"
        =role             "dialog"
        =aria-modal       "true"
        =aria-labelledby  "modal-headline"
        ;div.border-b.mb-4
          ;nav.flex.space-x-4
            =aria-label  "Tabs"
            ;button
              =class  "px-3 py-2 font-medium text-sm {?:(?=(%invites kind) "text-blue-700 border-blue-700" "text-gray-500 hover:text-gray-700")}"
              =hx-get      "/htmx/goals/local-membership-panel?kind=invites"
              =hx-target   "#local-membership-panel"
              =hx-trigger  "click"
              =hx-swap     "outerHTML"
              Invites
            ==
            ;button
              =class  "px-3 py-2 font-medium text-sm {?:(?=(%requests kind) "text-blue-700 border-blue-700" "text-gray-500 hover:text-gray-700")}"
              =hx-get      "/htmx/goals/local-membership-panel?kind=requests"
              =hx-target   "#local-membership-panel"
              =hx-trigger  "click"
              =hx-swap     "outerHTML"
              Requests
            ==
            ;button
              =class  "px-3 py-2 font-medium text-sm {?:(?=(%blocked kind) "text-blue-700 border-blue-700" "text-gray-500 hover:text-gray-700")}"
              =hx-get      "/htmx/goals/local-membership-panel?kind=blocked"
              =hx-target   "#local-membership-panel"
              =hx-trigger  "click"
              =hx-swap     "outerHTML"
              Blocked
            ==
            ;button
              =class  "px-3 py-2 font-medium text-sm {?:(?=(%discover kind) "text-blue-700 border-blue-700" "text-gray-500 hover:text-gray-700")}"
              =hx-get      "/htmx/goals/local-membership-panel?kind=discover"
              =hx-target   "#local-membership-panel"
              =hx-trigger  "click"
              =hx-swap     "outerHTML"
              Discover
            ==
          ==
        ==
        ;div(class "px-4 py-3 bg-gray-50 sm:px-6 sm:flex sm:flex-row-reverse")
          ;button
            =class       "w-full px-4 py-2 mt-3 font-medium text-white bg-red-600 rounded-md shadow-sm hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
            =hx-get      "/htmx/goals/local-membership-panel?kind=hidden"
            =hx-target   "#local-membership-panel"
            =hx-trigger  "click"
            =hx-swap     "outerHTML"
            Close
          ==
        ==
      ==
    ==
  ==
::
++  my-pools
  =>  |%
      ++  style
        ^~
        %-  trip
        '''
        .feather-mail {
          height: .875em;
          width:  .875em;
        }
        .my-indicator{
          color: black
        }
        .htmx-request .my-indicator{
          color: red
        }
        .htmx-request.my-indicator{
          color: red
        }
        '''
      --
  ::
  =/  m  (strand ,manx)
  ^-  form:m
  %-  pure:m
  ;html(lang "en")
    ;+  (page-header "My Pools")
    ;style: {style}
     ;+  dummy:htmx
     ;+  (init-refresher:htmx /htmx/goals)
    ;div.bg-gray-200.h-full.flex.justify-center.items-center.h-screen
      ;div(class "bg-[#DFF7DC] p-6 rounded shadow-md w-full h-screen overflow-y-auto")
        ;div.flex.justify-between.items-center.mb-4
          ;div#current-time: Current Time {(scow %da now.gowl)}
          ;p#hello-world.my-indicator: Hello, world!
          ;button
            =class       "p-2 mr-2 border border-gray-300 bg-gray-100 rounded hover:bg-gray-200 flex items-center justify-center"
            =hx-get      "/htmx/goals/fast-refresh"
            =hx-target   "#dummy"
            =hx-trigger  "click"
            Fast Refresher
          ==
          ;button
            =class       "p-2 mr-2 border border-gray-300 bg-gray-100 rounded hover:bg-gray-200 flex items-center justify-center"
            =hx-get      "/htmx/goals/local-membership-panel?kind=invites"
            =hx-target   "#local-membership-panel"
            =hx-trigger  "click"
            =hx-swap     "outerHTML"
            ;+  mail:fi
          ==
          ;div#local-membership-panel.hidden;
        ==
      ==
    ==
  ==
::  <div className="bg-gray-200 h-full flex justify-center items-center h-screen">
::       <div className="bg-[#DFF7DC] p-6 rounded shadow-md w-full h-screen overflow-y-auto">
::         <div className="flex justify-between items-center mb-4">
::           <TagSearchBar poolId={null} />
::           <button
::             onClick={toggleLocalMembershipPanel}
::             className="p-2 mr-2 border border-gray-300 bg-gray-100 rounded hover:bg-gray-200 flex items-center justify-center"
::             style={{ height: '2rem', width: '2rem' }} // Adjust the size as needed
::           >
::             <FiMail />
::           </button>
::           {showLocalMembershipPanel && (
::             <LocalMembershipPanel exit={() => setShowLocalMembershipPanel(false)} />
::           )}
::           { !live && (
::             <button
::               onClick={
::                 () => {
::                   setCurrentTreePage(`/pools`);
::                   navigateToPeriod(api.destination, currentPeriodType, getCurrentPeriod());
::                 }
::               }
::               className="p-2 mr-2 border border-gray-300 bg-gray-100 rounded hover:bg-gray-200 flex items-center justify-center"
::               style={{ height: '2rem', width: '2rem' }} // Adjust the size as needed
::             >
::               <FaListUl />
::             </button>
::           )}
::         </div>
::         <h1 className="text-2xl font-semibold text-blue-600 text-center mb-4">All Pools</h1>
::         <div className="flex flex-wrap justify-center mb-4">
::           {allLocalTags.map((tag, index) => (
::             <div
::               key={index}
::               className="flex items-center bg-gray-200 rounded px-2 py-1 m-1 cursor-pointer"
::               onClick={() => navigateToTag(api.destination, tag)}
::             >
::               {tag}
::             </div>
::           ))}
::         </div>
::         <ul className="flex justify-center -mb-px">
::           <li className={`${activeTab === 'Pools' ? 'border-blue-500' : ''}`}>
::             <button 
::               className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
::                 activeTab === 'Pools' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
::               }`} 
::               onClick={() => setActiveTab('Pools')}
::             >
::               Pools
::             </button>
::           </li>
::           <li className={`${activeTab === 'Harvest' ? 'border-blue-500' : ''}`}>
::             <button 
::               className={`inline-block p-4 text-md font-medium text-center cursor-pointer focus:outline-none ${
::                 activeTab === 'Harvest' ? 'border-b-2 text-blue-600 border-blue-500' : 'text-gray-500 hover:text-gray-800 hover:border-gray-300'
::               }`} 
::               onClick={() => setActiveTab('Harvest')}
::             >
::               Harvest
::             </button>
::           </li>
::         </ul>
::         {activeTab === 'Pools' && (
::           <>
::             <div className="flex items-center mb-4">
::               <input
::                 type="text"
::                 value={newTitle}
::                 onChange={(e) => setNewTitle(e.target.value)}
::                 onKeyDown={(e) => {
::                     if (e.key === 'Enter') handleAddTitle();
::                 }}
::                 placeholder="Enter new title..."
::                 className="p-2 flex-grow border box-border rounded mr-2 w-full" // <-- Notice the flex-grow and w-full here
::               />
::               <button 
::                 onClick={handleAddTitle} 
::                 className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 focus:outline-none"
::                 style={{maxWidth: '100px'}} // This ensures button never grows beyond 100px.
::               >
::                 Add
::               </button>
::             </div>
::             <PoolList destination={destination} pools={pools} refresh={triggerRefreshPools} isLoading={isLoading}/>
::           </>
::         )}
::         {activeTab === 'Harvest' && (
::           <Harvest destination={destination}/>
::         )}
::       </div>
::     </div>
::   );
:: }
::
++  counter
  =/  m  (strand ,manx)
  ^-  form:m
  ;<  val=@ud  bind:m  (scry-hard ,@ud /gx/htmxbox/val/noun)
  %-  pure:m
  ;div#counter.mb-5.p-3.text-xl.font-semibold.bg-gray-700.text-center.rounded: {(scow %ud val)}
::
++  page
  =/  m  (strand ,manx)
  ^-  form:m
  ;<  counter=manx  bind:m  counter
  %-  pure:m
  ;html(lang "en")
    ;head
      ;title: Counter App
      ;script(src "https://unpkg.com/htmx.org");
      ;script(src "https://cdn.tailwindcss.com");
     ;meta(charset "utf-8");
      ;meta
        =name     "viewport"
        =content  "width=device-width, initial-scale=1";
    ==
    ;body.bg-gray-100.font-sans.leading-normal.tracking-normal
      ;div.container.mx-auto.mt-8
        ;div.flex.justify-center.px-6
          ;div(class "w-full xl:w-3/4 lg:w-11/12 flex")
            ;div.w-full.h-auto.bg-gray-900.rounded-lg.shadow-xl
              ;div.p-5.border-b.border-gray-200.text-white.text-2xl.font-medium
                Counter App
              ==
              ;div.p-5.bg-gray-800.text-white.rounded-b-lg
              ;p.mb-5: Hello, world! I am %htmxbox!
              ==
              ;+  counter
              ;form.flex.justify-between
                =hx-post     "/apps/htmxbox"
                =hx-target   "#counter"
                =hx-swap     "outerHTML"
                ;input
                  =type   "hidden"
                  =name   "mark"
                  =value  "htmxbox-transition";
                ;input
                  =type   "hidden"
                  =name   "head-tag"
                  =value  "increment";
                ;input
                  =class  "w-1/4 text-gray-900 mr-3 p-2 rounded border focus:outline-none"
                  =type   "number"
                  =name   "val"
                  =value  "1"
                  =min    "1"
                  =style  "margin-right: 10px;";
                ;button
                  =type   "submit"
                  =class  "px-8 py-2 bg-blue-500 text-white font-bold rounded hover:bg-blue-600 focus:outline-none"
                  +
                ==
              ==
            ==
          ==
        ==
      ==
    ==
  ==
  ::
  ++  target-svg
    =;  svg=@t
      `manx`(fall (de-xml:html svg) *manx)
    '''
    <svg width="200" height="200" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
      <!-- Outer circle -->
      <circle cx="50" cy="50" r="40" stroke="#FFA500" stroke-width="8" fill="none" />
      <!-- Middle circle -->
      <circle cx="50" cy="50" r="25" stroke="#FFD700" stroke-width="8" fill="none" />
      <!-- Inner circle -->
      <circle cx="50" cy="50" r="10" stroke="#FF6a00" stroke-width="8" fill="none" />
    </svg>
    '''
--
