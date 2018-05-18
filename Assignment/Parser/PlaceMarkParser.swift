//
//  PlaceMarkParser.swift
//  Assignment
//
//  Created by Hanh Nguyen on 5/16/18.
//  Copyright © 2018 FPTSoftware. All rights reserved.
//

import Foundation
import KissXML

class PlaceMarkParser : NSObject {
    class func parser(placeMarkElem: DDXMLElement) -> Placemark {
        let placeMark = Placemark()
        var multiGeometry = [LineString]()
        var coordinates = [Coordinate]()
        
        if let childElements = placeMarkElem.children as? [DDXMLElement] {
            for childElement in childElements {
                if childElement.name == Constants.nameElem {
                    placeMark.name = childElement.stringValue
                } else if childElement.name == Constants.styleUrlElem {
                    placeMark.styleUrl = childElement.stringValue
                } else if childElement.name == Constants.multiGeometryElem {
                    if let multiGeometryChildElements = childElement.children as? [DDXMLElement] {
                        for multiGeometryChildElement in multiGeometryChildElements {
                            if multiGeometryChildElement.name == Constants.lineStringElem {
                                let lineString = LineStringParser.parser(lineStringElem: multiGeometryChildElement)
                                multiGeometry.append(lineString)
                            }
                        }
                    }
                } else if childElement.name == Constants.pointElem {
                    if let pointChildElements = childElement.children as? [DDXMLElement] {
                        for pointChildElement in pointChildElements {
                            if pointChildElement.name == Constants.coordinatesElem {
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
                }
            }
        }
        
        placeMark.coordinates = coordinates
        placeMark.multiGeometry = multiGeometry
        
        return placeMark
    }
}
