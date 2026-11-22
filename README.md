# TRS-80 Model III Teletype Terminal

A native Z80 RS-232 teletype terminal for the TRS-80 Model III, running LDOS 5.3.

## Configuration

- **Executable:** `TELETYPE/CMD` (repository file: `TELETYPE.CMD`)
- **Serial:** 300 baud, 8 data bits, no parity, 1 stop bit (300 8N1)
- **Terminal:** 64-column Model III display and keyboard
- **Serial hardware:** Model III RS-232 card
- **Use case:** Connect to a PiDP-11/70's USB-to-serial interface

From the LDOS Ready prompt run `TELETYPE`. Press **Ctrl-]** to exit to LDOS. The terminal expects remote echo, and displays incoming ASCII (LF ignored; CR processed). Display is limited to 7-bit ASCII, while outbound keyboard bytes are sent unmodified.

## Wiring

Use a correctly wired RS-232 null-modem cable, or a suitable level-shifting adapter for the Pi. The TRS-80 RS-232 port is *not* a TTL-level UART. Configure the Pi's attached serial interface to **300 8N1**, and ensure the required modem-control wiring or handshaking is present.

## Build

The repository contains `TELETYPE.ASM` (human-readable Z80 assembly), `build.py` (reproducible byte builder) and a ready-to-load `TELETYPE.CMD` binary. Build using `python3 build.py`. The program loads and starts at **6000H**, and uses LDOS `@EXIT` at **402DH**.

## Status

**Initial untested hardware build.** The CMD file structure and opcodes have been generated, but execution has not yet been tested on a TRS-80 Model III or with a PiDP-11/70. Serial wiring, terminal control characters, and keyboard handling should be verified on real hardware.

## Reference

- [TRS-80 port and I/O reference](https://www.trs-80.com/main-internal-ports-and-i-o.htm)
- [TRS-80 CMD file format](https://www.trs-80.com/sub-tips-file-formats.htm)
- [TRS-80 ROM keyboard and display routines](https://www.trs-80.com/sub-rom-io-and-misc-routines.htm)
