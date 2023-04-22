//
//  UICollectionView+Extensions.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 02/Jan/23.
//  Copyright © 2022 Artak Gevorgyan. All rights reserved.
//

import UIKit
// swiftlint:disable all
extension UICollectionReusableView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    static var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UICollectionView {
	func register<T: UICollectionViewCell>(_: T.Type) {
		let bundle = Bundle(for: T.self)

		let isIpad = UIDevice.current.userInterfaceIdiom == .pad
		var nibName = isIpad ? (T.nibName + "~iPad") : T.nibName
		if let _ = bundle.path(forResource: nibName, ofType: "nib") {
		} else {
			nibName = T.nibName
		}
		let nib = UINib.init(nibName: nibName, bundle: bundle)

		register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
	}

	func registerSupplementaryHeader<T: UICollectionReusableView>(_: T.Type) {
		let bundle = Bundle(for: T.self)

		let isIpad = UIDevice.current.userInterfaceIdiom == .pad
		var nibName = isIpad ? (T.nibName + "~iPad") : T.nibName
		if let _ = bundle.path(forResource: nibName, ofType: "nib") {
		} else {
			nibName = T.nibName
		}
		let nib = UINib.init(nibName: nibName, bundle: bundle)
		self.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
	}

	func registerSupplementaryFooter<T: UICollectionReusableView>(_: T.Type) {
		let bundle = Bundle(for: T.self)

		let isIpad = UIDevice.current.userInterfaceIdiom == .pad
		var nibName = isIpad ? (T.nibName + "~iPad") : T.nibName
		if let _ = bundle.path(forResource: nibName, ofType: "nib") {
		} else {
			nibName = T.nibName
		}
		let nib = UINib.init(nibName: nibName, bundle: bundle)
		self.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
	}

	func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
			fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
		}
		return cell
	}
}
