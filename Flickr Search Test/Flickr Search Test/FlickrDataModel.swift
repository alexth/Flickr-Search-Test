//
//  FlickrDataModel.swift
//  Flickr Search Test
//
//  Created by Alex Golub on 10/16/16.
//  Copyright © 2016 Alex Golub. All rights reserved.
//

import Foundation

struct FlickrDataModel {
    let title: String!
    let imageLink: String!
    init(title: String, imageLink: String) {
        self.title = title
        self.imageLink = imageLink
    }
}
