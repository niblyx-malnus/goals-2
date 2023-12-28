/+  server
|%
+$  message  (unit (each tape tape))
++  page
  |=  [=message dap=term =path fil=(list (pair @t mark)) dir=(list @t)]
  ^-  manx
  ;hmtl
    ;head
      ;title: filetree: {(trip (cat 3 '%' dap))}
      ;meta(charset "utf-8");
      ;meta
        =name     "viewport"
        =content  "width=device-width, initial-scale=1";
    ==
    ;body
      ;p: {(spud path)}
      ;*  (print-message message)
      ;h1: filetree: {(trip (cat 3 '%' dap))}
      ;+  (directory-structure dap path fil dir)
    ==
  ==
::
++  print-message
  |=  =message
  ^-  marl
  ?~  message  ~
  :_  ~
  ?-    -.u.message
      %&  ;p(style "color: green;"): {p.u.message}
      %|  ;p(style "color: red;"): {p.u.message}
  ==
::
++  directory-structure
  |=  [dap=term =path fil=(list (pair @t mark)) dir=(list @t)]
  ^-  manx
  ;table
    =style  "border-collapse: collapse"
    ;*  =;  first  [first (directory-contents dap path fil dir)]
        ;tr
          =style  "border: 1px solid black"
          ;td
            =style  "width: 300px; border: 1px solid black"
            ;h2: 📁 {(trip (cat 3 ?~(path '' (rear path)) '/'))}
          ==
          ;td
            =style  "width: 50px; text-align: center; border: 1px solid black"
            ;a
              =style     "padding: 0"
              =href      "{(spud [%filetree dap path])}.tar"
              =download  ""
              =title     "Download"
              =style     "width: 50px; text-align: center"
              ⬇️
            ==
          ==
          ;td
            =style  "border: 1px solid black"
            ;form
              =method   "post"
              =enctype  "multipart/form-data"
              =action   "{(spud [%filetree dap path])}"
              =class    "justified-form"
              ;input
                =id        "file-select"
                =type      "file"
                =name      "file"
                =required  "required"
                =directory        ""
                =webkitdirectory  ""
                =mozdirectory     "";
              ;input
                =type   "hidden"
                =name   "file-type"
                =value  "directory";
              ;input
                =type   "hidden"
                =name   "current-page"
                =value  "{(spud path)}";
              ;input(type "submit", value "upload");
            ==
          ==
          ;td
            =style  "width: 50px; text-align: center; border: 1px solid black"
            ;form
              =action   "{(spud [%filetree dap path])}"
              =method  "post"
              ;input
                =type   "hidden"
                =name   "delete"
                =value  "{(spud path)}"
                ;button(type "submit"): ❌
              ==
            ==
          ==
        ==
  ==
