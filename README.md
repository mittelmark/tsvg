[![license](https://img.shields.io/badge/license-BSD-lightgray.svg)](https://opensource.org/license/bsd)
[![Release](https://img.shields.io/github/v/release/mittelmark/tsvg.svg?label=current+release)](https://github.com/mittelmark/tsvg/releases)
![Downloads](https://img.shields.io/github/downloads/mittelmark/tsvg/total)
![Commits](https://img.shields.io/github/commits-since/mittelmark/tsvg/latest)
[![Docu Package](https://img.shields.io/badge/Docu-Package-blue)](http://htmlpreview.github.io/?https://github.com/mittelmark/tmdoc/blob/master/tsvg/tsvg.html)

# tsvg - Thingy SVG writer

Tcl  package  to create SVG files easily.

`tsvg` is a pure Tcl package  to create svg image files with a syntax
close to Tcl and to SVG. Using the python tool *cairosvg*  writing PDF and PNG
files is as well possible. Since version 0.4.0 as well  *rsvg-convert*  can be
used instead.

## Description

The package  provides  one command  tsvg which can hold  currently  just a
single SVG code collection.  All commands  will be evaluated  within the tsvg
namespace,  all unknown  methods  will be forwarded to the standard  tsvg::tag
method  and  produce  svg code out of them. So `tsvg  dummy  x="20"  hello` will
produce:  `<dummy  x="20">hello</dummy>`  as  output.  If the tool  `cairosvg`  is
installed  as well PNG and PDF files can be written  since  version  0.3.0. To
install `cairosvg` use for instance the Python package installer like this

```
$ pip3 install cairosvg --user
```
## Example

Here the typical "Hello World!" example.

```tcl
package require tsvg
tsvg set width 100
tsvg set height 100
tsvg circle cx 50 cy 50 r 45 stroke black stroke-width 2 fill salmon
tsvg text x 29 y 45 Hello
tsvg text x 27 y 65 World!
tsvg write hello-world.svg
```

![](https://user-images.githubusercontent.com/75636/253786943-d1bc2c26-729c-4e3e-bab9-ee2f525fd9f7.svg)

## Links

* Manual [https://htmlpreview.github.io/?https://github.com/mittelmark/tsvg/blob/master/tsvg/tsvg.html](https://htmlpreview.github.io/?https://github.com/mittelmark/tsvg/blob/master/tsvg/tsvg.html)
* Download [https://github.com/mittelmark/tsvg/archive/refs/heads/main.zip](https://github.com/mittelmark/tsvg/archive/refs/heads/main.zip)
* Wikipage at Tclers Wiki for discussion [https://wiki.tcl-lang.org/page/tsvg](https://wiki.tcl-lang.org/page/tsvg](https://wiki.tcl-lang.org/page/tsvg)
* Mozilla SVG Element Reference [https://developer.mozilla.org/en-US/docs/Web/SVG/Element](https://developer.mozilla.org/en-US/docs/Web/SVG/Element)

## Installation

Download the Zip archive, link above, and place it into a folder  belonging to
your Tcl  package path.

Alternatively you can just download the single file Tcl-script
[https://raw.githubusercontent.com/mittelmark/tsvg/main/tsvg/tsvg.tcl](https://raw.githubusercontent.com/mittelmark/tsvg/main/tsvg/tsvg.tcl)
and source it into your Tcl application.


## Changes

* __2021-08-28 Version 0.1__ - with docu uploaded to GitHub
* __2021-08-31 Version 0.2__ - fix for the header line
* __2021-12-01 Version 0.3.0__ - adding write option for PNG and PDF files using cairosvg 
* __2023-07-15 Version 0.3.1__ - fixing height issue, adding combine files method, own repo, License now BSD
* __2026-01-02 version 0.4.0__ - support for rsvg-convert in addtion to cairosvg to convert to pdf and png

## License

BSD-3-Clause 

## Author and Copyright

Detlef Groth, University of Potsdam, Germany

