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
    @IBOutlet weak var titleOfActivity: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var startview: UIView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var activityCollection: UICollectionView!
    @IBOutlet weak var start: UIButton!
    var activitiesName = ["велосипед", "бег", "догонялки с ОМОНом"]
    let myLocationManager: CLLocationManager = {
        let myManager = CLLocationManager()
        myManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return myManager
    }()
    var startTime = Date()
    var finishTime = Date()
    var distanceTotal: Double! = 0
    @IBAction func click(sender: UIButton) {
        titleOfActivity.text = selectedTitle
        startview.isHidden = true
        activityView.isHidden = false
        startTime = Date()
        finishTime = Date()
    }
    var pauseTest = false
    @IBAction func clickPause(sender: UIButton) {
        if (pauseTest){
            pauseButton.setImage( UIImage(named: "imagename"), for: .normal)
            pauseTest = false
        } else {
            pauseButton.setImage( UIImage(named: "pause.fill"), for: .normal)
            pauseTest = true
        }
    }
    @IBAction func clickOut(sender: UIButton) {
            titleOfActivity.text = selectedTitle
            startview.isHidden = false
            activityView.isHidden = true
            startTime = Date()
        distanceTotal = 0
    }
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
            
            let temp = myLocationHistory.last
            myLocationHistory.append(myLocation)
            if(myLocationHistory.count > 1 && !pauseTest){
                finishTime = Date()
                let dateDiff = Calendar.current.dateComponents([.hour, .minute,.second], from: startTime, to: finishTime)
                let hours = dateDiff.hour! > 9 ? "\(dateDiff.hour!)" : "0\(dateDiff.hour!)"
                let minutes = dateDiff.minute! > 9 ? "\(dateDiff.minute!)" : "0\(dateDiff.minute!)"
                let seconds = dateDiff.second! > 9 ? "\(dateDiff.second!)" : "0\(dateDiff.second!)"
                time.text = "\(hours):\(minutes):\(seconds)"
                let distanceCur = myLocationHistory.last?.distance(from: temp! )
                distanceTotal += distanceCur!
                distance.text = "\(round(distanceTotal)/1000 ) km"
                }
            }
        }
    
    private let userLocationIdentifier = "user_icon"
    var selectedTitle = "тест"
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.isHidden = true
        myLocationManager.delegate = self
        myLocationManager.requestAlwaysAuthorization()
        myLocationManager.startUpdatingLocation()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = "Назад"
        self.title = "Новая активность"
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        activityCollection.delegate = self
        activityCollection.dataSource = self

    }
}

extension MyMapViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        activitiesName.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)!.layer.borderColor = UIColor.purple.cgColor
        let testCell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        selectedTitle = testCell.title.text!
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)!.layer.borderColor = UIColor.black.cgColor
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activitiTypeCell", for: indexPath) as! CollectionViewCell
        cell.title.text = activitiesName[indexPath.item]
        cell.image.image = UIImage(named: "Image")
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        if (indexPath.item == 0){
            cell.layer.borderColor = UIColor.purple.cgColor
            selectedTitle = cell.title.text!
        }
        cell.layer.cornerRadius = 10
        return cell
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
