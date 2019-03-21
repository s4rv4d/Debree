//
//  HomeViewController.swift
//  Debree
//
//  Created by Sarvad shetty on 3/18/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import FirebaseDatabase

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var direcImageView: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var creditsValueLabel: UILabel!
    @IBOutlet weak var creditValueView: UIView!
    
    //MARK: - Variables
    var N_lat:Double!
    var S_lat:Double!
    var W_long:Double!
    var E_long:Double!
    var flag = 0
    var flagg = 0
    //db
    var ref:DatabaseReference!
    var latitude:String!
    var longitude:String!
    var location:CLLocationCoordinate2D!
    var locationManager = CLLocationManager()
    var valu:NSMutableDictionary!
    
    
    //MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.draaged(gestureRecog:)))
        testView.addGestureRecognizer(gesture)
        testView.isUserInteractionEnabled = true
        direcImageView.image = UIImage(named: "up")
        
        ref = Database.database().reference().child("bins")
        initializeTheLocationManager()
        self.mapView.isMyLocationEnabled = true
        
        //recog for qr img
        qrImgRecog()
        labelViewSetup()
//        updateFirebase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        download()
        if UserDefaults.standard.integer(forKey: KCREDITS) != nil{
            creditsValueLabel.text = "\(UserDefaults.standard.integer(forKey: KCREDITS))"
        }
//        updateFirebase()
    }
    
    //MARK: - Functions
//    
    func qrImgRecog(){
        let recog = UITapGestureRecognizer(target: self, action: #selector(self.qrImgTapped))
        qrImageView.isUserInteractionEnabled = true
        qrImageView.addGestureRecognizer(recog)
    }
    
    func labelViewSetup(){
        creditValueView.layer.masksToBounds = false
        creditValueView.layer.cornerRadius = 40
        creditValueView.layer.shadowColor = UIColor.init(0, 0, 0, 0.16).cgColor
        creditValueView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        creditValueView.layer.shadowOpacity = 1.0
        creditValueView.layer.shadowRadius = 6.0
    }
    
    //MARK: - @objc functions
    @objc func draaged(gestureRecog:UIPanGestureRecognizer){
        if gestureRecog.state == .began || gestureRecog.state == .changed{
            let translation = gestureRecog.translation(in: self.view)
//            print(gestureRecog.view?.center.y as Any)
            
            if Int((gestureRecog.view?.center.y)!) > -190 &&  Int((gestureRecog.view?.center.y)!) < 260{
                gestureRecog.view?.center = CGPoint(x: (gestureRecog.view?.center.x)!, y: (gestureRecog.view?.center.y)! + translation.y)
            }
            
            gestureRecog.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        }
        
        if gestureRecog.state == UIGestureRecognizer.State.ended{
            if Int((gestureRecog.view?.center.y)!) < 200{
                UIView.animate(withDuration: 0.5) {
                    gestureRecog.view?.center = CGPoint(x: (gestureRecog.view?.center.x)!, y: -170)
                }
//                print(gestureRecog.view?.center.y as Any)
//                print("lol")
                direcImageView.image = UIImage(named: "down")
            }
                
            else if Int((gestureRecog.view?.center.y)!) > 260{
                UIView.animate(withDuration: 0.5) {
                    gestureRecog.view?.center = CGPoint(x: (gestureRecog.view?.center.x)!, y: 253)
                }
                direcImageView.image = UIImage(named: "up")
//                print(gestureRecog.view?.center.y as Any)
            }
        }
    }
    
    @objc func qrImgTapped(){
        print("qr tapped")
        guard let qrVc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BarcodeViewController") as? BarcodeViewController else{
            fatalError("couldnt init barcode vc")
        }
        self.present(qrVc, animated: true, completion: nil)
    }
}

extension HomeViewController: CLLocationManagerDelegate{
    
    func initializeTheLocationManager()
    {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.setMinZoom(4.6, maxZoom: 20)
        
    }
    
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        location = locationManager.location?.coordinate
        let long = location?.longitude
        let lat = location?.latitude
        longitude = String(long!)
        latitude = String(lat!)
        
        print("LATITUDE : \(lat!)")
        
        print("LONGITUDE : \(long!)")
        //        print(latitude!)
        //        print(longitude!)
        print(UIDevice.current.identifierForVendor!.uuidString)
        if(flag == 0)
        {
            cameraMoveToLocation(toLocation: location)
            flag = flag+1
            
        }
        prepsearch()
        
    }

    func prepsearch()
    {
        
        //let N_long = location.longitude - 0.000015
        N_lat = location.latitude + 10*(0.000867)
        E_long = location.longitude + 10*(0.000919)
        //let E_lat = location.latitude + 0.000005
        //let S_long = location.longitude + 0.000005
        S_lat = location.latitude - 10*(0.000991)
        W_long = location.longitude - 10*(0.000949)
        //let W_lat = location.latitude - 0.000015
    }
    
    func download()
    {
        ref.observe(.value, with: { snapshot in
            if snapshot.exists()
            {
                let value = snapshot.value as? NSDictionary
                //self.textdisp.text = value?[request] as? String ?? ""
                self.valu = value as! NSMutableDictionary
                
                print(" valu is :\(self.valu)")
  
            }
            self.check()
        })
    }
    
    func check()
    {
        var templat:String!
        var templong:String!
        var checkname:String!
        var checklat:Double!
        var checklong:Double!
        var status:Bool!
        print("VALUE : \(valu!.count)")
        let templist:Array<Any>!
        var n = 0
        print(valu)

        print(valu)
        n = valu!.count
        print("valu count is\(n)")
        
        templist = valu.allKeys
        
        print(" valu keys:\(templist)")
        print(valu)
        
        for i in 0..<n
        {
            var path = "\(templist[i])"+".lat"
            print(path)
            templat = (valu.value(forKeyPath: path) as! String)
            path = "\(templist[i])"+".long"
            templong = (valu.value(forKeyPath: path) as! String)
//            path = "\(templist[i])"+".Name"
//            checkname = (valu.value(forKeyPath: path) as! String)
            path = "\(templist[i])"+".full"
            status = (valu.value(forKeyPath: path) as! Bool)
            
            checklat = Double(templat)!
            checklong = Double(templong)!
            
            print(checklat)
            print(checklong)
//            print(checkname!)
            print(N_lat)
            print(S_lat)
            print(W_long)
            print(E_long)
            
            
            let marker = GMSMarker()
            
            if(status == true)
            {
                if(checklat >= S_lat && checklat <= N_lat && checklong >= W_long && checklong <= E_long)
                {
//                    print("\(checkname!) is close-by !")

                    marker.position = CLLocationCoordinate2DMake(checklat,checklong)
//                    marker.title = checkname!
                    marker.snippet = "It's Full!"
                    marker.map = mapView
                    
                }

                else
                {
                    print("no luck!")
                }
            }
            else
            {
                mapView.clear()
            }
        }
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 16)
        }
    }
}
