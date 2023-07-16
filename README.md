# tsvg - Thingy SVG writer

Tcl  package  to create SVG files easily.

`tsvg` is a pure Tcl package  to create svg image  files with a syntax
close to Tcl and to SVG. Using the python tool *cairosvg*  writing PDF and PNG
files is as well possible.

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

## Installation

Download the Zip archive, link above, and place it into a folder  belonging to
your Tcl  package path.

## License

BSD-3-Clause 

## Author and Copyright

Detlef Groth, University of Potsdam, Germany



