//
//  LXCoreActivityIndicatorView.swift
//  Tiptop
//
//  Created by Artak Gevorgyan on 03.11.23.
//  Copyright © 2023 Artak Gevorgyan LLC. All rights reserved.
//

import UIKit

class LXCoreActivityIndicatorView: UIView {
    
    static let shared = LXCoreActivityIndicatorView(frame: UIScreen.main.bounds)
    private(set) var isAnimating: Bool = false
    
    private var arcView: LXCoreGradientArcView = {
        let view = LXCoreGradientArcView(frame: CGRect(origin: .zero, size: CGSize(width: 48, height: 48)))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 48).isActive = true
        view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        let specs = LXCoreActivityIndicatorUserSpecifications.shared
        view.startColor = specs.startColor
        view.endColor = specs.endColor
        return view
    }()
    
    private var backgroundView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        let specs = LXCoreActivityIndicatorUserSpecifications.shared
        view.backgroundColor = specs.backgroundColor
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Public

    func startAnimating() {
        guard !isAnimating, let window = UIApplication.shared.windows.last(where: { $0.isKeyWindow }) else { return }
        isAnimating = true
        setNeedsLayout()
        layoutIfNeeded()
        alpha = 0
        window.addSubview(self)
        internalStartAnimating()
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1
        }
    }

    func stopAnimating() {
        guard isAnimating else { return }
        isAnimating = false
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0
        } completion: { (_) in
            self.internalStopAnimating()
            self.removeFromSuperview()
        }
    }


    // MARK: - Private

    private func setup() {
        addSubview(backgroundView)
        addSubview(arcView)
        self.addBlurredBgViewIfNeed()
        arcView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        arcView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func addBlurredBgViewIfNeed() {
        let specs = LXCoreActivityIndicatorUserSpecifications.shared
        if specs.isNeedBlurredBackground {
            let blurredView = UIView()
            let blurEffect = UIBlurEffect(style: .light)
            let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
            customBlurEffectView.frame = self.bounds
            // 3. create semi-transparent black view
            let dimmedView = UIView()
            dimmedView.backgroundColor = .black.withAlphaComponent(0.2)
            dimmedView.frame = self.bounds

            // 4. add both as subviews
            blurredView.addSubview(customBlurEffectView)
            blurredView.addSubview(dimmedView)

            self.addSubview(blurredView)
            self.sendSubviewToBack(blurredView)

        }
    }

    private func internalStartAnimating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        arcView.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    private func internalStopAnimating() {
        arcView.layer.removeAllAnimations()
    }
}
