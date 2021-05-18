//
//  HomeViewController.swift
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/5/7.
//

import UIKit
import GameKit
import GameplayKit

class HomeViewController: UIViewController,GKGameCenterControllerDelegate {
    
    let nameImageView:UIView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "YoYoImage")
        return imageView
    }()

    let tipButton:UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("playGame"), for: .normal)
        button.setTitleColor(UIColor(named: "color_theme"), for: .normal)
        button.titleLabel?.font = blodFontWithSize(18)
        button.backgroundColor = UIColor(named: "color_title_black")
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        button.alpha = 0.8
        return button
    }()
    
    let tipButton1:UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("rankList"), for: .normal)
        button.setTitleColor(UIColor(named: "color_theme"), for: .normal)
        button.titleLabel?.font = blodFontWithSize(18)
        button.backgroundColor = UIColor(named: "color_title_black")
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        button.alpha = 0.8
        return button
    }()
    
    let tipButton2:UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("helpCenterTitle"), for: .normal)
        button.setTitleColor(UIColor(named: "color_theme"), for: .normal)
        button.titleLabel?.font = blodFontWithSize(18)
        button.backgroundColor = UIColor(named: "color_title_black")
        button.layer.cornerRadius = 19
        button.layer.masksToBounds = true
        button.alpha = 0.8
        return button
    }()
    
    let privacyBtn:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "color_title_black")
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.alpha = 0.3
        return button
    }()
    let privacyImageView:UIView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "privacyImage")
        return imageView
    }()
    
    let praiseBtn:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "color_title_black")
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.alpha = 0.3
        return button
    }()
    let praiseImageView:UIView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "praiseImage")
        return imageView
    }()
    
    let shareBtn:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "color_title_black")
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.alpha = 0.3
        return button
    }()
    let shareImageView:UIView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "shareImage")
        return imageView
    }()
    
    let soundView:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "color_title_black")
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.alpha = 0.3
        return button
    }()
    let soundImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_sound")
        return imageView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
        
        authenticateLocalPlayer()
        
        updateSoundView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "color_theme")
        
        self.view.addSubview(nameImageView)
        nameImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(125)
            make.width.equalTo(236)
            make.height.equalTo(59)
        }
        
        self.view.addSubview(tipButton1)
        tipButton1.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.height.equalTo(45)
            make.width.equalTo(200)
        }

        self.view.addSubview(tipButton)
        tipButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tipButton1.snp.top).offset(-30)
            make.height.equalTo(45)
            make.width.equalTo(200)
        }

        self.view.addSubview(tipButton2)
        tipButton2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(tipButton1.snp.bottom).offset(30)
            make.height.equalTo(45)
            make.width.equalTo(200)
        }
        
        tipButton.addTarget(self, action: #selector(newGameClick), for: .touchUpInside)
        tipButton1.addTarget(self, action: #selector(rankListClick), for: .touchUpInside)
        tipButton2.addTarget(self, action: #selector(helpClick), for: .touchUpInside)
        
        self.view.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.tipButton2.snp.centerX).offset(-15)
            make.top.equalTo(tipButton2.snp.bottom).offset(60)
            make.width.height.equalTo(36)
        }
        self.view.addSubview(shareImageView)
        shareImageView.snp.makeConstraints { (make) in
            make.center.equalTo(shareBtn)
            make.width.height.equalTo(20)
        }
        
        self.view.addSubview(privacyBtn)
        privacyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.tipButton2.snp.centerX).offset(15)
            make.top.equalTo(tipButton2.snp.bottom).offset(60)
            make.width.height.equalTo(36)
        }
        self.view.addSubview(privacyImageView)
        privacyImageView.snp.makeConstraints { (make) in
            make.center.equalTo(privacyBtn)
            make.width.height.equalTo(25)
        }
        
        self.view.addSubview(soundView)
        soundView.snp.makeConstraints { (make) in
            make.right.equalTo(self.shareBtn.snp.left).offset(-30)
            make.top.equalTo(tipButton2.snp.bottom).offset(60)
            make.width.height.equalTo(36)
        }
        self.view.addSubview(soundImageView)
        soundImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.soundView)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        updateSoundView()
        
        self.view.addSubview(praiseBtn)
        praiseBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.privacyBtn.snp.right).offset(30)
            make.top.equalTo(tipButton2.snp.bottom).offset(60)
            make.width.height.equalTo(36)
        }
        self.view.addSubview(praiseImageView)
        praiseImageView.snp.makeConstraints { (make) in
            make.center.equalTo(praiseBtn)
            make.width.height.equalTo(22)
        }
        
        privacyBtn.addTarget(self, action: #selector(privacyClick), for: .touchUpInside)
        praiseBtn.addTarget(self, action: #selector(praiseClick), for: .touchUpInside)
        shareBtn.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        soundView.addTarget(self, action: #selector(sound), for: .touchUpInside)
    }
    
    @objc func newGameClick() {
        if GKLocalPlayer.local.isAuthenticated {
            self.navigationController?.pushViewController(PlayYoQiuGameViewController(), animated: true)
        }else{
            let views = XZTipView()
            views.gameCompletion = {[weak self] in
                self?.navigationController?.pushViewController(PlayYoQiuGameViewController(), animated: true)
            }
            views.show()
        }
    }
    
    @objc func rankListClick() {
        let gameCenterVC = GKGameCenterViewController()
        gameCenterVC.gameCenterDelegate = self
        self.present(gameCenterVC, animated: true, completion: nil)
    }
    
    @objc func helpClick() {
        self.navigationController?.pushViewController(HelpViewController(), animated: true)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func privacyClick() {
        let webViewVC = XZWebViewController.init(url: "https://www.gezhipu.com/yoyoPinXiaoLe.pdf", titleStr: NSLocalizedString("privacyAgreement"))
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    @objc func praiseClick() {
        let  urlString = "itms-apps://itunes.apple.com/app/id1566548746?action=write-review"
        UIApplication.shared.open(URL.init(string: urlString)!, options: [:], completionHandler: nil)
    }
    
    @objc func shareClick() {
        let activityController = UIActivityViewController(activityItems: ["https://apps.apple.com/cn/app/id1566548746" + " (分享来自@YoYo拼消乐) " ], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
    }
    
    @objc func sound(){
        if XZGameSettingConfig.shared.gameSoundType == 1 {
            XZGameSettingConfig.shared.gameSoundType = 0
        }else{
            XZGameSettingConfig.shared.gameSoundType = 1
        }
        updateSoundView()
    }
    
    func updateSoundView() {
        if XZGameSettingConfig.shared.gameSoundType == 1 {
            soundImageView.image = UIImage(named: "ic_sound")
        }else{
            soundImageView.image = UIImage(named: "ic_soundClose")
        }
    }
    
}

//GameCenter
extension HomeViewController {
    func authenticateLocalPlayer(){
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
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
        }else{
            //存储玩家信息 - id - name
            let localPlayer = GKLocalPlayer.local
            GameUserInfoConfig.shared.gameId = localPlayer.gamePlayerID
            GameUserInfoConfig.shared.gameName = localPlayer.displayName

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
            if scores?.count ?? 0 > 0 {
                print("请求分数成功")
                if let sss = scores as [GKScore]?  {
                    for score in sss {
                        let gamecenterID = score.leaderboardIdentifier
                        let playerName = score.player.displayName
                        let scroeNumb = score.value
                        let rank = score.rank
                        let gamePlayerID = score.player.gamePlayerID
                        if GameUserInfoConfig.shared.gameId == gamePlayerID && GameUserInfoConfig.shared.gameName == playerName {
                            GameUserInfoConfig.shared.gameHigheScore = Int(scroeNumb)
                        }
                        print("排行榜 = \(gamecenterID),玩家id = \(gamePlayerID),玩家名字 = \(playerName),玩家分数 = \(scroeNumb),玩家排名 = \(rank)")
                    }
                }
            }else{
                print("请求分数失败")
                print("error = \(error)")
            }
        }
    }
}
