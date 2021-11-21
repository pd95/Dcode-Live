//
//  ColumnarView.swift
//  Dcode
//
//  Created by Philipp on 21.11.21.
//

import SwiftUI
import Algorithms

struct ColumnarView: View {
    @AppStorage("ciphertext") private var ciphertext = ""
    @AppStorage("columnCount") private var columnCount = 2

    @AppStorage("removeSpaces") private var removeSpaces = false
    @AppStorage("reverseText") private var reverseText = false

    @State private var columnOrder = [ShiftAmount]()

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
        let input = preparedCiphertext
        let chunkLength = input.count / columnCount

        guard chunkLength > 0 else { return ""}

        let parts = input.chunks(ofCount: chunkLength).map(Array.init)
        guard let firstPart = parts.first else { return "" }

        var rearranged = ""
        for i in 0..<firstPart.count {
            for part in parts {
                if i < part.count {
                    rearranged.append(part[i])
                }
            }
        }

        let wordParts = rearranged.chunks(ofCount: columnCount).map(Array.init)

        var finalOutput = ""

        for part in wordParts {
            for amount in columnOrder {
                let amount = Int(amount.content) ?? 1

                if amount > 0 && amount <= part.count {
                    finalOutput.append(part[amount - 1])
                }
            }
        }

        return finalOutput
    }

    var columns = [
        GridItem(.adaptive(minimum: 80, maximum: 120))
    ]

    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $ciphertext)
                .font(.system(.body, design: .monospaced))

            Divider()

            Stepper("Columns: \(columnCount)", value: $columnCount, in: 2...25)
                .onChange(of: columnCount) { _ in adjustShifts() }

            LazyVGrid(columns: columns) {
                ForEach($columnOrder) { $number in
                    TextField("Shift", text: $number.content)
                }
            }

            Divider()

            TextEditor(text: .constant(plaintext))
                .font(.system(.body, design: .monospaced))
        }
        .padding()
        .onAppear(perform: adjustShifts)
    }

    func adjustShifts() {
        let difference = columnCount - columnOrder.count

        if difference > 0 {
            let newArray = (columnOrder.count..<columnCount).map { num in
                ShiftAmount(content: String(num+1))
            }

            columnOrder.append(contentsOf: newArray)
        } else if difference < 0 {
            columnOrder.removeLast(abs(difference))
        }
    }
}

struct ColumnarView_Previews: PreviewProvider {
    static var previews: some View {
        ColumnarView()
    }
}
