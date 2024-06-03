#!/bin/bash

gen_fonts ()
{
    for f in ${fonts[@]}; do
        echo $f
        bin/sdf_atlas -f $rd/$f.ttf -o $f -bs 12 -rh 64 -tw 512
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

dst=/baz/matevz/root-dev/rcore-alja/examples/common/textures/fonts
gzip -f -9 *.js
cp -f *.png *.js.gz $dst
