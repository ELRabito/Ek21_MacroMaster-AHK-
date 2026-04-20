; ##########################################
; ##########################################
; MACROPAD MASTER SCRIPT - ULTRA EDITION (v2.1)
; Modifiers: Shift (via VIA), F23 (Phys.), F24 (Phys.)
; ##########################################
; ##########################################

#Requires AutoHotkey v2.0
InstallKeybdHook
SetTitleMatchMode 2
#UseHook

; --- DEFINES ---
global margin := 7
global taskbarHeight := 40 
global guiWidth := 220

; --- HUD INIT ---
HUD := Gui("+AlwaysOnTop -Caption +ToolWindow")
HUD.SetFont("s10 w700 cWhite", "Segoe UI")
HUDText := HUD.Add("Text", "Center w220", "")

; Modifier HUD
ShowHUD(txt, color) {
    xPos := (A_ScreenWidth / 2) - (guiWidth / 2)
    HUD.BackColor := color
    HUDText.Value := txt
    HUD.Show("x" xPos " y0 w" guiWidth " NoActivate")
}

; Feedback HUD
FlashHUD(txt, color) {
    xPos := (A_ScreenWidth / 2) - (guiWidth / 2)
    HUD.BackColor := color
    HUDText.Value := txt
    HUD.Show("x" xPos " y0 w" guiWidth " NoActivate")
    SetTimer () => HUD.Hide(), -1000 
}

; ##########################################
; LAYER 1: NORMAL (Halves & Maximize)
; ##########################################

; Shift + F13: Snap LEFT Half
$+F13::
{
    halfW := A_ScreenWidth / 2
    WinRestore "A"
    WinMove -margin, 0, halfW + (2 * margin), A_ScreenHeight - taskbarHeight, "A"
    FlashHUD("SNAP: LEFT HALF", "2D2D2D")
}

; Shift + F14: Maximize Window
$+F14::
{
    WinMaximize "A"
    FlashHUD("WINDOW: MAXIMIZED", "2D2D2D")
}

; Shift + F15: Snap RIGHT Half
$+F15::
{
    halfW := A_ScreenWidth / 2
    WinRestore "A"
    WinMove halfW - margin, 0, halfW + (2 * margin), A_ScreenHeight - taskbarHeight, "A"
    FlashHUD("SNAP: RIGHT HALF", "2D2D2D")
}

; Shift + F16: Transparency Toggle
$+F16::
{
    try {
        currentTrans := WinGetTransparent("A")
        newTrans := (currentTrans = 128) ? 255 : 128
        WinSetTransparent newTrans, "A"
        FlashHUD("GHOST MODE: " . (newTrans = 128 ? "ON" : "OFF"), "4B0082")
    } catch {
        WinSetTransparent 128, "A"
        FlashHUD("GHOST MODE: ON", "4B0082")
    }
}

; Shift + F17: Smart Close
$+F17::
{
    activeProcess := WinGetProcessName("A")
    FlashHUD("Closed", "8B0000")
    if (activeProcess ~= "i)firefox.exe|notepad\+\+\.exe|chrome.exe")
        Send "^w"
    else if (activeProcess = "Explorer.EXE")
        Send "!{F4}"
    else
        WinClose "A"
}

; --- F18: Smart foobar2000
$+F18::
{
    FlashHUD("APP: FOOBAR2000", "2E8B57")
    if WinExist("ahk_exe foobar2000.exe") {
        WinActivate
    } else {
        Run "foobar2000.exe"
        if WinWait("ahk_exe foobar2000.exe", , 2) {
            WinRestore "ahk_exe foobar2000.exe"
            targetW := A_ScreenWidth * 0.50
            targetH := A_ScreenHeight * 0.50
            posX := (A_ScreenWidth - targetW) / 2
            posY := (A_ScreenHeight - targetH - taskbarHeight) / 2
            
            WinMove posX, posY, targetW, targetH, "ahk_exe foobar2000.exe"
        }
    }
}
; Shift + F19: Smart Explorer
$+F19::
{
    FlashHUD("APP: EXPLORER", "0078D7")
    if WinExist("ahk_class CabinetWClass")
        WinActivate
    else
        Run "explorer.exe"
}

; Shift + F20: Smart Firefox
$+F20::
{
    FlashHUD("APP: FIREFOX", "E66000")
    if WinExist("ahk_exe firefox.exe")
        WinActivate
    else
        Run "firefox.exe"
}

; Shift + F21: Smart Downloads
$+F21::
{
    FlashHUD("FOLDER: DOWNLOADS", "0078D7")
    if WinExist("Downloads ahk_class CabinetWClass")
        WinActivate
    else
        Run "explorer.exe shell:Downloads"
}

; ##########################################
; LAYER 2: F23-MODIFIER (Thirds-Splits)
; ##########################################

#HotIf GetKeyState("F23", "P")

$+F13:: ; Snap LEFT Third
{
    thirdW := A_ScreenWidth / 3
    WinRestore "A"
    WinMove -margin, 0, thirdW + (2 * margin), A_ScreenHeight - taskbarHeight, "A"
    FlashHUD("SNAP: LEFT THIRD", "005A9E")
}

