//
//  CallModel.swift
//  CS-proto
//
//  Created by admin on 2018/09/06.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit


//各3Dモデル読み込みとパラメーター設定

class CallMoedl{

    // Whole Scale
    var w_s: SCNVector3 = SCNVector3(4.0, 4.0, 4.0)
    // Whole Rotation Axis
    var w_e: SCNVector4 = SCNVector4(0.0, 1.0, 0.0, 180.0)
    // Whole Position
    var w_p: SCNVector3 = SCNVector3(0.0, 0.0, 0.0)
    
    // Don't Change Pleas.
    var distanceRatio: Float = 0.01
    var scaleRatio: Float = 0.01
    
    // モデルcar
    func loadModel1() -> SCNNode {
        // 3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "Convertible", withExtension: "obj", subdirectory: "Assets.scnassets/car")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 0.5, scaleRatio * 0.5, scaleRatio * 0.5)
        let e = SCNVector3(toDeg(rad: 90.0 - 90.0), toDeg(rad: 199.0 - 180.0), toDeg(rad: 0.0))
        let p = SCNVector3(-(-2.47714 * distanceRatio), 0.0, (4.10417 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform, w_e.w, w_e.x, w_e.y, w_e.z)
        return referenceNode
    }
    
    //モデルwine
    func loadModel2() -> SCNNode {
        //3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "wine_bottle_1", withExtension: "obj", subdirectory: "Assets.scnassets/wine")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 5.464, scaleRatio * 5.464, scaleRatio * 5.464)
        let e = SCNVector3(toDeg(rad: 90.0 - 90.0), toDeg(rad: 143.0 - 180.0), toDeg(rad: 0.0))
        let p = SCNVector3(-(2.23107 * distanceRatio), 0.0, (2.13591 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform,  w_e.w, w_e.x, w_e.y, w_e.z)
        return referenceNode
    }
    
    
    //モデルcat
    func loadModel3() -> SCNNode {
        //3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "cat", withExtension: "obj", subdirectory: "Assets.scnassets/cat")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 1.924, scaleRatio * 1.924, scaleRatio * 1.924)
        let e = SCNVector3(toDeg(rad: 89.7 - 90.0), toDeg(rad: 122.0 - 180.0), toDeg(rad: 0.0))
        let p = SCNVector3(-(2.4515 * distanceRatio), (1.85972 * distanceRatio), (1.20806 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform,  w_e.w, w_e.x, w_e.y, w_e.z)
        return referenceNode
    }
    
    //モデルtokyotower
    func loadModel4() -> SCNNode {
        //3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "untitled", withExtension: "obj", subdirectory: "Assets.scnassets/tokyo_tower")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 2.287, scaleRatio * 2.287, scaleRatio * 2.287)
        let e = SCNVector3(toDeg(rad: 90.0 - 90.0), toDeg(rad: 0 - 180.0), toDeg(rad: 0.0))
        let p = SCNVector3(-(-1.38303 * distanceRatio), 0.0, (-1.6435 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform,  w_e.w, w_e.x, w_e.y, w_e.z)
        return referenceNode
    }
    
    //モデルchess
    func loadModel5() -> SCNNode {
        //3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "chess", withExtension: "obj", subdirectory: "Assets.scnassets/chess")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 0.622, scaleRatio * 0.622, scaleRatio * 0.622)
        let e = SCNVector3(toDeg(rad: 90.0 - 90.0), toDeg(rad: 2.74 - 180.0), toDeg(rad: 0.0))
        let p = SCNVector3(-(3.04735 * distanceRatio), 0.0, (2.46144 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform,  w_e.w, w_e.x, w_e.y, w_e.z)
        return referenceNode
    }
    
    //モデルchips
    func loadModel6() -> SCNNode {
        //3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "chips", withExtension: "obj", subdirectory: "Assets.scnassets/chips_max")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 0.332, scaleRatio * 0.332, scaleRatio * 0.332)
        let e = SCNVector3(toDeg(rad: 90.0 - 90.0), toDeg(rad: -20.3 - 180.0), toDeg(rad: 0.0))
        let p = SCNVector3((-1.02655 * distanceRatio), 0.0, (4.47266 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform,  w_e.w, w_e.x, w_e.y, w_e.z)
        return referenceNode
    }
    
    //モデルgoat
    func loadModel7() -> SCNNode {
        //3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "goat", withExtension: "obj", subdirectory: "Assets.scnassets/goat")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 1.243, scaleRatio * 1.243, scaleRatio * 1.243)
        let e = SCNVector3(toDeg(rad: 90.0 - 90.0), toDeg(rad: 484 - 180.0), toDeg(rad: 0.0))
        let p = SCNVector3(-(2.92358 * distanceRatio), 0.0, (1.48605 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform,  w_e.w, w_e.x, w_e.y, w_e.z)
        return referenceNode
    }
    
    //モデル一騎当千
    func loadModel8() -> SCNNode {
        //3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "untitled", withExtension: "obj", subdirectory: "Assets.scnassets/ikkitousen")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 0.1, scaleRatio * 0.1, scaleRatio * 0.1)
        let e = SCNVector3(toDeg(rad: 90.0 - 90.0), toDeg(rad: 145.0 - 180.0), toDeg(rad: 0.0))
        let p = SCNVector3(-(-2.18516 * distanceRatio), (6.77995 * distanceRatio), (0.18975 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform,  w_e.w, w_e.x, w_e.y, w_e.z)
        return referenceNode
    }
    
    //モデルジェット機
    func loadModel9() -> SCNNode {
        //3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "jet", withExtension: "obj", subdirectory: "Assets.scnassets/jet")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 0.388, scaleRatio * 0.388, scaleRatio * 0.388)
        let e = SCNVector3(toDeg(rad: 121 - 90.0), toDeg(rad: 177.0 - 180.0), toDeg(rad: -(15)))
        let p = SCNVector3(-(-0.03001 * distanceRatio), (9.41962 * distanceRatio), (-4.07924 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform,  w_e.w, w_e.x, w_e.y, w_e.z)
        //モデルパラメータ設定
        //var modelPara = SCNMatrix4MakeScale(0.01,0.01,0.01)
        //modelPara = SCNMatrix4Translate(modelPara,-0.15,0.4,-0.1)
        //modelPara = SCNMatrix4Rotate(modelPara,Float.pi * 0.15 ,0,1,0)
        //referenceNode.transform = modelPara
        
        
        return referenceNode
    }
    
    //モデルピザ
    func loadModel10() -> SCNNode {
        //3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "pizza", withExtension: "obj", subdirectory: "Assets.scnassets/pizza")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 0.414, scaleRatio * 0.414, scaleRatio * 0.414)
        let e = SCNVector3(toDeg(rad: 90.0 - 90.0), toDeg(rad: -145 - 180.0), toDeg(rad: 0.0))
        let p = SCNVector3(-(1.14266 * distanceRatio), 0.0, (2.83712 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform,  w_e.w, w_e.x, w_e.y, w_e.z)
        return referenceNode
    }
    
    //モデルギター
    func loadModel11() -> SCNNode {
        //3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "guitar", withExtension: "obj", subdirectory: "Assets.scnassets/acousticguitar")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 0.739, scaleRatio * 0.739, scaleRatio * 0.739)
        let e = SCNVector3(toDeg(rad: 98.6 - 90.0), toDeg(rad: -160 - 180.0), toDeg(rad: -(34.9)))
        let p = SCNVector3(-(2.68359 * distanceRatio), 0, (-0.92691 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform,  w_e.w, w_e.x, w_e.y, w_e.z)
        return referenceNode
    }
    
    //モデル鳥居
    func loadModel12() -> SCNNode {
        //3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "torii", withExtension: "obj", subdirectory: "Assets.scnassets/torii_")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 0.74, scaleRatio * 0.74, scaleRatio * 0.74)
        let e = SCNVector3(toDeg(rad: 90.0 - 90.0), toDeg(rad: 17.0 - 180.0), toDeg(rad: 0.0))
        let p = SCNVector3(-(-2.37841 * distanceRatio), 0.0, (3.51386 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform,  w_e.w, w_e.x, w_e.y, w_e.z)
        for node in referenceNode.childNodes {
            let material1 = SCNMaterial()
            material1.diffuse.contents = UIColor.red
            let material2 = SCNMaterial()
            material2.diffuse.contents = UIColor.black
            node.geometry?.replaceMaterial(at: 0, with: material1)
            node.geometry?.replaceMaterial(at: 1, with: material2)
        }
        
        
        return referenceNode
        
    }
    
    //モデルかっこうの本
    func loadModel13() -> SCNNode {
        //3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "kakko", withExtension: "obj", subdirectory: "Assets.scnassets/kakko")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 0.332, scaleRatio * 0.332, scaleRatio * 0.332)
        let e = SCNVector3(toDeg(rad: 90.0 - 90.0), toDeg(rad: 70.9 - 180.0), toDeg(rad: 0.0))
        let p = SCNVector3(-(2.221039 * distanceRatio), 0, (-3.77671 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform,  w_e.w, w_e.x, w_e.y, w_e.z)
        return referenceNode
    }
    
    //モデル騎士団の本_1
    func loadModel14() -> SCNNode {
        //3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "kishidan1", withExtension: "obj", subdirectory: "Assets.scnassets/kishidan_1")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 0.227, scaleRatio * 0.227, scaleRatio * 0.227)
        let e = SCNVector3(toDeg(rad: 95.9 - 90.0), toDeg(rad: 126 - 180.0), toDeg(rad: -(-3.78)))
        let p = SCNVector3(-(3.20992 * distanceRatio), (0.10132 * distanceRatio), (-3.70259 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform,  w_e.w, w_e.x, w_e.y, w_e.z)
        return referenceNode
    }
    
    //モデル騎士団の本_2
    func loadModel15() -> SCNNode {
        //3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "kishidan2", withExtension: "obj", subdirectory: "Assets.scnassets/kishidan_2")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 0.242, scaleRatio * 0.242, scaleRatio * 0.242)
        let e = SCNVector3(toDeg(rad: 90.0 - 90.0), toDeg(rad: 94.1 - 180.0), toDeg(rad: -(6.97)))
        let p = SCNVector3(-(2.24433 * distanceRatio), (0.09038 * distanceRatio), (-2.89150 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform,  w_e.w, w_e.x, w_e.y, w_e.z)
        return referenceNode
    }
    
    // モデル CD Vivaldi
    func loadModel16() -> SCNNode {
        // 3Dモデル読み込み
        let sceneURL = Bundle.main.url(forResource: "vivaldi_fs", withExtension: "obj", subdirectory: "Assets.scnassets/vivaldi_fs")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let s = SCNVector3(scaleRatio * 0.5, scaleRatio * 0.5, scaleRatio * 0.5)
        let e = SCNVector3(toDeg(rad: 90.0 - 90.0), toDeg(rad: 120.0 - 180.0), toDeg(rad: 0.0))
        let p = SCNVector3(-(3.72422 * distanceRatio), 0.0, (-0.29303 * distanceRatio))
        
        // モデルパラメータ設定
        referenceNode.scale = SCNVector3(s.x * w_s.x, s.y * w_s.y, s.z * w_s.z)
        referenceNode.eulerAngles = SCNVector3(e.x, e.y, e.z)
        referenceNode.position = SCNVector3((p.x + w_p.x) * w_s.x,
                                            (p.y + w_p.y) * w_s.y,
                                            (p.z + w_p.z) * w_s.z)
        referenceNode.transform = SCNMatrix4Rotate(referenceNode.transform, w_e.w, w_e.x, w_e.y, w_e.z)
        return referenceNode
    }
    
    
    func toDeg(rad: Float) -> Float {
        return  rad * Float.pi / 180
    }
    
}
