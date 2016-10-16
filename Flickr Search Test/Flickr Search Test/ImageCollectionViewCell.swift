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

    func setWith(title: String, imageLink: String) {
        titleLabel.text = title
        // TODO: image download and cache
    }
}
