//
//  Board.swift
//  UiApp
//
//  Created by Максим Вильданов on 12.11.2019.
//  Copyright © 2019 Artem Esolnyak. All rights reserved.
//


import Foundation

class Board: Codable {
    
    var title: String
    var items: [String]
    
    init(title: String, items: [String]) {
        self.title = title
        self.items = items
    }
}
