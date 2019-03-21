//
//  BarcodeViewController.swift
//  Debree
//
//  Created by Sarvad shetty on 3/18/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase
import JGProgressHUD


class BarcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    var captureSession = AVCaptureSession()
    var video = AVCaptureVideoPreviewLayer()
    var scannerFrame : UIView?
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                              AVMetadataObject.ObjectType.code39,
                              AVMetadataObject.ObjectType.code39Mod43,
                              AVMetadataObject.ObjectType.code93,
                              AVMetadataObject.ObjectType.code128,
                              AVMetadataObject.ObjectType.ean8,
                              AVMetadataObject.ObjectType.ean13,
                              AVMetadataObject.ObjectType.aztec,
                              AVMetadataObject.ObjectType.pdf417,
                              AVMetadataObject.ObjectType.itf14,
                              AVMetadataObject.ObjectType.dataMatrix,
                              AVMetadataObject.ObjectType.interleaved2of5]
    //db
    var ref:DatabaseReference!
    var capturedString:String!
    
    //MARK: - IBOutlets
    @IBOutlet weak var backButton: UIButton!
    
    //MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backButtonSetup()
        
        let Device = AVCaptureDevice.default(for: .video)
        do{
            let input = try AVCaptureDeviceInput(device: Device!)
            captureSession.addInput(input)
            let metaDataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        }catch{
            print(error.localizedDescription)
        }
        
        video = AVCaptureVideoPreviewLayer(session: captureSession)
        video.frame = view.layer.bounds
//        view.layer.addSublayer(video)
        view.layer.insertSublayer(video, at: 0)
        captureSession.startRunning()
        scannerFrame = UIView()
        if let scannerQR = scannerFrame{
            scannerQR.layer.borderColor = UIColor.green.cgColor
            scannerQR.layer.borderWidth = 2
            view.addSubview(scannerQR)
            view.bringSubviewToFront(scannerQR)
        }
        ref = Database.database().reference().child("bins")
    }
    
    //MARK: - IBAction
    @IBAction func backTapped(_ sender: UIButton) {
        print("noooooosdsdasdasdasooo \(capturedString)")
        ref.child(capturedString).updateChildValues(["busy":false])
//        ref.child(capturedString).setValue(<#T##value: Any?##Any?#>)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: - Functions
    func backButtonSetup(){
        backButton.layer.masksToBounds = false
        backButton.layer.cornerRadius = 16
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0{
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                
                let objectBounds = video.transformedMetadataObject(for: object)
                scannerFrame?.frame = objectBounds!.bounds
                
                if object.type == AVMetadataObject.ObjectType.qr {
//                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                    if object.stringValue != nil{
                        captureSession.stopRunning()
                        capturedString = object.stringValue!
                        //hud
                        hud.textLabel.text = "processing"
                        hud.show(in: self.view)
                        print("hghghghg",capturedString)
                    }
                    
                    //firebase stuff here
                    ref.observe(.value) { (snapshot) in
                        if snapshot.exists(){
//                            print(snapshot.value as! NSDictionary)
                            let dict = snapshot.value as! NSDictionary
//                            print(dict[self.capturedString] as! NSDictionary)
                            
                            let subDict = dict[self.capturedString] as! NSDictionary
//                            print(subDict["busy"])
//                            print(subDict["full"])
                            let busyStatus = subDict["busy"] as! Int
                            let fullStatus = subDict["full"] as! Int
                            
                            if busyStatus == 1{
                                //busy
                                self.hud.dismiss(animated: true)
                                let alert = UIAlertController(title: "Alert", message: "The bin is currently being used", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }else{
                                if fullStatus == 0{
                                    //go to screen
                                    guard let statVc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BinConfirmationViewController") as? BinConfirmationViewController else{
                                        fatalError("couldnt init")
                                    }
                                    self.captureSession.stopRunning()
                                    statVc.childName = self.capturedString
                                    self.hud.dismiss(animated: true)
                                    self.present(statVc, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


extension BarcodeViewController: BarcodeBackDelegate{
    func goBack(stat: Bool) {
        if stat == true{
        self.hud.dismiss(animated: true)
        self.dismiss(animated: true, completion: nil)
        }
    }
}
