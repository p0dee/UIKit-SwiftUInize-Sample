//
//  BrickLayout.swift
//  CustomUIKitOnSwiftUI
//
//  Created by Takeshi Tanaka on 2021/12/08.
//  Copyright © 2021 Goodpatch. All rights reserved.
    
import Foundation
import UIKit

protocol BrickLayoutDelegate: AnyObject {
    
    func item(for indexPath: IndexPath) -> String
    
}

final class BrickLayout: UICollectionViewLayout {
        
    weak var delegate: BrickLayoutDelegate?
    
    private var calcResults: [IndexPath : UICollectionViewLayoutAttributes] = [:]
    
    //content size
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    private var contentHeight: CGFloat = 0
    
    //brick size
    func minimumBrickWidth(forText text: NSString) -> CGFloat {
        let textWidth = text.boundingRect(with: .init(width: 0, height: brickHeight), attributes: [.font:UIFont.systemFont(ofSize: 14)], context: nil).width
        return ceil(textWidth + brickSidePadding * 2)
    }
    let brickHeight: CGFloat = 40
    let brickInsets: UIEdgeInsets = .init(top: 1, left: 1, bottom: 1, right: 1)
    let brickSidePadding: CGFloat = 16
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        if !calcResults.isEmpty { return }
        guard let delegate = delegate else { return }
        
        let section = 0
        var currentPos = CGPoint.zero
        var results: [[IndexPath : UICollectionViewLayoutAttributes]] = [[:]]
        for i in 0..<collectionView.numberOfItems(inSection: section) {
            let indexPath = IndexPath(item: i, section: section)
            let text = delegate.item(for: indexPath)
            let minBrickWidth = minimumBrickWidth(forText: text as NSString)
            let brickFrame: CGRect
            
            let surplus = contentWidth - currentPos.x
            if minBrickWidth <= surplus {
                //余白が十分にあれば、セルを横に並べる
                brickFrame = .init(origin: currentPos, size: .init(width: minBrickWidth, height: brickHeight))
            } else {
                //余白が不足していれば、
                //1. 現在行に含まれる幅をsurplus分均等に広げる
                let lastLineArray = results.last!.sorted {
                    $0.value.frame.origin.x < $1.value.frame.origin.x
                }
                let bw = surplus / CGFloat(lastLineArray.count)
                for (i, map) in lastLineArray.enumerated() {
                    let attrs = map.value
                    var newFrame = attrs.frame
                    newFrame.size.width += bw
                    newFrame.origin.x += bw * CGFloat(i)
                    attrs.frame = newFrame
                }
                //2. 改行して新しい行にセルを並べる
                currentPos.x = 0
                currentPos.y += brickHeight
                brickFrame = .init(origin: currentPos, size: .init(width: minBrickWidth, height: brickHeight))
                results.append([:])
            }
            currentPos.x += minBrickWidth
            contentHeight = max(contentHeight, brickFrame.maxY)
            
            let attrs = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: section))
            let insetFrame = brickFrame.inset(by: brickInsets)
            attrs.frame = insetFrame
            results[results.count - 1][indexPath] = attrs
        }
        calcResults = results.reduce([:], { (result, map) -> [IndexPath : UICollectionViewLayoutAttributes] in
            return result.merging(map) {(item, _) in item}
        })
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return calcResults.filter {
            $0.value.frame.intersects(rect)
        }.map {
            $0.value
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            return calcResults[indexPath]
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        calcResults.removeAll()
    }
    
}
