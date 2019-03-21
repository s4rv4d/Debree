//
//  LottieViewController.swift
//  Debree
//
//  Created by Sarvad shetty on 3/18/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import Lottie

class LottieViewController: UIViewController {
    
    //MARK: - Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - IBOutlets
    @IBOutlet weak var animationView: LOTAnimationView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        start()
    }
    
    //MARK: - Function
    func start(){
        animationView.setAnimation(named: "debree final")
        animationView.play { (val) in
            if val == true{
                
                guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "mainTab") as? UITabBarController else{
                    fatalError("couldnt init")
                }
                DispatchQueue.main.async {
                    let transition = CATransition()
                    transition.duration = 0.1
                    transition.type = CATransitionType.fade
                    transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
                    self.view.window?.layer.add(transition, forKey: kCATransition)
                    //                        self.present(vc, animated: false, completion: nil)
                    self.appDelegate.window?.rootViewController = vc
                }

                
                //change this if condition
//                if UserDefaults.standard.data(forKey: KLOGINSTATE) == nil{
//                    guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else{
//                        fatalError("couldnt init")
//                    }
//                    DispatchQueue.main.async {
//                        let transition = CATransition()
//                        transition.duration = 0.1
//                        transition.type = CATransitionType.fade
//                        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//                        self.view.window?.layer.add(transition, forKey: kCATransition)
////                        self.present(vc, animated: false, completion: nil)
//                        self.appDelegate.window?.rootViewController = vc
//                    }
//                }else{
//                    guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "mainTab") as? UITabBarController else{
//                        fatalError("couldnt init")
//                    }
//                    DispatchQueue.main.async {
//                        let transition = CATransition()
//                        transition.duration = 0.1
//                        transition.type = CATransitionType.fade
//                        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//                        self.view.window?.layer.add(transition, forKey: kCATransition)
////                        self.present(vc, animated: false, completion: nil)
//                        self.appDelegate.window?.rootViewController = vc
//                    }
//
//                }
            }
        }
    }
}
