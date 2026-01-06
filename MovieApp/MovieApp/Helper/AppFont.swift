//
//  AppFont.swift
//  MovieApp
//
//  Created by Amrah on 07.01.26.
//

import UIKit

enum AppFont {
    // Montserrat
    case montserratRegular(size: CGFloat)
    case montserratSemiBold(size: CGFloat)
    case montserratBold(size: CGFloat)
    case montserratLight(size: CGFloat)
    
    // Poppins
    case poppinsRegular(size: CGFloat)
    case poppinsSemiBold(size: CGFloat)
    case poppinsBold(size: CGFloat)
    case poppinsLight(size: CGFloat)
    
    var font: UIFont {
        switch self {
        // Montserrat
        case .montserratRegular(let size):
            return UIFont(name: "Montserrat-Regular", size: size) ?? .systemFont(ofSize: size)
        case .montserratSemiBold(let size):
            return UIFont(name: "Montserrat-SemiBold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
        case .montserratBold(let size):
            return UIFont(name: "Montserrat-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
        case .montserratLight(let size):
            return UIFont(name: "Montserrat-Light", size: size) ?? .systemFont(ofSize: size, weight: .light)
            
        // Poppins
        case .poppinsRegular(let size):
            return UIFont(name: "Poppins-Regular", size: size) ?? .systemFont(ofSize: size)
        case .poppinsSemiBold(let size):
            return UIFont(name: "Poppins-SemiBold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
        case .poppinsBold(let size):
            return UIFont(name: "Poppins-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
        case .poppinsLight(let size):
            return UIFont(name: "Poppins-Light", size: size) ?? .systemFont(ofSize: size, weight: .light)
        }
    }
}

// Extension for easier usage
extension UIFont {
    static func app(_ font: AppFont) -> UIFont {
        return font.font
    }
}
