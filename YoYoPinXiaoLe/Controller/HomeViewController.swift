//
//  HomeViewController.swift
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/5/7.
//

import UIKit

class HomeViewController: UIViewController {

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
//        if(!GameView)
//        {
//            GameView = [[Connect5ViewController alloc] initWithNibName:@"Connect5ViewController_iPhone" bundle:nil];
//            GameView.IsResumedGame = NO;
//            [self.navigationController pushViewController:GameView animated:YES];
//        }
//        else
//        {
//            GameView.IsResumedGame = NO;
//            [self.navigationController pushViewController:GameView animated:YES];
//            [GameView ReloadNewGame];
//        }
        let gameVC = Connect5ViewController()
        gameVC.isResumedGame = false
        self.navigationController?.pushViewController(gameVC, animated: true)
        
        
    }
    
    @objc func rankListClick() {
        
    }
    
    @objc func helpClick() {
        
    }
    
}
