//
//  TimeSpeedViewController.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

import Foundation
import Then
import UIKit
import AVFoundation

class TimeSpeedViewController : UIViewController {
    
    let instructionLabel = UILabel().then {
        $0.text = "말의 빠르기를 알려주세요"
        $0.textColor = .Black
        $0.textAlignment = .left
        $0.font = UIFont.Title()
        $0.numberOfLines = 0
    }
    let subLabel = UILabel().then {
        $0.text = "소리가 나오고 있어요! 볼륨을 조절해주세요"
        $0.textColor = .Disabled
        $0.textAlignment = .left
        $0.font = UIFont.Medium()
        $0.numberOfLines = 0
    }
    
    let soundImageView = UIImageView().then {
        $0.frame = CGRect(x: 50, y: 40, width: 100, height: 80)
        $0.contentMode = .left
    }
    
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.White, for: .normal)
        $0.titleLabel?.font = UIFont.Large()
        $0.backgroundColor = .Primary
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    var audioPlayer: AVAudioPlayer?
    var speedButtons: [UIButton] = []
    let speeds: [Float] = [0.3, 0.5, 1, 1.5, 2]
    let audioFiles: [Float: String] = [
            0.3: "minustwo.mp3",
            0.5: "minusone.mp3",
            1: "zero.mp3",
            1.5: "one.mp3",
            2: "two.mp3"
        ]
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalCentering
        $0.spacing = 7
    }
    override func viewWillDisappear(_ animated: Bool) {
        stopAudio()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupSpeedButtons()
        setupViews()
        setupAnimation()
    }
    
    private func setupNavigationBar() {
        self.title = "시간 계산"
        
        // 네비게이션 바 타이틀 폰트 설정
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.Large(), NSAttributedString.Key.foregroundColor: UIColor.Gray4]
        
        // 네비게이션 바 백 버튼 이미지 설정
        let backButtonImage = UIImage(named: "BackArrow")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .Black
        self.navigationItem.leftBarButtonItem = backButton
        
        // 네비게이션 바 우측 텍스트 설정
        let progressLabel = UILabel().then{
            $0.text = "4/4"
            $0.font = UIFont.Medium()
            $0.textColor = .Gray4
        }
        
        let progressButton = UIBarButtonItem(customView: progressLabel)
        self.navigationItem.rightBarButtonItem = progressButton
    }
    
    private func setupViews() {
        view.addSubview(instructionLabel)
        view.addSubview(subLabel)
        view.addSubview(nextButton)
        view.addSubview(soundImageView)
        view.addSubview(stackView)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(66)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        
        subLabel.snp.makeConstraints{ make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        
        soundImageView.snp.makeConstraints{ make in
            make.top.equalTo(subLabel.snp.bottom).offset(125)
            make.centerX.equalToSuperview()
        }
        for button in speedButtons {
            stackView.addArrangedSubview(button)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(soundImageView.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-46)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(46)
        }
        
    }
    func setupSpeedButtons() {
        for (index, speed) in speeds.enumerated() {
            let button = UIButton().then {
                $0.setTitle("X \(speed)", for: .normal)
                $0.setTitleColor(.Disabled, for: .normal)
                $0.titleLabel?.font = UIFont.Medium()
                $0.backgroundColor = .clear
                $0.layer.cornerRadius = 16.5
                $0.layer.borderColor = UIColor.Disabled.cgColor
                $0.layer.borderWidth = 1
                $0.tag = index
                $0.addTarget(self, action: #selector(speedButtonTapped(_:)), for: .touchUpInside)
            }
            button.snp.makeConstraints{ make in
                make.width.equalTo(60)
            }
            speedButtons.append(button)
        }
    }
    @objc func speedButtonTapped(_ sender: UIButton) {
        // 모든 버튼을 기본 상태로 되돌림
        for button in speedButtons {
            button.setTitleColor(.Disabled, for: .normal)
            button.layer.borderColor = UIColor.Disabled.cgColor
        }

        // 클릭된 버튼을 강조
        sender.setTitleColor(.Primary, for: .normal)
        sender.layer.borderColor = UIColor.Primary.cgColor
        
        // 해당 속도에 맞는 오디오 파일 재생
        let speed = speeds[sender.tag]
        if let fileName = audioFiles[speed] {
            playAudio(fileName: fileName)
        }
        
        ScriptTimeManager.shard.speed = Int(speed - 1)
        
    }

    func playAudio(fileName: String) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            print("Audio file \(fileName) not found.")
            return
        }
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing audio file: \(error.localizedDescription)")
        }
    }
    func stopAudio() {
        if let player = audioPlayer, player.isPlaying {
            player.stop()
        }
    }
    func setupAnimation() {
        // 이미지 배열 생성
        let imageNames = ["Sound1", "Sound2", "Sound3", "Sound2", "Sound3"] // 이미지 파일 이름
        var images: [UIImage] = []
        for name in imageNames {
            if let image = UIImage(named: name) {
                images.append(image)
            }
        }
        
        // 애니메이션 설정
        soundImageView.animationImages = images
        soundImageView.animationDuration = 2.0 // 애니메이션 반복에 걸리는 시간(초)
        soundImageView.animationRepeatCount = 0 // 0은 무한 반복
        
        // 애니메이션 시작
        soundImageView.startAnimating()
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func nextButtonTapped() {
        apiGenerateAudio()
        /*if scriptTitle.count >= 8 {
         let alert = UIAlertController(title: "대본 제목 길이 초과", message: "대본 제목은 8자 이하여야 합니다.", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
         present(alert, animated: true, completion: nil)
         return
         }*/
        
    }
    func apiGenerateAudio(){
        let request = GenerateAudioRequest(
            text: ScriptTimeManager.shard.script,
            speed: ScriptTimeManager.shard.speed,
            balpyoAPIKey: "1234"
        )
        let nextVC = ScriptLoadingViewController()
        navigationController?.pushViewController(nextVC, animated: true)
        NetworkService.shared.generateAudioService.generateAudio(bodyDTO: request) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                let nextVC = TimeResultViewController()
                nextVC.data = data
                navigationController?.pushViewController(nextVC, animated: true)
            default:
                print("오디오 생성 실패")
            }
        }
    }
}
