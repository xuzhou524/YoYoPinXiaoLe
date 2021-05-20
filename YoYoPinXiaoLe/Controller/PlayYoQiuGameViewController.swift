//
//  PlayYoQiuGameViewController.swift
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/5/7.
//

import UIKit

class PlayYoQiuGameViewController: UIViewController {

    //分
    let scoreBoardLabel:UILabel = {
        let label = UILabel()
        label.font = chalkboardSESize(35)
        label.textColor = UIColor(named: "color_title_black")
        label.text = "0"
        return label
    }()
    //最高分
    let highScoreLabel:UILabel = {
        let label = UILabel()
        label.font = chalkboardSESize(18)
        label.textColor = UIColor(named: "color_title_black")
        label.text = "\(GameUserInfoConfig.shared.gameHigheScore)"
        return label
    }()
    let crownImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_crown")
        return imageView
    }()
    //暂停
    let suspendView:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "color_title_black")
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.alpha = 0.3
        return button
    }()
    let suspendImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "suspendImage")
        return imageView
    }()
    //撤销
    let reductionView:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "color_title_black")
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.alpha = 0.3
        return button
    }()
    let reductionImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "reductionImage")
        return imageView
    }()
    //音效开关
    let soundView:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "color_title_black")
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.alpha = 0.3
        return button
    }()
    let soundImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_sound")
        return imageView
    }()
    
    //游戏操作区
    let gameContainerView:UIView = {
        let view = UIView()
        return view
    }()
    
    let matrix:CrystalBallMatrixView = {
        let view = CrystalBallMatrixView.init(frame: CGRect(x: 0, y: 0, width: kIsFullScreen ? 320 : 256, height: kIsFullScreen ? 320 : 256))
        return view
    }()
    
    let reductionBtn:UIButton = {
        let button = UIButton()
        return button
    }()
    //进度
    let progressView:GWProgressView = {
        let view = GWProgressView.init(frame: CGRect(x: 40, y: 0, width: kScreenWidth-80, height: 15))
        view.trackTintColor = UIColor.lightGray
        view.progressTintColor = UIColor(named: "color_red")
        return view
    }()
    let LevelLbl:UILabel = {
        let label = UILabel()
        label.font = blodFontWithSize(16)
        label.textColor = UIColor(named: "color_title_black")
        label.text = "0"
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
        checkLocalAuthenticated()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "color_theme")
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.backgroundColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: view)
        
        sebViews()
    }
    
    func sebViews(){
        self.view.addSubview(scoreBoardLabel)
        scoreBoardLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kIsFullScreen ? 35 : 25)
        }
        
        self.view.addSubview(highScoreLabel)
        highScoreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(scoreBoardLabel.snp.bottom)
            make.centerX.equalToSuperview().offset(10)
        }
        
        self.view.addSubview(crownImageView)
        crownImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(highScoreLabel)
            make.right.equalTo(highScoreLabel.snp.left).offset(-5)
            make.width.height.equalTo(18)
        }
        
        self.view.addSubview(gameContainerView)
        gameContainerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(kIsFullScreen ? 10 : 20)
            make.width.equalTo(kIsFullScreen ? 320 : 256)
            make.height.equalTo(kIsFullScreen ? 350 : 290)
        }

        matrix.delegate = self
        matrix.scoreBoard = scoreBoardLabel
        matrix.scoreBoardH = highScoreLabel
        
        let y = 0
        let xOffset = -15
        let padding = 2
        let cellSize = 32
        
        for i in 0..<5 {
            let cell:XZYoYoCellView = XZYoYoCellView.init(frame: CGRect(x: 20+Int(i)*(cellSize+padding)+xOffset, y: y, width: cellSize, height: cellSize))
            cell.tag = Int(4000+i)
            gameContainerView.addSubview(cell)
        }
        
        matrix.reductionBtn = reductionBtn
        gameContainerView.addSubview(matrix)
        
        self.view.addSubview(suspendView)
        suspendView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(self.scoreBoardLabel)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        self.view.addSubview(suspendImageView)
        suspendImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.suspendView)
            make.height.equalTo(13)
            make.width.equalTo(13)
        }
        
        self.view.addSubview(reductionView)
        reductionView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(self.scoreBoardLabel)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        self.view.addSubview(reductionImageView)
        reductionImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.reductionView)
            make.height.equalTo(15)
            make.width.equalTo(15)
        }
        
        self.view.addSubview(soundView)
        soundView.snp.makeConstraints { (make) in
            make.right.equalTo(self.reductionView.snp.left).offset(-20)
            make.bottom.equalTo(self.scoreBoardLabel)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        self.view.addSubview(soundImageView)
        soundImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.soundView)
            make.height.equalTo(18)
            make.width.equalTo(18)
        }
        updateSoundView()

        self.suspendView.addTarget(self, action: #selector(quit), for: .touchUpInside)
        self.reductionView.addTarget(self, action: #selector(reduction), for: .touchUpInside)
        self.soundView.addTarget(self, action: #selector(sound), for: .touchUpInside)
        
        self.view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(self.highScoreLabel.snp.bottom).offset(65)
            make.height.equalTo(15)
        }
        
        progressView.addSubview(LevelLbl)
        LevelLbl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.progressView.snp.top).offset(-15)
        }
    }
}

