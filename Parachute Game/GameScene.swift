//
//  GameScene.swift
//  Parachute Game
//
//  Created by Alexander Lester on 3/30/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

func + (left: CGPoint, right: CGPoint) -> CGPoint { return CGPoint(x: left.x + right.x, y: left.y + right.y) }
func - (left: CGPoint, right: CGPoint) -> CGPoint { return CGPoint(x: left.x - right.x, y: left.y - right.y) }
func * (point: CGPoint, scalar: CGFloat) -> CGPoint { return CGPoint(x: point.x * scalar, y: point.y * scalar) }
func / (point: CGPoint, scalar: CGFloat) -> CGPoint { return CGPoint(x: point.x / scalar, y: point.y / scalar) }

extension CGPoint {
    func length() -> CGFloat { return (x*x + y*y).squareRoot() }
    func normalized() -> CGPoint { return self / length() }
}

struct PhysicsCategory {
    static let None       : UInt32 = 0
    static let All        : UInt32 = UInt32.max
    static let Drone      : UInt32 = 0b1 // 1
    static let Projectile : UInt32 = 0b10 // 2
}

private let Ground = GroundNode()
private let Sky = SkyNode()

class GameScene: SKScene, SKPhysicsContactDelegate {
    var timer = Timer()
    let tank = SKSpriteNode(imageNamed: "Tank")
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
    }
    
    override func didMove(to view: SKView) {
        self.spawnTank()
        self.initPhysics()
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnDrone), SKAction.wait(forDuration: 4.5)])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { self.shootProjectile(atLocation: touch.location(in: self)) }
    }
    
    private func initPhysics() {
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
    }
    
    private func spawnTank() {
        let tank = SKSpriteNode(imageNamed: "Tank")
            tank.size = CGSize(width: 150.0, height: 125.0)
            tank.position = CGPoint(x: self.frame.size.width/2, y: 90.0)
        
        addChild(tank)
    }
    
    private func spawnDrone() {
        let drone = SKSpriteNode(imageNamed: "Drone")
            drone.size = CGSize(width: 64.0, height: 40.0)
            drone.position = CGPoint(x: 0, y: self.frame.size.height - CGFloat(arc4random_uniform(200))) // Start On Left Side Of Screen
            drone.physicsBody = SKPhysicsBody(rectangleOf: drone.size)
            drone.physicsBody?.isDynamic = true
            drone.physicsBody?.categoryBitMask = PhysicsCategory.Drone
            drone.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
            drone.physicsBody?.collisionBitMask = PhysicsCategory.None
        
            self.addChild(drone)
        
            let moveAction = SKAction.moveTo(x: self.frame.size.width, duration: 4.0)
            drone.run(moveAction) { drone.removeFromParent(); }
    }
    
    private func dropPackage() {
        let package = SKSpriteNode(imageNamed: "Package")
            package.size = CGSize(width: 35, height: 35)
        
    }
    
    private func shootProjectile(atLocation: CGPoint) {
        let projectile = SKSpriteNode(imageNamed: "Ammo")
            projectile.zPosition = -1.0
            projectile.setScale(1.0)
            projectile.position = CGPoint(x: self.frame.size.width/2, y: 90.0)
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.isDynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Drone
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
            projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(projectile)
        
        let destination = ((atLocation - projectile.position).normalized() * 2000)
        let shootAction = SKAction.move(to: destination, duration: 1.5)
        let shootActionDone = SKAction.removeFromParent()
    
        projectile.run(SKAction.sequence([shootAction, shootActionDone]))
    }
    
    private func randomPosition(ForSprite: SKSpriteNode) -> CGPoint {
        let rdm = GKRandomDistribution(lowestValue: 0, highestValue: Int(self.frame.size.width))
        let randomPosition = CGFloat(rdm.nextInt())
        return CGPoint(x: randomPosition, y: self.frame.size.height + ForSprite.size.height)
    }
    
    private func projectileDidCollideWithMonster(projectile: SKSpriteNode, drone: SKSpriteNode) {
        print("Drone Hit!")
        projectile.removeFromParent()
        drone.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask { firstBody = contact.bodyA; secondBody = contact.bodyB }
        else { firstBody = contact.bodyB; secondBody = contact.bodyA }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Drone != 0) && (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            if let drone = firstBody.node as? SKSpriteNode, let projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(projectile: projectile, drone: drone)
            }
        }
        
    }
}
