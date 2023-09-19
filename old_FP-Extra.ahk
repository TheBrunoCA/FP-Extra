#Requires AutoHotkey v2.0
#SingleInstance Force

; Includes
#Include ..\libraries\Github-Updater.ahk\github-updater.ahk
#Include ..\libraries\Bruno-Functions\bruno-functions.ahk
#Include ..\libraries\Bruno-Functions\IsOnline.ahk

#Include FP-Extra-Config.ahk

if FileExist(update_file) != ""{
    updated := true
    update_message := FileRead(update_file)
    FileDelete(update_file)
}

OpenConfigMenu(p_arg*) {
    config_gui.Show()
}

CalculateExpirationDate(p_arg*) {
    presc_date := cal_presc_date.Value
    if reset_cal
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

; Main user interface
main_gui := Gui("-MaximizeBox +OwnDialogs", git_repo " v-" version)

main_gui.SetFont("s20", "Consolas")
main_gui.AddText("Center", git_repo " por " git_user)

main_gui.SetFont("s10")

btn_config := main_gui.AddButton("xm", "Configurações")
btn_config.OnEvent("Click", OpenConfigMenu)

main_gui.AddText("x215 y60", "Data da receita")
cal_presc_date := main_gui.AddMonthCal("x160 y80")

btn_calc_date := main_gui.AddButton("x200", "Calcular validade")
btn_calc_date.OnEvent("Click", CalculateExpirationDate)

main_gui.Show()

If updated
    MsgBox(update_message, git_repo " Atualizado para v-" github.version)