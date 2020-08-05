//
//  GameViewController.swift
//  Nokkuman
//
//  Created by haru on 2020/07/08.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let menuScene = SKScene(fileNamed: "MenuScene")
//        let menuScene = GameScene(size: CGSize(width: 812, height: 375))
//        menuScene.stage = 3
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        menuScene!.scaleMode = .aspectFill
        skView.showsPhysics = true
        skView.showsNodeCount = true
        skView.showsFPS = true
        skView.presentScene(menuScene)
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
