//
//  PlayYoQiuGameViewController.swift
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/5/7.
//

import UIKit

class PlayYoQiuGameViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "color_theme")

    }

}
