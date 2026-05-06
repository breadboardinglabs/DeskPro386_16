# DeskPro386_16
Compaq DeskPro 386/16 KiCad Schematic and PLD files

The Compaq DeskPro 386 was one of the first 80386/i386 PC Compatable computers.
It used mainly standard components found in the PC and PC-XT and used 14 
basic 20 and 24 pin Programmable Logic Devices (PLDS).
Later DeskPro 386 versions used VLSI 160+ pin chips unsuitable for use with breadboards.

Internal Compaq Design documents have been made available on Archive.org which
not only include more recent schematics than the original DeskPro 386/16 Technical Guide,
but also include the PLD Logic Rules and test vectors for all the chips in the PALASM language.

PALASM can be converted into CUPL for use with WinCUPL/II and modern ATF16V8B and ATF22V10C PLDs.

Compaq DeskPro 386/16 Technical Guide https://archive.org/details/compaq-desk-pro-386-technical-reference-guide-vol-1-1986-09
COmpaq DeskPro 386/16 Internal Design Document https://archive.org/details/compaq-desk-pro-386-technical-reference-guide-vol-1-1986-09

## KiCad Schematics
The Internal Design Document schematics have been reproduced in KiCad 10.
I have layed them out in one big diagram so that related pages are closer together to make tracing labels easier.
I find decomposed diagrams over many pages more difficult to understand.
Feel free to make a copy and re-organise if you feel differently.

Many of the chip symbols have been created to match the DeskPro schematics (DP in name) in the Breadboarding Symbol library (Breadboarding.kicad_sym).
You will need to configure the path to this library after opening the Project.

Use Preferences | Manage Symbol Libraries... then select the "Project Specific Libraries" tab
Select the path to the Breadboarding.kicad_sym file downloaded from GitHub.

Note many of the DP symbols have the power pins removed as this is what the DeskPro schematics did.
If you try to use these symbols for making a PCB be aware of the missing power pins and decoupling capacitors.

Symbols with BB in the name tend to match the physical pin layout so that the schematic can also be used for laying out breadboard designs.
The layout dimensions are very large (almost twice as big as A0 paper size) at 40" x 70".
PDF readers may have problems dealing with the schematic.

I have numbered all the IC's with the Unn values in the Compaq Design document and the bill of materials in the document which is useful to clarify component IDs when the text is unclear.
Please note that if you run the Electrical Rules checker it may say "Schematic is not fully annotated." then ask you to Run the Annotation Dialog.
If you do this you may lose all the manually applied component numbering.
I would suggest NOT running the Annotation Dialog.
Also the rules checker will identify various warnings which can be ignored. Many are excluded.
There is one strange issue which messages about U13 (near a 74ALS1035 with ID U91). U13 is in fact an EPROM nowhere near.
This appears to be left over from when I was re-numbering the chips.
I have not found a way to delete it! 

## Programmable Logic Definitions
There are two versions of the Internal Design Document, text mode and photo mode.
Generally I have used text mode to convert the content but sometimes photo mode is better.
The main issues in converting the logic definitions have been confusions between numeric 0 and letter O and letter l and numeric 1.
The test vectors have required quite a lot of massaging as PDF does not make it easy to copy the content due to it sometimes arranging text blocks in columns.
The PALASM folder has the text copies of the original PDF document in their original format (and with original typos and spelling mistakes).
The file extension .ASM is used as this is the recognised file extension for the CUPL 2.0 PTOC.EXE converter which converts PLDASM files into a .PLD logic definition and .SI simulation file.

THe ZIP file Logical_Devices_CUPL_v3.2b.zip contains an old version of CUPL (July 1990) which predates ATMEL/MicroChip and include the PTOC.EXE utility used to convert PALASM in CUPL format files.

More folders will be added with the .PLD logic definition and .SI simulation files as these are migrated and tested.

