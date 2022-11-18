//
//  TextViewAround.swift
//  YouKoach
//
//  Created by Roby on 07/11/19.
//  Copyright © 2019 Hitasoft. All rights reserved.
//

import UIKit
@objc

class TextViewAround: NSObject {

    //latest xcode need this
        static func executeWorkaround() {
            if #available(iOS 13.2, *) {
            } else {
                let className = "_UITextLayoutView"
                let theClass = objc_getClass(className)
                if theClass == nil {
                    let classPair: AnyClass? = objc_allocateClassPair(UIView.self, className, 0)
                    objc_registerClassPair(classPair!)
                }
            }
        }
}
