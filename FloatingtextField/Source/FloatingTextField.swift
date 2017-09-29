//
//  FloatingTextField.swift
//  FloatingtextField
//
//  Created by Bharat Lal on 20/09/17.
//  Copyright © 2017 Bharat Lal. All rights reserved.
//

import UIKit

@IBDesignable class FloatingTextField: UITextField {
    
    fileprivate let bottomLayer = CALayer()
    fileprivate var floatingLabel: FloatingLabel? = nil
    fileprivate var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    fileprivate var placeholderText: String? = nil
    fileprivate var errorLabel: UILabel?
    fileprivate var placeholderTextWidth = CGFloat(0.0)
    
    /// A UIColor value that determines text color of the placeholder label
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    /// A UIColor value that determines text color of the placeholder label
    @IBInspectable var placeholderFont: UIFont? {
        didSet {
            updatePlaceholder()
        }
    }
    
    /// A UIColor value that determines bottom line color in various modes
    var normalLineColor: UIColor = .lightGray
    var activeLineColor: UIColor = .lightGray
    var filledTextFieldLineColor: UIColor = .lightGray
    
    //MARK: initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //MARK: private
    private func updatePlaceholder() {
        placeholderText = placeholder
        floatingLabel?.textColor = placeholderColor
        floatingLabel?.text = placeholderText
        floatingLabel?.font = placeholderFont ?? font
        floatingLabel?.textAlignment = textAlignment
        placeholderTextWidth = sizeOf(placeholderText ?? "", withFont: font!).width
        placeholder = ""
    }
    private func setup(){
        setuptextField()
        setupLabel()
        addObservers()
        setupErrorLabel()
    }
    private func setuptextField(){
        setupBottomLayer()
        borderStyle = .none
        
    }
    private func  setupBottomLayer(){
        let frame = CGRect(x: 0, y: bounds.size.height, width: bounds.size.width, height: 1.0)
        bottomLayer.frame = frame
        bottomLayer.backgroundColor = normalLineColor.cgColor
        layer.addSublayer(bottomLayer)
    }
    private func setupLabel(){
        floatingLabel = FloatingLabel(frame: bounds, padding: padding)
        if floatingLabel?.superview != self{
            addSubview(floatingLabel!)
        }
        
        
    }
    private func setupErrorLabel() {
        placeholderTextWidth = sizeOf(placeholderText ?? "", withFont: font!).width
        errorLabel = UILabel(frame: CGRect(x: placeholderTextWidth + 35, y: -((self.frame.height / 2 ) - 6), width: self.frame.width - (placeholderTextWidth + 20), height: 17))
        errorLabel?.textColor = .red
        errorLabel?.font = font?.withSize(12)
        self.addSubview(errorLabel!)
    }
    private func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(didBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeCharacters), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
        
    }
    private func sizeOf(_ string: String, withFont font: UIFont) -> CGSize {
        return (string as NSString).size(attributes: [NSFontAttributeName: font])
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
extension FloatingTextField{
    func didBeginEditing(){
        bottomLayer.backgroundColor = activeLineColor.cgColor
    }
    func didEndEditing(){
        hasText ? (bottomLayer.backgroundColor = filledTextFieldLineColor.cgColor) : (bottomLayer.backgroundColor = normalLineColor.cgColor)
    }
    func didChangeCharacters(){
        hasText ? moveToTop() : moveToOrigin()
        errorLabel?.isHidden = true
        bottomLayer.backgroundColor = activeLineColor.cgColor
    }
    private func moveToTop(){
        UIView.animate(withDuration: 0.2) {
            var frame = self.floatingLabel?.frame
            frame?.origin.y = -(self.frame.height / 2 )
            self.floatingLabel?.frame = frame ?? self.bounds
        }
    }
    private func moveToOrigin(){
        UIView.animate(withDuration: 0.1) {
            var frame = self.floatingLabel?.frame
            frame?.origin.y = 0
            self.floatingLabel?.frame = frame ?? self.bounds
        }
    }
    
    func showError(message: String?) {
        hasText ? (errorLabel?.frame.origin.x = CGFloat(placeholderTextWidth + 10)) : (errorLabel?.frame.origin.x = CGFloat(0.0))
        errorLabel?.text = message
        bottomLayer.backgroundColor = UIColor.red.cgColor
        errorLabel?.isHidden = false
    }
}
extension FloatingTextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
}
class FloatingLabel: UILabel{
    
    private var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //MARK: initializers
    required init(frame: CGRect, padding: UIEdgeInsets) {
        super.init(frame: frame)
        self.padding = padding
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
}
