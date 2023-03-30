timeout /t 2 /nobreak
del A_WorkingDir\app_name\git_hub.GetExtension()
move /y download_path A_WorkingDir

start A_WorkingDir "\" app_name "." git_hub.GetExtension()
timeout /t 2 /nobreak