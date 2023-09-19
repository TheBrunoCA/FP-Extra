VERSION     := "0.1.1"

gitRepo     := "FP-Extra"
author      := "TheBrunoCA"
github      := Git(author, gitRepo)

installPath := A_AppData "\" author "\" gitRepo
iniPath     := installPath "\" gitRepo "_config.ini"
inifile     := Ini(iniPath)
