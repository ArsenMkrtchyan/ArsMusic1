//
//  CMTime + Extension.swift
//  ArsMusic
//
//  Created by Arsen Mkrtchyan on 4/25/20.
//  Copyright © 2020 smu117. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    
    func toDisplayString() ->  String {
        guard  !CMTimeGetSeconds(self).isNaN else {return ""}
        let totalSecend = Int(CMTimeGetSeconds(self))
        let secends = totalSecend % 60
        let minuts = totalSecend / 60
        let timeFormatString = String(format: "%02d:%02d", minuts,secends)
        return timeFormatString
    }
}
