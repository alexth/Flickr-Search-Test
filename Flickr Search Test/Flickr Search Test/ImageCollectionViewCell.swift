//
//  ImageCollectionViewCell.swift
//  Flickr Search Test
//
//  Created by Alex Golub on 10/16/16.
//  Copyright © 2016 Alex Golub. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    fileprivate var isDownloadInProgress = false

    func setWith(title: String, imageLink: String) {
        titleLabel.text = title
        downloadImage(urlString: imageLink)
    }

    fileprivate func downloadImage(urlString: String) {
        if isDownloadInProgress == false {
            isDownloadInProgress = true
            NetworkManager().downloadImage(urlString: urlString, completion: { image in
                DispatchQueue.main.async(execute: {
                    self.imageView.image = image
                    self.isDownloadInProgress = false
                })
            })
        }
    }
}
