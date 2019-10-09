# Effects

Effects use 12 bits: 4 "type" bits, and 8 "parameter" bits. Here is the list of existing types:

 - 0 - Arpeggio
 - 1 - Slide up
 - 2 - Slide down
 - 3 - Toneporta
 - 4 - Vibrato
 - 5 - Set master volume
 - 6 - Call routine
 - 7 - Note delay
 - 8 - Set panning
 - 9 - Set duty cycle
 - A - Volume slide
 - B - Free slot
 - C - Set volume
 - D - Free slot
 - E - Note cut
 - F - Set speed

## 0 - Arpeggio

TODO:

**Note:** An arpeggio with argument 00 does nothing, and as such is the standard way to specify "no FX"

## 5 - Set master volume

Changes the master volume by writing to `NR51`. Which channel this is called on is irrelevant.

This FX also allows toggling the VIN audio input, though you're not likely to use it.

**Argument format:** The raw byte to write to `NR51`.

## 6 - Call routine

Calls an ASM snippet, particularly useful for syncing gameplay and music somehow. Make sure to put pointers to the routines in `hUGE_UserRoutines`!

*TODO:* Write a sort of API so routines can interact with the sound engine better

**Argument format:** The ID of the routine to call times 2. That is, use 00 to call the 1st routine in the table, 02 for the second, and so on.

**Limitations:** There can only be 128 routines.

## 7 - Note delay

Delays playing the note until after a certain amount of ticks.

**Argument format:** The number of ticks to wait.

TODO: if we implement dual-tempo tracks, split this argument in two?

## 8 - Set panning

Sets **all** channels' pannings to either hard left, hard right, both, or none. This is done by writing to `NR50`. Which channel this is called on is irrelevant.

**Argument format:** The raw byte to write to `NR50`.

## 9 - Set duty cycle

Sets the current channel's duty cycle (only applicable to CH1 and CH2), by writing to `NRx1`.

This also allows setting, for all channels, the sound length.

**Argument format:** The raw byte to be written to the hardware register.

## A - Volume slide

Adds (or subtracts) some amount from the channel's volume every so often.

TODO: how the hecc should this work with CH3?

**Argument format:** The upper 5 bits are the (signed!) amount to add to the volume; the lower 3 are how many ticks should elapse between volume changes, 1 meaning "do so on every tick".

## B - Free slot

This slot is free, you can suggest us some feature to implement there!

## C - Set volume

Sets the channel's volume to a given value.

**Argument format:** Dependent on channel; will basically be written raw to `NRx2`.

## D - Free slot

This slot is free, you can suggest us some feature to implement there!

## E - Note cut

Silences the channel after a certain amount of ticks.

**Argument format:** The number of ticks after which to silence the channel, plus 1. This means 1 will immediately kill the channel, the note won't be heard.

## F - Set speed

Sets a new tempo for the song.

**Argument format:** The new number of ticks that should elapse between rows, 1 meaning "do so on every tick".