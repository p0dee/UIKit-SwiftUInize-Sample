//
//  BrickView.swift
//  CustomUIKitOnSwiftUI
//
//  Created by Takeshi Tanaka on 2021/12/08.
//  Copyright © 2021 Goodpatch. All rights reserved.
    
import Foundation
import SwiftUI

struct BrickView: UIViewRepresentable {
    @Binding private var items: [String]

    private var onSelectItemCallback: ((String) -> Void)?

    init(items: Binding<[String]>) {
        _items = items
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> BrickCollectionView {
        // setup coodinator
        let ret = BrickCollectionView()
        ret.delegate = context.coordinator
        ret.dataSource = context.coordinator
        return ret
    }

    func updateUIView(_ brickView: BrickCollectionView, context: Context) {
        context.coordinator.items = items
        context.coordinator.onSelectItemCallback = onSelectItemCallback
        brickView.reloadData()
    }

    /// アイテムが選択された際のコールバックを指定します
    func onSelectItem(callback: @escaping (String) -> Void) -> Self {
        var ret = self
        ret.onSelectItemCallback = callback
        return ret
    }

    class Coordinator: NSObject, BrickViewDataSource, BrickViewDelegate {
        var parent: BrickView
        var items: [String] = []

        var onSelectItemCallback: ((String) -> Void)?

        init(_ brickView: BrickView) {
            self.parent = brickView
        }
        
        func numberOfItems(_ brickView: BrickCollectionView) -> Int {
            return items.count
        }
        
        func brickView(_ brickView: BrickCollectionView, itemAt index: Int) -> String {
            guard index < items.count else { return "" }
            return items[index]
        }
        
        func brickViewDidTapItem(_ brickView: BrickCollectionView, item: String) {
            onSelectItemCallback?(item)
        }
    }
}

// MARK: - Preview

struct AppointmentTimePickerWrapper_Previews: PreviewProvider {
    
    static let words: [String] = {
        let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        return text.components(separatedBy: .whitespaces)
    }()
    
    static var previews: some View {
        Group {
            BrickView(items: .constant(words))
        }
    }
}
