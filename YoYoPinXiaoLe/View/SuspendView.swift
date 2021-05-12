//
//  SuspendView.swift
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/5/12.
//

import UIKit

class SuspendView: UIView {

    var gameCompletion:(() -> Void)?
    var completion:(() -> Void)?
    var index:Int?
    init() {
        super.init(frame: CGRect(x: 30, y: kScreenHeight / 2.0 - 220, width: kScreenWidth - 60 , height: 350))
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10;
        self.clipsToBounds = true
    
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(30)
            make.width.equalTo(220)
            make.height.equalTo(83)
        }
        
        self.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(45)
        }
        
        self.addSubview(doneButton)
        doneButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.cancelButton.snp.top).offset(-25)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(45)
        }
        
        self.addSubview(gameButton)
        gameButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.doneButton.snp.top).offset(-25)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(45)
        }
    
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        gameButton.addTarget(self, action: #selector(game), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func done() {
        self.completion?()
        hide()
    }
    
    @objc func game() {
        self.gameCompletion?()
        hide()
    }
    
    let iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "restImage")
        return imageView
    }()

    let doneButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("返回首页", for: .normal)
        btn.backgroundColor = UIColor(named: "color_black")
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        btn.setTitleColor(UIColor(named: "color_white"), for: .normal)
        btn.titleLabel?.font = fontWithSize(18)
        return btn
    }()
    
    let gameButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("新游戏", for: .normal)
        btn.backgroundColor = UIColor(named: "color_black")
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        btn.setTitleColor(UIColor(named: "color_white"), for: .normal)
        btn.titleLabel?.font = fontWithSize(18)
        return btn
    }()
    
    let cancelButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor(named: "color_black"), for: .normal)
        btn.titleLabel?.font = fontWithSize(18)
        return btn
    }()
    
    
    let panel:UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        view.isUserInteractionEnabled = true
        return view
    }()
    @objc func show() {
        let window = Client.shared.mainWindow
        window.addSubview(panel)
        window.addSubview(self)
        
        panel.alpha = 0
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        UIView.animate(withDuration: 0.3) {
            self.panel.alpha = 1
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    @objc func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.panel.alpha = 0
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }) { (_) in
            self.panel.removeFromSuperview()
            self.removeFromSuperview()
        }
    }

}
