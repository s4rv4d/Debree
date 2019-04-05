//
//  BinConfirmationViewController.swift
//  Debree
//
//  Created by Sarvad shetty on 3/18/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import Lottie
import FirebaseDatabase

protocol BarcodeBackDelegate {
    func goBack(stat:Bool)
}

//MARK: - Global Variables


class BinConfirmationViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var animationView: LOTAnimationView!
    @IBOutlet weak var displayTextView: UIView!
    @IBOutlet weak var displayTextLabel: UILabel!
    @IBOutlet weak var goBackButton: UIButton!
    
    //MARK: - Variables
    var delegate:BarcodeBackDelegate?
    //db
    var ref:DatabaseReference!
    var childName:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        start()
//        setupDisplayText()
//        ref = Database.database().reference().child("bins")
//        updateFirebase()
    }
    
    //MARK: - Functions
    func start(){
        animationView.setAnimation(named: "throwing ball")
        animationView.play()
    }
    
    func updateFirebase(){
        print(childName)
//        ref.updateChildValues(["busy":1])
        print("herer 1111")
        ref.child(childName).updateChildValues(["busy":true])
    }
    
    func setupDisplayText(){
        //view
        displayTextView.layer.masksToBounds = false
        displayTextView.layer.cornerRadius = 5
        displayTextView.layer.shadowColor = UIColor.init(0, 0, 0, 0.16).cgColor
        displayTextView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        displayTextView.layer.shadowOpacity = 1.0
        displayTextView.layer.shadowRadius = 6.0
        
        //button
        goBackButton.layer.masksToBounds = false
        goBackButton.layer.cornerRadius = 5
        goBackButton.layer.shadowColor = UIColor.init(0, 0, 0, 0.16).cgColor
        goBackButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        goBackButton.layer.shadowOpacity = 1.0
        goBackButton.layer.shadowRadius = 6.0
        
        //text part
        let attributedString = NSMutableAttributedString(string: "Dispose the waste in Garbage Can and Press OK", attributes: [
            .font: UIFont.systemFont(ofSize: 24.0, weight: .regular),
            .foregroundColor: UIColor(red: 97.0 / 255.0, green: 50.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0),
            .kern: -0.58
            ])
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24.0, weight: .medium), range: NSRange(location: 21, length: 11))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24.0, weight: .semibold), range: NSRange(location: 43, length: 2))
        displayTextLabel.attributedText = attributedString
    }
    
    //MARK: - IBAction
    @IBAction func okTapped(_ sender: UIButton) {
        goBackButton.backgroundColor = #colorLiteral(red: 0.4599385262, green: 0.2715663016, blue: 0.4680609703, alpha: 1)
        goBackButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        
        ref.observe(.value) { (snapshot) in
            if snapshot.exists(){
                let dict = snapshot.value as! NSDictionary
                let subDict = dict[self.childName] as! NSDictionary
                let ammount = subDict["amount"] as! Float
                let totalAmount = ammount * 0.5
                
                UserDefaults.standard.set(Int(totalAmount), forKey: KCREDITS)
            }
        }
        
//        ref.child(childName).updateChildValues(["busy":false])
        
//        delegate?.goBack(stat: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
