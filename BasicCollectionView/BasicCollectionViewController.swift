//
//  BasicCollectionViewController.swift
//  BasicCollectionView
//
//  Created by Salvador Garcia on 11/14/21.
//

import UIKit

private let reuseIdentifier = "cell"

private let items = [
    "Alabama", "Alaska", "Arizona", "Arkansas", "California",
    "Colorado", "Connecticut", "Delaware", "Florida",
    "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
    "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
    "Massachusetts", "Michigan", "Minnesota", "Mississippi",
    "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
    "New Jersey", "New Mexico", "New York", "North Carolina",
    "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
    "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
    "Texas", "Utah", "Vermont", "Virginia", "Washington",
    "West Virginia", "Wisconsin", "Wyoming"
]



class BasicCollectionViewController: UICollectionViewController, UISearchResultsUpdating {

    let searchcontroller = UISearchController()
    
    var dataSource: UICollectionViewDiffableDataSource<Character,String>!
    
    lazy var filteredItems: [String] = items


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchcontroller
        searchcontroller.obscuresBackgroundDuringPresentation = false
        searchcontroller.searchResultsUpdater = self
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        
        createDataSource()
        
        
    }
    
    private func generateLayout() -> UICollectionViewLayout{
        
        let spacing: CGFloat = 10
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
        
        section.interGroupSpacing = spacing
        
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    var initialLetters: [Dictionary<String.Element, Array<String>>.Keys.Element] = []
    
    var itemsByInitialLetter: [String.Element : Array<String>] = [:]
    
    var filteredItemsSnapshot: NSDiffableDataSourceSnapshot<Character,
       String> {
        var snapshot = NSDiffableDataSourceSnapshot<Character,
           String>()
    
        for section in initialLetters {
            snapshot.appendSections([section])
            snapshot.appendItems(itemsByInitialLetter[section]!)
        }
    
        return snapshot
    }

   
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text,
               searchString.isEmpty == false {
                filteredItems = items.filter { (item) -> Bool in
                    item.localizedCaseInsensitiveContains(searchString)
                }
            } else {
                filteredItems = items
            }
        
            itemsByInitialLetter = filteredItems.reduce([:]) {
               existing, element in
                return existing.merging([element.first!:[element]]) { old,
                   new in
                    return old + new
                }
            }
            initialLetters = itemsByInitialLetter.keys.sorted()
        
        dataSource.apply(filteredItemsSnapshot, animatingDifferences: true)
        
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Character,
           String>(collectionView: collectionView, cellProvider:
           { (collectionView, indexPath, item) ->
           UICollectionViewCell? in
    
            let cell =
               collectionView.dequeueReusableCell(withReuseIdentifier:
               reuseIdentifier, for: indexPath) as!
               BasicCollectionViewCell
    
            cell.label.text = item
    
            return cell
        })
    
        dataSource.apply(filteredItemsSnapshot)
        
        dataSource.supplementaryViewProvider = { (collectionView,
           kind, indexPath) -> UICollectionReusableView? in
            let header =
               collectionView.dequeueReusableSupplementaryView(ofKind:
               kind, withReuseIdentifier: "Header", for: indexPath)
               as! BasicCollectionViewCell
    
            header.label.text =
               String(self.initialLetters[indexPath.section])
            
            return header
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    
    

//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return filteredItems.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BasicCollectionViewCell
//
//        cell.label.text = filteredItems[indexPath.item]
//
//        return cell
//    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
