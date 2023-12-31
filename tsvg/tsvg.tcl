#!/usr/bin/env tclsh
##############################################################################
#  Created By    : Dr. Detlef Groth
#  Created       : Sat Aug 28 09:52:16 2021
#  Last Modified : <230716.0919>
#
#  Description	 : Minimal Tcl package to write SVG code and write it to 
#                  a file.
#
#  Notes         : TODO - start and end flags to open and close a tag (done)
#                       - text if tk is loaded (done)
#                       - group_start, group_end tag (done)
#                       - error catching (done)
#                       - tsvg plugin embed (partially)
#                       - options with dashes -x 10 -y 20 (done)
#
#  History       : 
#                - 2021-08-28 - Version 0.1
#                - 2021-08-30 - Version 0.2.0 automatic figures, error shown in document
#                - 2021-12-01 - Version 0.3.0 adding export to png and pdf using cairosvg 
#                - 2023-07-15 - Version 0.3.1 
#                                  - fix for height of images 
#                                  - making viewbox optional  
#                                  - adding combineSVG Method    
#	
##############################################################################
#
#  Copyright (c) 2021-2023 Detlef Groth, Germany
# 
#  License: MIT 
# 
##############################################################################

#' ---
#' title: tsvg package 0.3.1
#' author: Detlef Groth, Germany
#' date: 2023-07-16
#' tsvg:
#'     eval: 1
#' tcl:
#'     eval: 1
#' ---
#' 
#' ## NAME 
#' 
#' _tsvg_ - Thingy SVG writer - package to create svg image files with a syntax close to Tcl and to SVG.
#' 
#' ## SYNOPSIS
#' 
#' ```
#' package require tsvg
#' tsvg set width 100
#' tsvg set height 100
#' # Tcl like syntax without hyphens
#' tsvg circle cx 50 cy 50 r 45 stroke black stroke-width 2 fill salmon
#' tsvg text x 29 y 45 Hello
#' tsvg text x 27 y 65 World!
#' tsvg write hello-world.svg
#' tsvg write hello-world.pdf # needs cairosvg
#' tsvg write hello-world.png # needs cairosvg
#' tsvg set code ""
#' # Tcl like syntax with hyphens
#' tsvg circle -cx 50 -cy 50 -r 45 -stroke black -stroke-width 2 -fill salmon
#' tsvg text -x 29 -y 45 Hello
#' tsvg text -x 27 -y 65 World!
#' tsvg write hello-world.svg
#' # SVG like syntax
#' tsvg circle cx="50" cy="50" r="45" stroke="black" \
#'    stroke-width="2" fill="light blue"
#' tsvg text x="29" y="45" Hello
#' tsvg text x="27" y="65" World!
#' ```
#' 
#' ## DESCRIPTION
#' 
#' The package provides one command _tsvg_ which can hold currently just a single 
#' svg code. All commands will be evaluated within the tsvg namespace, all unknown 
#' methods will be forwarded to the standard `tsvg::tag` method and produce 
#' svg code out of them. So _tsvg dummy x="20" hello_ will produce:
#' 
#' ```
#' <dummy x="20">hello</dummy>
#' ```
#' 
#' ## VARIABLES
#' 
#' The following public variables can be modified using the set command like so: _tsvg set varname_ value:
#' 
#' > - _code_ - the variable collecting the svg code, usually you will only set this variable by hand to remove all existing svg code after doing an image by calling _tsvg set code ""_.
#'   - _footer_ - the standard SVG-XML footer, should be usually not changed.
#'   - _header_ - the standard SVG-XML header, should be usually not changed.
#'   - _height_ - the image height used for writing out the svg file, default: 100
#'   - _width_ - the image width used for writing out the svg file, default: 100
#' 
#' ## METHODS
#' 
#' The following methods are implemented:
#' 
#' __self__
#' 
#' > just an `interp alias` for `namespace current`
#' 
#' __tsvg combine__ _inputFiles ?outputFile?_
#' 
#' > Combines several SVG files side by side, usually the should have the same height. See the demo which combines two simple "Hello World!" files
#'
#' __tsvg demo__ 
#' 
#' > Writes the "Hello World!" string into a file hello-world.svg in the current directory.
#'
#' __tsvg figure__ _filename_ _width_ _height_
#' 
#' > Writes the current svg code into the given filename with the 
#'   given width and height settings. 
#' 
#' __tsvg inline__ _?viewbox?_
#' 
#' > Returns the SVG code as inline SVG with or without the svg viewBox code which can be directly embedded within HTML pages. So the xml header is here missing.
#' 
#' __tsvg readSvgDimension__ _filename_
#' 
#' > Returns the SVG dimensions for width and heigth given as an key-value list
#' 
#' __tsvg write__ _filename_
#' 
#' > Writes the current svg code into the given filename with the current width and height settings. 
#'   Supported file extensions are *.svg* or if the tool *cairosvg* is installed as well *.png* and *.pdf*.
#' 
#' __tsvg tag__ _tagname_ _args_
#' 
#' > Creates the given tagname and adds all remaining arguments as attibutes if they come 
#'   in pairs. If the numer of arguments is odd, the last argument will be placed within 
#'   the XML tags.
#'
#' The following functions are just implemented for avoiding name clashes because some existing Tcl/Tk 
#' functions have the same name. They should be not used directly.
#' 
#' > - _tsvg text_
#' 
#' The following function(s) are private and should not be used directly by the user of
#' this package.
#' 
#' > - _tsvg TagFix_
#' 
#' ## EXAMPLES
#'  
#' ### Hello World  
#' 
#' The typical Hello World example:
#'
#' ```{.tsvg label=hello-world}
#' tsvg set width 100
#' tsvg set height 100
#' tsvg circle cx 50 cy 50 r 45 stroke black stroke-width 2 fill salmon
#' tsvg text x 29 y 45 Hello
#' tsvg text x 27 y 65 World!
#' tsvg write images/hello-world.svg
#' ```
#' 
#' The typical Hello World example but this time with hyphens to easier indicate the arguments:
#'
#' ```{.tsvg label=hello-world2}
#' tsvg set code "" ;# clear 
#' tsvg circle -cx 50 -cy 50 -r 45 -stroke black -stroke-width 2 -fill skyblue
#' tsvg text -x 29 -y 45 Hello
#' tsvg text -x 25 -y 65 World2!
#' tsvg write images/hello-world2.svg
#' ```
#' 
#' Since version 0.3.1 there is as well a method `tsvg combine` wich can be used to combine two ore more SVG files side by side.
#' 
#' ```{.tcl echo=false results=hide}
#' source tsvg.tcl
#' ```
#'
#' ```{.tsvg label=combined results=asis}
#' tsvg combine [list images/hello-world.svg images/hello-world2.svg]
#' ```
#' 
#' ### Pdf and Png writing
#' 
#' Since version 0.3.0 writing of PNG and PDF files is as well possible if the command line tool *cairosvg* is installed. You can install this tool either using your package manager, or if yo do not have administrator rights as ordinary user using the Python package installer like this:
#'
#' ```
#' pip3 install cairosvg --user 
#' ```  
#' 
#' If *cairosvg* is installed you can as well write PNG and PDF files. 
#' As this is an HTML document let's create a PNG file and display it thereafter, we add a red circle before:
#' 
#' ```{.tsvg label=test results=hide fig=true ext=png}
#' tsvg set code "" ;# clear 
#' tsvg circle -cx 50 -cy 50 -r 42 -stroke red -stroke-width 7 -fill none
#' tsvg write hello-world2.png
#' ```
#' 
#' 
#'  
#' For inclusion of images into LaTeX documents I would recommend using the PDF output format.
#' 
#' To continue with an other image you have first to clean up the previous image:
#' 
#' ```{.tsvg label=basic-shapes}
#' tsvg set code "" ;# clear 
#' tsvg set width 200 ;# new size as on the webpage
#' tsvg set height 250 
#' tsvg rect x="10" y="10" width="30" height="30" stroke="black" fill="transparent" stroke-width="5"
#' tsvg rect x="60" y="10" rx="10" ry="10" width="30" height="30" stroke="black" fill="transparent" stroke-width="5"
#' tsvg circle cx="25" cy="75" r="20" stroke="red" fill="transparent" stroke-width="5"
#' tsvg ellipse cx="75" cy="75" rx="20" ry="5" stroke="red" fill="transparent" stroke-width="5"
#' tsvg line x1="10" x2="50" y1="110" y2="150" stroke="orange" stroke-width="5"
#' tsvg polyline points="60 110 65 120 70 115 75 130 80 125 85 140 90 135 95 150 100 145" \
#'     stroke="orange" fill="transparent" stroke-width="5"
#' tsvg polygon points="50 160 55 180 70 180 60 190 65 205 50 195 35 205 40 190 30 180 45 180" \
#'     stroke="green" fill="transparent" stroke-width="5"
#' tsvg path d="M20,230 Q40,205 50,230 T90,230" fill="none" stroke="blue" stroke-width="5"
#' tsvg write basic-shapes.svg
#' ```
#' 
#' Nesting of elements can be achieved as well by adding *_start* and *_end* at the 
#' end of the tag, here an example for a group using the tag _g_.
#'
#' ```{.tsvg label=group-circles}
#' tsvg set code ""
#' tsvg set width 150
#' tsvg set height 150
#' tsvg g_start fill="white" stroke="green" stroke-width="5"
#' tsvg circle cx="40" cy="40" r="35"
#' tsvg circle cx="60" cy="60" r="25"
#' tsvg g_end
#' tsvg write group-circles.svg
#' ```
#' 
#' ### Embedding SVG code into HTML pages
#' 
#' The _tsvg_ object as well offers a _inline_ method which returns SVG code ready to be embed directly within HTML pages.
#' 
#' ```{.tsvg results=show fig=false}
#' tsvg circle cx="70" cy="70" r="15" stroke="blue" fill="white" stroke-width="5"
#' tsvg write inline.svg
#' tsvg inline
#' ```
#' 
#' ![](inline.svg)
#'
#' 
#' ### Information about SVG files
#' 
#' Since version 0.3.1 there is as well a command - getSvgDimensions` to get the width and height 
#' of an SVG file.
#' 
#' ```{.tcl}
#' puts [tsvg getSvgDimensions inline.svg]
#' ```
#' 
#' ### Extending the tsvg command
#' 
#' If you need to extend the package or to fix nameclashes with other packages you can 
#' just write your own procedures. For instance if one package you are working with would
#' import an _rect_ command you would call this using the _tsvg rect_ command to fix this issue you just have to  implement your own _tsvg rect_ procedure like this:
#' 
#' ```
#' tsvg proc rect {args} {
#'     set self [self]
#'     $self tag rect {*}$args
#' }
#' ```
#' 
#' That way you can as well create your own function which perform more complex SVG element creations. Here an example:
#' 
#' ```{.tsvg label=logo}
#' tsvg proc logo_tsvg {{filename ""}} {
#'     tsvg set code ""
#'     tsvg set width 100
#'     tsvg set height 60
#'     tsvg rect x 0 y 0 width 100 height 100 fill #F64935
#'     tsvg text x 20 y 40 style "font-size:24px;fill:blue;" tSVG
#'     if {$filename ne ""} {
#'        tsvg write $filename
#'     }
#' }
#' tsvg logo_tsvg logo.svg
#' ```
#' 
#'
#' ### Documentation extraction
#' 
#' The documentation for this HTML file was created using the pandoc-tcl-filter and the filter for the tsg package as follows:
#'
#' ```
#'  perl -ne "s/^#' ?(.*)/\$$1/ and print " lib/tsvg/tsvg.tcl > tsvg.md
#'  pandoc tsvg.md -s  \
#'     --metadata title="tsvg package documentation"  \
#'     -o tsvg.html  --filter pandoc-tcl-filter.tcl \
#'     --css mini.css --toc
#'  htmlark -o lib/tsvg/tsvg.html tsvg.html
#' ```
#' 
#' ## CHANGELOG
#' 
#' * 2021-08-28 Version 0.1 with docu uploaded to GitHub
#' * 2021-08-31 Version 0.2 fix for the header line
#' * 2021-12-01 Version 0.3.0 adding write option for PNG and PDF files using cairosvg 
#' * 2023-07-15 Version 0.3.1 fixing height issue, adding combine files method, own repo, License now BSD
#'     
#' ## SEE ALSO
#' 
#' * [Readme.html](../../Readme.html) - more information about pandoc Tcl filters
#' * [Tclers Wiki page](https://wiki.tcl-lang.org/page/tsvg) - place for discussion
#' 
#' ## AUTHOR
#' 
#' Detlef Groth, Caputh-Schwielowsee, Germany, detlef(_at_)dgroth(_dot_).de
#' 
#' ## LICENSE
#' 
#' ```
#' BSD 3-Clause License
#' 
#' Copyright (c) 2023, D Groth
#' 
#' Redistribution and use in source and binary forms, with or without
#' modification, are permitted provided that the following conditions are met:
#' 
#' 1. Redistributions of source code must retain the above copyright notice, this
#' list of conditions and the following disclaimer.
#' 
#' 2. Redistributions in binary form must reproduce the above copyright notice,
#' this list of conditions and the following disclaimer in the documentation
#' and/or other materials provided with the distribution.
#' 
#' 3. Neither the name of the copyright holder nor the names of its
#' contributors may be used to endorse or promote products derived from
#' this software without specific prior written permission.
#' 
#' THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#' IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#' DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
#' FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#' DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#'          SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#' CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#' OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#' OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#' ```
#' 


