----------------------------------------
XMAME v1.2 for GCW-Zero Linux 02/01/2015
Ported and developed by Slaanesh.
http://www.slaanesh.net/
----------------------------------------

XMAME is the X Multiple Arcade Machine Emulator capable of emulating 1000s of arcade machine games.
XMAME v1.2 includes 3x versions of XMAME 0.37b16 (AKA 0.52), 0.69 and 0.84.
Unlike MAME4ALL for Dingoo Native, XMAME is not based on MAME4ALL and is a brand new port of XMAME from later base versions.

----------------------------------------
How does it work?
----------------------------------------
XMAME can either be run from a shell or preferably for the GCW-Zero from a frontend.
The frontend is used to select a version of XMAME and a ROM to run as well as selecting various runtime parameters.


----------------------------------------
Requirements
----------------------------------------
* GCW-Zero console.
* OpenDingux Release 2014-08-20.


----------------------------------------
What's new in v1.0?
----------------------------------------
* Create work-arounds for some parts of the XMAME code so that things work! I believe there is a bug in the GCC compiler. A very subtle bug, which would have stopped XMAME from working correctly. Some games would work and others (most) would not. See memory.c for the workaround.
* Add a dozen or so software blitters. These were used before the GCW-Zero kernel supported hardware screen scaling. Still selectable when scaler is set to software mode and useful if you don't want a scaled image.
* Support hardware scaler.
* New Frontend.
----------------------------------------
What's new in v1.1?
----------------------------------------
* Improvements to installation process, support for FAT32 on SD cards.
* Inclusion of this readme.txt and license.txt.
----------------------------------------
What's new in v1.2?
----------------------------------------
* Fixes to system32.c for XMAME 0.69 and XMAME 0.84.
* Fixes to taito_f3.c for XMAME 0.69 and XMAME 0.84.
* Updated icons thanks to hi-ban.


----------------------------------------
How to use
----------------------------------------

Standard in-game MAME controls:

- D-Pad: UP, DOWN, LEFT and RIGHT.
- Buttons A,B,X,Y,L,R: MAME buttons 1,2,3,4,5,6.
- Buttons SELECT+R: Insert credit.
- Buttons SELECT+L: Start 1P game.
- Buttons SELECT+L+R: Exit.

Extended controls in game (to access menus and options)

- Buttons L+R: Pause.
- Buttons START+R: View FPS.
- Buttons START+L: XMAME menu. ie. Redefine keys, auto-fire, much more!
- Buttons START+Down: Take snapshot.
- Buttons START+Left: Save state.
- Buttons START+Right: Load state.


----------------------------------------
Frontend
----------------------------------------
- D-Pad: UP, DOWN to move ROM selector by one line.
- D-Pad: LEFT, RIGHT to move ROM select by a page.
- SELECT: Refresh ROM list cache - use if you add/remove a ROM file.
- L: Filter ROM list. Swap between Available Game, Available - Clones, Favourites and All Games.
- R: Switch between XMAME versions, currently 0.37b16, 0.69 and 0.84.
- A: Start game and choose options.
- Y: Toggle game as a favourite.

----------------------------------------
Options
----------------------------------------
* Indicates value used for 'Auto'.

- Video Rotation: Landscape* for normal rotation and Portrait for 270 degree rotation.
- Video Scaling: Software to use software blitters, Hardware Aspect* or Fullscreen to use GCW-Zero's IPU hardware scaler.
- Video Depth: 8-bit, 15-bit RGB Direct, 16-bit video depth. Auto is dependent on the game.
- Video Sync: Triple Buffer* or No Throttle to go as fast as possible.
- Video Freamskip: DOS or Barath* frameskip algorithm.
- Sound: On* or Off.
- Sound Volume: -32 to 0*. -32 is quiet and 0 is maximum. 
- Sound Freq: 11025, 22050* and 44100hz. The high, the better quality the sound, though many arcade machines don't go beyound 22050 anyway so setting it higher may not make any difference in some cases.
- Sound Stereo: Auto* or off. Use stereo if the game supports it or switch stereo off.
- Save High Score: Auto* or off. Save highscore if game supports it or switch high-score saving off. A few games crash with high-score support but i've tried to remove these from the hiscore.dat database file. Let me know if you find any that crash a game.
- Save State: None* or select a previously generated save state from A-Z.
- Cheats: Off* or on. You will need the cheat.dat file which is not included.
- Speed Hack: Off, Low, Medium or High. Underclocks the emulated CPUs to 90, 80 or 70% respectively.

----------------------------------------
FAQ
----------------------------------------
Q: My game is not working, what can I do?
A: Try the following:

* Just because it's in the MAME4ALL frontend, doesn't mean it will work! I don't test all the games, there are too many!
* If the game is not being displayed in the XMAME frontend check that the game is actually supported with this version of MAME4ALL. Check that you are running the right module! Some games have been moved around and some games are not in obvious modules. Check the gameslist.txt.
* Check that you have the right version of the ROMS. MAME's set of ROMS have changed over the many years of it's existence. This version of MAME mainly uses m37b5 ROMs though some games require later versions. Typically these games have their versions noted in the whatsnew.txt.
* Check that the game is 'likely' to run! If it's a really big game. ie. ZIP file is great than 3MB it may not work due to size.
* Try running the game with default settings. ie. Remove the game's frontend and config settings from the MAME4ALL directory. If you are using my bundled frontend config files make sure the settings are compatible with your A320, especially the Mhz.
* Try running the game using a directory with files unzipped already. ie if you are trying to run 'galaga' have a mame4all/roms/galaga directory with the contents of galaga.zip in this directory.
* Try running the game without the hiscore.dat file. Sometimes the hiscore DB can cause issues. If you know what you are doing, you can also edit the hiscore.dat file as it's just a text file - remove any suspect game entries.
* Try running the game in 16-bit graphics mode. Some games need this to display correctly. ie. Splatterhouse and other namcos1 games work faster in 8-bit mode but look better in 16-bit mode. See "games_16-bit.txt" for a list of ROMs for games that may look/work better with 16-bit mode enabled. Note: many of these may be perfectly fine in 8-bit mode.
* Try running the game without sound (volume = OFF). This will not load some sound ROMS thus reducing memory requirements.
* Try running the game at a slower clockspeed.
* Try running the game using either FAME (Fast Core) or Musashi (Compatible) core. This is only relevant if the game has a M68000 CPU. Check the start up screen - it lists the types of CPUs.

