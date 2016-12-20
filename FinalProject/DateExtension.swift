//
//  DateExtension.swift
//  FinalProject
//
//  Created by Suvan Ramani on 2016-12-20.
//  Copyright © 2016 suvanr. All rights reserved.
//

import Foundation

extension DateFormatter {
    convenience init(dateStyle: DateFormatter.Style) {
        self.init()
        self.dateStyle = dateStyle
    }
}

extension Date {
    struct Formatter {
        static let longDate = DateFormatter(dateStyle: .long)
    }
    var longDate: String {
        return Formatter.longDate.string(from: self)
    }
}
