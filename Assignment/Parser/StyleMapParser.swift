//
//  StyleMapParser.swift
//  Assignment
//
//  Created by Hanh Nguyen on 5/16/18.
//  Copyright © 2018 FPTSoftware. All rights reserved.
//

import Foundation
import KissXML

class StyleMapParser : NSObject {
    class func parser(styleMapElem: DDXMLElement) -> StyleMap {
        let styleMap = StyleMap()
        var pairs = [Pair]()
        
        styleMap.id = styleMapElem.attribute(forName: Constants.idAttr)?.stringValue
        
        if let childElements = styleMapElem.children as? [DDXMLElement] {
            for childElement in childElements {
                if childElement.name == Constants.pairElem {
                    let pair = PairParser.parser(pairElem: childElement)
                    pairs.append(pair)
                }
            }
        }
        
        styleMap.pairs = pairs
        
        return styleMap
    }
}
