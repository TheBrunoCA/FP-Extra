#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_ScriptDir

; Includes
#Include "lib\_JXON.ahk"

; Versão hard coded do script para testes
script_hard_version := 0

showScriptVersion(){
    MsgBox("FP-Extra versão: " script_hard_version, "Versão do aplicativo")
}

; Hotkey para mostrar versão
^+!v::showScriptVersion()

; Hotkey para atualizar script
^+!u::updateScript()


version_file := A_MyDocuments "\version_file.ini"


if(FileExist(version_file) == ""){
	IniWrite "0", version_file, "version", A_ScriptName
}

reloadScript(){
    MsgBox("Reloading", , "t1")
	Reload
}

