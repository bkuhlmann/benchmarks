# Benchmarks

[![Code Climate Maintainability](https://api.codeclimate.com/v1/badges/03890a29f08c29966b1b/maintainability)](https://codeclimate.com/github/bkuhlmann/benchmarks/maintainability)
[![Code Climate Test Coverage](https://api.codeclimate.com/v1/badges/03890a29f08c29966b1b/test_coverage)](https://codeclimate.com/github/bkuhlmann/benchmarks/test_coverage)
[![Circle CI Status](https://circleci.com/gh/bkuhlmann/benchmarks.svg?style=svg)](https://circleci.com/gh/bkuhlmann/benchmarks)

A collection of Ruby benchmarks.

<!-- Tocer[start]: Auto-generated, don't remove. -->

## Table of Contents

  - [Features](#features)
  - [Screencasts](#screencasts)
  - [Requirements](#requirements)
  - [Setup](#setup)
  - [Usage](#usage)
  - [Tests](#tests)
  - [Versioning](#versioning)
  - [Code of Conduct](#code-of-conduct)
  - [Contributions](#contributions)
  - [License](#license)
  - [History](#history)
  - [Credits](#credits)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

## Features

- Uses [Benchmark IPS](https://github.com/evanphx/benchmark-ips) to calculate CPU/speed results.

## Screencasts

[![asciicast](https://asciinema.org/a/224800.png)](https://asciinema.org/a/224800)

## Requirements

1. [Ruby 2.6.x](https://www.ruby-lang.org)

## Setup

Open a terminal window and execute one of the following depending on your version preference:

Current Version (stable):

    git clone https://github.com/bkuhlmann/benchmarks.git
    cd benchmarks
    git checkout 0.1.0

Master Version (unstable):

    git clone https://github.com/bkuhlmann/benchmarks.git
    cd benchmarks

## Usage

Every benchmark is executable. To run, copy a benchmark file path and pass it to Ruby. Example:

    ruby scripts/ruby/strings/split.rb

## Tests

To test, run:

    bundle exec rake

## Versioning

Read [Semantic Versioning](https://semver.org) for details. Briefly, it means:

- Major (X.y.z) - Incremented for any backwards incompatible public API changes.
- Minor (x.Y.z) - Incremented for new, backwards compatible, public API enhancements/fixes.
- Patch (x.y.Z) - Incremented for small, backwards compatible, bug fixes.

## Code of Conduct

Please note that this project is released with a [CODE OF CONDUCT](CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.

## Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

## License

Copyright 2019 [Alchemists](https://www.alchemists.io).
Read [LICENSE](LICENSE.md) for details.

## History

Read [CHANGES](CHANGES.md) for details.
Built with [Gemsmith](https://github.com/bkuhlmann/gemsmith).

## Credits

Developed by [Brooke Kuhlmann](https://www.alchemists.io) at
[Alchemists](https://www.alchemists.io).
