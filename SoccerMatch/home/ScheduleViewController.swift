import UIKit

class ScheduleViewController: UIViewController {

    var match: Match!

    @IBOutlet weak var day: StandardTextField!
    @IBOutlet weak var start: StandardTextField!
    @IBOutlet weak var finish: StandardTextField!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        day.delegate = self
        start.delegate = self
        finish.delegate = self

        day.text = match.day
        start.text = match.start
        finish.text = match.finish
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {

        case "unwindNewMatch":
            guard let vc = segue.destination as? NewMatchViewController else { return }
            vc.match = match
            return

        case .none, .some(_):
            return
        }
    }

    @IBAction func clickUpdate(_ sender: StandardButton) {
        match.day = day.text
        match.start = start.text
        match.finish = finish.text
        performSegue(withIdentifier: "unwindNewMatch", sender: nil)
    }

}

extension ScheduleViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }

}
