//
//  CustomCollectionViewFlowLayout.swift
//  CellTetris
//
//  Created by Vladislav Nikolaev on 01.08.2022.
//

import Foundation
import UIKit

/// Cp'ed stuff with weird bugged animation. Should have to learn more about UICollectionViewFlowLayout
class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        guard let attributes: UICollectionViewLayoutAttributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else { return nil }
        let startY = collectionView.frame.width
        let endTransform: CATransform3D = CATransform3DMakeTranslation(0, startY, 0)
        attributes.transform3D = endTransform
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        guard let attributes: UICollectionViewLayoutAttributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else { return nil }
        attributes.alpha = 0.0
        let endX = collectionView.frame.width
        let endTransform: CATransform3D = CATransform3DMakeTranslation(endX, 0, 0)
        attributes.transform3D = endTransform
        return attributes
    }
}
