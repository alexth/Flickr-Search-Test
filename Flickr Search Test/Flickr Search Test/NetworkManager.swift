//
//  NetworkManager.swift
//  Flickr Search Test
//
//  Created by Alex Golub on 10/16/16.
//  Copyright © 2016 Alex Golub. All rights reserved.
//

import Foundation

struct NetworkManager {
    func downloadLinks(searchString: String, completion: @escaping (_ result: [FlickrDataModel]) -> Void) {
        let flickrURLString = "http://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=" + searchString;
        let urlRequest = URL(string :flickrURLString)!
        let urlSession = URLSession.shared
        urlSession.dataTask(with: urlRequest) {(data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    if let resultString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                        // just check that response! Received JSON is totally broken and is not valid
                        let JSONString = self.shittyTrimming(string: resultString)
                        if let parsedDictionary = self.convertStringToDictionary(text: JSONString) {
                            let itemsArray = parsedDictionary["items"] as! NSArray
                            completion(self.setupModels(itemsArray: itemsArray))
                        } else {
                            print(json)
                        }
                    } else {
                        print(json)
                    }
                } else {
                    print(json)
                }
            }
        }.resume()
    }

    fileprivate func convertStringToDictionary(text: String) -> [String : AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

    fileprivate func setupModels(itemsArray: NSArray) -> [FlickrDataModel] {
        var receivedData = [FlickrDataModel]()
        for item in itemsArray {
            let dictionaryItem = item as! NSDictionary
            let title = dictionaryItem["title"] as! String
            let link = dictionaryItem["link"] as! String
            let model = FlickrDataModel(title: title, imageLink: link)
            receivedData.append(model)
        }
        return receivedData
    }

    // total shitcode. It's usage is caused by a corrupted JSON from response. I was really not able to get valid JSON
    // TODO: Refactor
    fileprivate func shittyTrimming(string: NSString) -> String {
        let string = string as String
        let stringWithoutPrefix = string.replacingOccurrences(of: "jsonFlickrFeed(", with: "")
        let x = stringWithoutPrefix.substring(to: stringWithoutPrefix.index(before: stringWithoutPrefix.endIndex))
        return x.replacingOccurrences(of: "<p><a href=", with: "")
    }
}
