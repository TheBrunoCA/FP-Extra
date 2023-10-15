#Requires AutoHotkey v2.0
#Warn All, StdOut

#Include ..\GithubReleases\GitHubReleases2.ahk
#Include ..\Bruno-Functions\IniClass.ahk
#Include ..\Bruno-Functions\GreatGui.ahk

global lg := Logfy(Paths.LOG_FILE)

MainGui()

Class Constants{
    static USER := "TheBrunoCA"
    static REPO := "FP-Extra"
    static VERSION := "1.0.0"
}

Class Paths{
    static INSTALL_DIR := NewDir(Format("{1}\{2}\{3}", A_AppData, Constants.USER, Constants.REPO))
    static INSTALL_FULL_PATH := Format("{1}\{2}", Paths.INSTALL_DIR, A_ScriptName)
    static IMAGES_DIR := NewDir(Format("{1}\{2}", Paths.INSTALL_DIR, "Images"))
    static CONFIG_INI := Format("{1}\{2}", Paths.INSTALL_DIR, "config.ini")
    static LOG_FILE := Format("{1}\{2}", Paths.INSTALL_DIR, "log.txt")
}

Class IniSections{
    static CONFIG := "CONFIG"
}

Class IniKeys{
    static EXPIRATION_DAYS := "EXPIRATION_DAYS"
}

Class Defaults{
    static EXPIRATION_DAYS := 179
}

Class Configuration{
    static config_ini := IniClass(Paths.CONFIG_INI)
    static expiration_days := Configuration.config_ini.GetValue(
        IniSections.CONFIG
        , IniKeys.EXPIRATION_DAYS
        , Defaults.EXPIRATION_DAYS
    )

    static Reload(){
        Configuration.expiration_days := Configuration.config_ini.GetValue(
            IniSections.CONFIG
            ,IniKeys.EXPIRATION_DAYS
            ,Defaults.EXPIRATION_DAYS
        )
        lg.Log(Format("{1} on {2} Successfully reloaded the configurations.", A_ThisFunc, Constants.REPO))
        return true
    }

    static Set(IniSection, IniKey, new_value){
        Configuration.config_ini.SetValue(IniSection, IniKey, new_value)
        lg.Log(Format("{1} on {2} Successfully set {3} to {4}-{5}."
        , A_ThisFunc, Constants.REPO, new_value, IniSection, IniKey))

        return new_value
    }
}

MainGui(*){
    main_gui := GreatGui()
    main_gui.OnEvent("Close", (*) => ExitApp())
    main_gui.Title := Format("{1} - Version: {2}", Constants.REPO, Constants.VERSION)

    main_gui.SetFont("S12")
    main_gui.AddText("xm", "Insira a data da receita ou escolha no calendário.")
    date_cal := main_gui.AddDateTime()
    calc_expiration := main_gui.AddButton("xm", "Calcular validade.")
    calc_expiration.OnEvent("Click", _OnCalcExpiration)
    calc_days_to_expire := main_gui.AddButton("xm", "Calcular dias restantes.")
    calc_days_to_expire.OnEvent("Click", _OnCalcDaysToExpire)
    calc_times_to_expire := main_gui.AddButton("xm", "Calcular quantas vezes resta.")
    calc_times_to_expire.OnEvent("Click", _OnCalcTimesToExpire)


    main_gui.Show()

    _OnCalcExpiration(*){
        local new_date := DateAdd(date_cal.Value, Configuration.expiration_days, "Days")
        local msg := "Receita válida até: {1}."
        if new_date < (A_Now - A_Sec){
            msg := "A receita já está vencida.`nEra válida até {1}"
        }
        local new_date := Format(FormatTime(new_date, "dddd, dd {1} MMMM {1} yyyy"), "de")
        msg := Format(msg, new_date)
        MsgBox(msg)
    }

    _OnCalcDaysToExpire(*){
        local msg := "A validade restante é de {1} dias, incluindo hoje."
        if DateAdd(date_cal.Value, Configuration.expiration_days, "Days") < (A_Now - 60)
            msg := "A receita já está vencida à {1} dias, incluindo hoje."
        msg := Format(msg, Abs(DateDiff(DateAdd(date_cal.Value, Configuration.expiration_days +1, "Days"), A_Now, "Days")))
        MsgBox(msg)
    }

    _OnCalcTimesToExpire(*){
        local msg := "Se considerar como hoje tendo já passado, é possível pegar mais {1} vezes, sendo:`n{2}."
        local expire_date := DateAdd(date_cal.Value, Configuration.expiration_days, "Days")
        local days_to_expire := DateDiff(expire_date, A_Now, "Days")
        local times_left := Floor(days_to_expire/30)
        local days := ""
        loop times_left{
            days .= "`n" Format(FormatTime(DateAdd(A_Now, 30*A_Index, "Days"), "dddd, dd {1} MMMM {1} yyyy"), "de")
        }
        if times_left <= 0{
            msg := "Se considerar como hoje tendo já passado, não é possível pegar mais."
            if DateAdd(date_cal.Value, Configuration.expiration_days, "Days") < (A_Now - 60)
                msg := "A receita já está vencida."
        }
        msg := Format(msg, times_left, days)
        MsgBox(msg)
    }

}