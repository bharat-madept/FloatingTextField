//
//  ValidationRules.swift
//  FloatingtextField
//
//  Created by Bharat Lal on 26/09/17.
//  Copyright © 2017 Bharat Lal. All rights reserved.
//

import Foundation
import UIKit
enum ValidationRule {
    case required(message: String)               // String is required or not empty
    case lettersOnly(message: String)                 // Only allowed A-Z lower or upper case and blank space.
    case maxLength(value: Int, message: String)  // Maximum string length
    case minLength(value: Int, message: String)  // Minimum string length
    case email(message: String)
    case mobile(message: String)
    case password(message: String)
    case characterRange(min:Int, max:Int, message: String)
    case alphaNumeric(message: String)            // Only allowed A-Z lower or upper case or blank space or numeric values.
    case range(min:Int, max:Int, message: String) // Range only apply on numeric values
}

struct ValidationError {
    static let domain               = "VALIDATIONFAILED"
    static let errorCode            = 501
}
