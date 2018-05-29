//
//  CeilingNode.swift
//  Parachute Game
//
//  Created by Alexander Lester on 4/26/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import Foundation
import SpriteKit

public class SkyNode: SKNode {
    public func setup(Size : CGSize) {
        let yPos : CGFloat = Size.height * 0.10
        let startPoint = CGPoint(x: 0, y: yPos)
        let endPoint = CGPoint(x: Size.width, y: yPos)
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
    }
}
