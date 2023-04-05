#Requires AutoHotkey v2.0
#SingleInstance Force

was_updated := false
DetectHiddenWindows(True)
if(WinExist(GetAppName() "_batch.bat")){
    was_updated := true
}

; Includes
#Include ..\libraries\Bruno-Functions\bruno-functions.ahk
#Include ..\libraries\Github-Updater.ahk\github-updater.ahk

dir_path := A_AppData "\" GetAppName()

if(DirExist(dir_path) == ""){
    DirCreate(dir_path)
}

config_file := dir_path "\config.ini"

icon_path := dir_path "\icon.ico"

icon_url := "https://drive.google.com/uc?export=download&id=1xNRHV5RBpoEbag6-m5r5ry6y8zy1ZMLV"

git_user := "TheBrunoCA"

git_repo := GetAppName()

Class config{
    static ini := IniFile(config_file, , true)
    static version := 0.12
    static auto_update := true
    static expiration_date := 179
}

LoadConfigs(&git_hub){
    if(!git_hub.is_online){
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

CalculateExpirationDate(arg*){
    presc_date := cal_presc_date.Value
    cal_presc_date.Value := A_Now
    expiration_date := DateAdd(presc_date, config.expiration_date, "Days")
    expiration_date := FormatTime(expiration_date, "LongDate")

    MsgBox("A receita é válida até " expiration_date)

}



LoadConfigs(&github)

MainGui := Gui("-MaximizeBox +OwnDialogs", "FP-Extra v-" IniRead(config_file, "version", GetAppName(), ""))

MainGui.SetFont("s20", "Consolas")
MainGui.AddText("Center", "FP-Extra por " git_user)

MainGui.SetFont("s10")

btn_config := MainGui.AddButton("xm", "Configurações")
btn_config.OnEvent("Click", OpenConfigMenu)

MainGui.AddText("x215 y60", "Data da receita")
cal_presc_date := MainGui.AddMonthCal("x160 y80")

btn_calc_date := MainGui.AddButton("x200", "Calcular validade")
btn_calc_date.OnEvent("Click", CalculateExpirationDate)

if(config.auto_update){
    CheckUpdates(&github, config_file, A_WorkingDir)
}
MainGui.Show()