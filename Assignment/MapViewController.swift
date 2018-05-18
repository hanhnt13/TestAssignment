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

class MapViewController: UIViewController, AGSGeoViewTouchDelegate {

    @IBOutlet weak var mapView: AGSMapView!
    
    private var map:AGSMap!
    private var overlay : AGSGraphicsOverlay!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.mapView.touchDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func setup() {
        if let fileUrl = Bundle.main.url(forResource: "2018_PCT", withExtension: "xml") {
            do {
                let data = try Data(contentsOf: fileUrl)
                parse(data: data, completion: { (document) in
                    if let latitude = document.lookAt?.latitude, let longitude = document.lookAt?.longitude {
                        self.map = AGSMap(basemapType: .imageryWithLabelsVector, latitude: latitude, longitude: longitude, levelOfDetail: 17)
                        let center = AGSPoint.init(clLocationCoordinate2D: CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude))
                        self.map.initialViewpoint = AGSViewpoint(center: center, scale: 1e4)
                        self.mapView.map = self.map
                    }
                    self.overlay = AGSGraphicsOverlay()
                    var graphics = [AGSGraphic]()
                    
                    if let folders = document.folder {
                        for folder in folders {
                            graphics += folder.folderGraphic(document: document)
                        }
                    }
                    
                    for graphic in graphics {
                        self.overlay.graphics.add(graphic)
                    }
                    
                    self.mapView.graphicsOverlays.add(self.overlay)
                })
            } catch let error {
                print(error)
            }
        }
    }
    
    private func parse(data: Data , completion: ((Document) -> ())?) {
            var ddDoc : DDXMLDocument? = nil
            var documentElems: [DDXMLNode]? = nil
            let document = Document()
            
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
            
            
            if let documentElem = documentElems?.first as? DDXMLElement {
                var styles = [NSObject]()
                var styleMaps = [StyleMap]()
                var folders = [Folder]()
                
                if let childElements = documentElem.children as? [DDXMLElement] {
                    for childElment in childElements {
                        if childElment.name == Constants.lookAtElem {
                            let lookAt = LookAtParser.parser(lookAtElem: childElment)
                            document.lookAt = lookAt
                        } else if childElment.name == Constants.styleElem {
                            //let style = StyleParser.parser(styleElem: childElment)
                            if let styleChildElements = childElment.children as? [DDXMLElement] {
                                for styleChildElement in styleChildElements {
                                    if styleChildElement.name == Constants.iconStyleElem {
                                        let iconStyle = IconStyle()
                                        iconStyle.id = childElment.attribute(forName: Constants.idAttr)?.stringValue
                                        if let iconStyleChildrens = styleChildElement.children as? [DDXMLElement] {
                                            for iconStyleChildren in iconStyleChildrens {
                                                if iconStyleChildren.name == Constants.scaleElem {
                                                    if let stringValue = iconStyleChildren.stringValue {
                                                        iconStyle.scale = Double(stringValue)
                                                    }
                                                } else if iconStyleChildren.name == Constants.iconElem {
                                                    if let iconChildrens = iconStyleChildren.children as? [DDXMLElement] {
                                                        for iconChildren in iconChildrens {
                                                            if iconChildren.name == Constants.hrefElem {
                                                                iconStyle.href = iconChildren.stringValue
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        styles.append(iconStyle)
                                    } else if styleChildElement.name == Constants.lineStyleElem {
                                        let lineStyle = LineStyle()
                                        lineStyle.id = childElment.attribute(forName: Constants.idAttr)?.stringValue
                                        if let lineStyleChildrens = styleChildElement.children as? [DDXMLElement] {
                                            for lineStyleChildren in lineStyleChildrens {
                                                if lineStyleChildren.name == Constants.widthElem {
                                                    if let stringValue = lineStyleChildren.stringValue {
                                                        lineStyle.width = Double(stringValue)
                                                    }
                                                } else if lineStyleChildren.name == Constants.colorElem {
                                                    lineStyle.color = lineStyleChildren.stringValue
                                                }
                                            }
                                        }
                                        styles.append(lineStyle)
                                    }
                                }
                            }
                        } else if childElment.name == Constants.styleMapElem {
                            let styleMap = StyleMapParser.parser(styleMapElem: childElment)
                            styleMaps.append(styleMap)
                        } else if childElment.name == Constants.folderElem {
                            let folder = FolderParser.parser(folderElem: childElment)
                            folders.append(folder)
                        }
                    }
                }
                
                document.style = styles
                document.styleMap = styleMaps
                document.folder = folders
                completion?(document)
            }
    }
    
    func showAlert(_ message: String? = nil, okHandler: (() -> Void)? = nil) -> Void {
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            alertVC.dismiss(animated: true, completion: {
                
            })
            okHandler?()
        }))
        self.present(alertVC, animated: true, completion: nil)
    }

}

