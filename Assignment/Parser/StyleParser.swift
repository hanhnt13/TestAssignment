//
//  StyleParser.swift
//  Assignment
//
//  Created by Hanh Nguyen on 5/16/18.
//  Copyright © 2018 FPTSoftware. All rights reserved.
//

import Foundation
import KissXML

class StyleParser : NSObject {
    class func parser(styleElem: DDXMLElement) -> IconStyle {
        let iconStyle = IconStyle()
        
        iconStyle.id = styleElem.attribute(forName: Constants.idAttr)?.stringValue
        
        if let childElements = styleElem.children as? [DDXMLElement] {
            for childElement in childElements {
                if childElement.name == Constants.iconStyleElem {
                     if let iconStyleChildrens = childElement.children as? [DDXMLElement] {
                        for iconStyleChildren in iconStyleChildrens {
                            if iconStyleChildren.name == Constants.scaleElem {
                                if let stringValue = iconStyleChildren.stringValue {
                                    iconStyle.scale = Double(stringValue)
                                } else if iconStyleChildren.name == Constants.iconElem {
                                    if let iconChildrens = childElement.children as? [DDXMLElement] {
                                        for iconChildren in iconChildrens {
                                            if iconChildren.name == Constants.hrefElem {
                                                iconStyle.href = iconChildren.stringValue
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return iconStyle
    }
}
