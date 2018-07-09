import UIKit

class MyMatchesViewController: UIViewController {

    var matchesCreated: [Match] = []
    var matchesSubscribed: [Match] = []

    @IBOutlet weak var collectionCreated: UICollectionView!
    @IBOutlet weak var collectionSubscribed: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionCreated.dataSource = self
        collectionSubscribed.dataSource = self

        getMatches()
    }

    func getMatches() {
        MatchService.getCreatedByMe { (matches) in
            self.matchesCreated = matches
            self.collectionCreated.reloadSections(IndexSet(integer: 0))
        }
        SubscriptionService.getMatches { (matches) in
            self.matchesSubscribed = matches
            self.collectionSubscribed.reloadSections(IndexSet(integer: 0))
        }
    }

}

extension MyMatchesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (collectionView.tag) {
        case 0:
            return matchesCreated.count
        case 1:
            return matchesSubscribed.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (collectionView.tag) {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "matchCreatedCell", for: indexPath) as! MatchCollectionCell

            let match = matchesCreated[indexPath.row]

            constructCell(cell, match: match)

            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "matchSubscribedCell", for: indexPath) as! MatchCollectionCell

            let match = matchesSubscribed[indexPath.row]

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

}
