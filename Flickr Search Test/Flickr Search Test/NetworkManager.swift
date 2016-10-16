//
//  NetworkManager.swift
//  Flickr Search Test
//
//  Created by Alex Golub on 10/16/16.
//  Copyright © 2016 Alex Golub. All rights reserved.
//

import Foundation

struct NetworkManager {
    func downloadLinks(searchString: String) {
        let flickrURLString = "http://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=" + searchString;
        let urlRequest = URL(string :flickrURLString)!
        let urlSession = URLSession.shared
        urlSession.dataTask(with: urlRequest) {(data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    if let resultString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                        let string = resultString as String
                        self.convertStringToDictionary(text: string)
//                        if string.hasPrefix("jsonFlickrFeed(") {
//                            let stringWithoutPrefix = string.replacingOccurrences(of: "jsonFlickrFeed(", with: "")
//                            let x = stringWithoutPrefix.substring(to: stringWithoutPrefix.index(before: stringWithoutPrefix.endIndex))
//                            self.convertStringToDictionary(text: x)
//                        }
                    }
//                    print(self.convertStringToDictionary(text: responseString))
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
}
