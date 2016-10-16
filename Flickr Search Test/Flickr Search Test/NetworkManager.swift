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
        let flickrURLString = "http://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=" + searchString
        let urlRequest = URL(string :flickrURLString)!
        let urlSession = URLSession.shared
        urlSession.dataTask(with: urlRequest) {(data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    if let resultString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? {
                        // just check that response! Received JSON is totally broken and is not valid
                        let JSONString = self.shittyTrimming(string: resultString) //trying to convert data to string and exclude all broken elements
                        if let parsedDictionary = self.convertStringToDictionary(text: JSONString) {
                            let itemsArray = parsedDictionary["items"] as! NSArray
                            completion(self.setupModels(itemsArray: itemsArray))
                        } else {
                            // TODO: handle errors in completionBlock
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
            let imageLinkDictionary = dictionaryItem["media"] as! NSDictionary
            let imageLink = imageLinkDictionary["m"] as! String
            let model = FlickrDataModel(title: title, imageLink: imageLink)
            receivedData.append(model)
        }
        return receivedData
    }

    // TOTAL shitcode!!! Worst I ever wrote. It's usage is caused by a corrupted JSON from response. I was really not able to get valid JSON
    // TODO: Refactor by any price
    fileprivate func shittyTrimming(string: String) -> String {
        let stringWithoutPrefix = string.replacingOccurrences(of: "jsonFlickrFeed(", with: "")
        let stringWithoutPrefixCharacters = stringWithoutPrefix.characters
        let itemsString = "items"
        let itemsAttributeLowerBound = stringWithoutPrefix.range(of: itemsString)?.lowerBound
        var trimmedPrefixesString = ""
        if let itemsWordIndex = itemsAttributeLowerBound {
            let prefixRange = stringWithoutPrefixCharacters.startIndex..<stringWithoutPrefixCharacters.index(itemsWordIndex, offsetBy: -1)
            let substring = stringWithoutPrefix[prefixRange]
            trimmedPrefixesString = stringWithoutPrefix.replacingOccurrences(of: substring, with: "")
        }
        let stringWithoutPreLastSymbol = trimmedPrefixesString.substring(to: trimmedPrefixesString.index(before: trimmedPrefixesString.endIndex))
        let stringWithoutLastSymbol = stringWithoutPreLastSymbol.substring(to: stringWithoutPreLastSymbol.index(before: stringWithoutPreLastSymbol.endIndex))
        return "{" + stringWithoutLastSymbol + "}"
    }
}
