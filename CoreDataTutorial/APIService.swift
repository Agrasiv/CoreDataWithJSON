//
//  APIService.swift
//  CoreDataTutorial
//
//  Created by Pyae Phyo Oo on 10/11/22.
//  Copyright © 2022 James Rochabrun. All rights reserved.
//

import Foundation

class APIService : NSObject {
    
    let query = "dogs"
    lazy var endPoint: String = {
        return "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=\(self.query)&nojsoncallback=1#"
    }()
    
    func getDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        guard let url = URL(string: endPoint) else {
            completion(.Error(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
                completion(.Error(.invalidResponseStatus))
                return
            }
            
            guard error == nil else {
                completion(.Error(.dataTaskError))
                return
            }
            
            guard let data = data else {
                completion(.Error(.corruptData))
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    guard let itemArray = jsonArray["items"] as? [[String: AnyObject]] else {
                        return
                    }
                    DispatchQueue.main.async {
                        completion(.Success(itemArray))
                    }
                }
            } catch {
                completion(.Error(.decodingError))
            }
        }
        .resume()
    }
    
}

enum Result<T> {
    case Success(T)
    case Error(APIError)
}

enum APIError: Error {
    case invalidURL
    case invalidResponseStatus
    case dataTaskError
    case corruptData
    case decodingError
}
