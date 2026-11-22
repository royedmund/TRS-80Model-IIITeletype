# TRS-80 Model III Teletype Terminal

A full-screen Teletype-style terminal for the **48 KB TRS-80 Model III**, with an animated printhead marker, scrolling paper, a local screen-test mode, and an experimental real RS-232 mode.

## Files

| File | Description |
| --- | --- |
| [TELETYPE.CMD](TELETYPE.CMD) | Native Z80 test program **v1.3** for TRSDOS/LDOS, loads at 7000h |
| [TELETYPE.ASM](TELETYPE.ASM) | Assembly source for the v1.3 native binary |
| [TELEDOS.BAS](TELEDOS.BAS) | **v1.4** TRSDOS Disk BASIC prototype |
| [TELETYPE.BAS](TELETYPE.BAS) | **v1.4** Model III ROM BASIC prototype |

### Running the native program

Copy `TELETYPE.CMD` to a TRSDOS/LDOS disk as `TELETYPE/CMD`, then enter:

```text
TELETYPE
```

The startup menus are:

1. **Operating mode:** 1 = local screen test (default), 2 = real RS-232
2. **Baud rate (real RS-232 only):** 1 = 9600 (default), 2 = 300; both 8N1
3. **Duplex (real RS-232 only):** 1 = full (default; remote echo), 2 = half (local echo)

**Full duplex** transmits keys but prints them only if they are echoed by the remote device. **Half duplex** transmits and locally displays the keys, so disable remote echo to avoid duplicates. Incoming serial data displays in either mode. These are terminal echo modes, not hardware flow-control settings.

Local screen-test mode does not use the UART or apply any artificial baud-rate delay. **Ctrl-]** exits back to DOS READY and restores the normal ROM cursor.

## 80-character Teletype lines on a 64-column Model III screen

The physical Model III display is 64 columns wide. Each **logical line** therefore displays its first 64 printable characters on one physical row and its remaining 16 on the following row. On printing the **80th character**, the terminal:

- Generates **one short bell** through the Model III cassette audio output port **FFh**
- Automatically performs a carriage return/line feed in the **display**, leaving the next character at the left of a fresh line
- Resets the logical character count to zero

If Enter / CR / LF arrives earlier, the counter resets and paper feeds without a bell. Incoming CR-LF sequences are treated as a single line feed. This is an **on-screen auto wrap**; it does not inject extra CR/LF bytes into the remote serial connection. The 80th character itself is still printed.

There is **no permanent header or status bar** after the menus. Paper occupies video rows 0–14, the `^` printhead occupies row 15, and old text rolls off the top. The ROM flashing cursor is hidden while the program is running.

### Bell sound

The single end-of-line bell is the **only sound feature** in this project. Mechanical print-strike, carriage, and other continuous sound effects remain excluded.

The Model III does not have a general-purpose built-in sound generator. The bell toggles the cassette output on port FFh. In TRS80GP, audible output depends on its audio configuration; on a physical Model III, you may need to monitor the cassette output through suitable audio equipment. The program does not require an internal speaker.

Because the bell is synchronous, printing pauses briefly at each 80th character. Real RS-232 receiving at 9600 baud is still experimental and can drop characters during the bell or display update. For testing, use 300 baud or local screen-test mode.

## BASIC prototypes

`TELEDOS.BAS` (TRSDOS Disk BASIC) uses `DEFUSR0` for a 33-byte machine-code paper scroll at `F000h` and `DEFUSR1` for a 25-byte Z80 bell at `F040h`. It requires high-memory reservation. The current prototype adjusts the BASIC memory limit and attempts to reserve space itself; start BASIC with **MEMORY SIZE 61439** if that fails.

`TELETYPE.BAS` (Model III ROM BASIC) optionally uses the same machine-code routines with `Memory Size? 61439` at ROM BASIC startup. Without reserved memory it uses much slower BASIC scrolling and a simple cassette-port click, not the short Z80 bell tone.

For reliable local screen behaviour, **use the native `TELETYPE.CMD`** instead of the BASIC prototypes.

## Status

The native v1.3 program was assembled into a TRSDOS command file and passed **instruction-level simulated Z80 tests** for menu selection, full/half duplex, local printing, 64-column physical wrapping, the 80th-character bell, linefeed, backspace, and returning from the bell to printing. The `/CMD` file's load and execution records were checked. It **has not yet been tested in TRS80GP or on physical hardware**.

## References

- User-provided *TRSDOS & Disk BASIC Reference Manual*
- [Model III port reference](https://www.trs-80.com/main-internal-ports-and-i-o.htm)
- [Model III cassette-port tone examples](https://www.trs-80.com/sub-disassem-dos-dosplus35-m3-codir-cmd.htm)
