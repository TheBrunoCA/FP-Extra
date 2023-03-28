; Credit to jim U (https://stackoverflow.com/users/4695439/jim-u)
ArrayToString(strArray)
{
  s := ""
  for i,v in strArray
    s .= "`n" . v
  return substr(s, 3)
}

DownloadToVar(url){
    whr := ComObject("MSXML2.XMLHTTP.6.0")
    whr.Open("GET", url, true)
    whr.Send()
    while(whr.readyState != 4){
        Sleep(100)
    }
    return whr.ResponseText
}

/*
Formats a json into a simple array
@Param json var containing json file
@Return Array
*/
FormatJsonToSimpleArray(json){
    text := StrReplace(json, "{", "")
    text := StrReplace(text, "}", "")
    text := StrReplace(text, " ", "")
    text := StrReplace(text, "`":", "`",")
    text := StrReplace(text, "`"", "")
    text := StrReplace(text, "[", "")
    text := StrReplace(text, "]", "")

    textArray := StrSplit(text, ",", " ")

    return textArray
}

/*
Gets a value from the next element in the first occurence of key.
@Param said_array The array in which to search.
@Param key The Key to search for in the array.
@Param default The default value in case "Key" is not found.
@Return The value from the key, or default if not found.
*/
GetKeyValueFromArray(said_array, key, default := ""){
    loop said_array.Length{
        if(said_array[A_Index] == key){
            return said_array[A_Index+1]
        }
    }
    return default
}

/*
 @Credit samfisherirl (https://github.com/samfisherirl/github.ahk)
*/
Class Git {
    __New(user, repo) {
        this.url := "https://api.github.com/repos/" user "/" repo "/releases/latest"
        this.body := DownloadToVar(this.url)
        this.body := FormatJsonToSimpleArray(this.body)
        this.dl_url := GetKeyValueFromArray(this.body, "browser_download_url")
        this.version := GetKeyValueFromArray(this.body, "tag_name")
        this.extension := StrSplit(this.dl_url, ".")
        this.extension := this.extension[this.extension.Length]
    }
    GetUrl(){
        return this.url
    }
    GetBody(){
        return this.body
    }
    GetDownloadUrl(){
        return this.dl_url
    }
    Download(path_to_save, filename){
        Download(this.dl_url, path_to_save "\" filename "." this.extension)
    }
    GetVersion(){
        return this.version
    }
    GetExtension(){
        return this.extension
    }
}