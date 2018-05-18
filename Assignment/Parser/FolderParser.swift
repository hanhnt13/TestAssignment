//
//  FolderParser.swift
//  Assignment
//
//  Created by Hanh Nguyen on 5/16/18.
//  Copyright © 2018 FPTSoftware. All rights reserved.
//

import Foundation
import KissXML

class FolderParser : NSObject {
    class func parser(folderElem: DDXMLElement) -> Folder {
        let folder = Folder()
        var folders = [Folder]()
        var placeMarks = [Placemark]()
        
        if let childElements = folderElem.children as? [DDXMLElement] {
            for childElement in childElements {
                if childElement.name == Constants.nameElem {
                    folder.name = childElement.stringValue
                } else if childElement.name == Constants.openElem {
                    if let stringValue = childElement.stringValue {
                        folder.open = Int(stringValue)
                    }
                } else if childElement.name == Constants.placemarkElem {
                    let placeMark = PlaceMarkParser.parser(placeMarkElem: childElement)
                    placeMarks.append(placeMark)
                } else if childElement.name == Constants.folderElem {
                    let folder = FolderParser.parser(folderElem: childElement)
                    folders.append(folder)
                }
            }
        }
        
        folder.folder = folders
        folder.placeMark = placeMarks
        
        return folder
    }
}
