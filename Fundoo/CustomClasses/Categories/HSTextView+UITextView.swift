//
//  HSTextView+UITextView.swift
//  Fundoo
//
//  Created by APPLE on 07/09/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import Foundation

extension UITextView {
    
    public func configTextView(color:UIColor,font:UIFont?,alignment:NSTextAlignment, text:String) {
        self.textColor = color
        self.textAlignment = alignment
        self.text = Utility().getAppLanguage()?.value(forKey: text) as? String
        self.font = font
    }
    var currentWord : String? {

        let beginning = beginningOfDocument

        if let start = position(from: beginning, offset: selectedRange.location),
            let end = position(from: start, offset: selectedRange.length) {

            let textRange = tokenizer.rangeEnclosingPosition(end, with: .word, inDirection: UITextDirection(rawValue: 1))

            if let textRange = textRange {
                return text(in: textRange)
            }
        }
        return nil
       }
}

class customTextView: UITextView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if (action == #selector(cut(_:))) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
