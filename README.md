# TRS-80 Model III Teletype

A TRS-80 Model III teletype paper/printhead simulator and experimental RS-232 terminal in TRSDOS Disk BASIC. Designed for a 48 KB Model III and testing in George Phillips' TRS80GP 2.5.8.

## Source

- [TELETYPE.BAS](TELETYPE.BAS) — **v0.8**, optimised display and machine-code paper scrolling
- [TELETYPE.ASM](TELETYPE.ASM) — separate early native Z80 terminal draft, not yet compiled or validated as a `/CMD` executable

## IMPORTANT: reserve memory before running v0.8

The BASIC program installs a **25-byte Z80 paper-feed routine at F000h (decimal 61440)**. Starting TRSDOS Disk BASIC, respond to the prompts as follows:

```text
DOS READY
BASIC
HOW MANY FILES? 0
MEMORY SIZE? 61439
```

Use a 48 KB Model III. When the BASIC prompt appears, load the program and `RUN`. Use `RUN "TELETYPE/BAS"` if the BASIC-format file has been saved to disk.

**Why this matters:** BASIC must not use the machine-code memory area. The program checks its high-memory limit and refuses to run if the required space was not reserved. If you have already started BASIC without this setting, leave BASIC, then restart it with `MEMORY SIZE? 61439`.

Technical notes: `DEFUSR0=-4096` specifies F000h as a signed address; BASIC uses `POKE -4096+I,D` to install the code. The program calls `Z=USR0(0)` when feeding paper. The included Z80 bytes do one 576-byte `LDIR` (screen rows 4–12 onto rows 3–11), then clear the bottom paper row using an additional 63-byte `LDIR` after planting one blank character. The machine routine returns with `RET`. It does not access serial or cassette ports.

## Startup options

The **first menu** offers:

- **1 / Enter:** fast local software loopback (default)
- **2:** real RS-232 serial port (experimental)

**Local mode:** echoes keystrokes directly into the moving-printhead display. It has **no baud-rate setting or artificial delay** and never accesses the RS-232 hardware.

**Real RS-232 mode** displays a second menu:

- **1 / Enter:** 9600 baud (default)
- **2:** 300 baud

Both real rates use **8 data bits, no parity, 1 stop bit (8N1)**. The UART setup accesses the TRS-80 Model III's serial ports; real mode expects **remote echo** and prints received bytes only. The BASIC interpreter may drop incoming characters at 9600 baud; start hardware testing at 300 baud.

**Half/full duplex:** planned as an additional startup option in a future version; it is **not yet implemented**.

## Screen behaviour

- Full 64 columns; no paper-side borders.
- Rows 3–12 are the paper; row 13 carries a small `^` printhead position marker.
- Each printable byte advances the head one column.
- Enter locally advances the paper upward by a line.
- At column 64, line feed happens automatically.
- Backspace erases the previous character on the current line.
- Ctrl-] exits.

The screen uses direct `POKE` updates per keystroke. Each normal character needs only an update to the paper cell and the old/new printhead marker. The slow interpreted BASIC nested `PEEK`/`POKE` loops previously used for paper feed have been replaced with Z80 `LDIR`.

## Planned

- Half/full duplex configuration in the startup menu
- Cassette-port mechanical printing and carriage-return sounds
- Reliable RS-232 high-speed reception in a native Z80 `TELETYPE/CMD`
- Real-hardware and emulator test reports

## Status

**Prototype / not verified in TRS80GP 2.5.8 or on real hardware.** Report BASIC syntax or runtime errors with line numbers so the source can be corrected.

## References

- User-supplied *TRSDOS & Disk BASIC Reference Manual* (TRSDOS v2.3, Disk BASIC v2.2), sections on `DEFUSR` and `USRn` (manual pages 7-16 and 7-24–7-29)
- [TRS-80 Model III serial and I/O reference](https://www.trs-80.com/main-internal-ports-and-i-o.htm)
