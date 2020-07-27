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
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        menuScene?.scaleMode = .aspectFill
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
