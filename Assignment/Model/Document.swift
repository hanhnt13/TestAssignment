//
//  Document.swift
//  Assignment
//
//  Created by Hanh Nguyen on 5/16/18.
//  Copyright © 2018 FPTSoftware. All rights reserved.
//

import Foundation

class Document : NSObject {
    var descriptionString: String?
    var lookAt: LookAt?
    var style: [NSObject]?
    var styleMap: [StyleMap]?
    var folder: [Folder]?
    
    func getStyle(id: String) -> NSObject? {
        let idToFind = id.replacingOccurrences(of: "#", with: "")
        if let allStyle = self.style {
            for item in allStyle {
                if let iconStyle = item as? IconStyle {
                    if iconStyle.id == idToFind {
                        return item
                    }
                } else if let lineStyle = item as? LineStyle {
                    if lineStyle.id == idToFind {
                        return item
                    }
                }
            }
        }
        
        if let allStyleMap = self.styleMap {
            for item in allStyleMap {
                if item.id == idToFind {
                    if let pair = item.pairs?.first {
                        if let styleUrl = pair.styleUrl {
                            return getStyle(id: styleUrl)
                        }
                    }
                }
            }
        }
        
        return nil
    }
}
