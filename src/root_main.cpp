/*
 * Copyright (c) 2019 Anton Stiopin astiopin@gmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <iostream>
#include <fstream>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <GL/glew.h>
#include <GL/gl.h>

#include "float2.h"
#include "sdf_gl.h"
#include "sdf_atlas.h"
#include "glyph_painter.h"
#include "font.h"

struct SdfCreator {

    SdfGl        sdf_gl;
    SdfAtlas     sdf_atlas;
    Font         font;
    GlyphPainter gp;

    int          max_tex_size = 4096;
    int          width = 1024;
    int          height = 0;
    int          row_height = 96;
    int          border_size = 16;

    struct UnicodeRange {
        uint32_t start;
        uint32_t end;
    };

    std::vector<UnicodeRange> unicode_ranges;


    void parse_unicode_ranges( const std::string &nword ) {
        errno = 0;
        int range_start = 0;
        int range_end   = 0;

        char *pos = const_cast<char*>( nword.c_str() );

        for(;;) {
            errno = 0;
            char *new_pos = pos;
            range_start = strtol( pos, &new_pos, 0 );
            if ( errno != 0 || range_start < 0 ) {
                std::cerr << "Error reading unicode ranges - begin range" << std::endl;
                exit( 1 );
            }
            range_end = range_start;

            pos = new_pos;
            char lim = *pos++;

            if ( lim == ':' ) {
                errno = 0;
                range_end = strtol( pos, &new_pos, 0 );
                if ( errno != 0 || range_end < 0 ) {
                    std::cerr << "Error reading unicode ranges - end range" << std::endl;
                    exit( 1 );
                }
                pos = new_pos;
                lim = *pos++;
            }

            if ( lim == ',' ) {
                unicode_ranges.push_back( UnicodeRange { (uint32_t) range_start, (uint32_t) range_end } );
                continue;
            } else if ( lim == 0 ) {
                unicode_ranges.push_back( UnicodeRange { (uint32_t) range_start, (uint32_t) range_end } );
                return;
            } else {
                std::cerr << "Error reading unicode ranges - after-range-separator" << std::endl;
                exit( 1 );
            }
        }
    }

    void apply_unicode_ranges() {
        if ( unicode_ranges.empty() ) {
            sdf_atlas.allocate_unicode_range( 0x21, 0x7e );
            sdf_atlas.allocate_unicode_range( 0xffff, 0xffff );
        } else {
            for ( const UnicodeRange& ur : unicode_ranges ) {
                sdf_atlas.allocate_unicode_range( ur.start, ur.end );
            }
        }
    }
};
