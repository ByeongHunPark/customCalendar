//
//  hexColor.swift
//  bh_calendar
//
//  Created by 박병훈 on 2023/02/23.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    convenience init(hex: String){
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb : UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
            let g = Double((rgb >>  8) & 0xFF) / 255.0
            let b = Double((rgb >>  0) & 0xFF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: 1)
    }
    
}
