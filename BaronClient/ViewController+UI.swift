import UIKit
import ARKit
import SceneKit
import Lottie

extension ViewController : UITextFieldDelegate {
    
    func buildUI() {
        // ARViewの描画
        self.arSceneView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.arSceneView.center = self.view.center
        self.arSceneView.delegate = self
        self.view.addSubview(self.arSceneView)
        
        // ARViewの設定
        let arSession = ARSession()
        self.arSceneView.session = arSession
        
        // オブジェクト配置のためのシーンを追加
        let scene = SCNScene()
        self.arSceneView.scene = scene
        
        // デバッグ情報表示
        self.arSceneView.showsStatistics = true
        self.arSceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // 猫を指し示す矢印
        arrowLbl.frame = CGRect(x: 20, y: 20, width:30, height: 30)
        arrowLbl.text = "→"
        arrowLbl.textColor = .red
        arrowLbl.font = UIFont.boldSystemFont(ofSize: 30)
        self.view.addSubview(arrowLbl)
        

        lbl1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width*0.8, height: 100)
        lbl1.center = CGPoint(x: self.view.frame.width/2, y: 100)
        lbl1.text = "latitude"
        lbl1.backgroundColor = .blue
        lbl1.numberOfLines = 0
        lbl1.isHidden = true
        self.view.addSubview(lbl1)
        
        lbl2.frame = CGRect(x: 0, y: 0, width: self.view.frame.width*0.8, height: 100)
        lbl2.center = CGPoint(x: self.view.frame.width/2, y: 200)
        lbl2.text = "tap point"
        lbl2.backgroundColor = .red
        lbl2.numberOfLines = 0
        lbl2.isHidden = true
        self.view.addSubview(lbl2)
        
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        btn.center = CGPoint(x:self.view.frame.width/2, y:self.view.frame.height/2)
        btn.backgroundColor = .gray
        btn.setTitle("ボタン", for: .normal)
        btn.addTarget(self, action: #selector(ViewController.btnAction(sender:)), for: .touchUpInside)
//        btn.isHidden = true
        self.view.addSubview(btn)
        
        
        inputX.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
        inputX.delegate = self
        inputX.text = "100"
        inputX.backgroundColor = .white
        inputX.layer.borderWidth = 0.5
        inputX.keyboardType = .default
        self.view.addSubview(inputX)
        
        inputY.frame = CGRect(x: 210, y: 200, width: 100, height: 50)
        inputY.delegate = self
        inputY.text = "200"
        inputY.backgroundColor = .white
        inputY.layer.borderWidth = 0.5
        inputY.keyboardType = .default
        self.view.addSubview(inputY)
        
        // NowLoadingアニメーション
        loadAnimeView = LOTAnimationView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        loadAnimeView.center = CGPoint(x:self.view.frame.width/2,y:self.view.frame.height/2)
        loadAnimeView.setAnimation(named: "circle")
        loadAnimeView.loopAnimation = true
        loadAnimeView.animationSpeed = 1
        view.addSubview(loadAnimeView)
        loadAnimeView.play()
        
        // 鳴き声アニメーション
        meowAnimeView = LOTAnimationView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        meowAnimeView.center = CGPoint(x:self.view.frame.width/2,y:self.view.frame.height/2)
        meowAnimeView.setAnimation(named: "check")
        meowAnimeView.loopAnimation = false
        meowAnimeView.animationSpeed = 1
        view.addSubview(meowAnimeView)
        loadAnimeView.play()
        
    }
    
    // ステータスバーを非表示にする
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}
