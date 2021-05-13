//
//  XZTipView.swift
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/5/13.
//

import UIKit

class XZTipView: UIView {
    
    var gameCompletion:(() -> Void)?
    var completion:(() -> Void)?

    init() {
        super.init(frame: CGRect(x: 30, y: kScreenHeight / 2.0 - 120, width: kScreenWidth - 60 , height: 150))
        
        self.backgroundColor = UIColor(named: "color_red")
        self.layer.cornerRadius = 5;
        self.clipsToBounds = true
        
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(20)
            make.width.height.equalTo(16)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(20)
            make.centerY.equalTo(self.iconImageView)
        }

        self.addSubview(summeryLabel)
        summeryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
        }
        
        self.addSubview(gameButton)
        gameButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(55)
            make.height.equalTo(45)
        }
        
        self.addSubview(doneButton)
        doneButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.right.equalTo(self.gameButton.snp.left).offset(-30)
            make.width.equalTo(55)
            make.height.equalTo(45)
        }
        
        panel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        doneButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        gameButton.addTarget(self, action: #selector(game), for: .touchUpInside)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "errorImage")
        return imageView
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = fontWithSize(16)
        label.textColor = UIColor(named: "color_title_black")
        label.text = "友情提示"
        return label
    }()
    
    let summeryLabel:UILabel = {
        let label = UILabel()
        label.font = fontWithSize(13)
        label.textColor = UIColor(named: "color_title_black")
        label.text = "当前Game Center没有授权无法保存分值，请点击帮助中心查看如何开启"
        label.numberOfLines = 0
        return label
    }()
    
    let doneButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor(named: "color_white"), for: .normal)
        btn.titleLabel?.font = fontWithSize(16)
        return btn
    }()
    
    let gameButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("继续", for: .normal)
        btn.setTitleColor(UIColor(named: "color_white"), for: .normal)
        btn.titleLabel?.font = fontWithSize(16)
        return btn
    }()

    let panel:UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.clear
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
    
    @objc func game() {
        self.gameCompletion?()
        hide()
    }

}
