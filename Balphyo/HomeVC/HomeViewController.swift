//
//  HomeViewController.swift
//  Balphyo
//
//  Created by jin on 6/15/24.
//

import UIKit
import Then
import SnapKit

class HomeViewController: UIViewController {
    
    let instructionLabel = UILabel().then {
        $0.text = "발표가 쉬워진다\n발표몇분"
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont.Title()
        $0.numberOfLines = 0
    }
    let storeButton = StoreButton().then{
        $0.backgroundColor = .Gray1
        $0.addTarget(self, action: #selector(storeButtonTapped), for: .touchUpInside)
    }
    
    // 시간 맞춤형 발표대본 생성
    private lazy var generateScriptView: UIView = {
        return createSectionView(title: "시간 맞춤형 발표대본 생성",
                                 subtitle1: "내 마음에 꼭 드는 발표대본을 만들어보세요.",
                                 subtitle2: "주제, 소주제, 발표시간만 입력하면 완성이에요!")
    }()
    
    // 단어당 발표 시간 계산기
    private lazy var timeCalculatorView: UIView = {
        return createSectionView(title: "단어당 발표 시간 계산기",
                                 subtitle1: "지금 바로 대본의 소요시간을 확인하세요.",
                                 subtitle2: "목표한 시간을 초과하거나 부족하다면 알려드릴게요!")
    }()
    
    // 발표 훈련 플로우 컨트롤러
    private lazy var flowControllerView: UIView = {
        return createSectionView(title: "발표 훈련 플로우 컨트롤러",
                                 subtitle1: "시간 안에 발표를 마칠 수 있도록 도와드릴게요.",
                                 subtitle2: "노래방에 온 것처럼 대본 플로우를 따라 읽어보세요!")
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }

    private func setupViews() {
        view.addSubview(instructionLabel)
        view.addSubview(generateScriptView)
        view.addSubview(timeCalculatorView)
        view.addSubview(flowControllerView)
        view.addSubview(storeButton)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(66)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        
        storeButton.snp.makeConstraints{ make in
            make.top.equalTo(instructionLabel)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(50)
        }
        
        generateScriptView.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(59)
            make.leading.trailing.equalToSuperview().inset(16)
            make.width.equalTo(328)
            make.height.equalTo(121)
        }
        
        timeCalculatorView.snp.makeConstraints { make in
            make.top.equalTo(generateScriptView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.width.equalTo(328)
            make.height.equalTo(121)
        }
        
        flowControllerView.snp.makeConstraints { make in
            make.top.equalTo(timeCalculatorView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.width.equalTo(328)
            make.height.equalTo(121)
        }
    }
    
    // 섹션 뷰를 생성하고 제목과 부제목을 설정하는 메서드
    private func createSectionView(title: String, subtitle1: String, subtitle2: String) -> UIView {
        let sectionView = UIView().then {
            $0.layer.cornerRadius = 12
            $0.layer.borderColor = UIColor.primary.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = .clear
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sectionViewTapped(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
        
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = UIFont.Title().withSize(22)
            $0.textColor = .text
        }
        
        let subtitleLabel1 = UILabel().then {
            $0.text = subtitle1
            $0.font = UIFont.Medium().withSize(13)
            $0.textColor = .gray3
        }
        
        let subtitleLabel2 = UILabel().then {
            $0.text = subtitle2
            $0.font = UIFont.Medium().withSize(13)
            $0.textColor = .gray3
        }
        
        sectionView.addSubview(titleLabel)
        sectionView.addSubview(subtitleLabel1)
        sectionView.addSubview(subtitleLabel2)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.trailing.equalToSuperview().inset(18)
        }
        
        subtitleLabel1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(18)
        }
        
        subtitleLabel2.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel1.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(18)
        }
        
        return sectionView
    }
    
    @objc private func sectionViewTapped(_ sender: UITapGestureRecognizer) {
        guard let sectionView = sender.view else { return }
        
        if sectionView == generateScriptView {
            let nextVC = ScriptTitleViewController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
        if sectionView == timeCalculatorView {
            let nextVC = TimeTitleViewController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
        if sectionView == flowControllerView {
            let alert = UIAlertController(title: "발표 훈련 플로우 컨트롤러", message: "추후 업데이트 예정입니다!\n많은 기대 부탁드립니다 :)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
    }
    @objc private func storeButtonTapped(){
        let nextVC = StorageListViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
