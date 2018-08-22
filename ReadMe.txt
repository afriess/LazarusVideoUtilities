Thanks to
Clootie -> MS DirectX 9.0 SDK = http://www.clootie.ru/fpc/index.html
The BlachSheep -> DSPack - Lazarus version of the progdigy DSPack DirectShow Multimedia components = https://github.com/TheBlackSheep/DSPack-Lazarus

Mike.Cornflake -> lazarusvideoutilities = https://sourceforge.net/projects/lazarusvideoutilities/



--------------------- 
Description
Currently there are several options for playing video in Lazarus
* LCLVCL - Trunk only
* PasLibVLC
* mplayer - Lazarus CCR
* DirectShow - Windows Only
* (and presumably others)

These all have their own interfaces. This project hopes to provide a set of wrappers presenting a consistent programming interface to these libraries. A method of enumerating available player technologies is planned so the end user can dynamically choose with player technology to use, or so the programmer can confirm that certain technologies are available on the end user system.

A set of additional components are planned, all of which will use the common interface:
* Video Playback Toolbar 
* Video Trackbar
* Video Playback Panel

This project will also serve as the test bed for enhancements to the Lazarus-CCR mplayer package.


Sources: 2016-02-06 R35
 Initial: Mike.Cornflake  https://sourceforge.net/projects/lazarusvideoutilities/
 
--------------------