::
++  directory-contents 
  |=  [dap=term =path fil=(list (pair @t mark)) dir=(list @t)]
  ^-  marl
  ;:  welp
    :~
      ;tr
        =style  "border: 1px solid black"
        ;td
          =style  "width: 300px; border: 1px solid black"
          📁 Create subdirectory
        ==
        ;td
          =style  "width: 50px; text-align: center; border: 1px solid black";
        ;td
          =style  "border: 1px solid black"
          ;form
            =method   "post"
            =enctype  "multipart/form-data"
            =action   "{(spud [%filetree dap path])}"
            =class    "justified-form"
            ;input
              =id        "file-select"
              =type      "file"
              =name      "file"
              =required  "required"
              =directory        ""
              =webkitdirectory  ""
              =mozdirectory     "";
            ;input
              =type   "hidden"
              =name   "file-type"
              =value  "directory";
            ;input
              =type   "hidden"
              =name   "create"
              =value  "";
            ;input
              =type   "hidden"
              =name   "current-page"
              =value  "{(spud path)}";
            ;input(type "submit", value "upload");
          ==
        ==
        ;td
          =style  "border: 1px solid black";
        ;td
          =style  "width: 50px; text-align: center; border: 1px solid black";
      ==
      ;tr
        =style  "border: 1px solid black"
        ;td
          =style  "width: 300px; border: 1px solid black"
          📄 Create file
        ==
        ;td
          =style  "width: 50px; text-align: center; border: 1px solid black";
        ;td
          =style  "border: 1px solid black"
          ;form
            =method   "post"
            =enctype  "multipart/form-data"
            =action   "{(spud [%filetree dap path])}"
            =class    "justified-form"
            ;input
              =id        "file-select"
              =type      "file"
              =name      "file"
              =required  "required";
            ;input
              =type   "hidden"
              =name   "file-type"
              =value  "file";
            ;input
              =type   "hidden"
              =name   "create"
              =value  "";
            ;input
              =type   "hidden"
              =name   "current-page"
              =value  "{(spud path)}";
            ;input(type "submit", value "upload");
          ==
        ==
        ;td
          =style  "border: 1px solid black";
        ;td
          =style  "width: 50px; text-align: center; border: 1px solid black";
      ==
    ==
    ::
    ?~  path  ~
    %+  turn  ['~' '..' ~]
    |=  name=@t
    ^-  manx
    ;tr
      =style  "border: 1px solid black"
      ;td
        =style  "width: 300px; border: 1px solid black"
        ;a
          =style  "padding: 0"
          =href   "{(spud [%filetree dap ?:(?=(%'~' name) ~ (snip `^path`path))])}"
          📁 {(trip (cat 3 name '/'))}
        ==
      ==
      ;td
        =style  "width: 50px; text-align: center; border: 1px solid black";
      ;td
        =style  "border: 1px solid black";
      ;td
        =style  "width: 50px; text-align: center; border: 1px solid black";
    ==
    ::
    %+  turn  dir
    |=  name=@t
    ^-  manx
    ;tr
      =style  "border: 1px solid black"
      ;td
        =style  "width: 300px; border: 1px solid black"
        ;a
          =style  "padding: 0"
          =href   "{(spud [%filetree dap (weld path name ~)])}"
          📁 {(trip (cat 3 name '/'))}
        ==
      ==
      ;td
        =style  "width: 50px; text-align: center; border: 1px solid black"
        ;a
          =style     "padding: 0"
          =href      "{(spud [%filetree dap (snoc path name)])}.tar"
          =download  ""
          =title     "Download"
          =style     "width: 50px; text-align: center"
          ⬇️
        ==
      ==
      ;td
        =style  "border: 1px solid black"
        ;form
          =method   "post"
          =enctype  "multipart/form-data"
          =action   "{(spud [%filetree dap (snoc path name)])}"
          =class    "justified-form"
          ;input
            =id        "file-select"
            =type      "file"
            =name      "file"
            =required  "required"
            =directory        ""
            =webkitdirectory  ""
            =mozdirectory     "";
          ;input
            =type   "hidden"
            =name   "file-type"
            =value  "directory";
          ;input
            =type   "hidden"
            =name   "current-page"
            =value  "{(spud path)}";
          ;input(type "submit", value "upload");
        ==
      ==
      ;td
        =style  "width: 50px; text-align: center; border: 1px solid black"
        ;form
          =action   "{(spud [%filetree dap path])}"
          =method  "post"
          ;input
            =type   "hidden"
            =name   "delete"
            =value  "{(spud (snoc path name))}"
            ;button(type "submit"): ❌
          ==
        ==
      ==
    ==
    ::
    %+  turn  fil
    |=  [name=@t =mark]
    ^-  manx
    ;tr
      =style  "border: 1px solid black"
      ;td
        =style  "width: 300px; border: 1px solid black"
        ;a
          =style     "padding: 0"
          =href      "{(spud [%filetree dap (snoc path name)])}.{(trip mark)}"
          📄 {(trip (rap 3 name '.' mark ~))}
        ==
      ==
      ;td
        =style  "width: 50px; text-align: center; border: 1px solid black"
        ;a
          =style     "padding: 0"
          =href      "{(spud [%filetree dap (snoc path name)])}.{(trip mark)}"
          =download  ""
          =title     "Download"
          =style     "width: 50px; text-align: center"
          ⬇️
        ==
      ==
      ;td
        =style  "border: 1px solid black"
        ;form
          =method   "post"
          =enctype  "multipart/form-data"
          =action   "{(spud [%filetree dap (weld path [name mark ~])])}"
          =class    "justified-form"
          ;input
            =id        "file-select"
            =type      "file"
            =name      "file"
            =required  "required";
          ;input
            =type   "hidden"
            =name   "file-type"
            =value  "file";
          ;input
            =type   "hidden"
            =name   "current-page"
            =value  "{(spud path)}";
          ;input(type "submit", value "upload");
        ==
      ==
      ;td
        =style  "width: 50px; text-align: center; border: 1px solid black"
        ;form
          =action   "{(spud [%filetree dap path])}"
          =method  "post"
          ;input
            =type   "hidden"
            =name   "delete"
            =value  "{(spud (weld path [name mark ~]))}"
            ;button(type "submit"): ❌
          ==
        ==
      ==
    ==
  ==
--
