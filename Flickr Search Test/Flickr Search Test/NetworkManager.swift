//
//  NetworkManager.swift
//  Flickr Search Test
//
//  Created by Alex Golub on 10/16/16.
//  Copyright © 2016 Alex Golub. All rights reserved.
//

import UIKit

struct NetworkManager {
    func downloadLinks(searchString: String,
                         completion: @escaping (_ result: [FlickrDataModel], _ error: NSError?) -> Void) {
        let flickrURLString = "http://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=" + searchString
        let urlRequest = URL(string :flickrURLString)!
        let urlSession = URLSession.shared
        urlSession.dataTask(with: urlRequest) {(data, response, error) -> Void in
            if let data = data {
                print(data)
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                let jsonDictionary = json as! [String: AnyObject]
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    let itemsArray = jsonDictionary["items"] as! NSArray
                    let modelsArray = self.setupModels(itemsArray: itemsArray)
                    completion(modelsArray, nil)
                } else {
                    print(json)
                }
            }
        }.resume()
    }

    func downloadImage(urlString: String, completion: @escaping (_ result: UIImage) -> Void) {
        if let url = NSURL(string: urlString) {
            print("downloadImage")
            if let data = NSData(contentsOf: url as URL) {
                if let image = UIImage(data: data as Data) {
                    completion(image)
                } else {
                    // TODO: Handle error with NSError instance
                }
            }
        }
    }

    fileprivate func setupModels(itemsArray: NSArray) -> [FlickrDataModel] {
        var receivedData = [FlickrDataModel]()
        for item in itemsArray {
            let dictionaryItem = item as! NSDictionary
            let title = dictionaryItem["title"] as! String
            let imageLinkDictionary = dictionaryItem["media"] as! NSDictionary
            let imageLink = imageLinkDictionary["m"] as! String
            let model = FlickrDataModel(title: title, imageLink: imageLink)
            receivedData.append(model)
        }
        return receivedData
    }
}
