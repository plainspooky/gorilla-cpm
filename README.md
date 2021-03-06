# Gorilla.BAS - CP/M version

This is a Modula-2 (despite the name) implementation for CP/M of the classic "GORILLA.BAS" BASIC game included in MS-DOS 5.0.

## Why Turbo Modula-2?
The choice was mainly due to a historic interest: this compiler (never distributed by Borland) [was written by Martin Odersky](https://groups.google.com/forum/?fromgroups=#!topic/comp.lang.modula2/Ruy9g8aBmF0) (the inventor of [Scala language](http://www.scala-lang.org/)) and had never been used by a critical mass of users. So it was both a challenging choice and a historic research.

## Contents of package
- **source** - Source code in Turbo Modula-2 (despite the name ".BAS")
  - [**xterm.def**](https://github.com/sblendorio/gorilla-cpm/blob/master/source/xterm.def) - XTerm Library: definition module (for terminal portability)
  - [**xterm.mod**](https://github.com/sblendorio/gorilla-cpm/blob/master/source/xterm.mod) - XTerm Library: implementation module
  - [**game.def**](https://github.com/sblendorio/gorilla-cpm/blob/master/source/game.def) - Game Engine: definition module
  - [**game.mod**](https://github.com/sblendorio/gorilla-cpm/blob/master/source/game.mod) - Game Engine: implementation module
  - [**main.mod**](https://github.com/sblendorio/gorilla-cpm/blob/master/source/main.mod) - Main module (run this)
- **binary** - Compiled .COM executable files for CP/M-80
  - [**gorilla.com**](https://github.com/sblendorio/gorilla-cpm/blob/master/binary/gorilla.com?raw=true) - Binary executable file
- **dists** - Collection of CP/M bootable disk images for Commodore 128 and Memotech MTX
  - [**gorilla.d71**](https://github.com/sblendorio/gorilla-cpm/blob/master/dists/gorilla.d71?raw=true) - Includes C128 CP/M boot code, all sources and binaries, some utilities
  - [**gorilla.d64**](https://github.com/sblendorio/gorilla-cpm/blob/master/dists/gorilla.d64?raw=true) - Includes C128 CP/M boot code, all sources and binaries
  - [**gorilla.mfloppy**](https://github.com/sblendorio/gorilla-cpm/blob/master/dists/gorilla.mfloppy?raw=true) - Includes Memotech MTX CP/M boot code and binaries (Memotech type 07 disk image)
  - [**gorilla-msx.dsk**](https://github.com/sblendorio/gorilla-cpm/blob/master/dists/gorilla-msx.dsk?raw=true) - Includes MSX-DOS boot code and binaries (MSX-DOS disk image)
  - [**gorilla-cpc.dsk**](https://github.com/sblendorio/gorilla-cpm/blob/master/dists/gorilla-cpc.dsk?raw=true) - Includes CP/M for Amstrad CPC6128 boot code and binaries (CPC CP/M disk image)

## Credits
Thanks to [Fabrizio Radica](http://www.retroacademy.it/) for the idea, [YAZE Team](http://www.mathematik.uni-ulm.de/users/ag/yaze/) for the fantastic Z80 emulator that runs fine on Mac OS X, [Lawrence Woodman](http://techtinkering.com/2013/03/12/if-only-borland-had-stuck-with-turbo-modula-2-for-cpm/) for sharing informations about CP/M and Turbo Modula-2, [Dave Stevenson](http://www.primrosebank.net/computers/mtx/mtx512.htm) for sharing informations about Memotech MTX and to **Sergio Gervasini** and **Stefania Calcagno** for support.

## In-game screen on Commodore 128
![C128](http://www.sblendorio.eu/images/gorilla-128.jpg)
## Intro screen on Amstrad CPC 128
![CPC6128](http://www.sblendorio.eu/images/gorillacpc.jpg)
## Multiple platforms: C128 / Amstrad CPC6128
![Multiple platforms](http://www.sblendorio.eu/images/gorilla128-5.jpg)
## Intro screen
![C128 version](http://www.sblendorio.eu/images/gorilla-1.png)
## Game screen - 1
![C128 version](http://www.sblendorio.eu/images/gorilla-2.png)
## Game screen - 2
![C128 version](http://www.sblendorio.eu/images/gorilla-3.png)

