This is a vim plugin that helps you transpose blocks of text, words, delimited
text, or lines that you can tokenize with a custom pattern.

    ab,cd,ef   :TransposeCSV ,   ab,gh,mno
    gh,ij,kl ==================> cd,ij,pqrs
    mno,pqrs                     ef,kl,

    abcde                         afjop
    fghi       :Transpose         bgk q
    jklmn  ====================>  chl r
    o                             dim s
    pqrst                         e n t

Installation
------------

If you have the Pathogen plugin installed or any other plugin manager, then
just copy this filetree into a subfolder of your Bundle folder.

Otherwise, copy the contents of the doc/, plugin/ and autoload/ folders to
resp.  ~/.vim/doc, ~/.vim/plugin and ~/.vim/autoload

Tutorial
--------

Open doc/transpose.txt inside vim, and try on the provided examples.

Development
-----------

The main git repository for this plugin is at
http://github.com/salsifis/vim-transpose

Licensing
---------

zlib/libpng license.

Copyright (c) 2012 Benoit Mortgat

This software is provided 'as-is', without any express or implied warranty. In
no event will the authors be held liable for any damages arising from the use
of this software.

Permission is granted to anyone to use this software for any purpose, including
commercial applications, and to alter it and redistribute it freely, subject to
the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim
   that you wrote the original software. If you use this software in oduct, an
acknowledgment in the product documentation would be appreciated is not
required.

2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution.
