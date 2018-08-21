//
//  MoleskineNotebook.swift
//  moleskineNFC
//
//  Created by Gabriel Walsh on 8/16/18.
//  Copyright © 2018 Gabriel Walsh. All rights reserved.
//

import Foundation

struct PageItem : Codable{
    var id : Int
    var createdAt : String
    var updatedAt : String
    var pageId : Int
    var body : String
    var image : String
}

struct Page : Codable {
    var id : Int
    var number: Int
    var notebookId : Int
    var createdAt : String
    var updatedAt : String
    var pageItems : [PageItem]
    
    enum CodingKeys: String, CodingKey {
        case id
        case number
        case notebookId
        case createdAt
        case updatedAt
        case pageItems
    }
}

struct MoleskineNotebook : Codable {
    var id : Int
    var title : String
    var createdAt : String
    var updatedAt : String
    var pages : [Page]
    var owner : User
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case createdAt
        case updatedAt
        case pages
        case owner
    }
}

