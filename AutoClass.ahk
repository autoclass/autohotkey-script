#persistent
#SingleInstance force

#Include Chrome.ahk

ClearFile(FileName)
{
    FileDelete, %FileName%
    FileAppend,, %FileName%
}

SetTitleMatchMode,2

Loop
{

    IfWinNotExist, Google Chrome
        break
    else
    {
        WinActivate, Google Chrome
        SendInput, ^w
    }
    Sleep, 1000
}

Run, chrome.exe "--remote-debugging-port=9222"
Sleep, 3000
PageInst := Chrome.GetPage()
platform := ""

setTimer, checkJoin, 1000
setTimer, checkMute, 1000
setTimer, checkDisconnect, 1000
ClearFile("join.txt")
ClearFile("mute.txt")
ClearFile("leave.txt")
return

FocusWin()
{
    SetTitleMatchMode, 2
    WinActivate, Google Chrome
    return
}

checkJoin:

FileRead, joinContent, join.txt
if(joinContent != "") 
{
    params := StrSplit(joinContent, A_Space)
    platform := params[1]
    link := params[2]
    FocusWin()
    PageInst.Call("Page.navigate", {"url": link}) ; go to desired page
    PageInst.WaitForLoad() ; wait for buttons load and turn off mic and join
    Sleep, 15000
    if(platform == "discord")
    {
        PageInst.Evaluate("document.evaluate('//div[text()=""Čas""]', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null)?.singleNodeValue?.click();")
        Sleep, 1000
        PageInst.Evaluate("document.querySelector('[aria-label=""Mute""][aria-checked=""false""]')?.click();")
    }
    else if(platform == "meet")
    {
        CoordMode, Mouse, Screen
        MouseMove, A_ScreenWidth/2, A_ScreenHeight/2
        Click
        Sleep, 3000
        PageInst.Evaluate("document.querySelectorAll('[data-is-muted=""false""]')?.forEach(e => e.click());")
        PageInst.Evaluate("document.querySelector('[jsaction=""click:cOuCgd; mousedown:UX7yZ; mouseup:lbsD7e; mouseenter:tfO1Yc; mouseleave:JywGue;touchstart:p6p2H; touchmove:FwuNnf; touchend:yfqBxc(preventMouseEvents=true|preventDefault=true); touchcancel:JMtRjd;focus:AHmuwe; blur:O22p3e; contextmenu:mg9Pef;""]')?.click();")
    }
    else if(platform == "teams")
    {
        PageInst.Evaluate("document.querySelector('[track-summary=""Join an ongoing meetup from the channel ongoing meeting object""]')?.click();")
        Sleep, 2000
        PageInst.Evaluate("document.querySelector('[track-summary=""Toggle camera OFF in meeting pre join screen""]')?.click();")
        PageInst.Evaluate("document.querySelector('[track-summary=""Toggle microphone OFF in meeting pre join screen""]')?.click();")
        Sleep, 1000
        PageInst.Evaluate("document.querySelector('[track-summary=""join meeting from pre-join screen""]')?.click();")
    }
    ClearFile("join.txt")
}
return


checkMute:

FileRead, muteContent, mute.txt
if(muteContent != "") 
{
    FocusWin()
    if(platform == "discord")
    {
        if(muteContent == 0)
        {
            PageInst.Evaluate("document.querySelector('[aria-label=""Mute""][aria-checked=""true""]')?.click();")
        }
        else
        {
            PageInst.Evaluate("document.querySelector('[aria-label=""Mute""][aria-checked=""false""]')?.click();")
        }
    }
    else if(platform == "meet")
    {
        if(muteContent == 0)
        {
            PageInst.Evaluate("document.querySelector('body')?.focus();") ; focus so mute button appears
            PageInst.Evaluate("document.querySelector('[jsaction=""rcuQ6b:Xzqvdb;JIbuQc:aokBrd;BKObxc:oU9ek;x1hWwd:Xzqvdb;u5SqHe:u2ulAb;erbPoe:.CLIENT""] > [data-is-muted=""true""]')?.click();")
        }
        else
        {
            PageInst.Evaluate("document.querySelector('body')?.focus();") ; focus so mute ubtton appears
            PageInst.Evaluate("document.querySelector('[jsaction=""rcuQ6b:Xzqvdb;JIbuQc:aokBrd;BKObxc:oU9ek;x1hWwd:Xzqvdb;u5SqHe:u2ulAb;erbPoe:.CLIENT""] > [data-is-muted=""false""]')?.click();")
        }
    }
    else if(platform == "teams")
    {
        if(muteContent == 0)
        {
            PageInst.Evaluate("document.querySelector('[aria-label=""Unmute""]')?.click();")
        }
        else
        {
            PageInst.Evaluate("document.querySelector('[aria-label=""Mute""]')?.click();")
        }
    }
    ClearFile("mute.txt")
}
return

checkDisconnect:

FileRead, disconnectContent, leave.txt
if(disconnectContent != "") 
{
    FocusWin()
    if(platform == "discord")
    {
        PageInst.Evaluate("document.querySelector('[aria-label=""Disconnect""]')?.click();")
    }
    else if(platform == "meet")
    {
        PageInst.Evaluate("document.querySelector('body')?.focus();") ; focus so leave button appears
        PageInst.Evaluate("document.querySelector('[jsname=""CQylAd""]')?.click();")
    }
    else if(platform == "teams")
    {
        PageInst.Evaluate("document.querySelector('[track-summary=""Hang up in unified bar""]')?.click();")
    }
    platform = ""
    ClearFile("leave.txt")
}
return