#Requires AutoHotkey v2.0
#SingleInstance Force

;====================================
; KONFIGURACE / DEFAULTY
;====================================

configFile := A_ScriptDir "\travian_farmlist.ini"

; výchozí hodnoty (použijí se, když není config)
baseX   := -1147
baseY   := 1069
spreadX := 100
spreadY := 20

botOn := false

CoordMode "Mouse", "Screen"

;====================================
; NAČTENÍ / ULOŽENÍ KONFIGU Z INI
;====================================

LoadConfig() {
    global baseX, baseY, spreadX, spreadY, configFile

    if !FileExist(configFile)
        return

    try baseX   := IniRead(configFile, "coords", "baseX",   baseX)
    try baseY   := IniRead(configFile, "coords", "baseY",   baseY)
    try spreadX := IniRead(configFile, "coords", "spreadX", spreadX)
    try spreadY := IniRead(configFile, "coords", "spreadY", spreadY)
}

SaveConfig() {
    global baseX, baseY, spreadX, spreadY, configFile

    IniWrite(baseX,   configFile, "coords", "baseX")
    IniWrite(baseY,   configFile, "coords", "baseY")
    IniWrite(spreadX, configFile, "coords", "spreadX")
    IniWrite(spreadY, configFile, "coords", "spreadY")
}

LoadConfig()

;====================================
; GUI PRO NASTAVENÍ SOUŘADNIC
;====================================

ShowConfigGui(startAfterSave := false) {
    global baseX, baseY, spreadX, spreadY

    cfgGui := Gui(, "Nastavit souřadnice")

    cfgGui.Add("Text",, "Základní souřadnice tlačítka (Screen):")

    cfgGui.Add("Text", "xm y+10", "X:")
    xEdit := cfgGui.Add("Edit", "w80 x+5", baseX)

    cfgGui.Add("Text", "xm y+10", "Y:")
    yEdit := cfgGui.Add("Edit", "w80 x+5", baseY)

    cfgGui.Add("Text", "xm y+10", "Rozptyl (±) X:")
    sxEdit := cfgGui.Add("Edit", "w80 x+5", spreadX)

    cfgGui.Add("Text", "xm y+10", "Rozptyl (±) Y:")
    syEdit := cfgGui.Add("Edit", "w80 x+5", spreadY)

    saveBtn  := cfgGui.Add("Button", "xm y+15 w90 Default", "Uložit")
    closeBtn := cfgGui.Add("Button", "x+10 w90", "Zavřít")

    saveBtn.OnEvent("Click", (*) => SaveCoordsFromGui(cfgGui, xEdit, yEdit, sxEdit, syEdit, startAfterSave))
    closeBtn.OnEvent("Click", (*) => cfgGui.Destroy())

    cfgGui.Show()
}

SaveCoordsFromGui(cfgGui, xEdit, yEdit, sxEdit, syEdit, startAfterSave) {
    global baseX, baseY, spreadX, spreadY, botOn

    ; přečíst hodnoty z GUI ( +0 = vynucený převod na číslo)
    baseX   := xEdit.Value + 0
    baseY   := yEdit.Value + 0
    spreadX := sxEdit.Value + 0
    spreadY := syEdit.Value + 0

    SaveConfig()
    cfgGui.Destroy()

    MsgBox "Souřadnice uloženy:" 
        . "`nX = " baseX 
        . "`nY = " baseY 
        . "`nspreadX = ±" spreadX 
        . "`nspreadY = ±" spreadY

    ; pokud máme po uložení rovnou startovat bota → udělej hned první klik
    if (startAfterSave) {
        botOn := true
        ClickFarm()
    }
}

;====================================
; HLAVNÍ OVLÁDÁNÍ (F9)
;====================================

; F9 = zapnout / vypnout bota
F9:: {
    global botOn

    botOn := !botOn

    if (botOn) {
        answer := MsgBox(
        "Travian bot ZAPNUT." 
        . "`n`nChceš teď nastavit souřadnice tlačítka?"
        , "Travian bot"
        , "YesNo 64"
        )

        if (answer = "Yes") {
            ; otevři GUI a po uložení rovnou spusť bota
            ShowConfigGui(true)
        } else {
            ; bez nastavování – hned klikni a rozjeď interval
            ClickFarm()
        }
    } else {
        MsgBox "Travian bot VYPNUT", "Travian bot", "48"
        SetTimer(ClickFarm, 0)  ; vypne timer
        ToolTip()               ; schová případný tooltip
    }
}

;====================================
; INTERVAL 4–6 MINUT
;====================================

SetRandomTimer() {
    ; 240000–360000 ms = 4–6 minut
    delay := Random(240000, 360000)
    SetTimer(ClickFarm, -delay)   ; jednorázový timer
    return delay
}

;====================================
; KLIK FUNKCE
;====================================

ClickFarm(*) {
    global baseX, baseY, spreadX, spreadY, botOn

    ; pokud je mezitím bot vypnutý, nic nedělat
    if (!botOn)
        return

    ; náhodné souřadnice v oblasti tlačítka
    x := baseX + Random(-spreadX, spreadX)
    y := baseY + Random(-spreadY, spreadY)

    ; uložit aktuální pozici myši
    MouseGetPos &oldX, &oldY

    ; přesun na tlačítko a klik
    MouseMove x, y, 10
    Sleep 150
    Click "left"
    Sleep 150

    ; vrátit myš zpátky
    MouseMove oldX, oldY, 10

    ; nastavit další interval a získat delay pro text
    nextDelay := SetRandomTimer()
    nextMins  := Round(nextDelay / 60000.0, 1)

    ; tooltip u kurzoru: kdy kliknul a kdy klikne příště
    ToolTip "Kliknuto na farmlist: " A_Hour ":" A_Min ":" A_Sec "`nDalší klik za cca " nextMins " min"
    ; schovat tooltip za 3 sekundy
    SetTimer(() => ToolTip(), -3000)
}
