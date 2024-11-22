//
//  ULInputView.swift
//  LXCore
//
//  Created by Artak Gevorgyan on 13 Oct, 2023
//  Copyright © 2023 Artak Gevorgyan LLC. All rights reserved.
//

import UIKit

/// InputView delegate methods
protocol LXCoreInputViewDelegate: AnyObject {

    /// Notifies about Input view's textField textFieldDidEndEditing event
    /// - Parameter value: TextField current value
    func didEnterValue(_ value: String)
    func didTapDropDownView()
}

fileprivate struct DefaultConstraints {
    fileprivate static var titleLabelConstraints = LXCoreConstraints(top: 16,
                                                                     left: 10,
                                                                     right: 10,
                                                                     bottom: 6)
    fileprivate static var mainInputContainerConstraints = LXCoreConstraints(top: 18,
                                                                        left: 10,
                                                                        right: 10,
                                                                        bottom: 18,
                                                                        height: 30)
    fileprivate static var areaContainerConstraints = LXCoreConstraints(top: 0,
                                                                        left: 0,
                                                                        right: 0,
                                                                        bottom: 0,
                                                                        width: 25,
                                                                        height: 30)

    fileprivate static var textFieldContainerConstraints = LXCoreConstraints(top: 0,
                                                                             left: 0,
                                                                             right: 0,
                                                                             bottom: 0,
                                                                             height: 30)

    fileprivate static var hintContainerConstraints = LXCoreConstraints(top: 18,
                                                                            left: 0,
                                                                            right: 0,
                                                                            bottom: 0)
}

fileprivate struct DefaultStyles {
    fileprivate static var defaultColor = UIColor.orange
    fileprivate static var contentViewStyle = LXCoreViewStyle(bgColor: .clear)

    fileprivate static var titleLabelStyle = LXCoreLabelStyle(bgColor: .yellow,
                                                              textColor: .blue,
                                                              textFont: .systemFont(ofSize: 20))
    fileprivate static var mainInputViewContainerStyle = LXCoreViewStyle(bgColor: .brown,
                                                                         cornerRadius: 10.0,
                                                                         borderColor: .clear,
                                                                         borderWidth: 5)
    fileprivate static var areaCodeContainerStyle = LXCoreViewStyle(bgColor: .clear)
    fileprivate static var areaCodeLabelStyle = LXCoreLabelStyle(bgColor: .blue,
                                                                 textColor: .blue,
                                                                 textFont: .systemFont(ofSize: 20))
    fileprivate static var textFieldContainerStyle = LXCoreViewStyle(bgColor: .clear)
    fileprivate static var textFieldStyle = LXCoreTextFieldStyle(bgColor: .green,
                                                                 textColor: .blue,
                                                                 textFont: .systemFont(ofSize: 20))
    fileprivate static var hintContainerViewStyle = LXCoreViewStyle(bgColor: .clear)
    fileprivate static var hintLabelStyle = LXCoreLabelStyle(bgColor: .green,
                                                                 textColor: .blue,
                                                                 textFont: .systemFont(ofSize: 20))


}

/// Class to represent InputView
class LXCoreInputView: UIView {

    // MARK: - Public properties

    enum InputViewStyle {

        case standard
        case twoComponents
        case dropDown
    }

    enum InputViewHintType {

        case error
        case warning
        case info

        // TODO: Artak. Is image should be public like enum?
//        var image: UIImage? {
//            switch self {
//            case .error:
//                return UIImage.cardsTabIcon
//            case .warning:
//                return UIImage.establishmentTabIcon
//            }
//        }
    }

    var style: InputViewStyle?
    var twoComponentsTitle: String?
    var firstComponentTitle: String?
    var placeholder: String?
    var maxCharacters: Int?
    weak var delegate: LXCoreInputViewDelegate?

    //    var rightImage: UIImage? {
    //        didSet {
    //            if rightImage != nil {
    //                self.rightImage = rightImage
    //                setNeedsDisplay()
    //            }
    //        }
    //    }

