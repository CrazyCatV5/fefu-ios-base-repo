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
    @IBOutlet weak var mapView: MKMapView!
    let myLocationManager: CLLocationManager = {
        let myManager = CLLocationManager()
        myManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return myManager
        
    }()
    
    fileprivate var myLocationHistory: [CLLocation] = []{
        didSet{
            let coordinates = myLocationHistory.map{ $0.coordinate }
            let route = MKPolyline(coordinates: coordinates, count: coordinates.count)
            route.title = "здесь могла быть ваша реклама"
            mapView.addOverlay(route)
        }
    }
    
    fileprivate var myLocation: CLLocation?{
        didSet{
            guard let myLocation = myLocation else{
                return
            }
            
                let region = MKCoordinateRegion(center: myLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(region, animated: true)
                
                myLocationHistory.append(myLocation)
            }
        }
    
    private let userLocationIdentifier = "user_icon"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLocationManager.delegate = self
        myLocationManager.requestAlwaysAuthorization()
        myLocationManager.startUpdatingLocation()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = "Назад"
        self.title = "Новая активность"
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        
    }
}

extension MyMapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        guard let curentLocation = locations.first else{
            return
        }
        myLocation = curentLocation
    }
}

extension MyMapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        if let polyline = overlay as? MKPolyline {
            let render = MKPolylineRenderer(polyline: polyline)
            render.fillColor = UIColor(named: "ForPolylineColor")
            render.strokeColor = UIColor(named: "ForPolylineColor")
            render.lineWidth = 5
            return render
            
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKUserLocation{
            let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: userLocationIdentifier)
            let view = dequedView ?? MKAnnotationView(annotation: annotation, reuseIdentifier: userLocationIdentifier)
            view.image = UIImage(named: "LocationMarker")
            return view
        }
        return nil
    }
}
