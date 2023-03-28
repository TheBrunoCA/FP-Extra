#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_ScriptDir

; Includes
#Include lib\functions.ahk

; Versino file path
version_file := A_MyDocuments "\version_file.ini"
; github username
git_user := "TheBrunoCA"
; github repo
git_repo := "FP-Extra"

github := Git(git_user, git_repo)

GetAppName(){
    return StrSplit(A_ScriptName, ".")[1]
}

reloadScript(){
    MsgBox("Reloading", , "t1")
	Reload
}

UpdateApp(){
    github.Download(A_WorkingDir, "FP-Extra")
    IniWrite github.GetVersion(), version_file, "version", GetAppName()
    MsgBox("A Aplicação foi atualizada e será fechada automaticamente, por favor apenas reabra.", "FP-Extra atualizado!")
    ExitApp()
}

CheckUpdates(){
    if(IsUpdated()){
        return
    }
    answer := MsgBox("Uma nova versão do app foi encontrada, deseja atualizar?", "Versão " github.GetVersion() " encontrada","0x4")
    if(answer == "Yes"){
        UpdateApp()
    }
    return
}

IsUpdated(){
    if(FileExist(version_file) == ""){
        return false
    }
    if(IniRead(version_file, "version", GetAppName()) < github.GetVersion()){
        return false
    }
    return true
}

CheckUpdates()