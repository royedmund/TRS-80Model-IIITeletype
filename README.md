# TRS-80 Model III Teletype

A minimal teletype screen simulator for **TRS-80 Model III (48K)**, using George Phillips' TRS80GP 2.5.8 for testing. The program has a fast local screen-test mode and an experimental real RS-232 mode.

## Which BASIC version?

- **[TELETYPE.BAS](TELETYPE.BAS)** — v1.1, **Radio Shack Model III ROM BASIC** (the screen with `Cass?` and `Memory Size?`)
- **[TELEDOS.BAS](TELEDOS.BAS)** — v1.1, **TRSDOS Disk BASIC** with `DEFUSR0`
- **[TELETYPE.ASM](TELETYPE.ASM)** — early native Z80 draft, not yet compiled or tested as a `/CMD` executable

## Startup

The only required mode selection is:

- **1 / Enter** — local screen test (default)
- **2** — real RS-232 (experimental)

**Local screen test** performs no UART I/O, no baud-rate selection, no baud delay, and no sound. Each keypress prints one character via a single `POKE` and moves the printhead. The goal is to validate screen behaviour first.

**Real RS-232** then offers **9600 baud (default)** or **300 baud**, both 8N1. It waits for remote echo to display typed characters; BASIC polling at 9600 may drop characters. Real serial wiring and emulator configuration still require testing.

**Half/full duplex selection** will be a future startup option, not part of v1.1.

## Screen

After the startup menu, the display is cleared and **has no header or status bar**:

- Printed paper occupies **rows 0–14**, the entire 64-column width
- Printhead `^` moves across **row 15**
- Every line feed moves paper one row up; old lines reach **the very top** before disappearing
- Enter feeds paper; wrapping at 64 columns also feeds
- Backspace erases the previous character on the current line
- Ctrl-] exits the program

To address the earlier post-Enter issue, local line feed now uses a normal `GOSUB 700` / `RETURN` so keyboard processing resumes.

## Paper-feed performance: optional 33-byte Z80 routine

For a fast paper feed, reserve high memory at startup in the **48K** Model III:

```text
Cass?             [Enter]
Memory Size? 61439
```

This limits BASIC's available RAM to `EFFFh` and protects the machine-code routine installed at `F000h`. The program checks the BASIC memory limit and only installs the routine when it equals 61439. It then uses Z80 `LDIR` to move the 14 visible historical paper lines up and clear the active row. The routine preserves AF, BC, DE, and HL.

If you simply press Enter at `Memory Size?`, the program uses a pure BASIC `PEEK`/`POKE` scrolling fallback. Printing individual characters still remains unthrottled; however, **each Enter may be noticeably slower** in that fallback mode.

The ROM BASIC version calls `USR(0)`; the Disk BASIC version uses `DEFUSR0` and `USR0(0)`. Do not exchange these versions.

## Testing notes

v1.1 has been reviewed statically and committed, but **not yet run in TRS80GP or on the real Model III**. Please test in local mode, including a few Enters, and report any BASIC error or line number. If the emulated BASIC interpreter is still dropping rapid keystrokes, moving keyboard polling into machine code will be the next performance step.

## References

- User-provided *TRSDOS & Disk BASIC Reference Manual*, sections 7-16 and 7-24–7-29 (`DEFUSR`, `USRn` and machine-code examples)
- [TRS-80 RAM addresses and BASIC vectors](https://www.trs-80.com/main-internal-ram-addresses-and-routines.htm)
