//
//  Placemark.swift
//  Assignment
//
//  Created by Hanh Nguyen on 5/16/18.
//  Copyright © 2018 FPTSoftware. All rights reserved.
//

import Foundation


class Placemark : NSObject {
    var multiGeometry : [LineString]?
    var name: String?
    var styleUrl: String?
    var coordinates : [Coordinate]?
}
