//
//  MapViewController.swift
//  Assignment
//
//  Created by Hanh Nguyen on 5/16/18.
//  Copyright © 2018 FPTSoftware. All rights reserved.
//

import UIKit
import KissXML
import ArcGIS

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func setup() {
        if let fileUrl = Bundle.main.url(forResource: "2018_PCT", withExtension: "xml") {
            do {
                let data = try Data(contentsOf: fileUrl)
                parse(data: data, completion: { (document) in
                    DispatchQueue.main.async {
                        
                    }
                })
            } catch let error {
                print(error)
            }
        }
    }
    
    private func parse(data: Data , completion: (([Document]?) -> ())?) {
         DispatchQueue.global(qos: .userInitiated).async {
            var ddDoc : DDXMLDocument? = nil
            var documentElems: [DDXMLNode]? = nil
            var document = [Document]()
            
            do {
                try ddDoc = DDXMLDocument(data: data, options: 0)
            } catch {
                return
            }
            
            do {
                documentElems = try ddDoc?.rootElement()?.nodes(forXPath: String(format: "*[local-name() = '%@']", Constants.documentElem))
            } catch {
                return
            }
            
            if documentElems == nil || documentElems!.isEmpty {
                return
            }
            
            for documentElem in documentElems! {
                if let documentElem = documentElem as? DDXMLElement {
                    let currentDocument = Document()
                    var styles = [IconStyle]()
                    var styleMaps = [StyleMap]()
                    
                    if let childElements = documentElem.children as? [DDXMLElement] {
                        for childElment in childElements {
                            if childElment.name == Constants.lookAtElem {
                                let lookAt = LookAtParser.parser(lookAtElem: childElment)
                                currentDocument.lookAt = lookAt
                            } else if childElment.name == Constants.styleElem {
                                let style = StyleParser.parser(styleElem: childElment)
                                styles.append(style)
                            } else if childElment.name == Constants.styleMapElem {
                                let styleMap = StyleMapParser.parser(styleMapElem: childElment)
                                styleMaps.append(styleMap)
                            }
                        }
                    }
                    
                    currentDocument.style = styles
                    currentDocument.styleMap = styleMaps
                    document.append(currentDocument)
                } else {
                    continue
                }
            }
            
            completion?(document)
        }
        
        
    }


}

