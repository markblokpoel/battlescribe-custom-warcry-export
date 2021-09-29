# BattleScribe custom card export for Warcry

This custom export allows you to generate cards for your warbands using [BattleScribe](https://battlescribe.net/).

## Usage

1. You will need to download this repository as ZIP file and extract it somewhere you remember, e.g., ``/home/mark/Downloads/custom-warcry-export``.

1. To generate the cards, create a warband roster for Warcry in BattleScribe.

1. Then, press the "Share" button and select "Export...". A pop-up will ask for two files.

    1. The XML stylesheet should point to the stylesheet, e.g., ``/home/mark/Downloads/custom-warcry-export/styles/warcry-card-abilities.xsl``
    
    1. The Output file should can have any name you want, but should be in the output folder of the zip you downloaded *and* it should have the ``.html`` extension, e.g., ``/home/mark/Downloads/custom-warcry-export/output/my_warband.html``

1. Press "Export" and you will find an HTML file with at the specified location. Open it in a browser and from there you can save as PDF or print.

## Errors

If your cards have no images and text is messed up, you may have not stored it in the output folder as specified in step 3.2. Check if the HTML file is in the output folder so it can load the images and scripts.

## Attributions and license

The project uses graphic materials from the awesome card creators made by @rachelnertia (https://github.com/rachelnertia/warcry-card-creator), [HENNIROCKS](https://hendrik-berends.de/en), [@dorb4n](https://github.com/dorb4n) and [Stevrak](https://github.com/Stevrak/warcry-card-creator).

The card layout would be possible if not for the awesome [textFit](https://github.com/STRML/textFit) library!

Paper texture is from [Wikimedia](https://commons.wikimedia.org/wiki/Category:Paper_textures#/media/File:Old_paper6.jpg) Public Domain.

[Creative Commons](http://creativecommons.org/licenses/by-nc/4.0/)

Please note that this is a non-commercial and non-profit project created by an enthusiast of Games Workshop products. This project is created and gets updated in my personal freetime, it may get abandoned on the long run. Being open source, feel free to fork this project and adapt and improve it.

This project is in no way endorsed or sanctioned by Games Workshop. Should the owner wish to authorise or cease useage then please get in touch.

Warhammer Age of Sigmar: Warcry © Copyright Games Workshop Ltd. GW, Games Workshop, Citadel, White Dwarf, Space Marine, 40K, Warhammer, Warhammer 40,000, the 'Aquila' Double-headed Eagle logo, Warhammer Age of Sigmar, Battletome, Stormcast Eternals, and all associated logos, illustrations, images, names, creatures, races, vehicles, locations, weapons, characters, and the distinctive likenesses thereof, are either ® or ™, and/or © Games Workshop Limited, variably registered around the world. All Rights Reserved.