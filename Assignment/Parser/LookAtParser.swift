//
//  LookAtParser.swift
//  Assignment
//
//  Created by Hanh Nguyen on 5/16/18.
//  Copyright © 2018 FPTSoftware. All rights reserved.
//

import Foundation
import KissXML

class LookAtParser : NSObject {
    class func parser(lookAtElem: DDXMLElement) -> LookAt {
        let lookAt = LookAt()
        
        if let childElements = lookAtElem.children as? [DDXMLElement] {
            for childElement in childElements {
                if childElement.name == Constants.longitudeElem {
                    if let stringValue = childElement.stringValue {
                        if let longitude = Double(stringValue) {
                            lookAt.longitude = longitude
                        }
                    }
                } else if childElement.name == Constants.latitudeElem {
                    if let stringValue = childElement.stringValue {
                        if let latitude = Double(stringValue) {
                            lookAt.latitude = latitude
                        }
                    }
                }
            }
        }
        
        return lookAt
    }
}
