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
import Vision
import VideoToolbox
import QuartzCore

class SenderViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate , MicDelegate, AVAudioPlayerDelegate{
    
    //delegate
    let fromAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //アウトレット接続
    //AR関連
    @IBOutlet weak var sceneView: ARSCNView!
    
    //Infoラベル
    @IBOutlet weak var senderInfo: UILabel!
    //戻るボタン
    @IBOutlet weak var back: UIButton!
    
    //クルクル関連
    @IBOutlet weak var kurukuru: UIActivityIndicatorView!
    var veilView: UIView!
    
    //MikeController準備
    var micController = MicController()
    
    //CallModel準備
    var callModel = CallMoedl()
    
    //multiAR準備
    var multipeerSession: MultipeerSession!
    
    //AR セッションフラグ
    var mapRecognized = false
    
    //通信用str受け皿
    var strComminucation: String = ""
    
    @IBOutlet weak var fdButton: UIButton!
    var isEnableFaceDetect: Bool = false
    var faceDetected: Bool = false
    var faceObservation: VNFaceObservation!
    
    
    //時間
    var timer = Timer()
    var count = 0
    
    //グラフの値
    var graph_num = 25
    var graph_val = [Float](repeating: 0.0, count: 25)
    var morimori_ave: Float = 0.0
    
    var graph_sum: Float = 0.0
    var graph_ave: Float = 0.0
    
    @IBOutlet weak var graphLabel: UIImageView!
    
    //音 peak と average RMS power を受け取る関数定義
    func nortice(mP: Float, mA: Float) {
        
        //盛り上がり度記録
        fromAppDelegate.morimori = -1 / mA      //盛り上がり度定義
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        morimori_ave += fromAppDelegate.morimori ?? 0.0
//        print("盛り上がり度: " + String(format: "%.2f", fromAppDelegate.morimori ?? 0) + " " + format.string(from: Date()))
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
        
        //クルクル系設定
        kurukuru.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        kurukuru.center = self.view.center
        kurukuru.hidesWhenStopped = true
        self.view.addSubview(kurukuru)
        kurukuru.startAnimating()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SenderViewController.kurukuruUnload), userInfo: nil, repeats: true)
        veilView = UIView()
        veilView.frame = CGRect(x:0.0, y:0.0, width:self.view.frame.width, height:self.view.frame.height)
        veilView.backgroundColor =  _ColorLiteralType(red: 0, green: 0, blue: 0, alpha: 0)
