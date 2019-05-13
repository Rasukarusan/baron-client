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
        
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        btn.center = CGPoint(x:self.view.frame.width/2, y:self.view.frame.height/2)
        btn.backgroundColor = .gray
        btn.setTitle("ボタン", for: .normal)
        btn.addTarget(self, action: #selector(ViewController.btnAction(sender:)), for: .touchUpInside)
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
        loadAnimeView.setAnimation(named: "loading")
        loadAnimeView.backgroundColor = .clear
        loadAnimeView.loopAnimation = true
        loadAnimeView.animationSpeed = 2
        loadAnimeView.contentMode = .scaleAspectFit
        loadAnimeView.play()
        self.view.addSubview(loadAnimeView)
        
        // 鳴き声アニメーション
        meowAnimeView = LOTAnimationView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        meowAnimeView.center = CGPoint(x:self.view.frame.width/2,y:self.view.frame.height/2)
        meowAnimeView.setAnimation(named: "meow")
        meowAnimeView.loopAnimation = false
        meowAnimeView.animationSpeed = 1
        meowAnimeView.backgroundColor = .clear
        meowAnimeView.contentMode = .scaleAspectFit
        self.meowAnimeView.isHidden = true
        self.view.addSubview(meowAnimeView)
        
        inputX.isHidden = true
        inputY.isHidden = true
        btn.isHidden = true
        
    }
    
    // ステータスバーを非表示にする
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}
