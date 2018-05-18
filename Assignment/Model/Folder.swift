//
//  Folder.swift
//  Assignment
//
//  Created by Hanh Nguyen on 5/16/18.
//  Copyright © 2018 FPTSoftware. All rights reserved.
//

import Foundation
import ArcGIS

class Folder :  NSObject {
    var name: String?
    var open: Int?
    var placeMark: [Placemark]?
    var folder: [Folder]?
    
    func folderGraphic(document: Document) -> [AGSGraphic] {
        var graphic = [AGSGraphic]()
        if let folders = self.folder {
            for folder in folders {
                graphic += folder.folderGraphic(document: document)
            }
        }
        
        if let placeMarks = self.placeMark {
            for placeMark in placeMarks {
                let style = document.getStyle(id: placeMark.styleUrl ?? "")
                
                if let iconStyle = style as? IconStyle {
                    if let href = iconStyle.href {
                        if href.hasPrefix("http") {
                            if let url = URL(string: href), let point = placeMark.coordinates?.first {
                                let pinSymbol = AGSPictureMarkerSymbol(url: url)
                                
                                //optionally set the size (if not set, the size in pixels of the image will be used)
                                pinSymbol.width = 24
                                pinSymbol.height = 24
                                pinSymbol.offsetY = 24
                                
                                //location for camp site
                                let pinPoint = AGSPoint.init(clLocationCoordinate2D: CLLocationCoordinate2D.init(latitude: point.latitude ?? 0, longitude: point.longitude ?? 0))
                                
                                if let name = placeMark.name {
                                    let namePosition = AGSPoint.init(clLocationCoordinate2D: CLLocationCoordinate2D.init(latitude: point.latitude ?? 0, longitude: point.longitude ?? 0))
                                    let nameSymbol = AGSTextSymbol(text: name,
                                                                   color: UIColor.white,
                                                                   size: 13,
                                                                   horizontalAlignment: .center,
                                                                   verticalAlignment: .bottom)
                                    nameSymbol.fontWeight = AGSFontWeight.bold
                                    graphic.append (AGSGraphic(geometry: namePosition, symbol: nameSymbol, attributes: nil))
                                }
                                
                                graphic.append (AGSGraphic(geometry: pinPoint, symbol: pinSymbol, attributes: nil))
                            }
                        } else {
                            if let imageName = href.split(separator: "/").last {
                                if let image = UIImage(named: String(imageName)), let point = placeMark.coordinates?.first {
                                    let pinSymbol = AGSPictureMarkerSymbol(image: image)
                                    pinSymbol.width = image.size.width * CGFloat(iconStyle.scale ?? 1)
                                    pinSymbol.height = image.size.height * CGFloat(iconStyle.scale ?? 1)
                                    pinSymbol.offsetY = pinSymbol.height
                                    
                                    let pinPoint = AGSPoint.init(clLocationCoordinate2D: CLLocationCoordinate2D.init(latitude: point.latitude ?? 0, longitude: point.longitude ?? 0))
                                    
                                    if let name = placeMark.name {
                                        let namePosition = AGSPoint.init(clLocationCoordinate2D: CLLocationCoordinate2D.init(latitude: point.latitude ?? 0, longitude: point.longitude ?? 0))
                                        let nameSymbol = AGSTextSymbol(text: name,
                                                                           color: UIColor.white,
                                                                           size: 13,
                                                                           horizontalAlignment: .center,
                                                                           verticalAlignment: .bottom)
                                        nameSymbol.fontWeight = AGSFontWeight.bold
                                        graphic.append (AGSGraphic(geometry: namePosition, symbol: nameSymbol, attributes: nil))
                                    }
                                    
                                    graphic.append(AGSGraphic(geometry: pinPoint, symbol: pinSymbol, attributes: nil))
                                }
                            }
                            
                        }
                    }
                } else if let lineStyle = style as? LineStyle {
                    if let multiGeo = placeMark.multiGeometry {
                        let boatRoute = AGSPolylineBuilder(spatialReference: .wgs84())
                        for lineString in multiGeo {
                            if let coordinate = lineString.coordinates {
                                for coor in coordinate {
                                    if let latitude = coor.latitude, let longitude = coor.longitude {
                                        boatRoute.add(AGSPoint.init(clLocationCoordinate2D: CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)))
                                    }
                                }
                            }
                        }
                        
                        let lineColor = UIColor.init(hexString: lineStyle.color ?? "")
                        let lineSymbol = AGSSimpleLineSymbol(style: .dash, color: lineColor ?? UIColor.red, width: CGFloat(lineStyle.width ?? 4))
                        let boatTripGraphic = AGSGraphic(geometry: boatRoute.toGeometry(), symbol: lineSymbol)
                        graphic.append(boatTripGraphic)
                    }
                }
                
            }
        }
        
        return graphic
    }
}
