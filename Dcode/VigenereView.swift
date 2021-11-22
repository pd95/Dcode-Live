//
//  VigenereView.swift
//  Dcode
//
//  Created by Philipp on 21.11.21.
//

import SwiftUI
import Algorithms

struct VigenereView: View {
    @AppStorage("ciphertext") private var ciphertext = ""
    @AppStorage("removeSpaces") private var removeSpaces = false
    @AppStorage("reverseText") private var reverseText = false

    @AppStorage("keyLength") private var keyLength = 2
    @AppStorage("keyOffset") private var keyOffset = 0

    @State private var shiftNumbers = [ShiftAmount]()

    var columns = [
        GridItem(.adaptive(minimum: 80, maximum: 120))
    ]

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
        guard shiftNumbers.isEmpty == false else { return "" }

        var output = ""
        var count = 0

        for letter in preparedCiphertext {
            let shift = shiftNumbers[count]

            if let position = Shared.alphabet.firstIndex(of: letter) {
                let movement = Int(shift.content) ?? 0
                output.append(Shared.alphabet[(position + movement) % 26])
                count += 1

                if count == shiftNumbers.count {
                    count = 0
                }
            } else {
                output += String(letter)
            }
        }

        return output
    }

    var keyedText: String {
        String(preparedCiphertext.dropFirst(keyOffset).striding(by: keyLength))
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                TextEditor(text: $ciphertext)
                    .font(.system(.body, design: .monospaced))

                Divider()
                DistancesView(text: preparedCiphertext)
                Divider()

                Stepper("Key length: \(keyLength)", value: $keyLength, in: 2...25)
                    .onChange(of: keyLength) { _ in adjustShifts() }

                LazyVGrid(columns: columns) {
                    ForEach($shiftNumbers) { $number in
                        TextField("Shift", text: $number.content)
                    }
                }

                Divider()

                TextEditor(text: .constant(plaintext))
                    .font(.system(.body, design: .monospaced))
            }
            .padding()

            VStack {
                FrequencyView(text: keyedText)
                Spacer()

                Stepper("Key offset: \(keyOffset + 1)", value: $keyOffset, in: 0...keyLength - 1)
            }
            .padding()
        }
        .padding()
        .onAppear(perform: adjustShifts)
    }

    func adjustShifts() {
        let difference = keyLength - shiftNumbers.count

        if difference > 0 {
            let newArray = (0..<difference).map { _ in ShiftAmount() }
            shiftNumbers.append(contentsOf: newArray)
        } else {
            shiftNumbers.removeLast(abs(difference))
        }
    }
}

struct VigenereView_Previews: PreviewProvider {
    static var previews: some View {
        VigenereView()
    }
}
