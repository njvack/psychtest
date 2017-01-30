# Pssychtest!

This is a little tiny demonstration app that collects some psychological data and stores it in both a relational database and a MongoDB instance. It's intended as a proof-of-concept thing in preparation for a larger web app framework development push.

The data we'll collect here will be the lag between a screen stimulus and keypress; we'll do it by showing a periodic flashing stimulus and having participants push a button when it blinks; the same trick is used in rhythm games. Participants can anticipate the flash, so it's not a reaction time test. However, there will be some lag between when the screen flashes and when a keypress is registered; we'll measure that.

