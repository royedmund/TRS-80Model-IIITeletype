# TRS-80 Model III Teletype Terminal

An experimental teletype terminal for a **TRS-80 Model III running LDOS 5.3**, intended eventually to connect to a PiDP-11/70 via RS-232 at **300 baud, 8 data bits, no parity, 1 stop bit (8N1)**.

## BASIC paper-and-printhead prototype

[TELETYPE.BAS](TELETYPE.BAS) is the first **local simulated RS-232 loopback** prototype. Keyboard bytes go through a software TX-to-RX path and are then printed; no serial hardware is accessed. It uses the Model III's native 64 x 16 video display to simulate:

- A teletype paper window with an advancing printhead
- Every typed byte is copied from simulated TX to RX, then processed for printing
- **Paper moving upward** with each line feed / ENTER
- Automatic carriage return and line feed at the right margin
- Backspace to erase the last character
- Ctrl-] to exit

Run from LDOS Disk BASIC after saving the listing as `TELETYPE/BAS`:

```basic
RUN "TELETYPE/BAS"
```

The paper occupies rows 2-12; the last paper row is the active printing line. The small `^` beneath the paper marks the moving printhead. On Enter, the eleven-line paper buffer shifts up and the printhead returns to the left.

**Not implemented yet:** actual RS-232 I/O, hardware loopback, 300-baud timing and cassette-port mechanical strike sounds. This is software echo only. The on-screen 300 8N1 label is a design target, not a working serial link.

## Z80 source

[TELETYPE.ASM](TELETYPE.ASM) is early, experimental assembly source for a separate terminal implementation. **No compiled `TELETYPE/CMD` binary has been published in this repository yet.** The assembly code has not been tested on the actual Model III hardware.

## Local loopback path

`INKEY# TRS-80 Model III Teletype Terminal

An experimental teletype terminal for a **TRS-80 Model III running LDOS 5.3**, intended eventually to connect to a PiDP-11/70 via RS-232 at **300 baud, 8 data bits, no parity, 1 stop bit (8N1)**.

## BASIC paper-and-printhead prototype

[TELETYPE.BAS](TELETYPE.BAS) is the first **local simulated RS-232 loopback** prototype. Keyboard bytes go through a software TX-to-RX path and are then printed; no serial hardware is accessed. It uses the Model III's native 64 x 16 video display to simulate:

- A teletype paper window with an advancing printhead
- Every typed byte is copied from simulated TX to RX, then processed for printing
- **Paper moving upward** with each line feed / ENTER
- Automatic carriage return and line feed at the right margin
- Backspace to erase the last character
- Ctrl-] to exit

Run from LDOS Disk BASIC after saving the listing as `TELETYPE/BAS`:

```basic
RUN "TELETYPE/BAS"
```

The paper occupies rows 2-12; the last paper row is the active printing line. The small `^` beneath the paper marks the moving printhead. On Enter, the eleven-line paper buffer shifts up and the printhead returns to the left.

**Not implemented yet:** actual RS-232 I/O, hardware loopback, 300-baud timing and cassette-port mechanical strike sounds. This is software echo only. The on-screen 300 8N1 label is a design target, not a working serial link.

## Z80 source

[TELETYPE.ASM](TELETYPE.ASM) is early, experimental assembly source for a separate terminal implementation. **No compiled `TELETYPE/CMD` binary has been published in this repository yet.** The assembly code has not been tested on the actual Model III hardware.

 -> `TX` -> software `RX=TX` -> print routine / paper feed. No cable, adapter or RS-232 emulator settings are required for this mode. The `300 8N1` display indicates the future serial target only.

## Planned improvements

1. More lifelike paper feed and printhead animation, maintaining the 64 x 16 display limitations.
2. Printhead impact and carriage-return effects using the cassette output, with safe port handling.
3. Real 300 8N1 communications through the Model III RS-232 card to the PiDP-11/70.
4. Tested LDOS `TELETYPE/CMD` executable and bootable disk distribution.

## Hardware notes

The Model III RS-232 signals use RS-232 electrical levels, not the Pi's TTL GPIO UART levels. Use a suitable USB-to-RS-232 adapter and cable wiring, with appropriate null-modem connections or handshaking as required.

## Status

**Prototype / not hardware-tested.** Please report any BASIC syntax, keyboard, or display issues observed under LDOS 5.3.

## References

- [TRS-80 Model III specifications](https://www.trs-80.com/sub-models-model3.htm)
- [TRS-80 graphics and character codes](https://www.trs-80.com/sub-tips-graphics.htm)
- [LDOS Model III BASIC disassembly](https://www.trs-80.com/sub-disassem-dos-ldos-m3-basic-cmd.htm)
