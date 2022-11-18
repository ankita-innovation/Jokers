//
//  Connectivity.swift
//  Fundoo
//
//  Created by MAC BOOK on 18/07/22.
//  Copyright © 2022 Hitasoft. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity {
    class func isConnectedToInternet() ->Bool {
        if let status = NetworkReachabilityManager()?.isReachable {
            return status
        }
        return false
    }
}
