//
//  PetsModel.swift
//  CombineUiTableView
//
//  Created by Sachin Daingade on 14/05/23.
//

import Foundation

struct PetsModel: Codable {
    let pets: [Pet]
}

struct Pet: Codable {
    let title: String
    let imageURL: String
    let dateAdded: String
    let contentURL: String

    enum CodingKeys: String, CodingKey {
        case title
        case imageURL = "image_url"
        case dateAdded = "date_added"
        case contentURL = "content_url"
    }
}
