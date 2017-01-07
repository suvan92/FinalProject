//
//  ColorManager.swift
//  FinalProject
//
//  Created by Tim Beals on 2016-12-29.
//  Copyright © 2016 suvanr. All rights reserved.
//

import UIKit

class ColorManager: NSObject {

    class func red() -> UIColor {
        return UIColor(red: 193/255, green: 30/255, blue: 30/255, alpha: 1)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 253/255, green: 178/255, blue: 178/255, alpha: 1)
    }
    
    class func gray() -> UIColor {
        return UIColor(red: 174/255, green: 174/255, blue: 174/255, alpha: 1)
    }
}
