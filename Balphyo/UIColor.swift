//
//  UIColor.swift
//  Balphyo
//
//  Created by jin on 6/12/24.
//

import UIKit

extension UIColor {
    //Primary&Secondary Color
    static let Primary = UIColor(named: "Primary") ?? UIColor(red: 235, green: 42, blue: 99, alpha: 1.0)
    static let Secondary = UIColor(named: "Secondary") ?? UIColor(red: 255, green: 140, blue: 174, alpha: 1.0)
    static let PrimaryDisabled = UIColor(named: "PrimaryDisabled") ?? UIColor(red: 250, green: 220, blue: 230, alpha: 1.0)
    //Gray Scale
    static let Gray1 = UIColor(named: "Gray1") ?? UIColor(red: 241, green: 241, blue: 241, alpha: 1.0)
    static let Gray2 = UIColor(named: "Gray2") ?? UIColor(red: 221, green: 221, blue: 221, alpha: 1.0)
    static let Gray3 = UIColor(named: "Gray3") ?? UIColor(red: 139, green: 139, blue: 139, alpha: 1.0)
    static let Gray4 = UIColor(named: "Gray4") ?? UIColor(red: 67, green: 67, blue: 67, alpha: 1.0)
    //Text
    static let Text = UIColor(named: "Text") ?? UIColor(red: 28, green: 28, blue: 28, alpha: 1.0)
    static let InputText = UIColor(named: "InputText") ?? UIColor(red: 45, green: 45, blue: 45, alpha: 1.0)
    static let Disabled = UIColor(named: "Disabled") ?? UIColor(red: 177, green: 177, blue: 177, alpha: 1.0)
    //Basic & System Color
    static let Error = UIColor(named: "Error") ?? UIColor(red: 243, green: 61, blue: 61, alpha: 1.0)
    static let Black = UIColor(named: "Black") ?? UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    static let White = UIColor(named: "White") ?? UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
}
