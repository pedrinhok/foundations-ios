import UIKit

import MapKit

class HomeViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        construct()
    }
    
    func construct() {
        locationManager.startUpdatingLocation()
        guard let location = locationManager.location else { return }

        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
    }
    
    @IBAction func unwindHome(segue: UIStoryboardSegue) {}

    @IBAction func clickNewMatch(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoNewMatch", sender: nil)
    }

}