    var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }

    @IBInspectable var isSecureTextEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = isSecureTextEntry
        }
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var contentView: UIView!

    @IBOutlet private weak var titleLabel: UILabel!

    @IBOutlet private weak var mainInputViewContainer: UIView!
    @IBOutlet private weak var areaCodeContainer: UIView!
    @IBOutlet private weak var areaCodeLabel: UILabel!

    @IBOutlet private weak var textFieldContainer: UIView!
    @IBOutlet private weak var textField: UITextField!
    
    @IBOutlet private weak var placeholderLabel: UILabel!

    @IBOutlet private weak var hintContainer: UIView!
    @IBOutlet private weak var hintLabel: UILabel!

    @IBOutlet private weak var rightImageButton: UIButton!

    // MARK: - Constraints

    @IBOutlet private weak var rightImageButtonWidthConstraint: NSLayoutConstraint!


    // MARK: - Customizable Constraints

    @IBOutlet private weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleBottomConstraint: NSLayoutConstraint!

    @IBOutlet private weak var mainInputViewContainerLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mainInputViewContainerRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mainInputViewContainerHeightConstraint: NSLayoutConstraint!

    @IBOutlet private weak var areaCodeContainerLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var areaCodeContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var areaCodeContainerRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var areaCodeContainerHeightConstraint: NSLayoutConstraint!

    @IBOutlet private weak var textFieldContainerLeftConstraintFromSuperView: NSLayoutConstraint!
    @IBOutlet private weak var textFieldContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textFieldContainerRightConstraint: NSLayoutConstraint!

    @IBOutlet private weak var hintContainerLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var hintContainerRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var hintContainerTopConstraint: NSLayoutConstraint!

    // MARK: - Private properties

    private enum PlaceholderPosition {

        case top
        case center

        var constraintSize: CGFloat {
            get {
                switch self {
                case .top:
                    return -40
                case .center:
                    return 0
                }
            }
        }
    }

    public enum InputViewState {

        case defaultState
        case disabledState
        case errorState
        case warningState
        case selectedState
        case completedState

        //        var firstComponentUnderlineViewColor: UIColor? {
        //            get {
        //                switch self {
        //                case .defaultState:
        //                    return Asset.Colors.unusedColor.color
        //                case .disabledState:
        //                    return Asset.Colors.unusedColor.color
        //                case .selectedState:
        //                    return Asset.Colors.unusedColor.color
        //                case .completedState:
        //                    return Asset.Colors.unusedColor.color
        //                case .errorState:
        //                    return Asset.Colors.unusedColor.color
        //                case .warningState:
        //                    return Asset.Colors.unusedColor.color
        //                }
        //            }
        //        }

        var hintLabelTextColor: UIColor? {
            get {
                let userSpecifiedColor = self.hintLabelTextColorUserSpecifiedValue
                switch self {
                case .defaultState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .disabledState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .selectedState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .completedState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .errorState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .warningState:
                    // There is no warning state for InputField, use Warning300 from Colors
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                }
            }
        }

        var textFieldTextColor: UIColor? {
            get {
                let userSpecifiedColor = self.textFieldTextColorUserSpecifiedValue
                switch self {
                case .defaultState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .disabledState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .selectedState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .completedState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .errorState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .warningState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                }
            }
        }

        var inputViewContainerBorderColor: UIColor? {
            get {
                let userSpecifiedColor = self.mainInputViewBorderColorUserSpecifiedValue
                switch self {
                case .defaultState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .disabledState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .selectedState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .completedState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .errorState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                case .warningState:
                    if let safeColor = userSpecifiedColor {
                        return safeColor
                    } else {
                        return DefaultStyles.defaultColor
                    }
                }
            }
        }

    }


    private var rightImageButtonWidthConstraintInitialValue: CGFloat = 0


    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        self.rightImageButtonWidthConstraintInitialValue = self.rightImageButtonWidthConstraint.constant
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        initUIElements()
    }

    func initWith(style: InputViewStyle,
                  title: String? = "",
                  firstComponentTitle: String? = "",
                  isSecure: Bool = false,
                  placeholder: String? = "",
                  maxCharacters: Int? = 10,
                  normalImage: UIImage? = nil,
                  selectedImage: UIImage? = nil) {
        self.style = style
        self.twoComponentsTitle = title
        self.firstComponentTitle = firstComponentTitle
        self.textField.clearButtonMode = isSecure ? .never : .whileEditing
        self.initRightImageButton(secureTextField: isSecure, normalImage: normalImage, selectedImage: selectedImage)
        self.placeholder = placeholder
        self.maxCharacters = maxCharacters
        self.setValuesOfUIElements()
        self.updateUIElementsRegardingStyle()
        self.removeErrorHint()
        self.updateElementsBasedOnState(.defaultState)
        self.setUserSpecifiedConstraints()
        self.setUserSpecifiedStyles()

    }

    // MARK: - Lifecycle

    override func draw(_ rect: CGRect) {
        //        self.placeholderLabel.text = self.placeholder
        // TODO: Artak. Replace checking with "" with the String's isEmpty/isNil/null method (Should be used String's extension from UPay)
        //        self.placeholderLabel.isHidden = self.textField.text?.isEmpty ?? true
        self.hidePlaceholderLabelInTwoComponentsCase()
    }

    // MARK: - Public

    func setHint(type: InputViewHintType, text: String) {
        self.hintLabel.text = text
        // TODO: Artak. Replace checking with "" with the String's isEmpty/isNil/null method (Should be used String's extension from UPay)
        let isHintTextEmpty = text.isEmpty
        self.hintContainer.isHidden = isHintTextEmpty
        if isHintTextEmpty {
            self.updateElementsBasedOnState(.defaultState)
        } else {
            self.setHintImageViewByType(type: type)
            switch type {
            case .error:
                self.updateElementsBasedOnState(.errorState)
            case .warning:
                self.updateElementsBasedOnState(.warningState)
            case .info:
                self.updateElementsBasedOnState(.defaultState)
            }
        }
    }

    func inputViewBecomeFirstResponder() {
        self.textField.becomeFirstResponder()
    }

    func setText(_ text: String) {
        self.maxCharacters = text.count > self.maxCharacters ?? 0 ? text.count : self.maxCharacters
        self.textField.text = text
    }

    func getText() -> String {
        return self.textField.text ?? ""
    }

    // MARK: - Private
    // MARK: Init UI elements
   
    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        addShadow()
        self.addSubview(view)
    }

    private func initUIElements() {
        self.initContentView()
        self.initPlaceholderLabel()
        self.initUnderlineView()
        self.initMainInputViewContainer()
        self.initTitleLabel()
        self.initAreaCodeViews()
        self.initTextFieldViews()
        self.initHintViews()
    }

    private func initContentView() {
        self.setStyleLXCore(DefaultStyles.contentViewStyle)
        contentView.setStyleLXCore(DefaultStyles.contentViewStyle)
    }

    private func addShadow() {
//        contentView.setStyleLXCore(DefaultStyles.contentViewStyle)

        // drop shadow
//        contentView.layer.shadowColor = Styling.defaultColor.cgColor
//        contentView.layer.shadowOpacity = 0.8
//        contentView.layer.shadowRadius = 3.0
//        contentView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }

    private func initPlaceholderLabel() {
        //        self.placeholderLabel.isUserInteractionEnabled = true
        //        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapOnPlaceholderLabel(_:)))
        //        self.placeholderLabel.addGestureRecognizer(gesture)
        self.updatePlaceholderLabelBasedOnPosition()
    }

    private func initRightImageButton(secureTextField: Bool, normalImage: UIImage? = nil, selectedImage: UIImage? = nil) {
        if let normalImage = normalImage, let selectedImage = selectedImage {
            self.rightImageButton.setImage(normalImage, for: .normal)
            self.rightImageButton.setImage(selectedImage, for: .selected)
        }
        self.rightImageButton.isEnabled = secureTextField
        self.rightImageButton.isSelected = false
        self.textField.isSecureTextEntry = secureTextField

        self.rightImageButton.addTarget(self, action: #selector(rightImageButtonPressed),
                                        for: UIControl.Event.touchUpInside)
    }

    private func initUnderlineView() {
        //   self.inputUnderlineView.backgroundColor = UIColor.lightGray
    }

    private func initMainInputViewContainer() {
        self.mainInputViewContainer.setStyleLXCore(DefaultStyles.mainInputViewContainerStyle)
    }

    private func initTitleLabel() {
        self.titleLabel.setStyleLXCore(DefaultStyles.titleLabelStyle)
    }

    private func initAreaCodeViews() {
        self.areaCodeContainer.setStyleLXCore(DefaultStyles.areaCodeContainerStyle)
        self.areaCodeLabel.setStyleLXCore(DefaultStyles.areaCodeLabelStyle)
    }

    private func initTextFieldViews() {
        self.textFieldContainer.setStyleLXCore(DefaultStyles.textFieldContainerStyle)
        self.textField.setStyleLXCore(DefaultStyles.textFieldStyle)
        self.textField.delegate = self
    }

    private func initHintViews() {
        self.hintContainer.setStyleLXCore(DefaultStyles.hintContainerViewStyle)
        self.hintContainer.isHidden = true
        self.hintLabel.setStyleLXCore(DefaultStyles.hintLabelStyle)
    }

    // MARK: Setup constraints
    
    private func setUserSpecifiedConstraints() {
        let specs = LXCoreInputViewUserSpecifications.shared
        self.setCustomConstraintsFor(title: specs.titleConstraints,
                                     mainInput: specs.mainInputConstraints,
                                     areaCode: style == .standard ? nil : specs.areaCodeConstraints,
                                     textField: specs.textFieldConstraints,
                                     hint: specs.hintConstraints)
    }

    func setCustomConstraintsFor(title titleLabelConstraints: LXCoreConstraints? = nil,
                                 mainInput mainInputConstraints: LXCoreConstraints? = nil,
                                 areaCode areaCodeConstraints: LXCoreConstraints? = nil,
                                 textField textFieldConstraints: LXCoreConstraints? = nil,
                                 hint hintContainerViewConstraints: LXCoreConstraints? = nil) {
        self.setTitleViewConstraints(titleLabelConstraints)
        self.setMainInputContainerConstraints(mainInputConstraints)
        self.setAreaContainerConstraints(areaCodeConstraints)
        self.setTextFieldContainerConstraints(textFieldConstraints)
        self.setHintContainerConstraints(hintContainerViewConstraints)
    }

    private func setTitleViewConstraints(_ constraint: LXCoreConstraints?) {
        self.titleTopConstraint?.constant = constraint?.top ??
                                            DefaultConstraints.titleLabelConstraints.top ?? 0
        self.titleLeftConstraint?.constant = constraint?.left ??
                                            DefaultConstraints.titleLabelConstraints.left ?? 0
        self.titleRightConstraint?.constant = constraint?.right ??
                                            DefaultConstraints.titleLabelConstraints.right ?? 0
        self.titleBottomConstraint?.constant = constraint?.bottom ??
                                            DefaultConstraints.titleLabelConstraints.bottom ?? 0
    }
    
    private func setMainInputContainerConstraints(_ constraint: LXCoreConstraints?) {
        self.mainInputViewContainerLeftConstraint.constant = constraint?.left ??
                                                            DefaultConstraints.mainInputContainerConstraints.left ?? 0
        self.mainInputViewContainerRightConstraint.constant = constraint?.right ??
                                                            DefaultConstraints.mainInputContainerConstraints.right ?? 0
        self.mainInputViewContainerHeightConstraint.constant = constraint?.height ??
                                                            DefaultConstraints.mainInputContainerConstraints.height ?? 0
    }

    private func setAreaContainerConstraints(_ constraint: LXCoreConstraints?) {
        self.areaCodeContainerLeftConstraint.constant = constraint?.left ??
                                                        DefaultConstraints.areaContainerConstraints.left ?? 0
        self.areaCodeContainerRightConstraint.constant = constraint?.right ??
                                                        DefaultConstraints.areaContainerConstraints.right ?? 0
        self.areaCodeContainerWidthConstraint.constant = constraint?.width ??
                                                        DefaultConstraints.areaContainerConstraints.width ?? 0
        self.areaCodeContainerHeightConstraint.constant = constraint?.height ??
                                                        DefaultConstraints.areaContainerConstraints.height ?? 0
    }

    private func setTextFieldContainerConstraints(_ constraint: LXCoreConstraints?) {
        self.textFieldContainerRightConstraint.constant = constraint?.right ??
                                                            DefaultConstraints.textFieldContainerConstraints.right ?? 0
        self.textFieldContainerHeightConstraint.constant = constraint?.height ??
                                                            DefaultConstraints.textFieldContainerConstraints.height ?? 0
        if self.style == .standard {
            self.textFieldContainerLeftConstraintFromSuperView.constant = constraint?.left ??
                                                            DefaultConstraints.textFieldContainerConstraints.left ?? 0
        }

    }

    private func setHintContainerConstraints(_ constraint: LXCoreConstraints?) {
        self.hintContainerTopConstraint?.constant = constraint?.top ??
                                                        DefaultConstraints.hintContainerConstraints.top ?? 0
        self.hintContainerLeftConstraint?.constant = constraint?.left ??
                                                        DefaultConstraints.hintContainerConstraints.left ?? 0
        self.hintContainerRightConstraint?.constant = constraint?.right ??
                                                        DefaultConstraints.hintContainerConstraints.right ?? 0

    }

    private func setUserSpecifiedStyles() {
        let specs = LXCoreInputViewUserSpecifications.shared
        self.stylingComponents(mainView: specs.mainViewStyle,
                               title: specs.titleLabelStyle,
                               mainInputViewContainer: specs.mainInputViewContainerStyle,
                               areaCode: style == .standard ? nil : specs.areaCodeLabelStyle,
                               textField: specs.textFieldStyle,
                               hint: specs.hintLabelStyle)
    }

    private func stylingComponents(mainView mainViewStyle: LXCoreViewStyle? = nil,
                                   title titleStyle: LXCoreLabelStyle? = nil,
                                   mainInputViewContainer mainInputViewContainerStyle: LXCoreViewStyle? = nil,
                                   areaCode areaCodeStyle: LXCoreLabelStyle? = nil,
                                   textField textFieldStyle: LXCoreTextFieldStyle? = nil,
                                   hint hintLabelStyle: LXCoreLabelStyle? = nil) {
        self.contentView.setStyleLXCore(mainViewStyle ?? DefaultStyles.contentViewStyle)
        self.titleLabel.setStyleLXCore(titleStyle ?? DefaultStyles.titleLabelStyle)
        self.mainInputViewContainer.setStyleLXCore(mainInputViewContainerStyle ?? DefaultStyles.mainInputViewContainerStyle)
        self.areaCodeLabel.setStyleLXCore(areaCodeStyle ?? DefaultStyles.areaCodeLabelStyle)
        self.textField.setStyleLXCore(textFieldStyle ?? DefaultStyles.textFieldStyle)
        self.hintLabel.setStyleLXCore(hintLabelStyle ?? DefaultStyles.hintLabelStyle)
    }


    @objc private func rightImageButtonPressed() {
        self.rightImageButton.isSelected = !self.rightImageButton.isSelected
        self.textField.isSecureTextEntry = !self.rightImageButton.isSelected
    }

    // MARK: Other

    private func hidePlaceholderLabelInTwoComponentsCase() {
        if self.style == .twoComponents {
            // self.placeholderLabel.isHidden = true
        }
    }

    private func updatePlaceholderLabelBasedOnPosition(isTopPosition: Bool = false) {
        //swiftlint:disable swiftgen_fonts_dot
        // TODO: Artak. Find solution to not allow linting in comments
        //        self.placeholderLabel.font = isTopPosition ? UIFont.inputPlacheholderTopFont() : UIFont.inputViewPlacheholderFont()
        //        self.placeholderLabel.textColor = UIColor.inputPlacheholderColor
        //swiftlint:enable swiftgen_fonts_dot
    }

    private func updateElementsBasedOnState(_ state: InputViewState) {
        // self.firstComponentUnderlineView.backgroundColor = state.firstComponentUnderlineViewColor
        // self.inputUnderlineView.backgroundColor = state.inputUnderlineViewColor
        self.textField.textColor = state.textFieldTextColor
        self.hintLabel.textColor = state.hintLabelTextColor
        self.mainInputViewContainer.layer.borderColor = state.inputViewContainerBorderColor?.cgColor
    }

    // TODO: Move this to UIView+Extension
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LXCoreInputView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    private func setValuesOfUIElements() {
        self.areaCodeLabel.text = firstComponentTitle
        self.titleLabel.text = twoComponentsTitle
        let placeholderColor = LXCoreInputViewUserSpecifications.shared.textFieldPlaceholderColor
        self.textField.attributedPlaceholder = NSAttributedString(
            string: self.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor ?? DefaultStyles.defaultColor]
        )
    }

    private func setHintImageViewByType(type: InputViewHintType) {
        //self.hintImageView.image = type.image
    }

    private func updateUIElementsRegardingStyle() {
//         self.titleLabel.isHidden = self.style == .standard || self.style == .dropDown
        let isNeedToHideAreaCodeContainer = self.style == .standard || self.style == .dropDown
        if isNeedToHideAreaCodeContainer {
//            self.areaCodeContainerWidthConstraint.constant = 0
            self.textFieldContainerLeftConstraintFromSuperView.isActive = true
            self.areaCodeContainer.isHidden = true
//            self.areaCodeContainerRightConstraint.constant = 0
        }
//        self.inputBackgroundViewLeftConstraint.constant = self.style == .standard || self.style == .dropDown ? -50 : 0
        //self.placeholderLabel.isHidden = self.style == .twoComponents
    }

    @objc func tapOnPlaceholderLabel(_ sender: UITapGestureRecognizer) {
        self.textField.becomeFirstResponder()
        switch style {
        case .standard:
            // self.movePlaceholderTo(position: .top)
            self.updateElementsBasedOnState(.selectedState)
        case .twoComponents:
            self.placeholderLabel?.isHidden = true
        case .dropDown:
            self.delegate?.didTapDropDownView()
        case .none:
            print("Unknown style state")
        }
    }

    private func removeErrorHint() {
        self.hintLabel.text = ""
        self.hintContainer.isHidden = true
    }

}