package provide tsvg 0.3.1

# minimal OOP
proc thingy name {
    proc $name args "namespace eval $name \$args"
} 

# does now work!
interp alias {} self {} namespace current 

;# our object
thingy tsvg

;# some variables
tsvg set code "" ;# the svg code
tsvg set header {<?xml version="1.0" encoding="utf-8" standalone="yes"?>
    <svg version="1.1" xmlns="http://www.w3.org/2000/svg" height="__HEIGHT__" width="__WIDTH__">}    
tsvg set footer {</svg>}
tsvg set width 100
tsvg set height 100

# the main function of the package
# creating the SVG code, must be not used directly
# all unkown methods are forwarded properly to the 
# tag method
tsvg proc tag {args} {
    set self [self]
    variable code
    set args [$self TagFix $args]
    set tag [lindex $args 0]
    set args [lrange $args 1 end]
    set sflag false
    if {[regexp {_end} $tag]} {
        append code "</[regsub {_end} $tag {}]>"
        return
    }
    if {[regexp {_start} $tag]} {
        set tag [regsub {_start} $tag ""]
        set sflag true
    }
    set ret "\n<$tag"
    set val ""
    
    # new check if attr="val" syntax  
    if {[regexp {=} [lindex $args 0]]} {
        set nargs [list]
        foreach kval $args {
            set idx [string first = $kval]
            set key [string range $kval 0 $idx-1]
            set val [string range $kval $idx+2 end-1]
            lappend nargs $key
            lappend nargs $val
        }
        set args $nargs
    } 
    # end of new check
    foreach {key val} $args {
       if {$val eq ""} {
           append ret ">\n$key\n"
           if {!$sflag} {
               append ret "</$tag>\n"
           }
           break
       } else {
           if {[string index $key 0] eq "-"} {
               set key [string range $key 1 end]
           }
           append ret " $key=\"$val\""
       }
    }
    if {$val ne ""} {
        if {$sflag} {
            append ret ">"
        } else {
            append ret " />\n"
        }
    }
    append code $ret
}

