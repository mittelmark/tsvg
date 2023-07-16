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



