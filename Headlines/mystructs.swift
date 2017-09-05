//
//  mystructs.swift
//  Headlines
//
//  Created by Andy Rees on 01/09/2017.
//  Copyright © 2017 rantcode.com. All rights reserved.
//

import Foundation

struct Sources: Decodable {
    
    let sources: [Source]
}

struct Source: Decodable{
    
    let id: String
    let name: String
    let description: String
    let category: String
    let language: String
    let url: String
    let country: String
    let sortBysAvailable: [String]
}

struct Articles: Decodable{
    
    let articles: [Article]
}

struct Article: Decodable {
    
    let title: String
    let description: String
    let url: String
    let urlToImage: String
}








