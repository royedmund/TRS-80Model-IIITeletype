# TRS-80 Model III Teletype

A mechanical teletype-style **visual terminal emulator** for the 48 KB TRS-80 Model III. The project supports full-width (64-column) printing, a moving printhead marker, upward-scrolling paper, and local or RS-232 operation.

## Programs

| File | Purpose |
| --- | --- |
| [TELETYPE.CMD](TELETYPE.CMD) | Native Z80 executable for TRSDOS/LDOS; no BASIC needed |
| [TELETYPE.ASM](TELETYPE.ASM) | Z80 source corresponding to the native terminal |
| [TELETYPE.BAS](TELETYPE.BAS) | Model III ROM BASIC prototype (the `Cass?` / `Memory Size?` environment) |
| [TELEDOS.BAS](TELEDOS.BAS) | TRSDOS Disk BASIC prototype with accelerated Z80 paper feed |

**The native `TELETYPE/CMD` executable is a test build.** The binary has not yet been run on TRS80GP or a physical Model III. Use a disposable/copy test disk and report the results.

## Native Z80 terminal — TELETYPE/CMD

Save the supplied `TELETYPE.CMD` file to the TRSDOS/LDOS disk as `TELETYPE/CMD`. At **DOS READY**, enter:

```text
TELETYPE
```

Startup mode selection:

- **1 or Enter** — local screen test (default). Prints locally, with no artificial speed limit.
- **2** — real Model III RS-232. Choose **9600 baud (default)** or **300 baud**; both use **8N1** (8 data bits, no parity, 1 stop bit).

In real serial mode, typed keys are sent over RS-232; the displayed output comes from received bytes (the remote system must echo). The hardware configuration and handshake wiring need testing with TRS80GP and the PiDP-11/70.

At run time:
- **Enter** feeds the paper in local mode.
- **Backspace** erases the preceding character on the active line.
- **Ctrl-]** exits to DOS READY.

## Paper and printhead

After selecting a mode, no title or status line remains onscreen. Paper can use the **entire 64-column width and screen rows 0–14**, and a `^` printhead marker moves along row 15. Lines feed upward, finally scrolling off the top edge.

In the native program, `LDIR` shifts the paper rapidly. Ordinary printed characters go directly into video memory.

## BASIC versions

The ROM BASIC prototype can use ordinary BASIC paper scrolling, or a 33-byte Z80 scroll helper if high memory is reserved:

```text
Cass?            [Enter]
Memory Size? 61439
```

The ROM BASIC version calls this helper through `USR(0)`. The separate TRSDOS Disk BASIC version uses `DEFUSR0` and `USR0(0)`; its current build requires the machine-code paper-feed helper. Do not mix the two BASIC source files.

The native `/CMD` version does not require a BASIC memory reservation.

## Planned improvements

- Half-duplex and full-duplex configuration in the serial startup menu
- More faithful Teletype paper and carriage behavior
- Real-hardware RS-232 compatibility testing and reliable buffering

## Status

**Experimental prototype.** The BASIC screen drawing was tested in TRS80GP, but the paper-feed performance and control-flow changes still require verification. The native `/CMD` build is also awaiting emulator testing.

## References

- User-provided *TRSDOS & Disk BASIC Reference Manual* (especially its `DEFUSR` / `USRn` examples)
- [TRS-80 Model III ports and I/O](https://www.trs-80.com/main-internal-ports-and-i-o.htm)
