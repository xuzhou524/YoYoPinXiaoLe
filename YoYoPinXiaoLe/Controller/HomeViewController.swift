//
//  HomeViewController.swift
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/5/7.
//

import UIKit
import GameKit
import GameplayKit

class HomeViewController: UIViewController,GKGameCenterControllerDelegate {

    let tipButton:UIButton = {
        let button = UIButton()
        button.setTitle("玩一下", for: .normal)
        button.setTitleColor(UIColor(named: "color_theme"), for: .normal)
        button.titleLabel?.font = blodFontWithSize(16)
        button.setBackgroundImage(UIColor(named: "color_title_black")?.image, for: .normal)
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        return button
    }()
    
    let tipButton1:UIButton = {
        let button = UIButton()
        button.setTitle("排行榜", for: .normal)
        button.setTitleColor(UIColor(named: "color_theme"), for: .normal)
        button.titleLabel?.font = blodFontWithSize(16)
        button.setBackgroundImage(UIColor(named: "color_title_black")?.image, for: .normal)
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        return button
    }()
    
    let tipButton2:UIButton = {
        let button = UIButton()
        button.setTitle("帮助中心", for: .normal)
        button.setTitleColor(UIColor(named: "color_theme"), for: .normal)
        button.titleLabel?.font = blodFontWithSize(16)
        button.setBackgroundImage(UIColor(named: "color_title_black")?.image, for: .normal)
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
        
        authenticateLocalPlayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "color_theme")
        
        self.view.addSubview(self.tipButton1)
        tipButton1.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.height.equalTo(48)
            make.width.equalTo(200)
        }

        self.view.addSubview(self.tipButton)
        tipButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tipButton1.snp.top).offset(-50)
            make.height.equalTo(48)
            make.width.equalTo(200)
        }

        self.view.addSubview(self.tipButton2)
        tipButton2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(tipButton1.snp.bottom).offset(50)
            make.height.equalTo(48)
            make.width.equalTo(200)
        }
        
        tipButton.addTarget(self, action: #selector(newGameClick), for: .touchUpInside)
        tipButton1.addTarget(self, action: #selector(rankListClick), for: .touchUpInside)
        tipButton2.addTarget(self, action: #selector(helpClick), for: .touchUpInside)

    }
    
    @objc func newGameClick() {
        self.navigationController?.pushViewController(PlayYoQiuGameViewController(), animated: true)
    }
    
    @objc func rankListClick() {
        let gameCenterVC = GKGameCenterViewController()
        gameCenterVC.gameCenterDelegate = self
        self.present(gameCenterVC, animated: true, completion: nil)
    }
    
    @objc func helpClick() {
        
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
}

//GameCenter
extension HomeViewController {
    func authenticateLocalPlayer(){
//        if isNoFirst {
//            isNoFirst = false
//            self.showloading()
//        }
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
//            self.hideLoading()
            if (viewController != nil) {
                let vc: UIViewController = self.view!.window!.rootViewController!
                vc.present(viewController!, animated: true) {
                    self.checkLocalAuthenticated()
                }
            }else {
                self.checkLocalAuthenticated()
            }
        }
    }
    
    func checkLocalAuthenticated() {
        if !GKLocalPlayer.local.isAuthenticated {
            print("没有授权，无法获取更多信息")
            GameUserInfoConfig.shared.gameId = ""
            GameUserInfoConfig.shared.gameName = "YoYo拼消乐"
//            sebWithoutAuthorizationViews()
        }else{
            //存储玩家信息 - id - name
            let localPlayer = GKLocalPlayer.local
            GameUserInfoConfig.shared.gameId = localPlayer.gamePlayerID
            GameUserInfoConfig.shared.gameName = localPlayer.displayName
            
//            sebViews()
            downLoadGameCenter()
        }
    }
    
    func downLoadGameCenter() {
        let leaderboadRequest = GKLeaderboard()
        //设置好友的范围
        leaderboadRequest.playerScope = .global

        let type = "all"
        if type == "today" {
            leaderboadRequest.timeScope = .today
        }else if type == "week" {
            leaderboadRequest.timeScope = .week
        }else if type == "all" {
            leaderboadRequest.timeScope = .allTime
        }

        //哪一个排行榜
        let identifier = "XZGame_YoYoPinXiaoLe"
        leaderboadRequest.identifier = identifier
        //从那个排名到那个排名
        let location = 1
        let length = 100
        leaderboadRequest.range = NSRange(location: location, length: length)

        //请求数据
        leaderboadRequest.loadScores { (scores, error) in
            if (error != nil) {
                print("请求分数失败")
                print("error = \(error)")
            }else{
                print("请求分数成功")
//                self.scores = scores
//                self.tableView.reloadData()
//                if let sss = scores as [GKScore]?  {
//                    for score in sss {
//                        let gamecenterID = score.leaderboardIdentifier
//                        let playerName = score.player.displayName
//                        let scroeNumb = score.value
//                        let rank = score.rank
//                        let gamePlayerID = score.player.gamePlayerID
//                        if GameUserInfoConfig.shared.gameId == gamePlayerID && GameUserInfoConfig.shared.gameName == playerName {
//                            GameUserInfoConfig.shared.gameShuHeHigheScore = Int(scroeNumb)
//                        }
//                        print("排行榜 = \(gamecenterID),玩家id = \(gamePlayerID),玩家名字 = \(playerName),玩家分数 = \(scroeNumb),玩家排名 = \(rank)")
//                    }
//                }
            }
        }
    }
}
