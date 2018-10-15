//
//  GetFrameBasic.swift
//  VKApp
//
//  Created by Алексей Сигай on 08.04.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import UIKit

struct GetFrameBasic {
    
    private static let indentsLeftRight: CGFloat = 25.0
    private static let indentPhotoVsName: CGFloat = 20.0
    private static let indentsTopBottom: CGFloat = 1.0
    private static let photoSide: CGFloat = 58.0

    static func photo() -> (CGRect) {
        let photoX = indentsLeftRight
        let photoY = indentsTopBottom
        let photoOrigin = CGPoint(x: photoX, y: photoY)
        let photoSize = CGSize(width: photoSide, height: photoSide)
        return CGRect(origin: photoOrigin, size: photoSize)
    }
    
    static func name(bounds: CGRect) -> (CGRect) {
        let width = bounds.width - (indentsLeftRight * 2 + indentPhotoVsName + photoSide)
        let height: CGFloat = 20.0
        let nameSize = CGSize(width: width, height: height)
        let nameX = indentsLeftRight + photoSide + indentPhotoVsName
        let nameY = bounds.height / 2 - height / 2
        let nameOrigin = CGPoint(x: nameX, y: nameY)
        return CGRect(origin: nameOrigin, size: nameSize)
    }

}
