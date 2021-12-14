//
//  BrickCollectionView.swift
//  CustomUIKitOnSwiftUI
//
//  Created by Takeshi Tanaka on 2021/12/08.
//  Copyright © 2021 Goodpatch. All rights reserved.
    
import UIKit

// MARK: - BrickCollectionView Protocols

protocol BrickViewDataSource: AnyObject {
    func numberOfItems(_ brickView: BrickCollectionView) -> Int
    func brickView(_ brickView: BrickCollectionView, itemAt index: Int) -> String
}

protocol BrickViewDelegate: AnyObject {
    func brickViewDidTapItem(_ brickView: BrickCollectionView, item: String)
}

// MARK: - BrickCollectionView

final class BrickCollectionView: UIView {
    
    private var collectionView: UICollectionView!
    
    weak var dataSource: BrickViewDataSource?
    weak var delegate: BrickViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
    
    private func setUpViews() {
        let gradView = GradientView()
        gradView.frame = bounds
        gradView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(gradView)
        
        let layout = BrickLayout()
        layout.delegate = self
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
        collectionView.delegate = self
        collectionView.frame = bounds
        collectionView.register(Cell.self, forCellWithReuseIdentifier: String(describing: Cell.self))
        addSubview(collectionView)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    class Cell: UICollectionViewCell {
        
        static let font = UIFont.systemFont(ofSize: 14)
        let label = UILabel()
        
        override var isHighlighted: Bool {
            didSet {
                let animator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1.0) {
                    let scale = self.isHighlighted ? 0.95 : 1.0
                    let alpha = self.isHighlighted ? 0.9 : 1.0
                    self.transform = .init(scaleX: scale, y: scale)
                    self.alpha = alpha
                }
                animator.startAnimation()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            contentView.layer.cornerCurve = .continuous
            contentView.layer.cornerRadius = 3
            contentView.clipsToBounds = true
            label.frame = contentView.bounds
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            label.textAlignment = .center
            label.font = type(of: self).font
            label.textColor = UIColor(white: 0.2, alpha: 1.0)
            contentView.addSubview(label)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}

// MARK: - LayoutDelegate

extension BrickCollectionView: BrickLayoutDelegate {
    
    func item(for indexPath: IndexPath) -> String {
        guard let dataSource = dataSource, indexPath.row < dataSource.numberOfItems(self) else { return "" }
        return dataSource.brickView(self, itemAt: indexPath.row)
    }
    
}

// MARK: - UICollectionViewDataSource

extension BrickCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BrickCollectionView.Cell.self), for: indexPath) as! Cell
        cell.contentView.backgroundColor = .white
        cell.label.text = item(for: indexPath)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension BrickCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.brickViewDidTapItem(self, item: item(for: indexPath))
    }
    
}
