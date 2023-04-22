//
//  UITableView+Extensions.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 02/Jan/23.
//  Copyright © 2022 Artak Gevorgyan. All rights reserved.
//

import UIKit
// swiftlint:disable all
extension UITableViewCell {
    static var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UITableViewHeaderFooterView {
    static var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        let bundle = Bundle(for: T.self)
        
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        var nibName = isIpad ? (T.nibName + "~iPad") : T.nibName
        if let _ = bundle.path(forResource: nibName, ofType: "nib") {
        } else {
            nibName = T.nibName
        }
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

	func register<T: UITableViewHeaderFooterView>(_: T.Type) {
		let bundle = Bundle(for: T.self)
		
		let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        var nibName = isIpad ? (T.nibName + "~iPad") : T.nibName
        if let _ = bundle.path(forResource: nibName, ofType: "nib") {
        } else {
            nibName = T.nibName
        }
        let nib = UINib.init(nibName: nibName, bundle: bundle)
		register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
	}
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UIView {
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = self.superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
}

extension UITableViewCell {
    var parentTableView: UITableView? {
        return self.parentView(of: UITableView.self)
    }
    
    var ip: IndexPath? {
		return parentTableView?.indexPathForRow(at: self.center)
    }
}
