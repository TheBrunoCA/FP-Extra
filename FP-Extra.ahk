#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_ScriptDir


; Includes
#Include lib\functions.ahk

dir_path := A_AppData "\" GetAppName()

config_file := dir_path "\config.ini"

icon_path := dir_path "\icon.ico"

icon_url := "https://drive.google.com/uc?export=download&id=1xNRHV5RBpoEbag6-m5r5ry6y8zy1ZMLV"

git_user := "TheBrunoCA"

git_repo := "FP-Extra"

Class config{
    __New() {
        ; update
        static auto_update := false
    }
}


GetAppName(){
    return StrSplit(A_ScriptName, ".")[1]
}

reloadScript(){
    MsgBox("Reloading", , "t1")
	Reload
}

UpdateApp(){
    github.Download(A_WorkingDir, "FP-Extra")
    IniWrite github.GetVersion(), config_file, "version", GetAppName()
    MsgBox("A Aplicação foi atualizada e será fechada automaticamente, por favor apenas reabra.", "FP-Extra atualizado!")
    ExitApp()
}

CheckUpdates(){
    if(!github.is_online){
        return
    }
    if(IsUpdated()){
        return
    }
    answer := MsgBox("Uma nova versão do app foi encontrada, deseja atualizar?", "Versão " github.GetVersion() " encontrada","0x4")
    if(answer == "Yes"){
        UpdateApp()
        return
    }
    return
}

IsUpdated(){
    if(FileExist(config_file) == ""){
        return false
    }
    if(IniRead(config_file, "version", GetAppName()) < github.GetVersion()){
        return false
    }
    return true
}

LoadConfigs(){
    if(DirExist(dir_path) == ""){
        DirCreate(dir_path)
    }
    if(FileExist(config_file) == ""){
        IniWrite("0", config_file, "version", GetAppName())
        IniWrite("true", config_file, "update", "auto-update")
    }
    config.auto_update := IniRead(config_file, "update", "auto-update", true)
    if(!github.is_online){
        return
    }
    if(FileExist(icon_path) == ""){
        Download(icon_url, icon_path)
    }
    TraySetIcon(icon_path)
}


OpenConfigMenu(arg*){
    MsgBox("Ainda não implementado.")
}

github := Git(git_user, git_repo)

LoadConfigs()

MainGui := Gui("-MaximizeBox +OwnDialogs", "FP-Extra Tela principal")

MainGui.SetFont("s20", "Consolas")
MainGui.AddText("Center", "FP-Extra por Bruno")

MainGui.SetFont("s10")
btn_config := MainGui.AddButton("xm", "Configurações")
btn_config.OnEvent("Click", OpenConfigMenu)

if(config.auto_update){
    CheckUpdates()
}
MainGui.Show()

