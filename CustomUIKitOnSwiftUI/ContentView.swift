//
//  ContentView.swift
//  CustomUIKitOnSwiftUI
//
//  Created by Takeshi Tanaka on 2021/12/08.
//  Copyright © 2021 Goodpatch. All rights reserved.
    

import SwiftUI

struct ContentView: View {
    
    @State var items: [String] = []
    @State var newItem: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            BrickView(items: $items)
                .onSelectItem { selected in
                    print("selected: \(selected)")
                }
            HStack {
                TextField("Type new item...", text: $newItem, prompt: nil)
                    .textFieldStyle(.roundedBorder)
                Button("Add") {
                    items.append(newItem)
                    newItem = ""
                }
                .disabled(newItem.isEmpty)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static let words: [String] = {
        let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        return text.components(separatedBy: .whitespaces)
    }()
    
    static var previews: some View {
        ContentView(items: words, newItem: "")
    }
}
