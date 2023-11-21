//
//  NetworkServices.swift
//  AsyncPhotoLoader
//
//  Created by Natalie on 2023-11-20.
//

import Foundation

public typealias ErrorHandler = (String) -> Void

open class NetworkServices {
    static let shared = NetworkServices()
    
    let objectCache = NSCache<AnyObject, AnyObject>()
    let genericError = "Oops! Something went wrong. Please try again later"
    
    private init() {}
    
    open func get(pathUrl: String,
                  parameters: [String: String] = [:],
                  successHandler: @escaping (Any) -> Void,
                  errorHandler: @escaping ErrorHandler) {
        
        let completeUrl = Keys.BaseUrl.rawValue + pathUrl + buildQueryString(fromDictionary: parameters)
        guard let url = URL(string: completeUrl) else {
            return errorHandler("Unable to create URL from given string")
        }
        
        if let objectFromCache = self.objectCache.object(forKey: completeUrl as AnyObject) {
            DispatchQueue.main.async {
                successHandler(objectFromCache)
            }
            return
        } else {
            URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
                if let error = error {
                    errorHandler(error.localizedDescription)
                    return
                }
                if self.isSuccessCode(response) {
                    guard let data = data else {
                        return errorHandler(self.genericError)
                    }
                    if let responseObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                        self.objectCache.setObject(responseObject as AnyObject, forKey: completeUrl as AnyObject)
                        DispatchQueue.main.async {
                            successHandler(responseObject)
                        }
                        return
                    }
                }
                errorHandler(self.genericError)
            } .resume()
        }
    }
    
    private func isSuccessCode(_ statusCode: Int) -> Bool {
        return statusCode >= 200 && statusCode < 300
    }
    
    private func isSuccessCode(_ response: URLResponse?) -> Bool {
        guard let urlResponse = response as? HTTPURLResponse else {
            return false
        }
        return isSuccessCode(urlResponse.statusCode)
    }
    
    private func buildQueryString(fromDictionary parameters: [String:String]) -> String {
        var urlVars: [String] = []
        
        for (k,value) in parameters {
            if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                urlVars.append(k + "=" + encodedValue)
            }
        }
        
        return urlVars.isEmpty ? "" : "?" + urlVars.joined(separator: "&")
    }
}
