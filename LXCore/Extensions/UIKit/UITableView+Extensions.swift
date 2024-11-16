//
//  UITableView+Extensions.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 02/Jan/23.
//  Copyright © 2022 Helix Consulting LLC. All rights reserved.
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
    /**
     Call this method to register cell of table view

     ```
     Usage:
     myTableView.registerCell(MyTableViewCell.self)
     ```
     */
    func registerCell<T: UITableViewCell>(_: T.Type) {
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

    /**
     Call this method to register header/footer view of table view

     ```
     Usage:
     myTableView.registerHeaderFooterView(MyTableViewHeaderFooterView.self)
     ```
     */
	func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) {
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
    /**
     Call this method to register header/footer view of table view

     ```
     Usage:
     myTableView.dequeueReusableCell(ofType: MyTableViewCell.self),
     ```
     */
    func dequeueReusableCell<T: UITableViewCell>(ofType type: T.Type) -> T? {
        let cellName = String(describing: T.self)

        return dequeueReusableCell(withIdentifier: cellName) as? T
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
// swiftlint:enable all
