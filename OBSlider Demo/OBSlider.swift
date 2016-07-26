//
// Created by TBinder on 26/07/16.
//

import Foundation
import UIKit

class OBSlider: UISlider
{
    var defaultScrubbingSpeeds: [CGFloat] = [1.0, 0.5, 0.25, 0.1]
    var scrubbingSpeeds: [CGFloat] = []
    
    var defaultScrubbingSpeedChangePositions: [CGFloat] = [0.0, 50.0, 100.0, 150.0]
    var scrubbingSpeedChangePositions: [CGFloat] = []
    
    var scrubbingSpeed: CGFloat = 0.0
    var realPositionValue: CGFloat = 0.0
    var beganTrackingLocation: CGPoint = CGPoint()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        scrubbingSpeeds = defaultScrubbingSpeeds
        scrubbingSpeedChangePositions = defaultScrubbingSpeedChangePositions
        scrubbingSpeed = scrubbingSpeeds[0]
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)

        scrubbingSpeeds = defaultScrubbingSpeeds
        scrubbingSpeedChangePositions = defaultScrubbingSpeedChangePositions
        scrubbingSpeed = scrubbingSpeeds[0]
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool
    {
        let beginTracking = super.beginTrackingWithTouch(touch, withEvent: event)
        
        if beginTracking
        {
            let thumbRect: CGRect = thumbRectForBounds(self.bounds,
                                                       trackRect: self.trackRectForBounds(self.bounds),
                                                       value: self.value)
            beganTrackingLocation = CGPointMake(thumbRect.origin.x + thumbRect.size.width / 2.0,
                                                thumbRect.origin.y + thumbRect.size.height / 2.0)
            self.realPositionValue = CGFloat(self.value)
        }
        
        return beginTracking
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool
    {
        if self.tracking
        {
            let previousLocation = touch.previousLocationInView(self)
            let currentLocation = touch.locationInView(self)
            let trackingOffset: CGFloat = currentLocation.x - previousLocation.x
            
            let verticalOffset = fabs(currentLocation.y - self.beganTrackingLocation.y)
            
            var scrubbingSpeedChangePosIndex = indexOfLowerScrubbingSpeed(scrubbingSpeedChangePositions, verticalOffset: verticalOffset)
            
            if (scrubbingSpeedChangePosIndex == NSNotFound)
            {
                scrubbingSpeedChangePosIndex = scrubbingSpeeds.count
            }
            
            scrubbingSpeed = scrubbingSpeeds[scrubbingSpeedChangePosIndex - 1]
            
            let trackRect = trackRectForBounds(self.bounds)
            let tmp = CGFloat(maximumValue - minimumValue)
            realPositionValue = realPositionValue + tmp * (trackingOffset / trackRect.size.width)
            
            let valueAdjustment = self.scrubbingSpeed * tmp * (trackingOffset / trackRect.size.width)
            var thumbAdjustment: CGFloat = 0.0
            
            if ( ((self.beganTrackingLocation.y < currentLocation.y) && (currentLocation.y < previousLocation.y)) ||
                ((self.beganTrackingLocation.y > currentLocation.y) && (currentLocation.y > previousLocation.y)) )
            {
                // We are getting closer to the slider, go closer to the real location
                thumbAdjustment = (self.realPositionValue - CGFloat(self.value)) / (1 + fabs(currentLocation.y - self.beganTrackingLocation.y))
            }
            
            self.value += Float( valueAdjustment + thumbAdjustment)
            
            if (self.continuous)
            {
                sendActionsForControlEvents(.ValueChanged)
            }
        }
        
        return self.tracking
    }
    
    func indexOfLowerScrubbingSpeed(scrubbingSpeedPositions: [CGFloat], verticalOffset: CGFloat) -> Int
    {
        for i in 0 ..< scrubbingSpeedPositions.count
        {
            let scrubbingSpeedOffset: CGFloat = scrubbingSpeedPositions[i]
            if (verticalOffset < scrubbingSpeedOffset)
            {
                return i
            }
        }
        
        return NSNotFound
    }
    
}
