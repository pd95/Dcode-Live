# Dcode

A little helper app for macOS to interactively decipher cipher texts. Implemented along the
[HWS+](https://www.hackingwithswift.com/plus/) live stream by Paul Hudson.

Supports you in deciphering the following "simple" ciphers:

- [Caesar](https://en.wikipedia.org/wiki/Caesar_cipher)
- [Columnar](https://en.wikipedia.org/wiki/Transposition_cipher#Columnar_transposition) (a transposition cipher)
- [Vigenère](https://en.wikipedia.org/wiki/Vigenère_cipher)

The implementation shows

- simple SwiftUI macOS app implementing above ciphers
- distance analysis and frequency analysis in Swift
- use of [Swift Algorithms](https://github.com/apple/swift-algorithms) package:
  - chunk data using `chunks(ofCount:)`
  - windowing using `windows(ofCount:)`
  - uniquing using `uniqued()`
  - striding using `striding(by:)`

You can find some cipher texts in the `Examples` folder.
