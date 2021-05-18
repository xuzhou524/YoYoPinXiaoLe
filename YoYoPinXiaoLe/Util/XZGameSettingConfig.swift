//
//  XZGameSettingConfig.swift
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/5/18.
//

import UIKit

class XZGameSettingConfig: NSObject {
    
    static let shared = XZGameSettingConfig()

    //音效开关 0 关 1 开
    var gameSoundType: Int = 1
    @objc static func getGameSoundType() -> Int {
        return XZGameSettingConfig.shared.gameSoundType
    }

}
