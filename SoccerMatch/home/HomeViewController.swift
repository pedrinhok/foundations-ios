import UIKit

import MapKit

class HomeViewController: UIViewController {

    var locationManager = CLLocationManager()
    var matches: [MatchAnnotation] = []

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var search: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        map.delegate = self
        search.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        locationManager.startUpdatingLocation()
        getMatches()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {

        case "gotoSelectMatch":
            guard let vc = segue.destination as? SelectMatchViewController else { return }
            guard let match = sender as? Match else { return }
            vc.match = match
            return

        case .none, .some(_):
            return
        }
    }

    func getMatches() {
        MatchService.get { (data) in
            for match in data {
                guard let x = match.x, let y = match.y else { continue }
                let ann = MatchAnnotation(match, x: CLLocationDegrees(x), y: CLLocationDegrees(y))
                self.matches.append(ann)
            }
            self.map.addAnnotations(self.matches)
        }
        matches = []
    }

    @IBAction func unwindHome(segue: UIStoryboardSegue) {}

    @IBAction func clickNewMatch(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoNewMatch", sender: nil)
    }

}

extension HomeViewController: CLLocationManagerDelegate, MKMapViewDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0] as CLLocation

        let span = MKCoordinateSpanMake(0.008, 0.008)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        guard let ann = view.annotation as? MatchAnnotation else { return }
        let match = ann.match

        performSegue(withIdentifier: "gotoSelectMatch", sender: match)
    }

}

extension HomeViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search.resignFirstResponder()
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(search.text!) { (placemarks, error) in
            if error == nil {
                let placemark = placemarks?.first
                
                let span = MKCoordinateSpanMake(0.008, 0.008)
                let region = MKCoordinateRegion(center: placemark!.location!.coordinate, span: span)
                
                self.map.setRegion(region, animated: true)
            }
        }
    }

}

class MatchAnnotation: NSObject, MKAnnotation {

    var match: Match
    var coordinate: CLLocationCoordinate2D

    init(_ data: Match, x: CLLocationDegrees, y: CLLocationDegrees) {
        match = data
        coordinate = CLLocationCoordinate2D(latitude: x, longitude: y)
    }

}