extension PlayYoQiuGameViewController: CrystalBallMatrixViewDelegate {
    func crystalBallMatrixViewQuit(_ matrixView: CrystalBallMatrixView!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addNextCells(withGraphCells GCells: [Any]!) {
        for i in 0..<5 {
            let cell:XZYoYoCellView = self.view.viewWithTag(4000+Int(i)) as! XZYoYoCellView
            if ( GCells != nil && i < GCells.count){
                let emptyCell:GraphCell = GCells[Int(i)] as! GraphCell
                cell.setStatusWith(emptyCell, animatation: CellAnimationType.init(rawValue: 2))
            }else{
                let emptyCell = GraphCell()
                emptyCell.color = unOccupied
                cell.setStatusWith(emptyCell, animatation: CellAnimationType.init(rawValue: 2))
            }
        }
    }
    
    func setProgress(_ progress: CGFloat, withLevelNumber levelNo: Int32) {
        progressView.progress = progress
        LevelLbl.text = "Level \(levelNo)"
    }
    
    func resetNextAddedCells() {
        resetNextCells()
    }
    
    func resetNextCells() {
        let emptyCell = GraphCell()
        emptyCell.color = unOccupied
        for i in 0..<5 {
            let cell:XZYoYoCellView = self.view.viewWithTag(4000+Int(i)) as! XZYoYoCellView
            cell.setStatusWith(emptyCell, animatation: CellAnimationType.init(rawValue: 2))
        }
    }
}

extension PlayYoQiuGameViewController {
    @objc func quit(){
        
        let virtuaew = SuspendView()
        
        virtuaew.gameCompletion = {[weak self] in
            self?.resetNextCells()
            self?.matrix.reloadNewGame()
        }
        virtuaew.completion = {[weak self] in
            XZGameCenterService.saveHighScore(score: NSInteger(self?.matrix.currentGame.score.score ?? 0))
            self?.navigationController?.popViewController(animated: true)
        }
        virtuaew.show()
    }
    
    @objc func reduction(){
        matrix.reductionLastMove()
    }
    
    @objc func sound(){
        if XZSettings.shared[.kSoundSwitch] == 1 {
            XZSettings.shared[.kSoundSwitch] = 0
        }else{
            XZSettings.shared[.kSoundSwitch] = 1
        }
        updateSoundView()
    }
    
    func updateSoundView() {
        if XZSettings.shared[.kSoundSwitch] == 1 {
            soundImageView.image = UIImage(named: "ic_sound")
        }else{
            soundImageView.image = UIImage(named: "ic_soundClose")
        }
    }
}

//GameCenter
extension PlayYoQiuGameViewController {

    func checkLocalAuthenticated() {
        if GKLocalPlayer.local.isAuthenticated {
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
        //从哪个排名到哪个排名
        let location = 1
        let length = 100
        leaderboadRequest.range = NSRange(location: location, length: length)

        //请求数据
        leaderboadRequest.loadScores {[weak self] (scores, error) in
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
                            self?.highScoreLabel.text = "\(GameUserInfoConfig.shared.gameHigheScore)"
                        }
                        print("排行榜 = \(gamecenterID),玩家id = \(gamePlayerID),玩家名字 = \(playerName),玩家分数 = \(scroeNumb),玩家排名 = \(rank)")
                    }
                }
            }
        }
    }
}
