//
//  TopPromptView.swift
//  YoYoPinXiaoLe
//
//  Created by xuzhou on 2021/5/11.
//

import UIKit

class TopPromptView: UIView {
        
    init() {
        super.init(frame: CGRect(x: 20, y: 44, width: kScreenWidth - 40 , height: 80))
        
        self.backgroundColor = UIColor(named: "color_red")
        self.layer.cornerRadius = 5;
        self.clipsToBounds = true
        
        self.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.height.equalTo(16)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(20)
            make.bottom.equalTo(self.snp.centerY).offset(-5)
        }

        self.addSubview(summeryLabel)
        summeryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.snp.centerY).offset(3)
        }
        
        panel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        self.perform(#selector(self.hide), with: nil, afterDelay: 2.0)
        
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
        label.textColor = UIColor(named: "color_white")
        label.text = "友情提示"
        return label
    }()
    
    let summeryLabel:UILabel = {
        let label = UILabel()
        label.font = fontWithSize(13)
        label.textColor = UIColor(named: "color_white")
        label.text = "到达此处位置的路不通，无法抵达."
        return label
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

}
