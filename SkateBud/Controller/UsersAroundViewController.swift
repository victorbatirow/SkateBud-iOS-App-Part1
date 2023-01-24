//
//  UsersAroundViewController.swift
//  SkateBud
//
//  Created by Victor on 2022-11-24.
//

import UIKit
import GeoFire
import CoreLocation
import FirebaseDatabase
import ProgressHUD

class UsersAroundViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var mapViewButton: UIButton!
    let mySlider = UISlider()
    let distanceLabel = UILabel()
    let manager = CLLocationManager()
    var userLat = ""
    var userLong = ""
    var geoFire: GeoFire!
    var geoFireRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        configureLocationManager()
        setupNavigationBar()
    }
    
    func configureLocationManager() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.pausesLocationUpdatesAutomatically = true
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
        
        self.geoFireRef = Ref().databaseGeo
        self.geoFire = GeoFire(firebaseRef: self.geoFireRef)
    }
    
    func setupNavigationBar() {
        title = "Find Skaters"
        let refresh = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(refreshTapped))
        distanceLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        distanceLabel.font = UIFont.systemFont(ofSize: 13)
        distanceLabel.text = "100 km"
        distanceLabel.textColor = UIColor(red: 93/255, green: 79/255, blue: 141/255, alpha: 1)
        let distanceItem = UIBarButtonItem(customView: distanceLabel)
        
        
        mySlider.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
        mySlider.minimumValue = 1
        mySlider.maximumValue = 999
        mySlider.isContinuous = true
        mySlider.value = Float(50)
        mySlider.tintColor = UIColor(red: 93/255, green: 79/255, blue: 141/255, alpha: 1)
        mySlider.addTarget(self, action: #selector(sliderValueChanged(slider:event:)), for: UIControl.Event.valueChanged)
        navigationItem.rightBarButtonItems = [refresh, distanceItem]
        navigationItem.titleView = mySlider
    }
    
    @IBAction func mapButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
    }
    
    @objc func refreshTapped() {
        print("REFRESHEDDDD")
    }
    
    @objc func sliderValueChanged(slider: UISlider, event: UIEvent) {
        distanceLabel.text = String(Int(slider.value)) + " km"
        print(Double(slider.value))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UsersAroundViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserAroundCollectionViewCell", for: indexPath) as! UserAroundCollectionViewCell
        cell.avatar.image = UIImage(named: "user_profile")
        cell.ageLbl.text = "30"
        cell.distanceLbl.text = "23 km"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/3 - 2, height: view.frame.size.width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

extension UsersAroundViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways) || (status == .authorizedWhenInUse) {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        ProgressHUD.showError("\(error.localizedDescription)")
    }
    
    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let updatedLocation: CLLocation = locations.first!
        let newCoordinate: CLLocationCoordinate2D = updatedLocation.coordinate
        print(newCoordinate.latitude)
        print(newCoordinate.longitude)
        // update location
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set("\(newCoordinate.latitude)", forKey: "current_location_latitude")
        userDefaults.set("\(newCoordinate.longitude)", forKey: "current_location_longitude")
        userDefaults.synchronize()
        
        if let userLat = UserDefaults.standard.value(forKey: "current_location_latitude") as? String,
           let userLong = UserDefaults.standard.value(forKey: "current_location_longitude") as? String {
            let location: CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
            
            self.geoFire.setLocation(location, forKey: Api.User.currentUserId)
            self.geoFire.setLocation(location, forKey: Api.User.currentUserId) { (error) in
                if error == nil {
                    // Find Users
                }
            }
        }
    }
}
