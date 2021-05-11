//
//  TopPromptView.swift
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/5/11.
//

import UIKit

class TopPromptView: UIView {
    let bgImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_QiuQiu")
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = blodFontWithSize(22)
        label.textColor = UIColor(named: "color_white")
        label.text = "生肖来了"
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sebViews()
    }
    
    func sebViews() {
        
        self.addSubview(bgImageView)
        self.addSubview(titleLabel)
        
        bgImageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(15)
            make.bottom.right.equalToSuperview().offset(-15)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35)
            make.top.equalToSuperview().offset(35)
        }

    }

}
