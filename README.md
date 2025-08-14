# vim-logcat
Vim plugin to work with Android lods obtained by a `adb logcat` command. It allows you quickly search for text, highlight certain phrases, remove unnecessary messages, etc. All this should let you efficintly understand root causes of problems. 

This plugin is work in progress and many features and shortcuts may be redesigned in near future until it reaches stable phase.

Plugin operates following terminology:
- logcat log - is a result of the `adb logcat` output

Each logcat line consists of following parts:
```
04-20 20:41:04.964 22 4444 D zloy    : log message
```
04-20 is a date of a message
20:41:04.964 is a time of the message, 20 is an hour, 41 is minutes, 04 is seconds, 964 is milliseconds
22 is a pid (process id) of the process who produced a message
4444 is a tid (thread id) of the thread who produced a message
D is a level of the log messages (D is debug). It is possible to see W for warning, I for Info, D for Debug, V for verbose, E for error, W for Warn, F for fatal 
zloy is a tag of the message (see logcat output documentation for more details). It is a free form string which then followed by :
'log message' is a message of the log, what log actually logged

Plugin understands each part of the logcat line and can operate with each idividually. For example, it can highlight certain tag, or show/hide data and time of the message to reduce noise.


Plugin follows following principles:
- Most of the actions can be triggered with vim commands. Some commands may take required arguments, some can take optional arguments. For example command `:LogcatHighlightTag` can be called without arguments, it will then search for a tag in the line under cursor. At the same time, you can explicitly specify tag to highlight by calling `:LogcatHighlightTag name of tag`. Another example is command `:LogcatFindHighlight 1` has to pass id of the highlighted phrase, otherwise it fails with an error.
- Some functionality exposed as shortcuts in normal mode. On the press of shortcut plugin will trigger command for you (i.e. anything that can be done via shortcut can be invoked via command). For example, <leader>-t will highlight logcat tag from the line under cursor.
- Whenever possible, plugin follows common vim shortcuts, but sometimes it introduces unconventional shortcut. For example it uses ]] } and ) for jumping to a next line with tag, pid, tid; at the same time it uses <leader>t to highlight tag (unconventional use of `t`)
- In the shortcuts plugin follows principle of 'negating' or 'reversing' same command if it is invoked with 'shift', i.e. lowercase shortcut vs uppercase shortcut. Example: <leader>t will highlight tag, <leader>T will un-highlight tag; <leader>f1 will search for a highlighted phrase and <leader>F1 will search for phrase backwards
- You can look a documentation for plugin by using `:help logcat` (not yet implemented)
- When you will be using different convenient highlights, it is possible to store all of them to a state line in the start of the logcat file, use `:LogcatWriteState` command, then once you reopen this file, Plugin will recover it's state and will be automatically syncing all changes to the file

Following features already implemented: 
- Syntax highlighting of the message to be distinct from the metadata like pid, tag, log level, etc
- Hide/Show Date-Time with command `LogcatHideToggle time`
- Highlight logcat tag with a difinitive color by keymapping `<leader>t` or by command `LogcatHighlightTag tagname`
- Un Highlight logcat tag which was previously highlighted by keymapping `<leader>T` or by command `LogcatUnHighlightTag`
- Navigation to the Start/End block marked by --> by pressing %
- Find tag and reverse find tag by pressing ) and ( in normal mode
- Find pid and reverse find pid by pressing ]] and [[ in normal mode
- Find tid and reverse find tid by pressing } and { in normal mode
- Highlight any custom text in the log message by invoking command `:LogcatHighligh phrase`, later you can search highlight quickly by pressing <leader>h1 or <leader>h2, etc based on the id of the highlight (assigned incrementally), you can also call :LogcatLsHighlights to see all ids
  - If you want to search for id which is greater then 9, you can invoke :LogcatFindHighlight ID
  - You can also reverse search by using <leader>H1, i.e. press leader+shift H+number
- Syntax highlighting of the Java stack trace
- Writing state of the plugin to a status line in the file (first line starting with --vim-logcat;)
  - Plugin will read this line and recover it's state once file is opened
  - If state line exists in the file, any updates to the plugin state will update a state line and save file for you
  - To create a state line very first time, call `:LogcatWriteState`

What is planned for future:
- Delete all messages of a certain tag
- Delete all messages other then a certain tag
- Delete all messages of a certain pid or tid
- Delete all messages other then a certain pid, tid
- Hide pid, tid, level, tag information to reduce noise
- Calculate time difference between 2 log lines to estimate duration of an operation (first line has to be `marked`, second can be a line where cursor is currently located)
- Store state of all manipulations in the log file on first line; When file is opened, reading the state of manipulations, i.e. to see all highlights/searches/hidden tags, etc. once file reopened

