/*
 takuto.ukawa
 sawada.kazuma
 
 toshiki.murakami01
 Koichi Toda
 
 Abstract:
 Softbankインターン開発：CS-proto
 ARを用いたコミュニケーション支援サービス
 */

import UIKit
import SceneKit
import ARKit
import MultipeerConnectivity
import AudioToolbox
import AVFoundation

class ReceiverViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate , MicDelegate{
    
    //アウトレット接続
    //AR関連
    @IBOutlet weak var sceneView: ARSCNView!
    
    //Infoラベル
    @IBOutlet weak var receiverInfo: UILabel!
    //戻るボタン
    @IBOutlet weak var back: UIButton!
    
    //MikeController準備
    var micController = MicController()
    
    //CallModel準備
    var callModel = CallMoedl()
    
    //multiAR準備
    var multipeerSession: MultipeerSession!
    
    //通信用str受け皿
    var strComminucation: String = ""
    
    //音 peak と average RMS power を受け取る関数定義
    func nortice(mP: Float, mA: Float) {
        
        
    }
    
    // 音 peak と average RMS power を表示
    func voiceVolume(){
        //マイクスタート
        micController.startUpdatingVolume()
    }
    
    //シーン読み込み
    override func viewDidLoad() {
        //view開始
        super.viewDidLoad()
        
        //multiAR開始
        multipeerSession = MultipeerSession(receivedDataHandler: receivedData)
        
        //norticeを自分のインスタンスにする
        micController.mikenortice = self
        //マイク開始
        voiceVolume()
        
        //receiverラベル処理
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ReceiverViewController.receiverInfoLabel), userInfo: nil, repeats: true)
        
    }
    
    //シーン終了処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                これじゃ使えん
            """)
        }
        
        //ARセッション開始
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        //degrateセット：UIフィードバックのためのアンカー用
        sceneView.session.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        //放置対策
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //ARセッションポーズ
        sceneView.session.pause()
    }
    
    var receiverMessage: String = " "
    
    //Infoラベル処理
    @objc func receiverInfoLabel(){
        
        if (strComminucation == "Yes"){
            receiverMessage = "会話中"
        }
        else{
            receiverMessage = "待機中"
        }
        receiverInfo.text = receiverMessage
    }
    
    //render処理
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let name = anchor.name, name.hasPrefix("ancPoint") {
            //鳥居に陰影をつける光
            let lightNode = SCNNode()
            lightNode.light = SCNLight()
            lightNode.light!.type = SCNLight.LightType.omni
            lightNode.light!.temperature = 3000
            lightNode.position = SCNVector3(x: 350, y: 350, z: 350)
            node.addChildNode(lightNode)
            //3Dモデルをnodeに追加
            node.addChildNode(callModel.loadModel1())//car
            node.addChildNode(callModel.loadModel2())//wine
            node.addChildNode(callModel.loadModel3())//cat
            node.addChildNode(callModel.loadModel4())//東京タワー
            node.addChildNode(callModel.loadModel5())//chess
            node.addChildNode(callModel.loadModel6())//chips
            node.addChildNode(callModel.loadModel7())//goat
            node.addChildNode(callModel.loadModel8())//一騎当千
            node.addChildNode(callModel.loadModel9())//ジェット機
            node.addChildNode(callModel.loadModel10())//ピザ
            node.addChildNode(callModel.loadModel11())//ギター
            node.addChildNode(callModel.loadModel12())//鳥居
            node.addChildNode(callModel.loadModel13())//かっこうの本
            node.addChildNode(callModel.loadModel14())//騎士団の本_1
            node.addChildNode(callModel.loadModel15())//騎士団の本_2
            node.addChildNode(callModel.loadModel16())// Vivaldi CD
        }
    }
    
    //ARセッションラベル
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    
    //ARセッションおっけい
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
    }
    
    //ARセッション終了
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required.
    }
    
    //ARセッション失敗
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user.
        resetTracking(nil)
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
    
    var mapProvider: MCPeerID?
    
    //データ受け取り
    func receivedData(_ data: Data, from peer: MCPeerID) {
        
        do {
            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) {
                // Run the session with the received world map.
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = .horizontal
                configuration.initialWorldMap = worldMap
                sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                
                // Remember who provided the map for showing UI feedback.
                mapProvider = peer
            }
        } catch {
            
            do {
                if let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: data){
                    // Add anchor to the session, ARSCNView delegate adds visible content.
                    sceneView.session.add(anchor: anchor)
                } else {
                    print("アンカーおかしい\(peer)")
                }
            } catch {
                    let str = String(data: data, encoding: .utf8)
                    DispatchQueue.main.async {
                        self.strComminucation = str!
                    }
            }
        }
    }
    
    //ARセッションマネジメント
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String
        
        switch trackingState {
        case .normal where frame.anchors.isEmpty && multipeerSession.connectedPeers.isEmpty:
            // No planes detected; provide instructions for this app's AR interactions.
            message = "待ってね..."
            
        case .normal where !multipeerSession.connectedPeers.isEmpty && mapProvider == nil:
            let peerNames = multipeerSession.connectedPeers.map({ $0.displayName }).joined(separator: ", ")
            message = "会話中 \(peerNames)."
            
        case .notAvailable:
            message = "まだできないよ"
            
        case .limited(.excessiveMotion):
            message = "ゆっくり動いてね"
            
        case .limited(.insufficientFeatures):
            message = "場所が悪いよ"
            
        case .limited(.initializing) where mapProvider != nil,
             .limited(.relocalizing) where mapProvider != nil:
            message = "マップを受け取ったよ \(mapProvider!.displayName)."
            
        case .limited(.relocalizing):
            message = "元の位置に戻ってね"
            
        case .limited(.initializing):
            message = "最初から"
            
        default:
            // No feedback needed when tracking is normal and planes are visible.
            // (Nor when in unreachable limited-tracking states.)
            message = ""
            
        }
    }
    
    @IBAction func resetTracking(_ sender: UIButton?) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    //戻る
    @IBAction func backAction(_ sender: Any) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
}

