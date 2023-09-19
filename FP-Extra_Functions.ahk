checkUpdate(){
    if not github.online and not A_IsCompiled
        return

    if VerCompare(VERSION, github.version) >= 0
        return

    updateApp()
}

updateApp(){
    p       := github.DownloadLatest(A_Temp, A_ScriptName)
    batfile := BatWrite(installPath)
    batfile .MoveFile(A_ScriptFullPath, A_Temp "\old_" A_ScriptName)
    batfile .MoveFile(A_Temp "\" A_ScriptName, A_ScriptFullPath)
    batfile .Start(A_ScriptFullPath)
    Run(batfile.path, , "Hide")
    ExitApp() ;TODO: Exitcodes
}