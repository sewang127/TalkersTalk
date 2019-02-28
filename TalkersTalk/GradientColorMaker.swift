//
//  GradientColorMaker.swift
//  RandomChat
//
//  Created by Se Wang Oh on 8/27/18.
//  Copyright © 2018 Se Wang Oh. All rights reserved.
//

import UIKit

class GradientColorMaker {
    
    static func createGradientColorLayer(topColor: UIColor, bottomColor: UIColor, bound: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = bound
        return gradientLayer
    }
    
}
