To develop plugin, use ./run_vim.sh example.logcat
It will start vim instance with only logcat plugin enabled. It will also show a status line with a name of the syntax ID under cursor which is very useful to debug syntax highlighting.

To run unit tests, run ./test_all.sh, it uses vader as a unit testing framework. Whenever new feature is added, please add a test case for it. 
