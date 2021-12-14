//
//  GradientView.swift
//  CustomUIKitOnSwiftUI
//
//  Created by Takeshi Tanaka on 2021/12/08.
//  Copyright © 2021 Goodpatch. All rights reserved.
    
import UIKit

final class GradientView: UIView {
    
    let colors: [UIColor] = [.systemRed, .systemBlue]
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let clrs = colors.map { $0.cgColor } as CFArray
        let grad = CGGradient(colorsSpace: nil, colors: clrs, locations: [0, 1])!
        ctx.drawLinearGradient(grad, start: .zero, end: .init(x: 0, y: rect.height), options: [])
    }
    
}
