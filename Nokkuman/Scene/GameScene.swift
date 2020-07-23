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
    let background = Background()
    var onJumpButton = false
    var onFireButton = false
    var onRightButton = false
    var onLeftButton = false
    var hud = HUD()
        
    override func didMove(to view: SKView) {

        self.anchorPoint = .zero
        
        // 背景をセット
        background.craeteBackground(frameSize: self.size, number: 3)
        self.addChild(background)
        
        //　地面をセット
        ground.createGround(frameSize: self.size, number: 3)
        self.addChild(ground)
        
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
                self.nokman.onGround = true
            default:
                print("No game logic.")
            }
        }else{
            // oneは弾
            switch two.categoryBitMask {
            case PhysicsCategory.enemy.rawValue:
                print("bullet -> enemy")
                
                var damegeAmount = 0
                
                if let bullet = one.node as? Shot{
                    bullet.removeFromParent()
                    damegeAmount = bullet.damage
                }
                
                var absolutePosition = CGPoint()
                
                // カエルかハエである場合ダウンキャストする
                if let frog = two.node as? Frog{
                    frog.takeDamage(damage: damegeAmount)
                    absolutePosition = self.convert(frog.position, from: frog.parent!)
                    
                    
                }else if let fly = two.node as? Fly{
                    fly.takeDamage(damage: damegeAmount)
                    absolutePosition = self.convert(fly.position, from: fly.parent!)
                }
                
                hud.showDamageLabel(position: absolutePosition, damage: damegeAmount)
                
                
            case PhysicsCategory.box.rawValue:
                print("bullet -> box")
                
                if let box = two.node as? Box{
                    let absolutePosition = self.convert(box.position, from: box.parent!)
                    box.explode(position: absolutePosition, scene: self)
                    box.removeFromParent()
                }
                
                one.node?.removeFromParent()
                
            default:
                print("No game logic.")
            }
        }
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
                self.onLeftButton = true
            } else if (node.name == "Right") {
                self.nokman.Run(bw:false)
                self.onRightButton = true
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
    
    func gameOver(){
        hud.showRestartButton()
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
                self.onLeftButton = false
                self.nokman.Stop(bw: true)
            } else if node.name == "Right" {
                self.onRightButton = false
                self.nokman.Stop(bw: false)
            } else if node.name == "Jump" {
                self.onJumpButton = false
            } else if node.name == "Fire" {
                self.onFireButton = false
            }
        }
    }
    
    
    var fireTime:Double = 0
    var fireInterval:Double = 0.1
    var jumpTime:Double = 0
    var jumpInterval:Double = 0.5
    
    override func update(_ currentTime: TimeInterval) {
        
        if nokman.die { return }
        
        nokman.update(currentTime)
        
        //　ジャンプボタンが押されているか
        if self.onJumpButton {
            if jumpTime == 0 || currentTime - jumpTime > jumpInterval {
                self.nokman.Jump()
                jumpTime = currentTime
            }
        }
        
        if self.onFireButton {
            // インターバルを空けないと発砲できないようにする
            if fireTime == 0 || currentTime - fireTime > fireInterval {
                self.nokman.Fire()
                fireTime = currentTime
            }
        }
        
        if nokman.position.y < -self.size.height/2{
            nokman.Die()
        }
    }
   
}