# private method to collect arguments like a="1 2 3 4" as {a="1 2 3 4"}
# allowing a more SVGish syntax
tsvg proc TagFix {args} { 
    set nargs [list]
    set args {*}$args
    set flag false
    for {set i 0} {$i < [llength $args]} {incr i 1} {
        if {!$flag && [regexp {=".+"} [lindex $args $i]]} { ;#"
            lappend nargs [lindex $args $i]
        } elseif {!$flag && [regexp {="} [lindex $args $i]]} { ;#"
            set flag true
            set qarg "[lindex $args $i] "
        } elseif {$flag && [regexp {"} [lindex $args $i]]} { ;#"
            set flag false
            append qarg "[lindex $args $i]"
            lappend nargs $qarg
        } elseif {$flag} {
            append qarg " [lindex $args $i]"
        } else {
            lappend nargs [lindex $args $i]
        }
    }
    return $nargs
}

namespace eval tsvg {
    namespace unknown tsvg::tag
}

# SVG code which can be embedded directly into web pages
tsvg proc inline {{viewbox true}} {
    set self [self]
    if {$viewbox} {
        set ret "<svg viewBox=\"0 0 [$self set width] [$self set height]\" width=\"[$self set width]\" height=\"[$self set height]\" xmlns=\"http://www.w3.org/2000/svg\">\n"
    } else {
        set ret ""
    }
    append ret [$self set code]
    if {$viewbox} {
        append ret "\n</svg>"
    }
    return $ret
}

# deprecated
tsvg proc viewBox {} {
    set self [self]
    return [$self inline]
}

# workaround to not call Tk's text command
tsvg proc text {args} {
    set self [self]
    $self tag text {*}$args
}
# write out svg code to file
tsvg proc write {filename} {
    variable width
    variable height
    variable header
    variable footer
    variable code
    set ext [file extension $filename]
    if {$ext in [list .pdf .png]} {
        if {[auto_execok cairosvg] eq ""} {
            error "tsvg conversion to $ext needs the cairosvg tool"
        }
    } elseif {$ext ne ".svg"}  {
        error "Unkown file extension, know file extensions are: .svg, .pdf, .png"
    }
    set out [open [file rootname ${filename}].svg w 0600]
    set head [regsub {__HEIGHT__} $header $height]
    set head [regsub {__WIDTH__} $head $width]
    puts $out $head
    puts $out $code
    puts $out $footer
    close $out
    if {$ext in [list .pdf .png]} {
       exec cairosvg [file rootname $filename].svg -o $filename -W $width -H $height
    } 
}

# justify width and height without using set before
tsvg proc figure {filename width height args} {
    set self [self]
    $self set width $width
    $self set height $height
    $self write $filename.svg
    return $filename.svg
}

tsvg proc combine {inputFiles {outputFile ""}} {
    set self [self]
    set combinedSvgCode ""
    set xTranslate 0
    foreach inputFile $inputFiles {
        set svgCode [$self ReadSvgFile $inputFile]
        array set svgDimensions [$self getSvgDimensions $inputFile]
        append combinedSvgCode "<g transform=\"translate(${xTranslate}, 0)\">\n${svgCode}\n</g>\n"
        set xTranslate [expr {$xTranslate + $svgDimensions(width)}]
    }
    $self set code $combinedSvgCode
    $self set width $xTranslate
    $self set height $svgDimensions(width)
    #puts $combinedSvgCode
    if {$outputFile ne ""} {
        $self write $outputFile
    } else {
        $self write test.svg
        return $combinedSvgCode
    }
}

tsvg proc ReadSvgFile {filename} {
    if {![file exists $filename]} {
        error "Error: File '$filename' does not exists!"
    }
    set file [open $filename r]
    set content ""
    while {[gets $file line] >= 0} {
        if {![regexp {<\?xml} $line] && ![regexp {<svg} $line] && ![regexp {</svg>} $line]} {
            append content "$line\n"
        }
        
    }
    close $file
    return $content
}

tsvg proc getSvgDimensions {filename} {
    if {![file exists $filename]} {
        error "Error: File '$filename' does not exists!"
    }

    set file [open $filename r]
    set content [read $file]
    close $file
    set width [lindex [regexp -inline { width="(\d+)"} $content]  end]
    set height [lindex [regexp -inline { height="(\d+)"} $content] end]
    return [list width $width height $height]
}


# just a short demo 
tsvg proc demo {} {
    set self [self]
    $self circle cx 50 cy 50 r 45 stroke black stroke-width 2 fill salmon
    $self text x 29 y 45 Hello
    $self text x 27 y 65 World!
    #$self figure 
    $self write hello-world.svg
    puts "Writing file hello-world.svg done!"
    $self set code ""
    $self circle cx 50 cy 50 r 45 stroke black stroke-width 2 fill skyblue
    $self text x 29 y 45 Hello
    $self text x 23 y 65 World2!
    #$self figure 
    $self write hello-world2.svg
    puts "Writing file hello-world2.svg done!"
    $self combine [list hello-world.svg hello-world2.svg] combined.svg
    $self set code ""
    $self set width 200 
    $self set height 250 
    $self rect x="10" y="10" width="30" height="30" stroke="black" fill="transparent" stroke-width="5"
    $self rect x="60" y="10" rx="10" ry="10" width="30" height="30" stroke="black" fill="transparent" stroke-width="5"
    $self circle cx="25" cy="75" r="20" stroke="red" fill="transparent" stroke-width="5"
    $self ellipse cx="75" cy="75" rx="20" ry="5" stroke="red" fill="transparent" stroke-width="5"
    $self line x1="10" x2="50" y1="110" y2="150" stroke="orange" stroke-width="5"
    $self polyline points="60 110 65 120 70 115 75 130 80 125 85 140 90 135 95 150 100 145" \
           stroke="orange" fill="transparent" stroke-width="5"
    $self polygon points="50 160 55 180 70 180 60 190 65 205 50 195 35 205 40 190 30 180 45 180" \
          stroke="green" fill="transparent" stroke-width="5"
    $self path d="M20,230 Q40,205 50,230 T90,230" fill="none" stroke="blue" stroke-width="5"
    $self write basic-shapes.svg
    puts "Writing file basic-shapes.svg done!"
    $self write basic-shapes.png
    puts "Writing file basic-shapes.png done!"
    $self write basic-shapes.pdf
    puts "Writing file basic-shapes.pdf done!"
}

                   
if {[info exists argv0] && $argv0 eq [info script] && [regexp tsvg.tcl $argv0]} {
    #package require Tk
    tsvg demo
}

