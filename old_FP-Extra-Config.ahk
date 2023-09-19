A_AppName := GetAppName()
git_user := "TheBrunoCA"
git_repo := A_AppName
dir_path := NewDir(A_AppDataCommon . "\" . git_user . "\" . git_repo)
config_file := NewIni(dir_path "\config.ini")
icon_path := dir_path "\icon.ico"
icon_url := "https://drive.google.com/uc?export=download&id=1xNRHV5RBpoEbag6-m5r5ry6y8zy1ZMLV"
github := Git(git_user, git_repo)
update_file := A_Temp "\" git_repo "-Updated.txt"
updated := false
update_message := ""

;Config
version := IniRead(config_file, "config", "version", "0.122")
auto_update := IniRead(config_file, "config", "auto update", true)
expiration_date := IniRead(config_file, "config", "expiration date", 179)
reset_cal := IniRead(config_file, "config", "reset calendar", true)

; Config screen
config_gui := Gui("-MaximizeBox +OwnDialogs", "Configurações")
config_gui.SetFont("s20", "Consolas")
config_gui.AddText("Center", "Configurações")
config_gui.SetFont("s10")

config_gui.AddText("xm y70", "Resetar calendario")
ckb_reset_cal := config_gui.AddCheckbox("x170 y70")
ckb_reset_cal.Value := true

LoadIcon(){
    if FileExist(icon_path) == ""{
        if IsOnline() == false
            return
        Download icon_url, icon_path
    }
    TraySetIcon icon_path
}