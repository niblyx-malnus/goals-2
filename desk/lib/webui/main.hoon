/-  p=pools, gol=goals, act=action
/+  *ventio, htmx, bind, server, goals-api, fi=webui-feather-icons
|%
++  poll-interval  ~s1
++  pool-id-to-html-id
  |=  =id:p
  ^-  tape
  ;:  weld
    ?~(sco=(scow %p host.id) !! t.sco)
    "X" :: trying to stick to alphanumerics, -, and _
        :: but reserving _ for a more general delimeter
    (trip name.id)
  ==
++  html-id-to-pool-id
  |=  =tape
  ^-  id:p
  (scan tape ;~((glue (just 'X')) fed:ag (cook crip (star prn))))
::
++  agent
  |_  [=bowl:gall cards=(list card:agent:gall)]
  +*  this  .
  +$  card  card:agent:gall
  ++  abet  (flop cards)
  ++  emit  |=(=card this(cards [card cards]))
  ++  emil  |=(cadz=(list card) this(cards (weld cadz cards)))
  ::
  ++  subscribe-to-pools-agent
    ^-  (list card:agent:gall)
    ?:  (~(has by wex.bowl) [/pools-transitions our.bowl %pools])
      ~
    [%pass /pools-transitions %agent [our.bowl %pools] %watch /transitions]~
  ::
  ++  subscribe-to-goals-agent
    ^-  (list card:agent:gall)
    ?:  (~(has by wex.bowl) [/goals-transitions our.bowl %goals])
      ~
    [%pass /goals-transitions %agent [our.bowl %goals] %watch /transitions]~
  ::
  ++  handle-pools-transition
    |=  tan=transition:p
    ^-  _this
    ?+    -.tan  this
        ?(%update-incoming-invites %update-incoming-invite-response)
      ~&  >  %handling-pools-transition-webui
      %-  emil
      :~  :*  %pass  /htmx-refresh  %agent  [our dap]:bowl  %poke
              :-  %htmx-refresh  !>
              :~  ["#local-membership-invites-pending" "/htmx/goals/local-membership/invites/pending" ~]
                  ["#local-membership-invites-resolved" "/htmx/goals/local-membership/invites/resolved" ~]
              ==
          ==
       ==
    ==
  ::
  ++  handle-goals-transition
    |=  =transition:act
    ^-  _this
    this
  --
