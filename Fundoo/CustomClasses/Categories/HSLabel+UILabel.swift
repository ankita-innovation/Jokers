//
//  HSLabel+UILabel.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 10/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
 
    //MARK: configure label
    public func config(color:UIColor,font:UIFont?, align:NSTextAlignment, text:String){
        self.textColor = color
        self.textAlignment = align
        self.text = Utility().getAppLanguage()?.value(forKey: text) as? String
        self.font = font
    }
    
    func cornerRadius() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    func lblMinimumCornerRadius() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    func setCustomColor(colorString : String, color : UIColor){
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self.text!);
        let range = attributedString.mutableString.range(of: colorString, options:NSString.CompareOptions.caseInsensitive)
        if range.location != NSNotFound {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range);
        }
        self.attributedText = attributedString
        
    }
    
  //MARK: check textfield is empty
     func isEmptyValue() -> Bool {
         if  (self.text! == "") || (self.text! == "NULL") || (self.text! == "(null)") || self.text! == nil || (self.text! == "<null>") || (self.text! == "Json Error") || (self.text! == "0") || (self.text!.isEmpty) ||  self.text!.trimmingCharacters(in: .whitespaces).isEmpty {
             return true
         }
         return false
     }
}
