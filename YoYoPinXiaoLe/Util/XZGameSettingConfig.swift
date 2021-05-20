//
//  XZGameSettingConfig.swift
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/5/18.
//

import UIKit

class XZGameSettingConfig: NSObject {
    
    static let shared = XZGameSettingConfig()

    @objc static func getGameSoundType() -> Int {
        return Int(XZSettings.shared[.kSoundSwitch] ?? 1)
    }

}
