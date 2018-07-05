import UIKit

import MapKit

class HomeViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        construct()
        getMatches()
    }
    
    func construct() {
        locationManager.startUpdatingLocation()
        guard let location = locationManager.location else { return }

        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
    }
    
    func getMatches() {
        MatchService.get { (matches) in

            var anns: [MKAnnotation] = []

            for match in matches {
                let ann = MKPointAnnotation()
                guard let x = match.x, let y = match.y else { continue }
                let c = CLLocationCoordinate2D(latitude: CLLocationDegrees(x), longitude: CLLocationDegrees(y))
                ann.coordinate = c
                anns.append(ann)
            }

            self.map.addAnnotations(anns)
        }
    }

    @IBAction func unwindHome(segue: UIStoryboardSegue) {}

    @IBAction func clickNewMatch(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoNewMatch", sender: nil)
    }

}
