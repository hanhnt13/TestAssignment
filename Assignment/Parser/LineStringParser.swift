//
//  LineStringParser.swift
//  Assignment
//
//  Created by Hanh Nguyen on 5/16/18.
//  Copyright © 2018 FPTSoftware. All rights reserved.
//

import Foundation
import KissXML

class LineStringParser : NSObject {
    class func parser(lineStringElem: DDXMLElement) -> LineString {
        let lineString = LineString()
        var coordinates = [Coordinate]()
        
        if let childElements = lineStringElem.children as? [DDXMLElement] {
            for childElement in childElements {
                if childElement.name == Constants.tessellateElem {
                    if let stringValue = childElement.stringValue {
                        lineString.tessellate = Int(stringValue)
                    }
                } else if childElement.name == Constants.coordinatesElem {
                    if let coordianteStrings = childElement.stringValue?.replacingOccurrences(of: "\n", with: "").split(separator: " ") {
                        for coordianteString in coordianteStrings {
                            let element = coordianteString.split(separator: ",")
                            let coordinate = Coordinate()
                            if element.count >= 2 {
                                coordinate.latitude = Double(element[1])
                                coordinate.longitude = Double(element[0])
                                if element.count == 3 {
                                    coordinate.altitude = Double(element[2])
                                }
                                
                                coordinates.append(coordinate)
                            } else {
                                continue
                            }
                        }
                    }
                }
            }
        }
        
        lineString.coordinates = coordinates
        return lineString
    }
}
