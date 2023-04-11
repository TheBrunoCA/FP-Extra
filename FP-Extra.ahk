#Requires AutoHotkey v2.0
#SingleInstance Force

; TODO: Detect if it was updated
; was_updated := false
; DetectHiddenWindows(True)
; if(WinExist(A_AppName "_batch.bat")){
;     was_updated := true
; }

; Includes
#Include ..\libraries\Github-Updater.ahk\github-updater.ahk
#Include ..\libraries\Bruno-Functions\bruno-functions.ahk
#Include ..\libraries\Bruno-Functions\IsOnline.ahk

A_AppName := GetAppName()
git_user := "TheBrunoCA"
git_repo := A_AppName
dir_path := NewDir(A_AppData . "\" . git_user . "\" . git_repo)
config_file := NewIni(dir_path "\config.ini")
icon_path := dir_path "\icon.ico"
icon_url := "https://drive.google.com/uc?export=download&id=1xNRHV5RBpoEbag6-m5r5ry6y8zy1ZMLV"
github := Git(git_user, git_repo)
update_file := A_Temp "\" git_repo "-Updated.txt"
updated := false
update_message := ""
if FileExist(update_file) != ""{
    updated := true
    update_message := FileRead(update_file)
    FileDelete(update_file)
}

;Config
version := IniRead(config_file, "config", "version", "0.121")
auto_update := IniRead(config_file, "config", "auto update", true)
expiration_date := IniRead(config_file, "config", "expiration date", 179)

LoadIcon(){
    if FileExist(icon_path) == ""{
        if IsOnline() == false
            return
        Download icon_url, icon_path
    }
    TraySetIcon icon_path
}

OpenConfigMenu(p_arg*) {
    MsgBox("Ainda não implementado.")
}

CalculateExpirationDate(p_arg*) {
    presc_date := cal_presc_date.Value
    cal_presc_date.Value := A_Now
    valid_until := DateAdd(presc_date, expiration_date, "Days")
    valid_until := FormatTime(valid_until, "LongDate")

    MsgBox("A receita é válida até " . valid_until)
}

CheckUpdates(){
    if github.IsUpdated(version)
        return

    answer := MsgBox("Uma nova versão do app foi encontrada, deseja atualizar?", "Versão " github.version " encontrada","0x4")

    if(answer == "Yes"){
        github.UpdateApp(dir_path)
        return
    }
}

LoadIcon()
if (auto_update) {
    CheckUpdates()
}

MainGui := Gui("-MaximizeBox +OwnDialogs", "FP-Extra v-" version)

MainGui.SetFont("s20", "Consolas")
MainGui.AddText("Center", "FP-Extra por " git_user)

MainGui.SetFont("s10")

btn_config := MainGui.AddButton("xm", "Configurações")
btn_config.OnEvent("Click", OpenConfigMenu)

MainGui.AddText("x215 y60", "Data da receita")
cal_presc_date := MainGui.AddMonthCal("x160 y80")

btn_calc_date := MainGui.AddButton("x200", "Calcular validade")
btn_calc_date.OnEvent("Click", CalculateExpirationDate)

MainGui.Show()

If updated
    MsgBox(update_message, git_repo " Atualizado para v-" github.version)