extension LXCoreInputView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Separate logic. One variable for "as NSString", another one for replacing
        let textFieldText = (textField.text as NSString?)
        let text = textFieldText?.replacingCharacters(in: range, with: string) ?? ""
        if text.count <= self.maxCharacters ?? 0 {
            return true
        }
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch style {
        case .twoComponents:
            // TODO: Artak. Replace checking with "" with the String's isEmpty/isNil/null method (Should be used String's extension from UPay)
            let textFieldValue = textField.text ?? ""
            if textFieldValue.isEmpty {
                self.updateElementsBasedOnState(.defaultState)
            } else {
                self.updateElementsBasedOnState(.completedState)
                self.delegate?.didEnterValue(textFieldValue)
            }
        case .standard:
            // TODO: Artak. Replace checking with "" with the String's isEmpty/isNil/null method (Should be used String's extension from UPay)
            let textFieldValue = textField.text ?? ""
            if textFieldValue.isEmpty {
                self.updateElementsBasedOnState(.defaultState)
            } else {
                self.updateElementsBasedOnState(.completedState)
                self.delegate?.didEnterValue(textFieldValue)
            }
        case .dropDown:
            print("dropDown style state")
        case .none:
            print("Unknown style state")
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch style {
        case .standard, .twoComponents:
            self.removeErrorHint()
            self.updateElementsBasedOnState(.selectedState)
        case .dropDown:
            self.textField.isEnabled = false
            self.delegate?.didTapDropDownView()
        case .none:
            print("none")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.updateElementsBasedOnState(.completedState)
        self.endEditing(true)
        return true
    }

}
extension UIView {

    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
