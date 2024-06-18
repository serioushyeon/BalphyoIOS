//
//  UIFont.swift
//  Balphyo
//
//  Created by jin on 6/12/24.
//

import UIKit

extension UIFont {
    static func XXSmall() -> UIFont {
        guard let font = UIFont(name: "Pretendard-Medium", size: 10) else {
            return UIFont.systemFont(ofSize: 10)
        }
        return font
    }
    static func XSmall() -> UIFont {
        guard let font = UIFont(name: "Pretendard-Regular", size: 12) else {
            return UIFont.systemFont(ofSize: 12)
        }
        return font
    }
    static func Small() -> UIFont {
        guard let font = UIFont(name: "Pretendard-Regular", size: 14) else {
            return UIFont.systemFont(ofSize: 14)
        }
        return font
    }
    static func Medium() -> UIFont {
        guard let font = UIFont(name: "Pretendard-Regular", size: 16) else {
            return UIFont.systemFont(ofSize: 16)
        }
        return font
    }
    static func Large() -> UIFont {
        guard let font = UIFont(name: "Pretendard-Regular", size: 18) else {
            return UIFont.systemFont(ofSize: 18)
        }
        return font
    }
    static func XLarge() -> UIFont {
        guard let font = UIFont(name: "Pretendard-Regular", size: 20) else {
            return UIFont.systemFont(ofSize: 20)
        }
        return font
    }
    static func Title() -> UIFont {
        guard let font = UIFont(name: "Pretendard-SemiBold", size: 24) else {
            return UIFont.systemFont(ofSize: 24)
        }
        return font
    }
}
