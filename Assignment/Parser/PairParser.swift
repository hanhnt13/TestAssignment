//
//  PairParser.swift
//  Assignment
//
//  Created by Hanh Nguyen on 5/16/18.
//  Copyright © 2018 FPTSoftware. All rights reserved.
//

import Foundation
import KissXML

class PairParser : NSObject {
    class func parser(pairElem: DDXMLElement) -> Pair {
        let pair = Pair()
        
        if let childElements = pairElem.children as? [DDXMLElement] {
            for childElement in childElements {
                if childElement.name == Constants.keyElem {
                    pair.key = childElement.stringValue
                } else if childElement.name == Constants.styleUrlElem {
                    pair.styleUrl = childElement.stringValue
                }
            }
        }
        
        return pair
    }
}
