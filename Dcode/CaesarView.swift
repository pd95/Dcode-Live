//
//  CaesarView.swift
//  Dcode
//
//  Created by Philipp on 21.11.21.
//

import SwiftUI

struct CaesarView: View {
    @AppStorage("ciphertext") private var ciphertext = ""
    @AppStorage("caesarShift") private var caesarShift = 0.0

    @AppStorage("removeSpaces") private var removeSpaces = false
    @AppStorage("reverseText") private var reverseText = false

    var shiftAmount: Int {
        Int(caesarShift)
    }

    var preparedCiphertext: String {
        var text = ciphertext.uppercased()
        if removeSpaces {
            text = text.replacingOccurrences(of: " ", with: "")
            print("removeSpaces")
        }

        if reverseText {
            text = String(text.reversed())
        }

        return text
    }

    var plaintext: String {
        var result = ""
        for letter in preparedCiphertext {
            if let index = Shared.alphabet.firstIndex(of: letter) {
                let newIndex = index + shiftAmount
                result.append(Shared.alphabet[newIndex % 26])
            } else {
                result.append(letter)
            }
        }
        return result
    }

    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $ciphertext)
                .font(.system(.body, design: .monospaced))

            Divider()

            Text("Shift by \(shiftAmount)")
            Slider(value: $caesarShift, in: 0...25, step: 1)

            Divider()

            TextEditor(text: .constant(plaintext))
                .font(.system(.body, design: .monospaced))
        }
        .padding()
    }
}

struct CaesarView_Previews: PreviewProvider {
    static var previews: some View {
        CaesarView()
    }
}
