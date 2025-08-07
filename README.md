# vim-logcat
Vim plugin for better work with Android logs (obtained with adb logcat)

At the moment this is a work in progress and unusable, in future is should significantly simplify navigation and analysis of android logs. Idea is to allow turning on/off highlighting of a specific tag by a shortcut, hide/show certain blocks of log (time,pid,tag), quickly jump to next log message from the same pid, tid, tag, hide/show logs from a certain pid/tid/tag, hide/show logs from a certain log level.

- Help with syntax highlighting Java/Kotlin crashes
- Highlight lines with different log levels
- Highlight lines with a specific tags of interest (can be toggled by placing curor to the the line with tag and pressing shortcut)
- Hide/Show lines of a certain tag/pid/log level
- Navigating to next/previous log message of the same pid,tag,tid,loglevel
- Navigation to the Start/End block (see example) by pressing %

```
--> section A
other text
<-- section A
```

What is working at the moment:
- Highlight message of the log to be distinct from the metadata like pid, tag, log level, etc
- Hide/Show Date-Time with command `LogcatHide time`
- Highlight logcat tag with a difinitive color by keymapping `gt` or by command `LogcatHighlightTag`
- Un Highlight logcat tag which was previously highlighted by keymapping `Gt` or by command `LogcatUnHighlightTag`
- Navigation to the Start/End block marked by -->
- Find tag and reverse find tag by pressing t and T in normal mode
