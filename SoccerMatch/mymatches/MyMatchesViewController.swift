import UIKit

class MyMatchesViewController: UIViewController {
    
    var created: [Match] = []
    var subscribed: [Subscription] = []
    
    @IBOutlet weak var numberCreated: UILabel!
    @IBOutlet weak var numberSubscribed: UILabel!
    @IBOutlet weak var collectionCreated: UICollectionView!
    @IBOutlet weak var collectionSubscribed: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionCreated.dataSource = self
        collectionCreated.delegate = self
        collectionSubscribed.dataSource = self
        collectionSubscribed.delegate = self
        
        getMatches()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "gotoMatchCreated":
            guard let match = sender as? Match else { return }
            guard let vc = segue.destination as? MatchCreatedViewController else { return }
            vc.match = match
            return
            
        case "gotoMatchSubscribed":
            guard let subscription = sender as? Subscription else { return }
            guard let vc = segue.destination as? MatchSubscribedViewController else { return }
            vc.subscription = subscription
            return
            
        case .none, .some(_):
            return
        }
    }
    
    func getMatches() {
        let user = UserService.current()!
        MatchService.get(creator: user.ref) { (matches) in
            self.created = matches
            self.numberCreated.text = String(matches.count)
            self.collectionCreated.reloadSections(IndexSet(integer: 0))
        }
        SubscriptionService.getSubscriptionsByUser(user.ref!) { (subscriptions) in
            self.subscribed = subscriptions
            self.numberSubscribed.text = String(subscriptions.count)
            self.collectionSubscribed.reloadSections(IndexSet(integer: 0))
        }
    }
    
}

extension MyMatchesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (collectionView.tag) {
        case 0:
            return created.count
        case 1:
            return subscribed.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (collectionView.tag) {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "matchCreatedCell", for: indexPath) as! MatchCollectionCell
            
            let match = created[indexPath.row]
            
            constructCell(cell, match: match)
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "matchSubscribedCell", for: indexPath) as! MatchCollectionCell
            
            let subscription = subscribed[indexPath.row]
            let match = subscription.match!
            
            constructCell(cell, match: match)
            
            return cell
        default:
            return MatchCollectionCell()
        }
    }
    
    func constructCell(_ cell: MatchCollectionCell, match: Match) {
        cell.desc.text = match.desc
        cell.location.text = match.location
        cell.schedule.text = "\(match.day!) (\(match.start!) - \(match.finish!))"
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch (collectionView.tag) {
            
        case 0:
            let match = created[indexPath.row]
            
            performSegue(withIdentifier: "gotoMatchCreated", sender: match)
            
        case 1:
            let subscription = subscribed[indexPath.row]
            
            performSegue(withIdentifier: "gotoMatchSubscribed", sender: subscription)
            
        default:
            print("?")
        }
    }
    
}
