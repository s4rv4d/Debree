//
//  TabbarHeader.swift
//  Debree
//
//  Created by Sarvad shetty on 3/18/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.4078431373, blue: 0.3490196078, alpha: 1)
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        // anchor your view right above the tabBar
        containerView.bottomAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 6).isActive = true
    }
}
