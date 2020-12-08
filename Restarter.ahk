#persistent
#SingleInstance force

ClearFile(FileName)
{
    FileDelete, %FileName%
    FileAppend,, %FileName%
}

ClearFile("reset.txt")
setTimer, checkReset, 1000
return

checkReset:
FileRead, resetContent, reset.txt
if(resetContent != "") 
{
    Run, AutoClass.exe
    ClearFile("reset.txt")
}
return