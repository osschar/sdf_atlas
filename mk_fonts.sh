#!/bin/bash

gen_fonts ()
{
    for f in ${fonts[@]}; do
        echo $f
        bin/sdf_atlas -f $rd/$f.ttf -o $f -bs 12 -rh 64 -tw 1024  \
          -ur 31:126,0x00e0:0x00fc,0x010c:0x010d,0x0160:0x0161,0x017d:0x017e,0x0391:0x03a9,0x03b1:0x03c9,0xffff
#                      -ur 31:126,0xc48c:0xc48d,0xc5a0:0xc5a1,0xc5bd:0xc5be,0xffff
    done
}

rd=~/root-dev/dev-1-bld/fonts
fonts=( monotype verdana comic )
gen_fonts

rd=/usr/share/fonts/liberation-mono
fonts=( LiberationMono-BoldItalic  LiberationMono-Bold  LiberationMono-Italic  LiberationMono-Regular ) 
gen_fonts

rd=/usr/share/fonts/liberation-sans
fonts=( LiberationSans-BoldItalic  LiberationSans-Bold  LiberationSans-Italic  LiberationSans-Regular )
gen_fonts

rd=/usr/share/fonts/liberation-serif
fonts=(LiberationSerif-BoldItalic  LiberationSerif-Bold  LiberationSerif-Italic  LiberationSerif-Regular )
gen_fonts

dst=/home/matevz/root-dev/dev-1/ui5/eve7/fonts
gzip -f -9 *.js
cp -f *.png *.js.gz $dst
