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
        label.font = blodFontWithSize(30)
        label.textColor = UIColor(named: "color_title_black")
        label.text = "0"
        return label
    }()
    //游戏操作区
    let gameContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orange
        return view
    }()
    
    let matrix:MatrixView = {
        let view = MatrixView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        return view
    }()
    
    let undoBtn:UIButton = {
        let button = UIButton()
        return button
    }()
    
    let cancelBtn:UIButton = {
        let button = UIButton()
        button.setTitle("暂停", for: .normal)
        button.setTitleColor(UIColor(named: "color_theme"), for: .normal)
        button.titleLabel?.font = blodFontWithSize(14)
        button.setBackgroundImage(UIColor(named: "color_title_black")?.image, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    let okBtn:UIButton = {
        let button = UIButton()
        button.setTitle("撤销", for: .normal)
        button.setTitleColor(UIColor(named: "color_theme"), for: .normal)
        button.titleLabel?.font = blodFontWithSize(14)
        button.setBackgroundImage(UIColor(named: "color_title_black")?.image, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "color_theme")
        sebViews()
    }
    
    func sebViews(){
        self.view.addSubview(scoreBoardLabel)
        scoreBoardLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        self.view.addSubview(gameContainerView)
        gameContainerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.height.equalTo(kScreenWidth)
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
        
        self.view.addSubview(self.cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(self.scoreBoardLabel.snp.bottom).offset(10)
            make.height.equalTo(48)
            make.width.equalTo(48)
        }
        self.view.addSubview(self.okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.scoreBoardLabel.snp.bottom).offset(10)
            make.height.equalTo(48)
            make.width.equalTo(48)
        }
//        self.cancelBtn.addTarget(self.matrix, action: #selector(matrix.cancelAction(_:)), for: .touchUpInside)
//        self.okBtn.addTarget(self.matrix, action: #selector(matrix.okAction(_:)), for: .touchUpInside)
        self.cancelBtn.addTarget(self, action: #selector(quit), for: .touchUpInside)
        self.okBtn.addTarget(self, action: #selector(undo), for: .touchUpInside)
        
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
        classTypeActionSheet.showC("Pause",
                                   cancel: "取消",
                                   buttons: ["Quit","New Game"]) { (nResult) in
            if nResult == 0 {
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
