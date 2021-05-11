//
//  PlayYoQiuGameViewController.swift
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/5/7.
//

import UIKit

class PlayYoQiuGameViewController: UIViewController {

    //分
    let scoreBoardLabel:UILabel = {
        let label = UILabel()
        label.font = blodFontWithSize(35)
        label.textColor = UIColor(named: "color_title_black")
        label.text = "0"
        return label
    }()
    //游戏操作区
    let gameContainerView:UIView = {
        let view = UIView()
        return view
    }()
    
    let matrix:MatrixView = {
        let view = MatrixView.init(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
        return view
    }()
    
    let undoBtn:UIButton = {
        let button = UIButton()
        return button
    }()
    
    let suspendView:UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIColor(named: "color_title_black")?.image, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.alpha = 0.3
        return button
    }()
    let suspendImageView:UIView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "suspendImage")
        return imageView
    }()
    
    let reductionView:UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIColor(named: "color_title_black")?.image, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.alpha = 0.3
        return button
    }()
    let reductionImageView:UIView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "reductionImage")
        return imageView
    }()
    
    let progressView:SSPieProgressView = {
        let view = SSPieProgressView()
        view.pieFillColor = UIColor.red
        view.pieBorderColor = UIColor.blue
        view.pieBackgroundColor = UIColor.gray
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
            make.top.equalToSuperview().offset(60)
        }
        
        self.view.addSubview(gameContainerView)
        gameContainerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.width.equalTo(320)
            make.height.equalTo(350)
        }

        matrix.delegate = self
        matrix.scoreBoard = scoreBoardLabel
        
        let y = 0
        let xOffset = -15
        let padding = 2
        let cellSize = 32
        
        for i in 0..<5 {
            let cell:CellView = CellView.init(frame: CGRect(x: 20+Int(i)*(cellSize+padding)+xOffset, y: y, width: cellSize, height: cellSize))
            cell.tag = Int(4000+i)
            gameContainerView.addSubview(cell)
        }
        
        matrix.undoBtn = undoBtn
        gameContainerView.addSubview(matrix)
        
        self.view.addSubview(self.suspendView)
        suspendView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(self.scoreBoardLabel)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        self.view.addSubview(suspendImageView)
        suspendImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.suspendView)
            make.height.equalTo(12)
            make.width.equalTo(12)
        }
        
        self.view.addSubview(self.reductionView)
        reductionView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(self.scoreBoardLabel)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        self.view.addSubview(reductionImageView)
        reductionImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.reductionView)
            make.height.equalTo(18)
            make.width.equalTo(18)
        }

        self.suspendView.addTarget(self, action: #selector(quit), for: .touchUpInside)
        self.reductionView.addTarget(self, action: #selector(undo), for: .touchUpInside)
        
        self.view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.scoreBoardLabel.snp.bottom).offset(20)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        
        progressView.addSubview(LevelLbl)
        LevelLbl.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}

extension PlayYoQiuGameViewController: MatrixViewDelegate {
    func matrixViewQuit(_ matrixView: MatrixView!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addNextCells(withGraphCells GCells: [Any]!) {
        for i in 0..<5 {
            let cell:CellView = self.view.viewWithTag(4000+Int(i)) as! CellView
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
            let cell:CellView = self.view.viewWithTag(4000+Int(i)) as! CellView
            cell.setStatusWith(emptyCell, animatation: CellAnimationType.init(rawValue: 2))
        }
    }
}

extension PlayYoQiuGameViewController {
    @objc func quit(){
        let classTypeActionSheet = DoActionSheet()
        classTypeActionSheet.showC(" ",
                                   cancel: "取消",
                                   buttons: ["返回","新游戏"]) { (nResult) in
            if nResult == 0 {
                XZGameCenterService.saveHighScore(score: NSInteger(self.matrix.currentGame.score.score))
                self.navigationController?.popViewController(animated: true)
            }else if nResult == 1 {
                self.resetNextCells()
                self.matrix.reloadNewGame()
            }
        }
    }
    
    @objc func undo(){
        matrix.undoLastMove()
    }
}
