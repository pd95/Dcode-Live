//
//  ContentView.swift
//  Dcode
//
//  Created by Philipp on 21.11.21.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("removeSpaces") private var removeSpaces = false
    @AppStorage("reverseText") private var reverseText = false
    @SceneStorage("selectedTab") private var selectedTab = "Caesar"

    var body: some View {
        VStack {
            TabView {
                CaesarView()
                    .tabItem {
                        Text("Caesar")
                    }
                    .tag("Caesar")
            }
            .padding()

            HStack {
                Toggle("Remove spaces", isOn: $removeSpaces)
                Toggle("Reverse text", isOn: $reverseText)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
