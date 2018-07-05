import UIKit

class ScheduleViewController: UIViewController {

    var match: Match!

    @IBOutlet weak var day: StandardTextField!
    @IBOutlet weak var start: StandardTextField!
    @IBOutlet weak var finish: StandardTextField!
    @IBOutlet var dayKeyboard: UIView!
    @IBOutlet weak var daySelector: UIDatePicker!
    @IBOutlet var startKeyboard: UIView!
    @IBOutlet weak var startSelector: UIDatePicker!
    @IBOutlet var finishKeyboard: UIView!
    @IBOutlet weak var finishSelector: UIDatePicker!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        day.inputView = dayKeyboard
        start.inputView = startKeyboard
        finish.inputView = finishKeyboard

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

    func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Wops", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }

    @IBAction func clickUpdate(_ sender: StandardButton) {

        guard let day = day.text, day != "" else {
            showMessage("You must set the day!")
            return
        }
        match.day = day

        guard let start = start.text, start != "" else {
            showMessage("You must set the start!")
            return
        }
        match.start = start

        guard let finish = finish.text, finish != "" else {
            showMessage("You must set the finish!")
            return
        }
        match.finish = finish

        performSegue(withIdentifier: "unwindNewMatch", sender: nil)
    }

    @IBAction func dayUpdate(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        day.text = formatter.string(from: daySelector.date)
        day.resignFirstResponder()
    }

    @IBAction func startUpdate(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        start.text = formatter.string(from: startSelector.date)
        start.resignFirstResponder()
    }

    @IBAction func finishUpdate(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        finish.text = formatter.string(from: finishSelector.date)
        finish.resignFirstResponder()
    }

}

extension ScheduleViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }

}
