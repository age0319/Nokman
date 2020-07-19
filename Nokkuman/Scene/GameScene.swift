//
//  GameScene.swift
//  Nokkuman
//
//  Created by haru on 2020/07/08.
//  Copyright © 2020 Harunobu Agematsu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    let nokman = Nokman()
    let cam = SKCameraNode()
    let ground = Ground()
    var onJumpButton = false
    var onFireButton = false
    var hud = HUD()
        
    override func didMove(to view: SKView) {

        self.anchorPoint = .zero
        
        // プレイヤーをセット
        self.addChild(nokman)
        
        // カメラをセット
        self.camera = cam
        self.addChild(cam)
        
        // ボタンをセット
        hud.setup(cam: cam, scene: self)
        hud.setupButton()
        hud.setupHeartDisplay(maxLife: nokman.maxLife)
        hud.updateHeartDisplay(life: nokman.life)
        
        // エンカウンターをセット
        setupEncounters()
        
        self.physicsWorld.contactDelegate = self
    }
        
    var nodesToRemove = [SKNode]()
    
    func didBegin(_ contact: SKPhysicsContact) {
        var one:SKPhysicsBody = SKPhysicsBody()
        var two:SKPhysicsBody = SKPhysicsBody()
        var player:Bool = false
    
        let nokmanMask = PhysicsCategory.nokman.rawValue
        
        let bulletMask = PhysicsCategory.bullet.rawValue

        // Aがプレイヤーだった場合、Bを条件判定対象に
        if (contact.bodyA.categoryBitMask & nokmanMask) > 0 {
            one = contact.bodyA
            two = contact.bodyB
            player = true
        // Bがプレイヤーだった場合、Aを条件判定対象に
        }else if(contact.bodyB.categoryBitMask & nokmanMask > 0){
            one = contact.bodyB
            two = contact.bodyA
            player = true
        // Aが弾だった場合、Bを条件判定対象に
        }else if (contact.bodyA.categoryBitMask & bulletMask) > 0 {
            one = contact.bodyA
            two = contact.bodyB
        // Bが弾だった場合、Aを条件判定対象に
        }else if(contact.bodyB.categoryBitMask & bulletMask > 0){
            one = contact.bodyB
            two = contact.bodyA
        }

        
        if player {
            // oneはプレイヤー
            switch two.categoryBitMask {
            case PhysicsCategory.ground.rawValue:
                print("player -> ground")
                self.nokman.onGround = true
            case PhysicsCategory.enemy.rawValue:
                print("player -> enemy")
                self.nokman.Hurt()
                hud.updateHeartDisplay(life: nokman.life)
            case PhysicsCategory.box.rawValue:
                print("player -> box")
            default:
                print("No game logic.")
            }
        }else{
            // oneは弾
            switch two.categoryBitMask {
            case PhysicsCategory.enemy.rawValue:
                print("bullet -> enemy")
                
                // 弾を消す
                nodesToRemove.append(one.node!)
                
                // カエルかハエである場合ダウンキャストする
                if let frog = two.node as? Frog{
                    frog.die()
                }else if let fly = two.node as? Fly{
                    fly.die()
                }
                
            case PhysicsCategory.box.rawValue:
                print("bullet -> box")
                // 弾を消す
                nodesToRemove.append(one.node!)
                // 箱を消す
                nodesToRemove.append(two.node!)
            default:
                print("No game logic.")
            }
        }
    }
    
    
    override func didFinishUpdate()
    {
        nodesToRemove.forEach(){$0.removeFromParent()}
        nodesToRemove = [SKNode]()
    }
    
    func setupEncounters(){
        let em = EncounterManager()
        for i in 0..<em.encounters.count{
            let node:SKNode = em.encounters[i]
            node.position = CGPoint(x: Int(self.size.width)*i,y: 0)
            self.addChild(node)
        }
    }
    
    override func didSimulatePhysics() {
        //横スクロールゲームのため、高さは固定でx座標だけ動けば良い。
        if self.nokman.position.x > 0 {
            self.camera?.position = CGPoint(x: self.nokman.position.x, y:0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチしたボタンによって処理を分ける
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if (node.name == "Left") {
                self.nokman.Run(bw:true)
            } else if (node.name == "Right") {
                self.nokman.Run(bw:false)
            } else if ( node.name == "Jump") {
                self.onJumpButton = true
            } else if ( node.name == "Fire"){
                self.onFireButton = true
            } else if ( node.name == "Restart"){
                // ゲームシーンを呼び出して初めからスタート。
                self.view?.presentScene(GameScene(size: self.size), transition: .crossFade(withDuration: 0.6))
            }
        }
    }
    
    func shotSpawn(){
        let shot = Shot(pos: self.nokman.position, bw:self.nokman.backward)
        self.addChild(shot)
        shot.fire()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == "Left" {
                self.nokman.leftMoving = false
                self.nokman.Idle()
            } else if node.name == "Right" {
                self.nokman.rightMoving = false
                self.nokman.Idle()
            } else if node.name == "Jump" {
                self.onJumpButton = false
            } else if node.name == "Fire" {
                self.onFireButton = false
            }
        }
    }
    
    var fireTime:Double = 0
    var fireInterval:Double = 0.1
    
    override func update(_ currentTime: TimeInterval) {
        
        nokman.update(currentTime)
        
        //　ジャンプフラグが立っていなければ終了
        if self.onJumpButton {
            self.nokman.Jump()
        }
        
        if self.onFireButton {
            // インターバルを空けないと発砲できないようにする
            if fireTime == 0 || currentTime - fireTime > fireInterval {
                self.nokman.Fire()
                fireTime = currentTime
            }
        }
    }
   
}

