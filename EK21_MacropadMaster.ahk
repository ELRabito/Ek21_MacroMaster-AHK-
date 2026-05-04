; ##########################################
; ##########################################
; MACROPAD MASTER SCRIPT - ULTRA EDITION (v2.3)
; Modifiers: Shift (via VIA), F23 (Phys.), F24 (Phys.)
; ##########################################
; ##########################################

global margin := 7
global taskbarHeight := 40
#Requires AutoHotkey v2.0
InstallKeybdHook
SetTitleMatchMode 2
#UseHook

; ##########################################
; HUD SYSTEM - OCD PRECISION EDITION (v2.4)
; ##########################################

global HUD := Gui("+AlwaysOnTop -Caption +ToolWindow")
HUD.SetFont("s12 w700 cWhite", "Bahnschrift")
global HUDText := HUD.Add("Text", "Center -Wrap", "") 
global isFlashing := false
global padding := 60

; --- OVERLAY SYSTEM ---
global Overlay := Gui("+AlwaysOnTop -Caption +ToolWindow")
try {
    Overlay.Add("Picture", "w800 h-1", "Macro_Cheatsheet.png") 
} catch {
    Overlay.BackColor := "1A1A1A"
    Overlay.SetFont("s18 w700 cWhite", "Bahnschrift")
    Overlay.Add("Text", "Center w600", "Macro_Cheatsheet.png missing!")
    
    Overlay.SetFont("s11 w400 cAAAAAA")
    Overlay.Add("Text", "Center w600", "`nPlace a file named 'Macro_Cheatsheet.png' in your Autohotkey script/compiled exe folder`nto display your custom keymap here.`n")

    Overlay.Add("Text", "h10", "") 
}

UpdateHUD(txt, color, tColor := "Black") {
    global HUD, HUDText, padding
    tempGui := Gui()
    tempGui.SetFont("s12 w700", "Bahnschrift")
    tempText := tempGui.Add("Text", "", txt)
    tempText.GetPos(,, &tw)
    tempGui.Destroy()
    newWidth := tw + padding
    xPos := (A_ScreenWidth / 2) - (newWidth / 2)
    HUD.BackColor := color
    HUDText.Opt("c" . tColor . " +Center")
    HUDText.Value := txt
    HUDText.Move(0, 3, newWidth, 24)
    HUD.Opt("+AlwaysOnTop") 
    HUD.Show("x" xPos " y0 w" newWidth " h28 NoActivate")
    WinSetAlwaysOnTop 1, "ahk_id " HUD.Hwnd
}

ShowHUD(txt, color) {
    if (isFlashing)
        return
    UpdateHUD(txt, color)
}

FlashHUD(txt, color) {
    global isFlashing := true 
    UpdateHUD(txt, color)
    SetTimer(HideFlash, -1000) 
}

HideFlash() {
    global isFlashing, HUD
    isFlashing := false
    HUD.Hide()
}

; ##########################################
; LAYER 1: NORMAL
; ##########################################

$+F13:: {
    halfW := A_ScreenWidth / 2
    WinRestore "A"
    WinMove -margin, 0, halfW + (2 * margin), A_ScreenHeight - taskbarHeight, "A"
    FlashHUD("SNAP: LEFT HALF", "00cc33")
}

$+F14:: {
    WinMaximize "A"
    FlashHUD("WINDOW: MAXIMIZED", "00cc33")
}

$+F15:: {
    halfW := A_ScreenWidth / 2
    WinRestore "A"
    WinMove halfW - margin, 0, halfW + (2 * margin), A_ScreenHeight - taskbarHeight, "A"
    FlashHUD("SNAP: RIGHT HALF", "00cc33")
}

$+F16:: {
    try {
        currentTrans := WinGetTransparent("A")
        newTrans := (currentTrans = 128) ? 255 : 128
        WinSetTransparent newTrans, "A"
        FlashHUD("GHOST MODE: " . (newTrans = 128 ? "ON" : "OFF"), "9966FF")
    } catch {
        WinSetTransparent 128, "A"
        FlashHUD("GHOST MODE: ON", "9966FF")
    }
}

$+F17:: {
    activeProcess := WinGetProcessName("A")
    FlashHUD("Closed", "8B0000")
    if (activeProcess ~= "i)firefox.exe|notepad\+\+\.exe|chrome.exe")
        Send "^w"
    else if (activeProcess = "Explorer.EXE")
        Send "!{F4}"
    else
        WinClose "A"
}

