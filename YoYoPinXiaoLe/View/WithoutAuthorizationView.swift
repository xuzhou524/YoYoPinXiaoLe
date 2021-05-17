//
//  WithoutAuthorizationView.swift
//  QiuQiu
//
//  Created by xuzhou on 2021/4/16.
//

import UIKit

class WithoutAuthorizationView: UIView {

    let oneLabel:UILabel = {
        let label = UILabel()
        label.font = blodFontWithSize(16)
        label.textColor = UIColor(named: "color_title_black")
        label.numberOfLines = 0
        label.text = NSLocalizedString("helpCenterSum1")
        return label
    }()
    
    let oneImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "helpOne")
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let twoLabel:UILabel = {
        let label = UILabel()
        label.font = blodFontWithSize(16)
        label.textColor = UIColor(named: "color_title_black")
        label.numberOfLines = 0
        label.text = NSLocalizedString("helpCenterSum2")
        return label
    }()
    
    let twoImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "helpTwe")
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let threeLabel:UILabel = {
        let label = UILabel()
        label.font = blodFontWithSize(16)
        label.textColor = UIColor(named: "color_title_black")
        label.numberOfLines = 0
        label.text = NSLocalizedString("helpCenterSum3")
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "color_theme")
        sebViews()
    }
    
    func sebViews() {
        
        self.addSubview(oneLabel)
        self.addSubview(oneImageView)
        self.addSubview(twoLabel)
        self.addSubview(twoImageView)
        self.addSubview(threeLabel)
        
        oneLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(25)
        }
        
        oneImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(oneLabel.snp.bottom).offset(10)
            make.height.equalTo((kScreenWidth - 50) / 2.36)
        }
        
        twoLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(oneImageView.snp.bottom).offset(20)
        }
        
        twoImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(twoLabel.snp.bottom).offset(10)
            make.height.equalTo((kScreenWidth - 50) / 1.47)
        }
        
        threeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(twoImageView.snp.bottom).offset(20)
        }
        
    }

}
