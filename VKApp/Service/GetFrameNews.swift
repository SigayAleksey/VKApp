//
//  GetFrameNews.swift
//  VKApp
//
//  Created by Алексей Сигай on 09.04.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import UIKit

struct GetFrameNews {
    
    private static let indentsLeftRight: CGFloat = 25.0
    private static let indentsTopBottom: CGFloat = 1.0
    private static let textHeight: CGFloat = 20.0
    private static let stackResponseHeight: CGFloat = 10.0
    private static var stackResponseTop: CGFloat = 390.0
    private static var indentsResponseBlock: CGFloat = 0.0
   
    static func text(bounds: CGRect) -> (CGRect) {
        let width = bounds.width - indentsLeftRight * 2
        let height = textHeight
        let size = CGSize(width: width, height: height)
        let originX = indentsLeftRight
        let originY = indentsTopBottom
        let origin = CGPoint(x: originX, y: originY)
        return CGRect(origin: origin, size: size)
    }
    
    static func photo(bounds: CGRect, widthOrig: CGFloat, heightOrig: CGFloat) -> (CGRect) {
        let widthMax = bounds.width - indentsLeftRight * 2
        var width: CGFloat
        if widthMax > widthOrig {
            width = widthOrig
        } else {
            width = widthMax
        }
        let height = ceil(heightOrig * width / widthOrig)
        // Get stackResponseTop
        stackResponseTop = indentsTopBottom + textHeight + height + 5
        let size = CGSize(width: width, height: height)
        let originX = indentsLeftRight
        let originY = indentsTopBottom + textHeight
        let origin = CGPoint(x: originX, y: originY)
        return CGRect(origin: origin, size: size)
    }
 
    static func responseCount(bounds: CGRect, text: String, font: UIFont, type: String) -> CGRect {
        let textBlock = CGSize(width: 70, height: stackResponseHeight)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let width = rect.size.width
        let height = rect.size.height
        let size = CGSize(width: ceil(width), height: ceil(height))
        var originX: CGFloat = 0.0
        switch type {
        case "like":
            originX = bounds.width - (indentsLeftRight + indentsResponseBlock + ceil(width))
            indentsResponseBlock += ceil(width) + 5
        case "comment":
            originX = bounds.width - (indentsLeftRight + indentsResponseBlock + ceil(width))
            indentsResponseBlock += ceil(width) + 5
        case "repost":
            originX = bounds.width - (indentsLeftRight + indentsResponseBlock + ceil(width))
            indentsResponseBlock += ceil(width) + 5
        default:
            originX = bounds.width - (indentsLeftRight + ceil(width))
            indentsResponseBlock = ceil(width) + 5
        }
        let originY = stackResponseTop
        let origin = CGPoint(x: originX, y: originY)
        return CGRect(origin: origin, size: size)
    }
    
    static func responseImage(bounds: CGRect) -> (CGRect) {
        let width = stackResponseHeight
        let height = stackResponseHeight
        let size = CGSize(width: width, height: height)
        let originX = bounds.width - (indentsLeftRight + indentsResponseBlock + ceil(width))
        indentsResponseBlock += ceil(width) + 10
        let originY = stackResponseTop + 1
        let origin = CGPoint(x: originX, y: originY)
        return CGRect(origin: origin, size: size)
    }

}
