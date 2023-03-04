//
//  EmailValidationPredicate.swift
//  VOD
//
//  Created by Hitasoft on 28/12/21.
//

import Foundation
import CoreGraphics
import UIKit

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    func isValidPhone() -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    func setAsSuperscript(_ textToSuperscript: String, font: UIFont = regular_14 ?? UIFont.systemFont(ofSize: 14)) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let foundRange = attributedString.mutableString.range(of: textToSuperscript)
        
        let font = font

        if foundRange.location != NSNotFound {
            attributedString.addAttribute(.font, value: font, range: foundRange)
            attributedString.addAttribute(.baselineOffset, value: 12, range: foundRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: foundRange)
        }
        return attributedString
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension NSMutableAttributedString {
    func setColorForText(_ textToFind: String?, with color: UIColor) {
        let range:NSRange?
        if let text = textToFind{
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range!)
        }
    }
    func setColorWithFont(_ textToFind: String?, with color: UIColor, font: UIFont) {
        let range:NSRange?
        if let text = textToFind{
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range!)
            addAttribute(NSAttributedString.Key.font, value: font, range: range!)
        }
    }
    class func getAttributedString(fromString string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string)
    }
    
    func apply(attribute: [NSAttributedString.Key: Any], subString: String)  {
        if let range = self.string.range(of: subString) {
            self.apply(attribute: attribute, onRange: NSRange(range, in: self.string))
        }
    }
    
    func apply(attribute: [NSAttributedString.Key: Any], onRange range: NSRange) {
        if range.location != NSNotFound {
            self.setAttributes(attribute, range: range)
        }
    }
    func apply(color: UIColor, font: UIFont, subString: String, headString: String, headColor: UIColor) {
      if let range = self.string.range(of: subString), let range1 = self.string.range(of: headString){
          self.addAttributes([NSAttributedString.Key.font: font], range: NSRange(range, in:self.string))
          self.apply(color: headColor, onRange: NSRange(range1, in:self.string))
        self.apply(color: color, onRange: NSRange(range, in:self.string))
      }
    }
    
    // Apply color on given range
    func apply(color: UIColor, onRange: NSRange) {
      self.addAttributes([NSAttributedString.Key.foregroundColor: color],
                         range: onRange)
    }
    
}

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = (self.description.components(separatedBy: ".").last)!.count
        return String(formatter.string(from: number) ?? "")
    }
}
