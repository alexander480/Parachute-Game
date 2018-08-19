//
//  GameViewController.swift
//  Parachute Game
//
//  Created by Alexander Lester on 3/30/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            view.presentScene(SKScene(fileNamed: "GameScene.sks"))
            view.ignoresSiblingOrder = true
            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone { return .portrait } else { return .all }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool { return false }
    
    override var shouldAutorotate: Bool { return false }
}
