//
//  ArcView.swift
//  test
//
//  Created by Matt Cloke on 01/04/2015.
//  Copyright (c) 2015 Matt Cloke. All rights reserved.
//

import UIKit

@IBDesignable
class ArcView: UIView {
    let circlePathLayer = CAShapeLayer()
    let minus90Degrees: CGFloat = -1.570
    var circleRadius: CGFloat = 40.0
    
    @IBInspectable var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            if (newValue > 1) {
                circlePathLayer.strokeEnd = 1
            } else if (newValue < 0) {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = 2
        circlePathLayer.fillColor = UIColor.clearColor().CGColor
        circlePathLayer.strokeColor = UIColor.redColor().CGColor
        layer.addSublayer(circlePathLayer)
        backgroundColor = UIColor.whiteColor()
        progress = 0;
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleFrame.origin.x = CGRectGetMidX(circlePathLayer.bounds) - CGRectGetMidX(circleFrame)
        circleFrame.origin.y = CGRectGetMidY(circlePathLayer.bounds) - CGRectGetMidY(circleFrame)
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: circleFrame())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = max(bounds.width, bounds.height)
        circleRadius=(bounds.width/2)-5.0
        NSLog("%s",self.circleRadius)
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().CGPath
        circlePathLayer.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        circlePathLayer.transform = CATransform3DRotate(circlePathLayer.transform, minus90Degrees , 0.0, 0.0, 1.0)
        //layer.transform = CGAffineTransformMakeRotation(CGFloat(-1.570));
    }
}