//        self.view.addSubview(veilView)
        
        //senderラベル処理
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SenderViewController.senderInfoLabel), userInfo: nil, repeats: true)
        
        //グラフの初期化
        graph_init()
        
        //グラフ用に盛り上がり度の取得
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.count += 1

            self.graph_sum = 0.0
            self.graph_sum = self.graph_sum - self.graph_val[0]
            for i in (0..<self.graph_num-1){
                self.graph_val[i] = self.graph_val[i+1]
                //self.graph_sum += self.graph_val[i]
            }
            for i in (0..<10){
                self.graph_sum += self.graph_val[self.graph_num-i-2]
            }
            self.graph_val[self.graph_num-1] = 100.0*(self.morimori_ave/10.0 - 0.018)
            //print(self.graph_val[self.graph_num-1])
            if self.graph_val[self.graph_num-1] >= 4.0{
                self.graph_val[self.graph_num-1] = 4.0
            }
            self.graph_sum += self.graph_val[self.graph_num-1]
            self.graph_ave = self.graph_sum / Float(self.graph_num)
            print(self.graph_ave)
            self.graph_val[self.graph_num-1] = pow(self.graph_val[self.graph_num-1],3)
            //print(self.graph_val[self.graph_num-1])
            self.morimori_ave = 0.0
            self.draw_graph()
        })
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
    
    var senderMessage: String = " "
    var musicFlag = true
    
    //Infoラベル処理
    @objc func senderInfoLabel(){
        
        if touchFlg{
            senderMessage = "画面タッチでオブジェクトを配置"
        }
        else{
            if(touchCount > 0){
                senderMessage = "あと" + String(touchCount) + "回タッチ"
            }
            else if (touchCount == 0){
                senderMessage = "会話中"
                
                //ワールドマップ共有完了フラグ
                var yes: String = "Yes"
                let data: Data? = yes.data(using: .utf8)
                self.multipeerSession.sendToReceiver(data!)
            }
            else if(touchCount == -1){
                senderMessage = "話題を掘り下げて"
            }
            else if(touchCount == -2){
                senderMessage = "音楽を楽しみましょう"
                if musicFlag{
                    turnAudio(name: "vivaldi_spring")
                    musicFlag = false
                }
            }
            else if(touchCount == -3){
                senderMessage = "他の話題に"
                audioPlayer.stop()
            }
            else if(touchCount == -4){
                senderMessage = "東京タワーに興味がありそうです"
            }
            else if(touchCount == -5){
                senderMessage = "話を膨らませましょう"
            }
            else{
                senderMessage = "どうぞ楽しんで"
            }
        }
        senderInfo.text = senderMessage
    }
    //クルクル処理
    @objc func kurukuruUnload(){
        if mapRecognized {
            kurukuru.stopAnimating()
//            self.view.sendSubviewToBack(veilView)
        }
        else{
            kurukuru.startAnimating()
//            self.view.bringSubviewToFront(veilView)
        }
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
    
    var moriSum:Float = 0.0
    
    /* Kudo Edit */
    var currentFocusedObjectName: String? = ""
    var focusStartAt: Date? = nil
    // Continuously called while camera is active.
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        if (isEnableFaceDetect) {
            var cgImage: CGImage?
            guard let cuptureImage = sceneView.session.currentFrame?.capturedImage else {
                return
            }
            VTCreateCGImageFromCVPixelBuffer(cuptureImage, options: nil, imageOut: &cgImage)
            detectFace(image: resize(image: cgImage!)!)
        }
        
        // 画面中央のHitTestを実施
        let hitResults = sceneView.hitTest(CGPoint(x: sceneView.frame.width / 2.0, y: sceneView.frame.height / 2.0), options: [:])
        var focus: String = ""
        if hitResults.count > 0 {
            // Hit ResultやNodeは、想定しない型の場合があるため、チェックを厳重に行う
            guard let result = hitResults.first else {return}
            guard let hitNode:SCNNode = result.node else {return}
            // 画面中央に何も写っていない場合の一部で、HitTestが成功し、かつノードが存在する場合がある。
            // TOOD: この場合、写っていないとへ判定することが出来ない…
            guard let hitNodeName:String = hitNode.name else {
                return
            }
            if hitNodeName.isEmpty {
                focus = "None"
            } else {
                focus = hitNodeName
            }
        } else {
            focus = "None"
        }
        
        if currentFocusedObjectName == focus {
            
            /* Ukawa Edit */
            //盛り上がり指数計算
            moriSum += fromAppDelegate.morimori ?? 0
            /* Ukawa Edit */
            
            return
        } else {
            if focusStartAt != nil {
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                print("FOCUSED_AT:" + currentFocusedObjectName! + " DURATION:" + format.string(from: focusStartAt!) + "~" + format.string(from: Date()))
                
                /* Ukawa Edit */
                //盛り上がり指数表示
                print("FOCUSED_AT:" + currentFocusedObjectName! + " 盛り上がり指数: " + String(format: "%.2f", moriSum) )
                /* Ukawa Edit */
                
            }
            
            /* Ukawa Edit */
            //盛り上がり指数リセット
            moriSum = 0
            /* Ukawa Edit */
            
            focusStartAt = Date()
            currentFocusedObjectName = focus
        }
    }
    /* Kudo Edit */
    
    //ARセッションラベル
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    //ARセッションボタン
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        switch frame.worldMappingStatus {
        case .notAvailable, .limited:
            mapRecognized = false
        case .extending:
            mapRecognized = !multipeerSession.connectedPeers.isEmpty
        case .mapped:
            mapRecognized = !multipeerSession.connectedPeers.isEmpty
        }
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
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
    
    //touchフラグ
    var touchFlg = true
    var touchCount = 1
    
    //画面タップアクション
    @IBAction func handleSceneTap(_ sender: UITapGestureRecognizer) {
        if (touchFlg == true) {
            guard let hitTestResult = sceneView
                .hitTest(sender.location(in: sceneView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
                .first
                else { return }
            
            //アンカー設置
            let anchor = ARAnchor(name: "ancPoint", transform: hitTestResult.worldTransform)
            sceneView.session.add(anchor: anchor)
            //アンカー送信
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: true)
                else { fatalError("アンカーエンコードできてないよ")}
            self.multipeerSession.sendToAllPeers(data)
            
            //タッチフラグ切り替え
            touchFlg = false
            
        }
        else{
            if(touchCount > 0){
                sceneView.session.getCurrentWorldMap { worldMap, error in
                    guard let map = worldMap
                        else { print("Error: \(error!.localizedDescription)"); return }
                    guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                        else { fatalError("マップエンコードできてないよ") }
                    self.multipeerSession.sendToAllPeers(data)
                    
                    //タッチカウント進行
                    self.touchCount -= 1
                }
            }
            else{
                print("ラベルdemo用処理実行")
                //タッチカウント進行
                self.touchCount -= 1
            }
        }
        
        let hitResults = sceneView.hitTest(sender.location(in: sceneView), options: [:])
        if hitResults.count > 0 {
            // Hit ResultやNodeは、想定しない型の場合があるため、チェックを厳重に行う
            guard let result = hitResults.first else {return}
            guard let hitNode:SCNNode = result.node else {return}
            // 画面中央に何も写っていない場合の一部で、HitTestが成功し、かつノードが存在する場合がある。
            // TOOD: この場合、写っていないとへ判定することが出来ない…
            guard let hitNodeName:String = hitNode.name else {
                return
            }
            if hitNodeName.contains("vivaldi"){
                turnAudio(name: "vivaldi_spring")
            }
        }
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
        touchFlg = true
    }
    
    @IBAction func backAction(_ sender: Any) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        touchFlg = true
    }
    var roundRectLayer = CAShapeLayer.init()

    /* Kudo Edit */
    private func detectFace(image: CGImage) {
        let request = VNDetectFaceRectanglesRequest { (request, error) in
            for observation in request.results as! [VNFaceObservation] {
                print(observation)
                self.faceObservation = observation
                self.faceDetected = true
                /* --- 角丸四角形を描画 --- */
                let roundRectFrame = CGRect.init(x: self.view.frame.width * observation.boundingBox.origin.y,
                                                 y: self.view.frame.height * observation.boundingBox.origin.x,
                                                 width: self.view.frame.width * observation.boundingBox.size.height,
                                                 height: self.view.frame.height * observation.boundingBox.size.width)
                self.roundRectLayer.frame = roundRectFrame
                self.roundRectLayer.strokeColor = UIColor.blue.cgColor
                self.roundRectLayer.fillColor = UIColor.clear.cgColor
                self.roundRectLayer.lineWidth = 2.5
                self.roundRectLayer.path = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: roundRectFrame.size.width, height: roundRectFrame.size.height), cornerRadius: 8).cgPath
                self.view.layer.addSublayer(self.roundRectLayer)
                return
            }
            self.roundRectLayer.removeFromSuperlayer()
            self.faceDetected = false
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        try? handler.perform([request])
    }
    
    func resize(image: CGImage) -> CGImage? {
        let ratio: Float = 0.1
        let imageWidth = Float(image.width)
        let imageHeight = Float(image.height)
        let width = imageWidth * ratio
        let height = imageHeight * ratio
        
        guard let colorSpace = image.colorSpace else { return nil }
        guard let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: image.bitsPerComponent, bytesPerRow: image.bytesPerRow, space: colorSpace, bitmapInfo: image.alphaInfo.rawValue) else { return nil }
        
        // draw image to context (resizing it)
        context.interpolationQuality = .low
        context.draw(image, in: CGRect(x: 0, y: 0, width: Int(width), height: Int(height)))
        
        // extract resulting image from context
        return context.makeImage()
    }
    
    @IBAction func fdButtonPressed(_ sender: Any) {
        if (!isEnableFaceDetect) {
            isEnableFaceDetect = true;
            fdButton.setTitle("Disable FD", for: UIControl.State.normal)
        } else {
            isEnableFaceDetect = false;
            fdButton.setTitle("Disable FD", for: UIControl.State.normal)
        }
    }
    
    var audioPlayer: AVAudioPlayer!
    func turnAudio(name: String) {
        if (audioPlayer != nil && audioPlayer.isPlaying) {
            audioPlayer.stop()
        } else {
            guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
                print("File " + name + " not found.")
                return
            }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer.delegate = self
                audioPlayer.play()
            } catch {
                return
            }
        }
    }
    
    /* Kudo Edit */
    
    
    //グラフの初期化
    var graph = [CAShapeLayer.init()]
    func graph_init() {
        for i in (0..<self.graph_num){
            graph.append(CAShapeLayer.init())
            graph[i].isHidden = true
            self.view.layer.addSublayer(self.graph[i])
        }
        /*
        let line = CAShapeLayer.init()
        let roundRectFrame = CGRect.init(x: 0,
                                         y: 420,
                                         width: 400,
                                         height: 3)
        line.strokeColor = UIColor.gray.cgColor
        line.fillColor = UIColor.gray.cgColor
        line.lineWidth = 2
        line.path = UIBezierPath.init(roundedRect: CGRect.init(x: 8, y: 722, width: roundRectFrame.size.width, height: roundRectFrame.size.height), cornerRadius: 0).cgPath
        self.view.layer.addSublayer(line)
 */
    }
    
    //グラフの描画
    func draw_graph() {
        var scale = 3
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        for i in 0..<self.graph_num{
            let roundRectFrame = CGRect.init(x: i*15+8,
                                             y: 550 - scale*Int(self.graph_val[i]),
                                             width: 10,
                                             height: scale*Int(self.graph_val[i]))
            graph[i].isHidden = false
            self.graph[i].frame = roundRectFrame
            self.graph[i].strokeColor = UIColor.blue.cgColor
            if self.graph_ave <= 2.0 {
                self.graph[i].strokeColor = UIColor.red.cgColor
                self.graph[i].fillColor = UIColor.red.cgColor
            }else if self.graph_ave > 2.0 && self.graph_ave <= 5.0 {
                self.graph[i].strokeColor = UIColor.green.cgColor
                self.graph[i].fillColor = UIColor.green.cgColor
            }else{
                self.graph[i].strokeColor = UIColor.blue.cgColor
                self.graph[i].fillColor = UIColor.blue.cgColor
            }
            //self.graph[i].fillColor = UIColor.blue.cgColor
            self.graph[i].path = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: roundRectFrame.size.width, height: roundRectFrame.size.height)).cgPath
        }
        CATransaction.commit()
    }
}

