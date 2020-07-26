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
    var hud = HUD()
    // 2以上にすること
    let stageCount = 3
    var finalWidth = CGFloat()
        
    override func didMove(to view: SKView) {

        self.anchorPoint = .zero
        
        // 背景をセット
        background.craeteBackground(frameSize: self.size, number: stageCount)
        self.addChild(background)
        
        //　地面をセット
        ground.createGround(frameSize: self.size, number: stageCount)
        self.addChild(ground)
        
        // カメラの停止位置を計算
        finalWidth = self.size.width*CGFloat((stageCount-1))
        
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
            case PhysicsCategory.enemy.rawValue:
                print("player -> enemy")
                self.nokman.Hurt(damage: 1)
            case PhysicsCategory.box.rawValue:
                print("player -> box")
            case PhysicsCategory.spike.rawValue:
                self.nokman.Hurt(damage: 1)
            case PhysicsCategory.exit.rawValue:
                print("goal!!!!!")
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
                
                if let boxItem = two.node as? BoxItem{
                    let absolutePosition = self.convert(boxItem.position, from: boxItem.parent!)
                    boxItem.explode(position: absolutePosition, scene: self)
                    boxItem.removeFromParent()
                    self.nokman.Cure(heart: 1)
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
        let posX = self.nokman.position.x
        if (0 < posX && posX < finalWidth) {
            self.camera?.position = CGPoint(x: posX, y:0)
        }else if(posX >= finalWidth){
            self.camera?.position = CGPoint(x: finalWidth, y: 0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチしたボタンによって処理を分ける
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if (node.name == "Left") {
                self.nokman.Run(bw:true)
                hud.onLeftButton(on: true)
            } else if (node.name == "Right") {
                self.nokman.Run(bw:false)
                hud.onRightButton(on: true)
            } else if ( node.name == "Jump") {
                self.onJumpButton = true
                hud.onUpButton(on: true)
            } else if ( node.name == "Fire"){
                self.onFireButton = true
                hud.onAButton(on: true)
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
                self.nokman.Stop(bw: true)
                hud.onLeftButton(on: false)
            } else if node.name == "Right" {
                self.nokman.Stop(bw: false)
                hud.onRightButton(on: false)
            } else if node.name == "Jump" {
                self.onJumpButton = false
                hud.onUpButton(on: false)
            } else if node.name == "Fire" {
                self.onFireButton = false
                hud.onAButton(on: false)
            }
        }
    }
    
    
    var fireTime:Double = 0
    var fireInterval:Double = 0.1
    var jumpTime:Double = 0
    var jumpInterval:Double = 0.8
    
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

