//
//  Extensions.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    func transparent() {
        setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        shadowImage = UIImage()
    }
    func visible() {
        setBackgroundImage(nil, for: .default)
        shadowImage = nil
    }
}

extension UISearchBar {
    static func setSearchBarAppearance() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .darkGray
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = attributes
    }
}

extension UICollectionViewFlowLayout {
    func availableHeight(collectionViewHeight: CGFloat, numberOfRows: CGFloat, navigationBarHeight: CGFloat) -> CGFloat {
        let availableHeight = collectionViewHeight
            - self.sectionInset.top - self.sectionInset.bottom
            - (self.minimumInteritemSpacing * numberOfRows)
            - navigationBarHeight
        return availableHeight
    }
    
    func availableWidth(collectionViewWidth: CGFloat, numberOfColumns: CGFloat) -> CGFloat {
        let availableWidth = collectionViewWidth
            - self.sectionInset.left - self.sectionInset.right
            - (self.minimumInteritemSpacing * numberOfColumns)
        return availableWidth
    }
}

extension UIView {
    func fillSuperview() {
        guard let superview = self.superview else { return }
        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
}

extension UICollectionViewController {
    func navigationBarHeight() -> CGFloat {
        return self.navigationController?.navigationBar.bounds.height ?? 0
    }
}
