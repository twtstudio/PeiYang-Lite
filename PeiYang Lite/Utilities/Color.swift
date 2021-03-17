//
//  Color.swift
//  PeiYang Lite
//
//  Created by phoenix Dai on 2021/3/13.
//
//
import SwiftUI

class WPYColor {
    enum ColorStyle {
        case login
        case register
        case forgetpw
        case gpa
        case coursetable
        case account
        case studyroom
    }

    struct ColorAttributes {
        let fontColor: UIColor
        let titleColor: UIColor
        let backgroundColor: UIColor?

        init(fontColor: UIColor, titleColor: UIColor, backgroundColor: UIColor? = nil) {
            self.fontColor = fontColor
            self.titleColor = titleColor
            self.backgroundColor = backgroundColor
        }
    }
    
    let attributesForColor: (_ style: ColorStyle) -> ColorAttributes
    
    init(attributesForColor: @escaping (_ style: ColorStyle) -> ColorAttributes) {
        self.attributesForColor = attributesForColor
    }
    
// MARK: - Convenience Getters
    func fontColor(for style: ColorStyle) -> UIColor {
        return attributesForColor(style).fontColor
    }

    func titleColor(for style: ColorStyle) -> UIColor {
        return attributesForColor(style).titleColor
    }

    func backgroundColor(for style: ColorStyle) -> UIColor? {
        return attributesForColor(style).backgroundColor
    }
}

extension WPYColor {
    static var Myapp: WPYColor {
        return WPYColor(
            attributesForColor: { $0.myAppAttributes }
        )
    }
}

private extension WPYColor.ColorStyle {
    var myAppAttributes: WPYColor.ColorAttributes {
        switch self {
        case .login:
            return WPYColor.ColorAttributes(fontColor: .black, titleColor: .black, backgroundColor: .black)
        case .register:
            return WPYColor.ColorAttributes(fontColor: .black, titleColor: .black, backgroundColor: .black)
        case .forgetpw:
            return WPYColor.ColorAttributes(fontColor: .black, titleColor: .black, backgroundColor: .black)
        case .gpa:
            return WPYColor.ColorAttributes(fontColor: .black, titleColor: .black, backgroundColor: .black)
        case .coursetable:
            return WPYColor.ColorAttributes(fontColor: .black, titleColor: .black, backgroundColor: .black)
        case .account:
            return WPYColor.ColorAttributes(fontColor: .black, titleColor: .black, backgroundColor: .black)
        case .studyroom:
            return WPYColor.ColorAttributes(fontColor: .black, titleColor: .black, backgroundColor: .black)
        }
    }
}