$+F14:: ; Snap CENTER Third
{
    thirdW := A_ScreenWidth / 3
    WinRestore "A"
    WinMove thirdW - margin, 0, thirdW + (2 * margin), A_ScreenHeight - taskbarHeight, "A"
    FlashHUD("SNAP: CENTER THIRD", "005A9E")
}

$+F15:: ; Snap RIGHT Third
{
    thirdW := A_ScreenWidth / 3
    WinRestore "A"
    WinMove (2 * thirdW) - margin, 0, thirdW + (2 * margin), A_ScreenHeight - taskbarHeight, "A"
    FlashHUD("SNAP: RIGHT THIRD", "005A9E")
}

$+F16:: ; Smart Search
{
    A_Clipboard := ""
    Send "^c"
    if ClipWait(1) {
        searchQuery := StrReplace(A_Clipboard, " ", "+")
        FlashHUD("SEARCH: GOOGLE", "4285F4")
        Run "firefox.exe https://www.google.com/search?q=" . searchQuery
    }
}

$+F17:: ; Filter Explorer (Current Window Priority)
{
    A_Clipboard := ""
    Send "^c"
    ClipWait(0.5)

    if WinExist("ahk_class CabinetWClass") 
    {
        WinActivate "ahk_class CabinetWClass"
        if WinWaitActive("ahk_class CabinetWClass", , 1) {
            Send "{f3}"
            Sleep 200 
            Send "^a{BackSpace}"
            Sleep 100
            if (A_Clipboard != "") {
                Send "^v{Enter}"
                FlashHUD("FILTERING CURRENT WINDOW", "0078D7")
            } else {
                FlashHUD("SEARCH MODE", "0078D7")
            }
        }
    } 
    else 
    {
        Run "explorer.exe"
        if WinWaitActive("ahk_class CabinetWClass", , 2) {
            Sleep 300
            Send "{f3}"
            Sleep 100
            Send "^a{BackSpace}"
            Sleep 50
            if (A_Clipboard != "") {
                Send "^v{Enter}"
                FlashHUD("OPEN & FILTER", "0078D7")
            }
        }
    }
}

$+F18:: ; Smart YouTube
{
    FlashHUD("APP: YOUTUBE", "FF0000")
    if WinExist("YouTube")
        WinActivate
    else
        Run "firefox.exe https://www.youtube.com"
}

; 3 Keys left

#HotIf

; ##########################################
; LAYER 3: F24-MODIFIER
; ##########################################

#HotIf GetKeyState("F24", "P")

$+F13:: ; Center Large (75% of screen)
{
    w := A_ScreenWidth * 0.75
    h := A_ScreenHeight * 0.75
    WinRestore "A"
    WinMove (A_ScreenWidth-w)/2, (A_ScreenHeight-h)/2, w, h, "A"
    FlashHUD("MODE: CENTER 75%", "D4A017")
}

$+F14:: ; Focus Mode (90% of screen)
{
    w := A_ScreenWidth * 0.90
    h := A_ScreenHeight * 0.90
    WinRestore "A"
    WinMove (A_ScreenWidth-w)/2, (A_ScreenHeight-h)/2, w, h, "A"
    FlashHUD("MODE: FOCUS 90%", "D4A017")
}

$+F15:: ; PiP Toggle
{
    pipW := A_ScreenWidth * 0.25
    pipH := A_ScreenHeight * 0.25
    ExStyle := WinGetExStyle("A")
    if (ExStyle & 0x8) {
        WinSetAlwaysOnTop 0, "A"
        WinMaximize "A" 
        FlashHUD("PiP: OFF", "D4A017")
    } else {
        WinRestore "A"
        WinSetAlwaysOnTop 1, "A"
        WinMove A_ScreenWidth-pipW, A_ScreenHeight-pipH-taskbarHeight, pipW, pipH, "A"
        FlashHUD("PiP: ON", "D4A017")
    }
}

$+F16:: ; Smart Explorer - ARMA
{
    FlashHUD("FOLDER: ARMA PROJECT", "7B904B")
    if WinExist("Arma ahk_class CabinetWClass")
        WinActivate
    else
        Run 'explorer.exe "G:\Arma"'
}

$+F17:: ; Same-App-Hopper
{
    activeProc := WinGetProcessName("A")
    FlashHUD("HOP: " . activeProc, "D4A017")
    searchTarget := (activeProc = "Explorer.EXE") ? "ahk_class CabinetWClass" : "ahk_exe " activeProc
    ids := WinGetList(searchTarget)
    if (ids.Length > 1) {
        WinMoveBottom("A")
        for id in ids {
            if (id = ids[1])
                continue
            if (WinGetStyle("ahk_id " id) & 0x10000000) {
                WinActivate("ahk_id " id)
                break
            }
        }
    }
}

$+F18:: ; Copy Current Explorer Path
{
    if WinActive("ahk_class CabinetWClass") {
        Send "^l"
        Sleep 50
        Send "^c"
        Sleep 50
        Send "{Esc}"
        FlashHUD("PATH COPIED", "0078D7")
    }
}

; 3 Keys left

#HotIf

; ##########################################
; HELPERS & MODIFIER HUD
; ##########################################

*F23::
{
    ShowHUD("LAYER 2: THIRDS", "005A9E")
    KeyWait "F23"
    HUD.Hide()
}

*F24::
{
    ShowHUD("LAYER 3: POWER", "D4A017")
    KeyWait "F24"
    HUD.Hide()
}
