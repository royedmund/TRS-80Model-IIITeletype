# TRS-80 Model III Teletype

An experimental full-width teletype paper and moving printhead display for a TRS-80 Model III (48 KB) running TRSDOS Disk BASIC. Intended for testing in George Phillips' TRS80GP 2.5.8, then on physical hardware.

## BASIC source

[TELETYPE.BAS](TELETYPE.BAS) — version 0.6.

### Startup options

The first menu selects speed:

- **1** — 9600 baud (default)
- **2** — 300 baud
- **ENTER** — accept 9600

The second menu selects mode:

- **1** — Local software loopback (default)
- **2** — Real RS-232 serial port
- **ENTER** — accept local loopback

All modes use **8N1**: 8 data bits, no parity, 1 stop bit.

In **local loopback**, keyboard characters pass through a software TX -> RX variable path into the paper display, without accessing the serial card. Baud rate is informational only in this mode.

In **real RS-232**, the program initializes the Model III UART using ports E8/E9/EA and reads/writes data using EB. This mode **actually accesses serial hardware**. It assumes **remote echo**; locally typed characters are not immediately printed. The selected baud rate is applied to both receive and transmit. RS-232 receive is polled using BASIC, so **9600 baud is experimental and may overrun or lose characters**, particularly during the paper redraw. 300 baud is more practical for the BASIC stage. Check the emulator's serial mapping and the remote device's matching settings.

### Controls

- Printable keys: transmit (and print in local mode, or print upon receiving remote echo in real mode).
- **ENTER:** newline locally; sends CR in real mode.
- **Backspace:** delete previous print position locally; transmit BS in real mode.
- **Ctrl-]:** exit.

### Display

Uses all **64 columns** of the Model III text screen; there are no side borders. Rows 3-12 are paper, row 13 shows the moving `^` printhead indicator. Newline advances paper upward. An 11th row is not drawn; printed lines scroll through the ten-row paper region.

### Hardware details

Model III serial ports: E8 (232) resets UART, E9 (233) selects baud, EA (234) sets 8N1 control / returns status, EB (235) transfers bytes. Values: **238** for 9600, **85** for 300, **104** for 8N1 control with DTR/RTS asserted. These direct-port operations should be tested cautiously on the Model III and TRS80GP. The PiDP-11/70 USB serial interface must use an appropriate **RS-232-level** adapter and wiring; do not connect a TTL GPIO UART directly.

References: [Model III port documentation](https://www.trs-80.com/main-internal-ports-and-i-o.htm).

## Running

Enter or import the ASCII BASIC listing using TRSDOS Disk BASIC, then `RUN`. Save as `TELETYPE/BAS` for subsequent use.

## Status and next steps

**Experimental, not yet verified in TRS80GP or on actual hardware.** Start with local loopback for screen testing; use 300 baud for initial real serial testing. Future work: print-strike audio through the cassette interface, improved printhead motion, reliable high-speed RS-232 reception in native Z80 code, and a tested `TELETYPE/CMD` executable.

[TELETYPE.ASM](TELETYPE.ASM) is a separate early Z80 draft; no validated `TELETYPE/CMD` binary has been published.
