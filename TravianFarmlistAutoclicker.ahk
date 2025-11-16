#Requires AutoHotkey v2.0
#SingleInstance Force

; Základní poloha tlačítka (tvé souřadnice)
baseX := -1147
baseY := 1069

; Rozsah klikání kolem tlačítka
spreadX := 100     ; ±100 px do stran
spreadY := 20      ; ±20 px nahoru/dolů

botOn := false

CoordMode "Mouse", "Screen"

; F9 = zapnout / vypnout bota
F9:: {
    global botOn

    botOn := !botOn

    if (botOn) {
        MsgBox "Travian bot ZAPNUT`n(F9 = vypnout)", "Travian bot", "64"
        ; první klik hned po zapnutí (a uvnitř se nastaví další interval)
        ClickFarm()
    } else {
        MsgBox "Travian bot VYPNUT", "Travian bot", "48"
        SetTimer(ClickFarm, 0)  ; vypne timer
        ToolTip()               ; schová případný tooltip
    }
}

; Interval 4–6 minut – jen nastaví timer a vrátí delay
SetRandomTimer() {
    ; 240000–360000 ms = 4–6 minut
    delay := Random(240000, 360000)
    SetTimer(ClickFarm, -delay)   ; jednorázový timer
    return delay
}

; Funkce pro klik na tlačítko
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
