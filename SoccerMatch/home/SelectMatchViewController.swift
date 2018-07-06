import UIKit

class SelectMatchViewController: UIViewController {

    var match: Match!

    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var scheduleDate: UILabel!
    @IBOutlet weak var scheduleDuration: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var vacancies: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        desc.text = match.desc
        location.text = match.location
        scheduleDate.text = match.day
        scheduleDuration.text = "\(match.start!) - \(match.finish!)"
        price.text = match.price
        vacancies.text = match.vacancies
    }

}
