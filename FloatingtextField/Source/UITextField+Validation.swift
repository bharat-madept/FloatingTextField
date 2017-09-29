//
//  UITextField+Validation.swift
//  FloatingtextField
//
//  Created by Bharat Lal on 26/09/17.
//  Copyright © 2017 Bharat Lal. All rights reserved.
//

import Foundation
import UIKit

private var validationKey: UInt8 = 0
extension UITextField {
    var letterOnlyRegEx: String {
        get{
            return "[^a-zA-Z ]"
        }
        set{
            self.letterOnlyRegEx = newValue
        }
    }
    var alphaNumericRegEx: String {
        get{
            return "[^a-zA-Z0-9 ]"
        }
        
    }
    var numericOnlyRegEx: String{
        get{
            return "[^0-9]"
        }
    }
    var emailRegEx: String {
        get{
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        }
    }
    var passwordRegEx: String{
        get{
            return "(.{6,12})"
        }
    }
}
extension UITextField {
    
    // Apply validations textfield.
    var validationRules: [ValidationRule] {
        get {
            if let validations = objc_getAssociatedObject(self, &validationKey) as? [ValidationRule] {
                return validations
            } else {
                return []
            }
        }
        
        set {
            objc_setAssociatedObject(self, &validationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // check if text field is empty
    func isEmpty() -> Bool{
        guard let string = self.text else {
            return true
        }
        let whitespaceSet = CharacterSet.whitespaces
        return string.trimmingCharacters(in: whitespaceSet).isEmpty
    }
    
    //MARK: Validation method
    func validate() throws {
        do{
            for validation in validationRules {
                switch validation {
                case let .required(message):
                    try requiredValidation(message: message)
                    
                case let .lettersOnly(message):
                    try letterValidation(message: message)
                    
                case let .maxLength(value, message):
                    try maxLengthValidation(length: value, message: message)
                    
                case let .minLength(value, message):
                    try minLengthValidation(length: value, message: message)
                    
                case let .email(message):
                    try emailValidation(message: message)
                    
                case let .mobile(message):
                    try mobileNumberValidation(message: message)
                    
                case let .password(message):
                    try passwordValidation(message: message)
                    
                case let .characterRange(min, max, message):
                    try characterRangeValidation(min: min, max: max, message: message)
                    
                case let .alphaNumeric(message):
                    try alphaNumericValidation(message: message)
                    
                case let .range(min, max, message):
                    try rangeValidation(min: min, max: max, message: message)
                    
                }
            }
        }
        catch {
            throw error
        }
    }
    
    //MARK: Private methods
    private func requiredValidation(message: String) throws {
        guard let value = text, !value.isEmpty else {
            throw generateException(message)
        }
    }
    
    private func letterValidation(message: String) throws {
        if let value = text, !value.isEmpty {
            if !(value.range(of: self.letterOnlyRegEx, options: .regularExpression) == nil) {
                throw generateException(message)
            }
        }
    }
    
    private func maxLengthValidation(length:Int, message: String) throws {
        if let value = text, value.characters.count > length , !value.isEmpty{
            throw generateException(message)
        }
    }
    
    private func minLengthValidation(length:Int, message: String) throws {
        if let value = text, value.characters.count < length , !value.isEmpty{
            throw generateException(message)
        }
    }
    
    private func alphaNumericValidation(message: String) throws {
        if let value = text, !value.isEmpty {
            if !(value.range(of: self.alphaNumericRegEx, options: .regularExpression) == nil) {
                throw generateException(message)
            }
        }
    }
    
    private func numericValidation(message: String) throws {
        if let value = text, !value.isEmpty {
            if !(value.range(of: self.numericOnlyRegEx, options: .regularExpression) == nil) {
                throw generateException(message)
            }
        }
    }
    
    private func emailValidation(message: String) throws {
        if let value = text, !value.isEmpty {
            let emailTest = NSPredicate(format: "SELF MATCHES %@", self.emailRegEx)
            if !emailTest.evaluate(with: value) {
                throw generateException(message)
            }
        }
    }
    
    private func mobileNumberValidation(message: String) throws {
        if let value = text, !value.isEmpty {
            if !(value.range(of: self.numericOnlyRegEx, options: .regularExpression) == nil) || value.characters.count != 10 {
                throw generateException(message)
            }
        }
    }
    
    private func passwordValidation(message: String) throws {
        if let string = text, !string.isEmpty {
            if !NSPredicate(format: "SELF MATCHES %@", self.passwordRegEx).evaluate(with: string) || isEmpty() {
                throw generateException(message)
            }
        }
    }
    
    private func characterRangeValidation(min:Int, max:Int, message: String) throws {
        if let string = text, !(string.characters.count >= min && string.characters.count <= max), !string.isEmpty {
            throw generateException(message)
        }
    }
    
    private func rangeValidation(min:Int, max:Int, message: String) throws {
        if let string = text, !string.isEmpty {
            guard let numeric = Int(string) else {
                throw generateException(message)
            }
            
            if !(numeric >= min && numeric <= max) {
                throw generateException(message)
            }
        }
    }
    
    // Generate error from validations
    private func generateException(_ message: String) -> Error {
        return NSError(domain: ValidationError.domain, code: ValidationError.errorCode, userInfo: [NSLocalizedDescriptionKey: message, "textField":self]) as Error
    }
    
}
