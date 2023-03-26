#Requires AutoHotkey v2.0

#SingleInstance Force
SetWorkingDir A_ScriptDir
TraySetIcon("assets\icon.ico")

#Include lib\github.ahk
#Include lib\Native.ahk

version_file := A_MyDocuments "\version_file.ini"


if(FileExist(version_file) == ""){
	IniWrite "0", version_file, "version", A_ScriptName
}

isUpdated(){
    try {
        git := Github("TheBrunoCA", A_ScriptName)
    } catch Error as e {
        if(e.Message == "Item has no value.")
           throw Error("Não foi possível encontrar a pagina do repositorio.")
    }

    installed_version := IniRead(version_file, "version", A_ScriptName, "0")
    
    if(installed_version == 0 || installed_version < git.Version()){
    	Return False
    }
    
    Return True
}

updateScript(){
	git := Github("TheBrunoCA", A_ScriptName)
    
    git.Download(A_ScriptDir "\" A_ScriptName)
    IniWrite git.Version(), version_file, "version", A_ScriptName
    
    reloadScript()
}

checkAndUpdate(){
	if(isUpdated()){
    	Return
    }
    
    updateScript()
}

reloadScript(){
    MsgBox("Reloading", , "t1")
	Reload
}

checkAndUpdate()

mainGui := Gui("+AlwaysOnTop", A_ScriptName)