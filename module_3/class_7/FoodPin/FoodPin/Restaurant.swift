//
//  Restaurant.swift
//  FoodPin
//
//  Created by David Velarde on 21/7/2016.
//  Copyright © 2017 Area51. All rights reserved.
//

import Foundation

class Restaurant {
    var restaurantId : Int32? = nil
    var name = ""
    var type = ""
    var location = ""
    var image = ""
    var isVisited = false
    var phone = ""
    var rating = ""
    
    init(name: String, type: String, location: String, phone: String, image: String, isVisited: Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.image = image
        self.isVisited = isVisited
    }
}