$+F18:: {
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

$+F19:: {
    ids := WinGetList("ahk_class CabinetWClass")
    count := ids.Length
    if (count == 0) {
        Run "explorer.exe"
        FlashHUD("EXPLORER: START", "00cc33")
    }
    else if (count == 1) {
        WinActivate("ahk_id " ids[1])
        Run "explorer.exe"
        if WinWait("ahk_class CabinetWClass", , 2) {
            Sleep 150
            newIds := WinGetList("ahk_class CabinetWClass")
            WinRestore("ahk_id " newIds[1])
            WinMove(-margin, 0, (A_ScreenWidth/2) + (2*margin), A_ScreenHeight - taskbarHeight, "ahk_id " newIds[1])
            WinActivate("ahk_id " newIds[1])
            WinRestore("ahk_id " newIds[2])
            WinMove((A_ScreenWidth/2) - margin, 0, (A_ScreenWidth/2) + (2*margin), A_ScreenHeight - taskbarHeight, "ahk_id " newIds[2])
            WinActivate("ahk_id " newIds[2])
            FlashHUD("EXPLORER: 50/50 SNAP", "00cc33")
        }
    }
    else {
        if (count == 2) {
            Run "explorer.exe"
            WinWait("ahk_class CabinetWClass", , 2)
            Sleep 150
        }
        finalIds := WinGetList("ahk_class CabinetWClass")
        tw := A_ScreenWidth / 3
        loop Min(finalIds.Length, 3) {
            currentId := finalIds[A_Index]
            WinRestore("ahk_id " currentId)
            posX := ((A_Index - 1) * tw) - margin
            WinMove(posX, 0, tw + (2*margin), A_ScreenHeight - taskbarHeight, "ahk_id " currentId)
            WinActivate("ahk_id " currentId)
        }
        FlashHUD("EXPLORER: TRIPLE TILE", "00cc33")
    }
}

$+F20:: {
    A_Clipboard := ""
    Send "^c"
    if ClipWait(0.25) {
        searchQuery := StrReplace(A_Clipboard, " ", "+")
        FlashHUD("SEARCH: GOOGLE", "4285F4")
        Run "firefox.exe https://www.google.com/search?q=" . searchQuery
    } 
    else {
        FlashHUD("NO SELECTION", "8B0000")
    }
}

$+F21:: {
    FlashHUD("FOLDER: DOWNLOADS", "0078D7")
    if WinExist("Downloads ahk_class CabinetWClass")
        WinActivate
    else
        Run "explorer.exe shell:Downloads"
}

; ##########################################
; LAYER 2: F23-MODIFIER
; ##########################################

#HotIf GetKeyState("F23", "P")

$+F13:: {
    thirdW := A_ScreenWidth / 3
    WinRestore "A"
    WinMove -margin, 0, thirdW + (2 * margin), A_ScreenHeight - taskbarHeight, "A"
    FlashHUD("SNAP: LEFT THIRD", "005A9E")
}

$+F14:: {
    thirdW := A_ScreenWidth / 3
    WinRestore "A"
    WinMove thirdW - margin, 0, thirdW + (2 * margin), A_ScreenHeight - taskbarHeight, "A"
    FlashHUD("SNAP: CENTER THIRD", "005A9E")
}

$+F15:: {
    thirdW := A_ScreenWidth / 3
    WinRestore "A"
    WinMove (2 * thirdW) - margin, 0, thirdW + (2 * margin), A_ScreenHeight - taskbarHeight, "A"
    FlashHUD("SNAP: RIGHT THIRD", "005A9E")
}

$+F16:: {
    A_Clipboard := ""
    Send "^c"
    ClipWait(0.5)
    if WinExist("ahk_class CabinetWClass") {
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
    } else {
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

$+F17:: {
    FlashHUD("FOLDER: MUSIC", "7B904B")
    if WinExist("Musik ahk_class CabinetWClass") || WinExist("Music ahk_class CabinetWClass")
        WinActivate
    else 
        Run "explorer.exe shell:My Music"
}

$+F18:: {
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

$+F19:: {
    if WinActive("ahk_class CabinetWClass") {
        Send "^l"
        Sleep 50
        Send "^c"
        Sleep 50
        Send "{Esc}"
        FlashHUD("PATH COPIED", "0078D7")
    } else {
        FlashHUD("NO EXPLORER FOCUSED", "8B0000")
    }
}

$+F20:: FlashHUD("EMPTY", "8B0000")
$+F21:: FlashHUD("EMPTY", "8B0000")

#HotIf

; ##########################################
; LAYER 3: F24-MODIFIER
; ##########################################

#HotIf GetKeyState("F24", "P")

$+F13:: {
    w := A_ScreenWidth * 0.75
    h := A_ScreenHeight * 0.75
    WinRestore "A"
    WinMove (A_ScreenWidth-w)/2, (A_ScreenHeight-h)/2, w, h, "A"
    FlashHUD("MODE: CENTER 75%", "D4A017")
}

$+F14:: {
    w := A_ScreenWidth * 0.90
    h := A_ScreenHeight * 0.90
    WinRestore "A"
    WinMove (A_ScreenWidth-w)/2, (A_ScreenHeight-h)/2, w, h, "A"
    FlashHUD("MODE: FOCUS 90%", "D4A017")
}

$+F15:: {
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

$+F16:: FlashHUD("EMPTY", "8B0000")
$+F17:: FlashHUD("EMPTY", "8B0000")
$+F18:: FlashHUD("EMPTY", "8B0000")
$+F19:: FlashHUD("EMPTY", "8B0000")
$+F20:: FlashHUD("EMPTY", "8B0000")
$+F21:: FlashHUD("EMPTY", "8B0000")

#HotIf

; ##########################################
; HELPERS & MODIFIER
; ##########################################

; COMBO: F23 + F24 -> Macro Overview
~F23 & F24::
{
    UpdateHUD("CHEATSHEET", "00CC33") 
    Overlay.Show()
    while (GetKeyState("F23", "P") && GetKeyState("F24", "P"))
    {
        Sleep 20
    }
    
    Overlay.Hide()
    HUD.Hide()
}

; Modifier 1 (Layer 2)
~*F23::
{
    Sleep 70 
    if GetKeyState("F24", "P")
        return
    
    ShowHUD("LAYER 2", "005A9E")
    KeyWait "F23"
    if (!isFlashing)
        HUD.Hide()
}

; Modifier 2 (Layer 3)
~*F24::
{
    Sleep 70
    if GetKeyState("F23", "P")
        return
        
    ShowHUD("LAYER 3", "D4A017")
    KeyWait "F24"
    if (!isFlashing)
        HUD.Hide()
}
