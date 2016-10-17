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
    fileprivate let showDetailSegue = "showDetail"
    fileprivate let numberOfSections = 1
    fileprivate let numberOfItems = 10
    fileprivate var itemsPerRow = 1
    fileprivate var sourceArray = [FlickrDataModel]()
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate var linksSourceArray = [String]()
    fileprivate var selectedImage = UIImage()

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadImages(searchQuery: "cars")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDetailSegue {
            let dvc = segue.destination as! DetailViewController
            dvc.image = selectedImage
        }
    }

    // MARK: Actions

    @IBAction func segmentedControlDidChanged(segmentedControl: UISegmentedControl) {
        itemsPerRow = segmentedControl.selectedSegmentIndex + 1
        collectionView.reloadData()
    }

    // MARK: ScrollView

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    // MARK: Utils

    fileprivate func reloadImages(searchQuery: String) {
        NetworkManager().downloadLinks(searchString: searchQuery) { (dataModelsArray) in
            self.sourceArray = dataModelsArray
            DispatchQueue.main.async(execute: {
                self.collectionView.reloadData()
            })
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sourceArray.count
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = selectedImage
        performSegue(withIdentifier: showDetailSegue, sender: self)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let separatedWords = searchBar.text?.components(separatedBy: " ")
        if let firstWord = separatedWords?.first {
            reloadImages(searchQuery: firstWord)
            searchBar.resignFirstResponder()
        }
    }
}
