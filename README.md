# Kristin
[![Code Climate](https://codeclimate.com/github/ricn/kristin.png)](https://codeclimate.com/github/ricn/kristin)
[![Build Status](https://travis-ci.org/ricn/kristin.png?branch=master)](https://travis-ci.org/ricn/kristin)

Convert PDF docs to beautiful HTML files without losing text or format. This gem uses pdf2htmlEX to do the conversion.

## Installation

Add this line to your application's Gemfile:

    gem 'kristin'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kristin

## Usage

You need to install [pdf2htmlEX](https://github.com/coolwanglu/pdf2htmlEX) on your system to use this gem.

```ruby
require 'kristin'

# Converts document.pdf to document.html
# This requires that the pdf2htmlEX command is present in your PATH.
Kristin.convert('document.pdf', 'document.html')

# You can also convert a source file directly from an URL
Kristin.convert('http://myserver.com/123/document.pdf', 'document.html')

# You can also specify options for fine grained conversion:
Kristin.convert('document.pdf', 'document.html', { first_page: 2, last_page: 4, hdpi: 72, vdpi: 72})

# Available options:

# process_outline - show outline in HTML. Default: true
# first_page - first page to convert. Default: 1
# last_page - last page to convert. Default: 2147483647
# hdpi - horizontal resolution for graphics in DPI. Default: 144
# vdpi - vertical resolution for graphics in DPI. Default: 144
# zoom - zoom ratio. Default: 1.0
# fit_width - fit width (pixels). Example: fit_width: 1024 
# fit_height - fit height (pixels). Example: fit_height: 1024   
# split_pages - if true, output is split into pages. Example: split_pages: true

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
