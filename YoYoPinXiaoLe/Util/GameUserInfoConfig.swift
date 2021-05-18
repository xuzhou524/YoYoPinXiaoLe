//
//  GameUserInfoConfig.swift
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/4/25.
//

import UIKit

class GameUserInfoConfig: NSObject {
    static let shared = GameUserInfoConfig()

    //玩家昵称
    
    var gameId : String = ""
    var gameName: String = "YoYo拼消乐"
    
    //数和 最高分
    var gameHigheScore: NSInteger = 0
    @objc static func getGameHigheScore() -> NSInteger {
        return GameUserInfoConfig.shared.gameHigheScore
    }

}
