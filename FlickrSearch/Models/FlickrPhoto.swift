//
//  FlickrPhoto.swift
//  FlickrSearch
//
//  Created by LB on 7/3/24.
//

import Foundation

struct FlickrPhoto: Codable, Identifiable {
    let id = UUID()
    let title: String
    let media: Media
    let description: String
    let author: String
    let published: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case media
        case description
        case author = "author_id"
        case published
    }
    
    struct Media: Codable {
        let m: String
    }
}

struct FlickrResponse: Codable {
    let items: [FlickrPhoto]
}

