//
//  PhotoModel.swift
//  AsyncPhotoLoader
//
//  Created by Natalie on 2023-11-20.
//

import Foundation

struct PhotoModel: Codable {
    var id: String
    var imageUrl: String
    var width: Int
    var height: Int
    
    private enum CodingKeys : String, CodingKey {
        case id
        case imageUrl = "download_url"
        case width
        case height
    }
    
    static func getPhotoList(from responseObject : [Any]) -> [PhotoModel]?{
        do {
            let responseJsonData = try JSONSerialization.data(withJSONObject: responseObject, options: .prettyPrinted)
            let decoder = JSONDecoder()
            let PhotoList = try decoder.decode([PhotoModel].self, from: responseJsonData)
            return PhotoList
        } catch {
            print(error)
        }
        return nil
    }
    
}