::
++  vine
  |_  =gowl
  +*  gap  ~(. goals-api gowl)
  ++  handle-http-request
    |=  [eyre-id=@ta req=inbound-request:eyre]
    =/  m  (strand ,vase)
    ^-  form:m
    =/  [[ext=(unit @ta) site=(list @t)] args=key-value-list:kv:htmx]
      (parse-request-line:server url.request.req)
    ::
    ~&  >>  [site+site ext+ext args+args]
    ::
    ?+    [method.request.req site ext]
      (strand-fail %bad-http-request ~)
      ::
        [%'GET' [%htmx %goals %current-time ~] *]
      =/  =manx
        ;div#current-time: Current Time {(scow %da now.gowl)}
      (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
      ::
        [%'GET' [%htmx %goals ~] *]
      (give-html-manx:htmx [our dap]:gowl eyre-id my-pools |)
      ::
        [%'GET' [%htmx %goals %target ~] [~ %svg]]
      (give-svg-manx:htmx [our dap]:gowl eyre-id target-svg |)
      ::
        [%'GET' [%htmx %goals %local-membership ~] *]
      =/  active-tab=@t
        (fall (get-key:kv:htmx 'active-tab' args) 'hidden')
      =/  =manx  (local-membership active-tab)
      (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
      ::
        [%'GET' [%htmx %goals %local-membership %invites ~] *]
      =/  active-tab=@t  (need (get-key:kv:htmx 'active-tab' args))
      =/  =manx  (invites:local-membership active-tab '')
      (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
      ::
        [%'GET' [%htmx %goals %local-membership %invites %pending ~] *]
      ;<  =incoming-invites:p  bind:m
        (scry-hard ,incoming-invites:p /gx/pools/incoming-invites/noun)
      =/  =manx  (invites-list:local-membership 'pending' incoming-invites)
      (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
      ::
        [%'GET' [%htmx %goals %local-membership %invites %resolved ~] *]
      ;<  =incoming-invites:p  bind:m
        (scry-hard ,incoming-invites:p /gx/pools/incoming-invites/noun)
      =/  =manx  (invites-list:local-membership 'resolved' incoming-invites)
      (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
      ::
        [%'GET' [%htmx %goals %local-membership %invites %accept ~] *]
      =/  pool-id=@t        (need (get-key:kv:htmx 'pool-id' args))
      =/  loading=@t        (need (get-key:kv:htmx 'loading' args))
      =/  accept-invite=@t  (fall (get-key:kv:htmx 'accept-invite' args) 'false')
      =/  =id:p  (html-id-to-pool-id (trip pool-id))
      ;<  ~  bind:m
        ?.  ?=(%true accept-invite)
          (pure:(strand ,~) ~)
        :: TODO: Catch and serve failures to the frontend
        (accept-invite:mem:gap id)
      =/  =manx  (invite-accept-button:local-membership id ?=(%true loading))
      ;<  =vase  bind:m  (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
      ;<  ~  bind:m  (poke [our dap]:gowl htmx-fast-refresh+!>(~))
      (pure:m vase)
      ::
        [%'GET' [%htmx %goals %local-membership %invites %reject ~] *]
      =/  pool-id=@t        (need (get-key:kv:htmx 'pool-id' args))
      =/  loading=@t        (need (get-key:kv:htmx 'loading' args))
      =/  reject-invite=@t  (fall (get-key:kv:htmx 'reject-invite' args) 'false')
      =/  =id:p  (html-id-to-pool-id (trip pool-id))
      ;<  ~  bind:m
        ?.  ?=(%true reject-invite)
          (pure:(strand ,~) ~)
        :: TODO: Catch and serve failures to the frontend
        (reject-invite:mem:gap id)
      =/  =manx  (invite-reject-button:local-membership id ?=(%true loading))
      ;<  =vase  bind:m  (give-html-manx:htmx [our dap]:gowl eyre-id manx |)
      ;<  ~  bind:m  (poke [our dap]:gowl htmx-fast-refresh+!>(~))
      (pure:m vase)
    ==
  --
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
++  my-pools
  =>  |%
      ++  style
        ^~
        %-  trip
        '''
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
  ^-  manx
  ;html(lang "en")
    ;+  (page-header "My Pools")
    ;style: {style}
     ;+  dummy:htmx
     ;+  (init-refresher:htmx /htmx/goals)
    ;div.bg-gray-200.h-full.flex.justify-center.items-center.h-screen
      ;div(class "bg-[#DFF7DC] p-6 rounded shadow-md w-full h-screen overflow-y-auto")
        ;div.flex.justify-between.items-center.mb-4
          ;button
            =class       "p-2 mr-2 border border-gray-300 bg-gray-100 rounded hover:bg-gray-200 flex items-center justify-center"
            =hx-get      "/htmx/goals/local-membership?active-tab=invites"
            =hx-target   "#local-membership"
            =hx-trigger  "click"
            =hx-swap     "outerHTML"
            ;+  (set-attribute:mx:htmx %style "height: .875em; width: .875em;" (make:fi %mail))
          ==
          ;div#local-membership.hidden;
        ==
      ==
    ==
  ==
  ::
  ++  target-svg
    ^-  manx
    =;  svg=@t  (fall (de-xml:html svg) *manx)
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
::
++  local-membership
  =<  local-membership
  |%
  ++  local-membership
    |=  active-tab=@t
    ^-  manx
    ?:  ?=(%hidden active-tab)
      ;div#local-membership.hidden;
    ;div#local-membership.fixed.inset-0.z-10.overflow-y-auto
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
                =class  "px-3 py-2 font-medium text-sm {?:(?=(%invites active-tab) "text-blue-700 border-blue-700" "text-gray-500 hover:text-gray-700")}"
                =hx-get      "/htmx/goals/local-membership?active-tab=invites"
                =hx-target   "#local-membership"
                =hx-trigger  "click"
                =hx-swap     "outerHTML"
                Invites
              ==
              ;button
                =class  "px-3 py-2 font-medium text-sm {?:(?=(%requests active-tab) "text-blue-700 border-blue-700" "text-gray-500 hover:text-gray-700")}"
                =hx-get      "/htmx/goals/local-membership?active-tab=requests"
                =hx-target   "#local-membership"
                =hx-trigger  "click"
                =hx-swap     "outerHTML"
                Requests
              ==
              ;button
                =class  "px-3 py-2 font-medium text-sm {?:(?=(%blocked active-tab) "text-blue-700 border-blue-700" "text-gray-500 hover:text-gray-700")}"
                =hx-get      "/htmx/goals/local-membership?active-tab=blocked"
                =hx-target   "#local-membership"
                =hx-trigger  "click"
                =hx-swap     "outerHTML"
                Blocked
              ==
              ;button
                =class  "px-3 py-2 font-medium text-sm {?:(?=(%discover active-tab) "text-blue-700 border-blue-700" "text-gray-500 hover:text-gray-700")}"
                =hx-get      "/htmx/goals/local-membership?active-tab=discover"
                =hx-target   "#local-membership"
                =hx-trigger  "click"
                =hx-swap     "outerHTML"
                Discover
              ==
            ==
          ==
          ;+  ?+    active-tab
                  ;div;
                %invites   (invites %pending '')
                %requests  requests
                %blocked   blocked
                %discover  discover
              ==
          ;div(class "px-4 py-3 bg-gray-50 sm:px-6 sm:flex sm:flex-row-reverse")
            ;button
              =class       "w-full px-4 py-2 mt-3 font-medium text-white bg-red-600 rounded-md shadow-sm hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
              =hx-get      "/htmx/goals/local-membership?active-tab=hidden"
              =hx-target   "#local-membership"
              =hx-trigger  "click"
              =hx-swap     "outerHTML"
              Close
            ==
          ==
        ==
      ==
    ==
  ::
  ++  error-message
    |=  msg=@t
    ^-  manx
    ?~  msg
      ;div.hidden;
    ;div.p-2.mb-4.text-sm.text-red-700.bg-red-100.rounded-lg.flex.items-center
      ;+  =/  =manx  (set-attribute:mx:htmx %style "height: .875em; width: .875em;" (make:fi %alert-circle))
          (extend-attribute:mx:htmx %class " inline mr-2 text-lg" manx)
      msg
    ==
  ::
  ++  invites
    |=  [active-tab=@t msg=@t]
    ^-  manx
    ;div#local-membership-invites(class "px-4 pt-5 pb-4 bg-white sm:p-6 sm:pb-4")
      ;div(class "sm:flex sm:items-start")
        ;div(class "mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left w-full")
          ;h3#modal-headline.text-lg.font-medium.leading-6.text-gray-900
            Incoming Pool Invites
          ==
          ;div.mt-2
            ;+  (error-message msg)
            ;div.my-5
              ;div.mb-2
                ;button
                  =class  "px-4 py-2 font-bold text-white rounded {?:(?=(%pending active-tab) "bg-blue-700" "bg-blue-200")}"
                  =hx-get      "/htmx/goals/local-membership/invites?active-tab=pending"
                  =hx-target   "#local-membership-invites"
                  =hx-trigger  "click"
                  =hx-swap     "outerHTML"
                  Pending
                ==
                ;button
                  =class  "px-4 py-2 ml-2 font-bold text-white rounded {?:(?=(%resolved active-tab) "bg-green-700" "bg-green-200")}"
                  =hx-get      "/htmx/goals/local-membership/invites?active-tab=resolved"
                  =hx-target   "#local-membership-invites"
                  =hx-trigger  "click"
                  =hx-swap     "outerHTML"
                  Resolved
                ==
              ==
              ;div#local-membership-invites-list.flex.justify-center
                =hx-get      "/htmx/goals/local-membership/invites/{(trip active-tab)}"
                =hx-target   "this"
                =hx-trigger  "load"
                =hx-swap     "outerHTML"
                ;+  =/  =manx  (set-attribute:mx:htmx %style "height: .875em; width: .875em;" (make:fi %loader))
                    (extend-attribute:mx:htmx %class " text-4xl text-blue-500 animate-spin" manx)
              ==
            ==
          ==
        ==
      ==
    ==
  ::
  ++  invite-accept-button
    |=  [=id:p loading=?]
    ^-  manx
    =/  pool-id=tape  (pool-id-to-html-id id)
    =/  html-id=tape  (weld "local-membership-invites-accept_" pool-id)
    ?.  loading
      ;button
        =id          html-id
        =class       "px-2 py-1 text-sm text-white bg-green-500 rounded hover:bg-green-600 focus:outline-none"
        =hx-get      "/htmx/goals/local-membership/invites/accept?pool-id={pool-id}&loading=true"
        =hx-target   "this"
        =hx-trigger  "click"
        =hx-swap     "outerHTML"
        Accept
      ==
    ;button
      =id          html-id
      =disabled    "true"
      =class       "px-2 py-1 text-sm text-white bg-green-500 rounded hover:bg-green-600 focus:outline-none"
      =hx-get      "/htmx/goals/local-membership/invites/accept?pool-id={pool-id}&loading=false&accept-invite=true"
      =hx-target   "this"
      =hx-trigger  "load"
      =hx-swap     "outerHTML"
      ;+  =/  =manx  (set-attribute:mx:htmx %style "height: .875em; width: .875em;" (make:fi %loader))
          (extend-attribute:mx:htmx %class " text-sm text-white animate-spin" manx)
    ==
  ::
  ++  invite-reject-button
    |=  [=id:p loading=?]
    ^-  manx
    =/  pool-id=tape  (pool-id-to-html-id id)
    =/  html-id=tape  (weld "local-membership-invites-reject_" pool-id)
    ?.  loading
      ;button
        =id          html-id
        =class       "px-2 py-1 text-sm text-white bg-red-500 rounded hover:bg-red-600 focus:outline-none"
        =hx-get      "/htmx/goals/local-membership/invites/reject?pool-id={pool-id}&loading=true"
        =hx-target   "this"
        =hx-trigger  "click"
        =hx-swap     "outerHTML"
        Reject
      ==
    ;button
      =id          html-id
      =disabled    "true"
      =class       "px-2 py-1 text-sm text-white bg-red-500 rounded hover:bg-red-600 focus:outline-none"
      =hx-get      "/htmx/goals/local-membership/invites/reject?pool-id={pool-id}&loading=false&reject-invite=true"
      =hx-target   "this"
      =hx-trigger  "load"
      =hx-swap     "outerHTML"
      ;+  =/  =manx  (set-attribute:mx:htmx %style "height: .875em; width: .875em;" (make:fi %loader))
          (extend-attribute:mx:htmx %class " text-sm text-white animate-spin" manx)
    ==
  ::
  ++  invite-response-buttons
    |=  =id:p
    ^-  manx
    ;div.flex.space-x-2
      ;+  (invite-accept-button id %.n)
      ;+  (invite-reject-button id %.n)
    ==
  ::
  ++  invite-delete-interface
    |=  response=?
    ^-  manx
    ;div
      ;span(class "text-sm font-bold {?:(response "text-green-500" "text-red-500")}")
        {?:(response "Accepted" "Rejected")}
      ==
      ;button
        =disabled  "false" :: is deleting...
        =class     "ml-2 text-red-500 hover:text-red-600"
        ;+  (set-attribute:mx:htmx %style "height: .875em; width: .875em;" (make:fi %trash-2))
      ==
    ==
  ::
  ++  invites-list
    |=  [active-tab=@t =incoming-invites:p]
    ^-  manx
    ?.  ?=(?(%pending %resolved) active-tab)
      ;div: error
    ::
    =/  invites=(list [id:p invite:p status:p])
      %+  murn  ~(tap by incoming-invites)
      |=  [=id:p =invite:p =status:p]
      ?.  %.  %goals  %~  has  in
          ((as so):dejs:format (~(gut by invite) 'dudes' a+~))
        ~
      ?-  active-tab
        %pending   ?^(status ~ [~ id invite status])
        %resolved  ?~(status ~ [~ id invite status])
      ==
    ::
    ;div.flex.justify-center
      =id  "local-membership-invites-{(trip active-tab)}"
      ;div(class "flex justify-between items-center p-3 bg-gray-100 rounded-lg mb-2")
        ;+  ?~  invites
              ;div: No {(trip active-tab)} invites.
            ;div
              ;*
              %+  turn  invites
              |=  [=id:p =invite:p =status:p]
              ^-  manx
              ;div
                ;div
                  ;p.text-sm.font-bold: {(trip (so:dejs:format (~(gut by invite) 'title' s+'ERROR: No pool title.')))}
                  ;p.px-2.text-sm.text-gray-600: From: {(trip (so:dejs:format (~(gut by invite) 'from' s+'ERROR: No "from".')))}
                ==
                ;+  ?-  active-tab
                      %pending   (invite-response-buttons id)
                      %resolved  (invite-delete-interface response:(need status))
                    ==
              ==
            ==
      ==
    ==
  ::
  ++  requests
    ;div: Requests
  ::
  ++  blocked
    ;div: Blocked
  ::
  ++  discover
    ;div: Discover
  --
--
:: import React, { useEffect, useState, useRef } from 'react';
:: import { FiX, FiLoader, FiTrash2, FiAlertCircle } from 'react-icons/fi';
:: import { Pool } from '../../types';
:: import api from '../../api'; // Ensure this path matches your API utility file
:: 
:: interface Invite {
::   invite: any;
::   status: null | { response: boolean; metadata: any };
:: }
:: 
:: interface Invites {
::   [pid: string]: Invite;
:: }
:: 
:: const InvitesTab = () => {
::   const [incomingInvites, setIncomingInvites] = useState<Invites>({});
::   const [activeTab, setActiveTab] = useState<'pending' | 'resolved'>('pending');
::   const [isLoading, setIsLoading] = useState(true);
::   const [isDeleting, setIsDeleting] = useState<{ [key: string]: boolean }>({});
::   const [processingInvites, setProcessingInvites] = useState<{ [key: string]: boolean }>({});
::   const [errorMessage, setErrorMessage] = useState('');
::   const [refresh, setRefresh] = useState(true);
:: 
::   useEffect(() => {
::     setIsLoading(true);
::     const fetch = async () => {
::       try {
::         const invites = await api.getIncomingInvites();
::         console.log("incoming invites");
::         console.log(invites);
::         setIncomingInvites(invites);
::       } catch (error) {
::         console.error("Error fetching incoming invites:", error);
::         setErrorMessage("Failed to fetch incoming invites.");
::       } finally {
::         setIsLoading(false);
::       }
::     };
::     fetch();
::   }, [refresh]);
:: 
::   const handleAcceptInvite = async (pid: string) => {
::     setProcessingInvites({ ...processingInvites, [pid]: true });
::     try {
::       await api.acceptInvite(pid);
::       setProcessingInvites({ ...processingInvites, [pid]: false });
::       setRefresh(!refresh);
::       // Optionally refresh the list of invites here
::     } catch (error) {
::       console.error("Error accepting invite:", error);
::       setErrorMessage(`Failed to accept invite for pool ${pid}.`);
::       setProcessingInvites({ ...processingInvites, [pid]: false });
::     }
::   };
:: 
::   const handleRejectInvite = async (pid: string) => {
::     setProcessingInvites({ ...processingInvites, [pid]: true });
::     try {
::       await api.rejectInvite(pid);
::       setProcessingInvites({ ...processingInvites, [pid]: false });
::       setRefresh(!refresh);
::       // Optionally refresh the list of invites here
::     } catch (error) {
::       console.error("Error rejecting invite:", error);
::       setErrorMessage(`Failed to reject invite for pool ${pid}.`);
::       setProcessingInvites({ ...processingInvites, [pid]: false });
::     }
::   };
:: 
::   const handleDeleteInvite = async (pid: string) => {
::     const isConfirmed = window.confirm('Are you sure you want to delete this invite?');
::     if (isConfirmed) {
::       setIsDeleting({ ...isDeleting, [pid]: true });
::       try {
::         await api.deleteInvite(pid);
::         setRefresh(!refresh);
::         // Optionally refresh the list of invites here
::       } catch (error) {
::         console.error("Error deleting invite:", error);
::         setErrorMessage(`Failed to delete invite for pool ${pid}.`);
::       } finally {
::         setIsDeleting({ ...isDeleting, [pid]: false });
::       }
::     }
::   };
:: 
::   const renderInviteActionButtons = (pid: string) => (
::     <div className="flex space-x-2">
::       <button
::         onClick={() => handleAcceptInvite(pid)}
::         disabled={processingInvites[pid]}
::         className="px-2 py-1 text-sm text-white bg-green-500 rounded hover:bg-green-600 focus:outline-none"
::       >
::         Accept
::       </button>
::       <button
::         onClick={() => handleRejectInvite(pid)}
::         disabled={processingInvites[pid]}
::         className="px-2 py-1 text-sm text-white bg-red-500 rounded hover:bg-red-600 focus:outline-none"
::       >
::         Reject
::       </button>
::     </div>
::   );
:: 
::   const renderInvites = () => {
::     // Filter invites based on the activeTab
::     const filteredInvites = Object.entries(incomingInvites).filter(([_, invite]) =>
::       activeTab === 'pending' ? invite.status === null : invite.status !== null
::     );
::   
::     return filteredInvites.length > 0 ? (
::         filteredInvites.map(([pid, invite]) => (
::           <div key={pid} className="flex justify-between items-center p-3 bg-gray-100 rounded-lg mb-2">
::             <div>
::               <p className="text-sm font-bold">{invite.invite.title}</p>
::               <p className="px-2 text-xs text-gray-600">From: {invite.invite.from}</p>
::             </div>
::             {activeTab === 'pending' ? (
::               renderInviteActionButtons(pid)
::             ) : (
::               <>
::                 <span className={`text-sm font-bold ${invite.status?.response ? 'text-green-500' : 'text-red-500'}`}>
::                 {invite.status?.response ? 'Accepted' : 'Rejected'}
::                 </span>
::                 <button
::                   onClick={() => handleDeleteInvite(pid)}
::                   className="ml-2 text-red-500 hover:text-red-600"
::                   disabled={isDeleting[pid]}
::                 >
::                   <FiTrash2 />
::                 </button>
::               </>
::             )}
::           </div>
::         ))) : (
::         <div>No pending invites.</div>
::       );
::   };
:: 
::   return (
::     <div className="px-4 pt-5 pb-4 bg-white sm:p-6 sm:pb-4">
::       <div className="sm:flex sm:items-start">
::         <div className="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left w-full">
::           <h3 className="text-lg font-medium leading-6 text-gray-900" id="modal-headline">
::             Incoming Pool Invites
::           </h3>
::           <div className="mt-2">
::             {errorMessage && (
::               <div className="p-2 mb-4 text-sm text-red-700 bg-red-100 rounded-lg">
::                 <FiAlertCircle className="inline mr-2 text-lg"/> {errorMessage}
::               </div>
::             )}
::             <div className="my-5">
::               <div className="mb-2">
::                 <button
::                   className={`px-4 py-2 font-bold text-white rounded ${activeTab === 'pending' ? 'bg-blue-700' : 'bg-blue-200'}`}
::                   onClick={() => setActiveTab('pending')}
::                 >
::                   Pending
::                 </button>
::                 <button
::                   className={`px-4 py-2 ml-2 font-bold text-white rounded ${activeTab === 'resolved' ? 'bg-green-700' : 'bg-green-200'}`}
::                   onClick={() => setActiveTab('resolved')}
::                 >
::                   Resolved
::                 </button>
::               </div>
::               {isLoading ? (
::                 <div className="flex justify-center">
::                   <FiLoader className="text-4xl text-blue-500 animate-spin"/>
::                 </div>
::               ) : renderInvites()}
::             </div>
::           </div>
::         </div>
::       </div>
::     </div>
::   );
:: }
:: 
:: interface Request {
::   request: any;
::   status: null | { response: boolean; metadata: any };
:: }
:: 
:: interface Requests {
::   [pid: string]: Request;
:: }
:: 
:: const RequestsTab = () => {
::   const [outgoingRequests, setOutgoingRequests] = useState<Requests>({});
::   const [activeTab, setActiveTab] = useState<'pending' | 'resolved'>('pending');
::   const [isLoading, setIsLoading] = useState(true);
::   const [isRequesting, setIsRequesting] = useState(false);
::   const [isCancelling, setIsCancelling] = useState<{ [key: string]: boolean }>({});
::   const [poolToRequest, setPoolToRequest] = useState('');
::   const [errorMessage, setErrorMessage] = useState('');
::   const [refresh, setRefresh] = useState(true);
:: 
::   useEffect(() => {
::     const fetch = async () => {
::       setIsLoading(true);
::       try {
::         const requests = await api.getOutgoingRequests();
::         console.log("outgoing requests");
::         console.log(requests);
::         setOutgoingRequests(requests);
::       } catch (error) {
::         console.error("Error fetching outgoing requests:", error);
::         setErrorMessage("Failed to fetch outgoing requests.");
::       } finally {
::         setIsLoading(false);
::       }
::     };
::     fetch();
::   }, [refresh]);
:: 
::   const handleExtendRequest = async () => {
::     setIsRequesting(true);
::     try {
::       await api.extendRequest(poolToRequest);
::       console.log('Requesting to join pool:', poolToRequest);
::       setPoolToRequest('');
::     } catch (error) {
::       console.error("Error requesting to join pool:", error);
::       setErrorMessage('Failed to request to join the pool. Please try again.');
::     } finally {
::       setRefresh(!refresh);
::       setIsRequesting(false);
::     }
::   };
:: 
::   const handleCancelRequest = async (pid: string) => {
::     const confirmation = window.confirm(`Are you sure you want to cancel the request for ${pid}?`);
::     if (!confirmation) {
::       return;
::     }
::     setIsCancelling({ ...isCancelling, [pid]: true });
::     try {
::       await api.cancelRequest(pid);
::     } catch (error) {
::       console.error(`Error cancelling request for ${pid}:`, error);
::     } finally {
::       setIsCancelling({ ...isCancelling, [pid]: false });
::       setRefresh(!refresh);
::     }
::   };
:: 
::   const renderRequests = () => {
::     const pendingRequests = Object.entries(outgoingRequests || {}).filter(
::       ([_, request]) => request.status === null
::     );
:: 
::     const resolvedRequests = Object.entries(outgoingRequests || {}).filter(
::       ([_, request]) => request.status !== null
::     );
:: 
::     const requestsToShow = activeTab === 'pending' ? pendingRequests : resolvedRequests;
:: 
::     return requestsToShow.length > 0 ? (
::       requestsToShow.map(([pid, { status }], index) => (
::         <div key={index} className="flex justify-between items-center p-3 bg-gray-100 rounded-lg mb-2">
::           <span>{pid}</span>
::           <div className="flex items-center">
::             {activeTab === 'pending' ? (
::               <>
::                 <button
::                   onClick={() => handleCancelRequest(pid)}
::                   className="px-2 py-1 text-sm text-white bg-red-500 rounded hover:bg-red-600 focus:outline-none"
::                   disabled={isCancelling[pid]}
::                 >
::                   Cancel
::                 </button>
::               </>
::             ) : (
::               <>
::                 <span className={`text-sm font-bold ${status?.response ? 'text-green-500' : 'text-red-500'}`}>
::                   {status?.response ? 'Accepted' : 'Rejected'}
::                 </span>
::                 <button
::                   onClick={() => handleCancelRequest(pid)}
::                   className="ml-2 text-red-500 hover:text-red-600"
::                   disabled={isCancelling[pid]}
::                 >
::                   <FiTrash2 />
::                 </button>
::               </>
::             )}
::           </div>
::         </div>
::       ))
::     ) : (
::       <div>No {activeTab} requests.</div>
::     );
::   };
:: 
::   return (
::     <div>
::       <div className="mb-4 mx-4">
::         <div className="my-5">
::           <div className="mb-2">
::             <button
::               className={`px-4 py-2 font-bold text-white rounded ${activeTab === 'pending' ? 'bg-blue-700' : 'bg-blue-200'}`}
::               onClick={() => setActiveTab('pending')}
::             >
::               Pending
::             </button>
::             <button
::               className={`px-4 py-2 ml-2 font-bold text-white rounded ${activeTab === 'resolved' ? 'bg-green-700' : 'bg-green-200'}`}
::               onClick={() => setActiveTab('resolved')}
::             >
::               Resolved
::             </button>
::           </div>
::         </div>
::         <div className="flex space-x-2 mt-2">
::           <input
::             type="text"
::             placeholder="Enter a pool id to request to join..."
::             className="p-2 border rounded w-full"
::             value={poolToRequest}
::             onChange={(e) => setPoolToRequest(e.target.value)}
::             disabled={isRequesting} // Disable input during invite process
::           />
::           <button
::             onClick={handleExtendRequest}
::             className={`p-2 text-white rounded ${isRequesting ? 'bg-blue-300' : 'bg-blue-500'} relative`}
::             disabled={isRequesting} // Disable button during invite process
::           >
::             {isRequesting ? (
::               <FiLoader className="animate-spin h-5 w-5 mx-auto text-white" />
::             ) : (
::               'Request'
::             )}
::           </button>
::         </div>
::         {errorMessage && (
::           <div className="flex items-center justify-between bg-red-100 text-red-700 p-2 rounded mt-2">
::             <div className="flex items-center">
::               <FiAlertCircle className="mr-2" />
::               {errorMessage}
::             </div>
::             <FiX className="cursor-pointer" onClick={() => setErrorMessage('')} />
::           </div>
::         )}
::       </div>
::       {isLoading ? (
::         <div className="flex justify-center">
::           <FiLoader className="text-4xl text-blue-500 animate-spin"/>
::         </div>
::       ) : renderRequests()}
::     </div>
::   );
:: }
:: 
:: const BlockedTab = () => {
::   const [blockedHosts, setBlockedHosts] = useState<string[]>([]);
::   const [blockedPools, setBlockedPools] = useState<string[]>([]);
::   const [activeTab, setActiveTab] = useState<'hosts' | 'pools'>('hosts');
::   const [isLoading, setIsLoading] = useState(true);
::   const [errorMessage, setErrorMessage] = useState('');
::   const [refresh, setRefresh] = useState(true);
::   const [blockId, setBlockId] = useState('');
::   const [isBlocking, setIsBlocking] = useState(false);
:: 
::   useEffect(() => {
::     const fetch = async () => {
::       setIsLoading(true);
::       try {
::         const blocked = await api.getLocalBlocked();
::         console.log("blocked");
::         console.log(blocked);
::         setBlockedHosts(blocked.hosts);
::         setBlockedPools(blocked.pools);
::       } catch (error) {
::         console.error("Error fetching blocked info:", error);
::         setErrorMessage("Failed to fetch blocked info.");
::       } finally {
::         setIsLoading(false);
::       }
::     };
::     fetch();
::   }, [refresh]);
:: 
::   const handleBlock = async () => {
::     setIsBlocking(true);
::     try {
::       if (activeTab === 'hosts') {
::         await api.blockHost(blockId);
::         setBlockedHosts([...blockedHosts, blockId]);
::       } else {
::         await api.blockPool(blockId);
::         setBlockedPools([...blockedPools, blockId]);
::       }
::       setBlockId(''); // Clear the input field
::     } catch (error) {
::       console.error(`Error blocking ${activeTab === 'hosts' ? 'host' : 'pool'}:`, error);
::       setErrorMessage(`Failed to block ${activeTab === 'hosts' ? 'host' : 'pool'}.`);
::     } finally {
::       setIsBlocking(false);
::       setRefresh(!refresh);
::     }
::   };
:: 
::   const handleUnblock = async (id: string) => {
::     const type = activeTab === 'hosts' ? 'host' : 'pool';
::     try {
::       // Assuming the API provides methods to unblock hosts and pools
::       if (type === 'host') {
::         await api.unblockHost(id);
::         setBlockedHosts(blockedHosts.filter(host => host !== id));
::       } else {
::         await api.unblockPool(id);
::         setBlockedPools(blockedPools.filter(pool => pool !== id));
::       }
::     } catch (error) {
::       console.error(`Error unblocking ${type}:`, error);
::       setErrorMessage(`Failed to unblock ${type}.`);
::     } finally {
::       setRefresh(!refresh);
::     }
::   };
:: 
::   const renderBlockedItems = () => {
::     const items = activeTab === 'hosts' ? blockedHosts : blockedPools;
::     if (items.length === 0) {
::       return <div>No blocked {activeTab}.</div>;
::     }
:: 
::     return items.map((item, index) => (
::       <div key={index} className="flex justify-between items-center p-3 bg-gray-100 rounded-lg mb-2">
::         <span>{item}</span>
::         <button
::           onClick={() => handleUnblock(item)}
::           className="px-2 py-1 text-sm text-white bg-red-500 rounded hover:bg-red-600 focus:outline-none"
::         >
::           Unblock
::         </button>
::       </div>
::     ));
::   };
:: 
::   return (
::     <div className="my-4 mx-4">
::       <div className="mb-4 flex justify-center">
::         <button
::           className={`px-4 py-2 font-bold text-white rounded ${activeTab === 'hosts' ? 'bg-blue-700' : 'bg-blue-200'}`}
::           onClick={() => setActiveTab('hosts')}
::         >
::           Hosts
::         </button>
::         <button
::           className={`px-4 py-2 ml-2 font-bold text-white rounded ${activeTab === 'pools' ? 'bg-green-700' : 'bg-green-200'}`}
::           onClick={() => setActiveTab('pools')}
::         >
::           Pools
::         </button>
::       </div>
::       <div className="flex space-x-2 my-4">
::         <input
::           type="text"
::           placeholder={`Enter ${activeTab === 'hosts' ? 'host' : 'pool'} ID to block`}
::           className="flex-grow p-2 border rounded"
::           value={blockId}
::           onChange={(e) => setBlockId(e.target.value)}
::           disabled={isBlocking}
::         />
::         <button
::           onClick={handleBlock}
::           className={`px-4 py-2 text-white bg-red-600 rounded hover:bg-red-700 ${isBlocking ? 'opacity-50 cursor-not-allowed' : ''}`}
::           disabled={isBlocking}
::         >
::           Block
::         </button>
::       </div>
::       {isLoading ? (
::         <div className="flex justify-center">
::           <FiLoader className="text-4xl text-blue-500 animate-spin"/>
::         </div>
::       ) : (
::         <div>
::           {errorMessage && (
::             <div className="flex items-center justify-between bg-red-100 text-red-700 p-2 rounded mt-2">
::               <div className="flex items-center">
::                 <FiAlertCircle className="mr-2" />
::                 {errorMessage}
::               </div>
::               <FiX className="cursor-pointer" onClick={() => setErrorMessage('')} />
::             </div>
::           )}
::           {renderBlockedItems()}
::         </div>
::       )}
::     </div>
::   );
:: }
:: 
:: const DiscoverTab = () => {
::   const [activeTab, setActiveTab] = useState<'pals' | 'search'>('pals');
::   const [isShipSearching, setIsShipSearching] = useState(false);
::   const [isPalsSearching, setIsPalsSearching] = useState<{ [target: string]: boolean }>({});
::   const [isRequesting, setIsRequesting] = useState<{ [pid: string]: boolean }>({});
::   const [shipPools, setShipPools] = useState<Pool[]>([]);
::   const [palsPools, setPalsPools] = useState<{ [target: string]: { pools: Pool[] | null, error: boolean } }>({});
::   const [shipToSearch, setShipToSearch] = useState('');
::   const [searchedShip, setSearchedShip] = useState('');
::   const [errorMessage, setErrorMessage] = useState('');
:: 
::   useEffect(() => {
::     const fetch = async () => {
::       try {
::         const targets: string[] = await api.palsTargets();
::         if (targets.length === 0) {
::           return;
::         }
:: 
::         // Initialize state for each target
::         setPalsPools(targets.reduce((acc, target) => {
::           acc[target] = { pools: [], error: false };
::           return acc;
::         }, {} as { [target: string]: { pools: Pool[] | null, error: boolean } }));
:: 
::         targets.forEach(async (target: string) => {
::           setIsPalsSearching(prev => ({ ...prev, [target]: true }));
::           try {
::             const pools: Pool[] = await api.discover(target.substring(1));
::             setPalsPools(prev => ({
::               ...prev,
::               [target]: { pools: pools, error: false }
::             }));
::           } catch (error) {
::             console.error(`Error discovering pools for target ${target}:`, error);
::             setPalsPools(prev => ({
::               ...prev,
::               [target]: { pools: null, error: true }
::             }));
::           } finally {
::             setIsPalsSearching(prev => ({ ...prev, [target]: false }));
::           }
::         });
::       } catch (error) {
::         console.error("Error fetching pals targets:", error);
::       }
::     };
:: 
::     fetch();
::   }, []);
:: 
::   const sortedTargets = Object.keys(palsPools).sort();
:: 
::   const handleShipSearch = async () => {
::     setIsShipSearching(true);
::     try {
::       const pools = await api.discover(shipToSearch);
::       console.log("ship pools");
::       console.log(pools);
::       setShipPools(pools);
::       console.log('Discovering pools from:', shipToSearch);
::       setSearchedShip(shipToSearch);
::     } catch (error) {
::       console.error("Error discovering pools from:", error);
::       setErrorMessage('Failed to discover pools. Please try again.');
::     } finally {
::       setIsShipSearching(false);
::       setShipToSearch('');
::     }
::   };
:: 
::   const handleExtendRequest = async (pid: string) => {
::     console.log("pid");
::     console.log(pid);
::     setIsRequesting(prev => ({ ...prev, [pid]: true }));
::     try {
::       await api.extendRequest(pid);
::       console.log('Requesting to join pool:', pid);
::     } catch (error) {
::       console.error("Error requesting to join pool:", error);
::       setErrorMessage('Failed to request to join the pool. Please try again.');
::     } finally {
::       setIsRequesting(prev => ({ ...prev, [pid]: false }));
::     }
::   };
:: 
::   const renderSearchResults = () => {
::     return (
::       !searchedShip ? (
::        <div>Enter a ship name to begin your search.</div>
::       ) : (
::       <div>
::         <h3 className="text-lg leading-6 font-medium text-gray-900">Pools From:</h3>
::         <h3 className="text-lg leading-6 font-medium text-gray-900">{searchedShip}</h3>
::         {(shipPools.length > 0) ? (
::             <div>
::               <ul>
::               {shipPools.map((pool, index) => (
::                   <li key={pool.pid} className="text-gray-700 py-1 flex justify-between items-center">
::                   {pool.title}
::                   {!pool.requested && (
::                     <button
::                       className="ml-4 px-2 py-1 bg-blue-500 text-white rounded hover:bg-blue-600"
::                       onClick={() => handleExtendRequest(pool.pid)}
::                     >
::                       Request
::                     </button>
::                   )}
::                 </li>
::               ))}
::               </ul>
::             </div>
::         ) : (
::           <div>No pools found.</div>
::         )}
::       </div>
::     ));
::   };
:: 
::   const renderPools = () => {
::     return (
::       <div className="my-4 mx-4">
::         <h4 className="text-lg leading-6 font-medium text-gray-900">Pals' Pools:</h4>
::         {sortedTargets.length === 0 ? (
::               <div>No pals found.</div>
::         ) : sortedTargets.map(target => (
::           <div key={target}>
::             <h5 className="font-bold">{target}</h5>
::             {isPalsSearching[target] ? (
::               <div className="flex justify-center">
::                 <FiLoader className="animate-spin h-5 w-5 text-blue-500" />
::               </div>
::             ) : palsPools[target].error ? (
::               <p className="text-red-500"><FiAlertCircle className="inline mr-2" />Failed to discover pools.</p>
::             ) : palsPools[target].pools && (palsPools[target].pools as Pool[]).length > 0 ? (
::               <ul>
::                 {palsPools[target].pools ? palsPools[target].pools?.map(pool => (
::                   <li key={pool.pid} className="text-gray-700 py-1 flex justify-between items-center">
::                       {pool.title}
::                       {!pool.requested && (
::                         <button
::                           className="ml-4 px-2 py-1 bg-blue-500 text-white rounded hover:bg-blue-600"
::                           onClick={() => handleExtendRequest(pool.pid)}
::                         >
::                           Request
::                         </button>
::                       )}
::                     </li>
::                 )) : <p className="text-gray-500">Loading...</p>}
::               </ul>
::             ) : (
::               <div>No pools found.</div>
::             )}
::           </div>
::         ))}
::       </div>
::     );
::   };
::   
::   return (
::     <div className="my-4 mx-4">
::       <div className="mb-4 flex justify-center">
::         <button
::           className={`px-4 py-2 font-bold text-white rounded ${activeTab === 'pals' ? 'bg-blue-700' : 'bg-blue-200'}`}
::           onClick={() => setActiveTab('pals')}
::         >
::           Pals
::         </button>
::         <button
::           className={`px-4 py-2 ml-2 font-bold text-white rounded ${activeTab === 'search' ? 'bg-green-700' : 'bg-green-200'}`}
::           onClick={() => setActiveTab('search')}
::         >
::           Search
::         </button>
::       </div>
::       {activeTab === 'pals' && (
::         <div>
::           {renderPools()}
::         </div>
::       )}
::       {activeTab === 'search' && (
::         <div>
::           <div className="flex space-x-2 mt-2">
::             <input
::               type="text"
::               placeholder="Enter a ship name to search..."
::               className="p-2 border rounded w-full"
::               value={shipToSearch}
::               onChange={(e) => setShipToSearch(e.target.value)}
::               disabled={isShipSearching} // Disable input during invite process
::             />
::             <button
::               onClick={handleShipSearch}
::               className={`p-2 text-white rounded ${isShipSearching ? 'bg-blue-300' : 'bg-blue-500'} relative`}
::               disabled={isShipSearching} // Disable button during invite process
::             >
::               {isShipSearching ? (
::                 <FiLoader className="animate-spin h-5 w-5 mx-auto text-white" />
::               ) : (
::                 'Search'
::               )}
::             </button>
::           </div>
::           {renderSearchResults()}
::         </div>
::       )}
::       {errorMessage && <div className="error text-red-500">{errorMessage}</div>}
::     </div>
::   );
:: }
:: 
:: const LocalMembershipPanel = ({
::   exit,
:: } : {
::   exit: () => void,
:: }) => {
::   const [activeTab, setActiveTab] = useState<'invites' | 'requests' | 'blocked' | 'discover'>('invites');
:: 
::   const handleTabClick = (tabName: 'invites' | 'requests' | 'blocked' | 'discover') => {
::     setActiveTab(tabName);
::   };
:: 
::   return (
::     <div className="fixed inset-0 z-10 overflow-y-auto">
::       <div className="flex items-end justify-center min-h-screen px-4 pt-4 pb-20 text-center sm:block sm:p-0">
::         <div className="fixed inset-0 transition-opacity">
::           <div className="absolute inset-0 bg-gray-500 opacity-75"></div>
::         </div>
::         <span className="hidden sm:inline-block sm:align-middle sm:h-screen">&#8203;</span>
::         <div className="inline-block overflow-hidden text-left align-bottom transition-all transform bg-white rounded-lg shadow-xl sm:my-8 sm:align-middle sm:max-w-lg sm:w-full" role="dialog" aria-modal="true" aria-labelledby="modal-headline">
::           <div className="border-b mb-4">
::             <nav className="flex space-x-4" aria-label="Tabs">
::               <button
::                 className={`px-3 py-2 font-medium text-sm ${activeTab === 'invites' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
::                 onClick={() => handleTabClick('invites')}
::               >
::                 Invites
::               </button>
::               <button
::                 className={`px-3 py-2 font-medium text-sm ${activeTab === 'requests' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
::                 onClick={() => handleTabClick('requests')}
::               >
::                 Requests
::               </button>
::               <button
::                 className={`px-3 py-2 font-medium text-sm ${activeTab === 'blocked' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
::                 onClick={() => handleTabClick('blocked')}
::               >
::                 Blocked
::               </button>
::               <button
::                 className={`px-3 py-2 font-medium text-sm ${activeTab === 'discover' ? 'text-blue-700 border-blue-700' : 'text-gray-500 hover:text-gray-700'}`}
::                 onClick={() => handleTabClick('discover')}
::               >
::                 Discover
::               </button>
::             </nav>
::           </div>
::           {activeTab === 'invites' && (
::             <InvitesTab/>
::           )}
::           {activeTab === 'requests' && (
::             <RequestsTab/>
::           )}
::           {activeTab === 'blocked' && (
::             <BlockedTab/>
::           )}
::           {activeTab === 'discover' && (
::             <DiscoverTab/>
::           )}
::           <div className="px-4 py-3 bg-gray-50 sm:px-6 sm:flex sm:flex-row-reverse">
::             <button onClick={exit} className="w-full px-4 py-2 mt-3 font-medium text-white bg-red-600 rounded-md shadow-sm hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
::               Close
::             </button>
::           </div>
::         </div>
::       </div>
::     </div>
::   );
:: };
:: 
:: export default LocalMembershipPanel;
