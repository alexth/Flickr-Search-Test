//
//  ViewController.swift
//  Flickr Search Test
//
//  Created by Alex Golub on 10/16/16.
//  Copyright © 2016 Alex Golub. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    fileprivate let collectionViewCellIdentifier = "collectionViewCellIdentifier"
    fileprivate let numberOfSections = 1
    fileprivate let numberOfItems = 10
    fileprivate var itemsPerRow = 3
    fileprivate var sourceArray = [FlickrDataModel]()
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate var linksSourceArray = [String]()

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
//        NetworkManager().downloadLinks(searchString: "cars")
        NetworkManager().data_request()
    }

    // MARK: Actions

    @IBAction func segmentedControlDidChanged(segmentedControl: UISegmentedControl) {
        itemsPerRow = segmentedControl.selectedSegmentIndex + 1
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! ImageCollectionViewCell
        let dataModel = sourceArray[indexPath.row]
        cell.setWith(title: dataModel.title, imageLink: dataModel.imageLink)
        return cell
    }
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * CGFloat((itemsPerRow + 1))
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension ViewController: UICollectionViewDelegate {

}

extension ViewController: UISearchBarDelegate {

}
