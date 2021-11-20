//
//  MyMapView.swift
//  fefuactivity
//
//  Created by wsr5 on 20.11.2021.
//

import UIKit
import MapKit
import CoreLocation

class MyMapViewController: UIViewController{
    let myLocationManager: CLLocationManager = {
        let myManager = CLLocationManager()
        myManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return myManager
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        myLocationManager.delegate = self
        myLocationManager.requestAlwaysAuthorization()
        myLocationManager.startUpdatingLocation()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = "Назад"
        self.title = "Новая активность"
    }
}

extension MyMapViewController: CLLocationManagerDelegate{
    func myLocationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        
    }
}
