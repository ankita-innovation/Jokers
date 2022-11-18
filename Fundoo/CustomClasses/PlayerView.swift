//
//  PlayerView.swift
//  Fundoo
//
//  Created by MAC BOOK on 14/07/22.
//  Copyright © 2022 Hitasoft. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class PlayerView: UIView {

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer {
    
        return layer as! AVPlayerLayer
    }

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
    
        set {
            playerLayer.player = newValue
        }
    }
}
