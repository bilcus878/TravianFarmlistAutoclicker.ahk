# Travian Farmlist AutoClicker (AutoHotkey v2)

Malý AutoHotkey skript, který v Travianu každých 4–6 minut automaticky klikne na tlačítko **„Poslat všechny farmlisty“**.  
Spouští se klávesou **F9** (zap / vyp).

> ⚠️ **Upozornění:** Používání botů je proti pravidlům Travianu. Skript používáš na vlastní riziko (ban účtu apod.).

---

## 1. Požadavky

- Windows
- [AutoHotkey v2](https://www.autohotkey.com/) nainstalovaný v systému

---

## 2. Instalace AutoHotkey

1. Otevři stránku `https://www.autohotkey.com/`.
2. Klikni na **Download** a stáhni verzi pro Windows.
3. Spusť instalátor a zvol:
   - **Express Installation** nebo **Custom** (Standard je ok).
4. Po instalaci by měly mít soubory s příponou `.ahk` ikonku se zeleným **H** a půjdou spustit dvojklikem.

---

## 3. Zjištění souřadnic tlačítka (Window Spy)

Skript kliká na konkrétní souřadnice obrazovky. Proto je potřeba jednou zjistit pozici tlačítka **„Poslat všechny farmlisty“**.

1. Otevři Travian v prohlížeči a okno:
   - nech **maximalizované** a
   - **nehýbej** s ním (souřadnice se vážou na polohu okna).
2. Klikni pravým na nějaký `.ahk` soubor nebo na ikonu AutoHotkey (pokud ji máš) a najdi nástroj **Window Spy**.  
   Často je i v nabídce Start jako **"Window Spy"**.
3. Spusť **Window Spy**.
4. Najdi v Travianu tlačítko **„Poslat všechny farmlisty“**.
5. Najdi si ho myší a sleduj ve Window Spy hodnoty:
   - `Mouse Position` → `Screen` → `X`, `Y`
6. Tyhle hodnoty si poznamenej – to budou tvoje `baseX` a `baseY` ve skriptu.

> Poznámka: Jakmile změníš rozlišení, druhý monitor, nebo polohu/velikost okna, souřadnice už nemusí sedět – pak je potřeba je přeměřit znovu.

---

## 4. Nastavení skriptu

V repozitáři je soubor:

- `travian_farmlist.ahk`

Otevři ho v Poznámkovém bloku nebo jiném editoru a uprav tyto řádky:

```ahk
; Základní poloha tlačítka (tvé souřadnice)
baseX := -1147
baseY := 1069
