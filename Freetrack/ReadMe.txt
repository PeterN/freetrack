Delphi DirectX 9.0 headers : Clootie_DirectX92_01.31 can be found here http://sourceforge.net/project/showfiles.php?group_id=116990


DSPack 2.3.4 can be found here 
http://www.progdigy.com/modules.php?name=DSPack


indy 10.0.52 (required for Lomac DLL) can be found here
http://www.indyproject.org/download/index.iwp


PNGComponents
www.thany.org/pngcomponents/ 
Ensure DSPack is after PNGComponents in 'uses' list because they both have a TFilter.


DKLang localization
http://www.dk-soft.org/products/dklang/
Requires Tnt Delphi UNICODE Controls
http://mh-nexus.de/tntunicodecontrols.htm
Use DKLang Translation Editor to create translation files *.lang from *.dklang source
Resourcestrings must be defined in: Project -> Edit Project Constants (easier to load from constants.txt file)
and accessed use DKLangConstW('constant');
*.dklang source language files should never be edited directly.


JvHidControllerClass
For HID access to Wii Remote


Optitrack SDK





