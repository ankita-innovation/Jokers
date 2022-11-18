//
//  AVPlayer+Extension.swift
//  Fundoo
//
//  Created by MAC BOOK on 11/07/22.
//  Copyright © 2022 Hitasoft. All rights reserved.
//

import Foundation
import AVKit
extension AVPlayer {
   
   var isPlaying: Bool {
      if (self.rate != 0 && self.error == nil) {
         return true
      } else {
         return false
      }
   }
   
}
