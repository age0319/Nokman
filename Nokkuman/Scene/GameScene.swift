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
    var hud = HUD()
    var finalWidth = CGFloat()
    var stage = Int()
    
    override func didMove(to view: SKView) {
//        self.anchorPoint = .zero
        self.physicsWorld.contactDelegate = self

        // ステージを設定
        let st = Settings(stage: stage)
        
        // 敵キャラをセット
        setupSprite(fileNames: st.fileNames)
        
        // カメラの停止位置を計算
        finalWidth = self.size.width*CGFloat(st.stageNumber - 1)
        
        // 背景をセット
        background.craeteBackground(frameSize: self.size, number: st.stageNumber,stage: stage)
        self.addChild(background)

        //　地面をセット
        ground.createGround(frameSize: self.size, number: st.stageNumber)
        self.addChild(ground)
                        
        // プレイヤーをセット
        self.addChild(nokman)
        
        // カメラノードをセット
        self.camera = cam
        self.addChild(cam)
        
        // カメラノードにHUDをセット
        cam.addChild(hud)
        hud.setupButton()
        hud.setupHeartDisplay(maxLife: nokman.maxLife)
        hud.updateHeartDisplay(life: nokman.life)
        
    }
    
    func setupSprite(fileNames:[String]) {
                
        for i in 0 ..< fileNames.count{
            if let scene = SKScene(fileNamed: fileNames[i]){
                let node = SKNode()
                for child in scene.children{
                    let sprite = type(of: child).init()
                    sprite.position = child.position
                    sprite.name = child.name
                    node.addChild(sprite)
                }
                node.position = CGPoint(x: Int(self.size.width)*i,y: 0)
                self.addChild(node)
            }
        }
        
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
                stageSelect()
            case PhysicsCategory.fireball.rawValue:
                print("player -> fireball")
                var damegeAmount = 0
                if let fb = two.node as? Fireball{
                    fb.removeFromParent()
                    damegeAmount = fb.damage
                }
                self.nokman.Hurt(damage: damegeAmount)
            default:
                print("No game logic.")
            }
        }else{
            // oneは弾
            switch two.categoryBitMask {
            case PhysicsCategory.enemy.rawValue:
                print("bullet -> enemy")
                
                var damegeAmount = 0
                var absolutePosition = CGPoint()
                
                if let bullet = one.node as? Shot{
                    damegeAmount = bullet.damage
                    bullet.removeFromParent()
                }
                
                if let enemy = two.node as? Enemy{
                    enemy.takeDamage(damage: damegeAmount)
                    absolutePosition = self.convert(enemy.position, to: enemy.parent!)
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
                
            case PhysicsCategory.ground.rawValue:
                one.node?.removeFromParent()
                
            default:
                print("No game logic.")
            }
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
    
    var touchStarted: TimeInterval?
    let longTapTime: TimeInterval = 0.5
    
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
                if touchStarted == nil{
                    touchStarted = touch.timestamp
                }
                hud.onAButton(on: true)
                self.nokman.Charge(on: true)
            } else if ( node.name == "Restart"){
                restartGame()
            } else if ( node.name == "Back"){
                stageSelect()
            }
        }
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
            } else if node.name == "Fire" && touchStarted != nil{
                let timeEnded = touch.timestamp
                if timeEnded! - touchStarted! >= longTapTime {
                    self.nokman.Fire(charged: true)
                } else {
                    self.nokman.Fire(charged: false)
                }
                touchStarted = nil
                hud.onAButton(on: false)
                self.nokman.Charge(on: false)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchStarted = nil
    }

    func stageSelect(){
        let scene = SKScene(fileNamed: "StageSelect")
        scene!.scaleMode = .aspectFit
        self.view?.presentScene(scene)
    }
    
    func restartGame(){
        let scene = GameScene(size: self.size)
        scene.stage = stage
        scene.scaleMode = .aspectFit
        self.view?.presentScene(scene)
    }
    
    func gameOver(){
        hud.showRestartMenu()
    }
    
    func gameClear(){
        hud.showClearMenu()
    }
    
    var jumpTime:Double = 0
    var jumpInterval:Double = 0.8
    var fireballTime:Double = 0
    var fireballInterval:Double = 2.5
    
    override func update(_ currentTime: TimeInterval) {
        
        if nokman.die { return }
        
        // 横ボタンが押されていたら速度を設定する
        nokman.update()
        
        //　ジャンプボタンが押されていたらジャンプする
        if self.onJumpButton {
            if jumpTime == 0 || currentTime - jumpTime > jumpInterval {
                self.nokman.Jump()
                jumpTime = currentTime
            }
        }
        
        // 地面以下になったら死亡
        if nokman.position.y < -self.size.height/2{
            nokman.Die()
        }
                
    }
   
}

