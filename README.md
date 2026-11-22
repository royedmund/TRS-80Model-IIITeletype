# TRS-80 Model III Teletype

A teletype-style printhead and scrolling paper simulation for the 48 KB TRS-80 Model III. The prototype provides fast, **unthrottled local keyboard loopback** and an **experimental real RS-232** mode (9600 or 300 baud, 8N1). Intended for testing with George Phillips' TRS80GP 2.5.8.

## Which BASIC are you using?

The screen showing **Cass?**, **Memory Size?**, and **Radio Shack Model III Basic** indicates the **ROM/cassette BASIC** environment, even if the machine also has TRSDOS available.

- **[TELETYPE.BAS](TELETYPE.BAS)** — **Model III ROM BASIC**, suitable for the **Cass? / Memory Size?** screen in TRS80GP. Uses the classic `USR(0)` entry vector at addresses 16526–16527.
- **[TELEDOS.BAS](TELEDOS.BAS)** — **TRSDOS Disk BASIC** version. Uses `DEFUSR0` and `USR0(0)` instead.
- **[TELETYPE.ASM](TELETYPE.ASM)** — a separate experimental assembly draft, not yet compiled into a working `TELETYPE/CMD`.

Do **not** run the Disk BASIC version under ROM BASIC.

## Memory Size? (ROM BASIC)

At the Model III's startup prompts:

```text
Cass?               [press Enter]
Memory Size?         [press Enter]
```

The ROM BASIC version will run using ordinary BASIC paper scrolling. This is slower on **line feeds** but has no special memory requirement.

For **fast machine-code scrolling** on a 48 KB machine, reset ROM BASIC and answer:

```text
Cass?               [press Enter]
Memory Size? 61439
```

This protects memory starting at **F000h (61440)**. When the program detects exactly this reserved BASIC memory limit, it loads a 25-byte Z80 scroll routine at F000h, sets the ROM BASIC USR entry vector to F000h, and uses `USR(0)` to move paper. If the limit does not match, it **does not poke machine code into high memory** and instead uses a slower BASIC loop for line feed.

The TRSDOS Disk BASIC version uses the same reservation and code but calls it through `DEFUSR0=-4096` and `USR0(0)`. For TRSDOS, start `BASIC` from DOS READY and enter `61439` at its MEMORY SIZE prompt to enable acceleration.

## Startup options

The mode selection comes first:

- **1 / Enter:** local software loopback, **unthrottled** (default)
- **2:** real RS-232 serial port (experimental)

Only real RS-232 mode asks for baud:

- **1 / Enter:** 9600 baud (default)
- **2:** 300 baud

Both real serial configurations target **8 data bits, no parity, 1 stop bit**.

A **half-duplex/full-duplex** choice is planned for a future menu; it has not been implemented.

## Display and controls

- All 64 columns are available for text (no paper side borders).
- Video rows 3–12 represent paper; row 13 displays a moving `^` printhead.
- Every typed printable character is written straight into video RAM via `POKE`.
- **Enter:** paper feeds upward by a row in local mode.
- **Backspace:** removes the previous printed character on the current line.
- **Ctrl-]:** exit.
- Column 64 automatically wraps and feeds paper.

For a character, the program updates only that video location and two printhead locations. With memory reserved, the Z80 scroll uses **LDIR** to shift 576 paper bytes up and fill the 64-character active row. Without memory reserved, scrolling uses BASIC `PEEK`/`POKE`.

## Testing

Start in **local loopback** to verify the screen. It performs *no real UART I/O* and imposes no artificial 300/9600 baud delay. If rapid typing still loses keys, the remaining cause is likely BASIC interpreter/keyboard polling speed, rather than a baud-rate throttle.

Real RS-232 mode uses the Model III serial card ports directly and assumes **remote echo**. Polling the UART from BASIC is experimental and could still lose characters, especially at 9600 baud. Start with 300 baud and verify emulator/device setup.

**Status: not yet execution-tested in TRS80GP or on real hardware.** Please report any error and its BASIC line number.

## References

- User-supplied *TRSDOS & Disk BASIC Reference Manual*, sections 7-16 and 7-24 to 7-29 for machine-language calls.
- [Model III BASIC tips](https://www.trs-80.com/sub-tips-model-3.htm)
- [TRS-80 USR/PEEK/POKE techniques](https://www.trs-80.com/sub-tips-packing.htm)
