//
//  DistancesView.swift
//  Dcode
//
//  Created by Philipp on 21.11.21.
//

import SwiftUI
import Algorithms

struct DistancesView: View {
    let text: String

    var body: some View {
        Text(distances)
    }

    var distances: String {
        let input = String(text.unicodeScalars.filter(CharacterSet.alphanumerics.contains))

        let letterPairs = Set(input.windows(ofCount: 2))

        let results = letterPairs.map { pair in
            PairCounter(
                letters: pair,
                segments: input.components(separatedBy: pair).dropFirst().dropLast()
            )
        }

        let top5 = results.sorted().prefix(5)

        var output = [String]()

        for match in top5 {
            let distances = Array(match.segments.map { $0.count + 2 }.uniqued())

            let ourFactors = factors(for: distances)
            var counts = [Int: Int]()

            for factor in ourFactors {
                counts[factor, default: 0] += 1
            }

            let filteredCounts = counts
                .filter { $0.value > 1 }
                .sorted { first, second in
                    if first.value == second.value {
                        return first.key > second.key
                    } else {
                        return first.value > second.value
                    }
                }

            var factorCounts = ""

            for count in filteredCounts {
                factorCounts += "\(count.value)x\(count.key) "
            }

            output.append("\(match.letters): \(factorCounts)")
        }

        return output.joined(separator: "\n")
    }

    func factors(for numbers: [Int]) -> [Int] {
        let max = numbers.max() ?? 2

        let allFactors = numbers.map { number in
            (2...max).filter { number.isMultiple(of: $0) }
        }

        return Array(allFactors.joined())
    }
}

struct DistancesView_Previews: PreviewProvider {
    static var previews: some View {
        DistancesView(text: "ABC")
    }
}
