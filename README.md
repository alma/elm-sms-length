# elm-sms-length lib

[![Build Status](https://travis-ci.org/alma/elm-sms-length.svg?branch=master)](https://travis-ci.org/alma/elm-sms-length)


## Example

```elm
import SmsLength

SmsLength.charsUsed "Hello World!"
12

SmsLength.charsAvailable "Hello World!"
160

SmsLength.charsUsed "Hello World 🎅"
14

SmsLength.charsAvailable "Hello World 🎅"
70

```

## Contributing

We're happy to receive any feedback and ideas for about additional features.
Any input and pull requests are very welcome and encouraged. If you'd like to
help or have ideas, get in touch with us on github by opening an issue!
