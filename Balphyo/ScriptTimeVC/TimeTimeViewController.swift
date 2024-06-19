//
//  TimeTimeViewController.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

import Foundation
import Then
import UIKit

class TimeTimeViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let instructionLabel = UILabel().then {
        $0.text = "목표 발표 시간을 알려주세요"
        $0.textColor = .Black
        $0.textAlignment = .left
        $0.font = UIFont.Title()
        $0.numberOfLines = 0
    }
    
    let noTimeView = UIView().then{
        $0.layer.cornerRadius = 6
        $0.layer.borderColor = UIColor.Gray2.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .clear
    }
    let noTimeLabel = UILabel().then {
        $0.text = "정해진 발표 시간이 없어요"
        $0.font = UIFont.Medium()
        $0.textColor = .InputText
    }
    
    let noTimeImage = UIImageView(image: UIImage(named: "Unchecked"))
    
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.White, for: .normal)
        $0.titleLabel?.font = UIFont.Large()
        $0.backgroundColor = .Primary
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    let pickerView = UIPickerView()
    
    var minutes: [Int] = []
    var seconds: [Int] = []
    
    var isNoTime = false
    let tapGuesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tapGuesture.addTarget(self, action: #selector(noTimeButtonTapped(_:)))
        pickerView.delegate = self
        pickerView.dataSource = self
        minutes = Array(0...3)
        seconds = Array(0...59)
        noTimeView.addGestureRecognizer(tapGuesture)
        setupNavigationBar()
        setupViews()
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
            $0.text = "3/4"
            $0.font = UIFont.Medium()
            $0.textColor = .Gray4
        }
        
        let progressButton = UIBarButtonItem(customView: progressLabel)
        self.navigationItem.rightBarButtonItem = progressButton
    }
    
    private func setupViews() {
        view.addSubview(instructionLabel)
        view.addSubview(pickerView)
        view.addSubview(nextButton)
        view.addSubview(noTimeView)
        noTimeView.addSubview(noTimeLabel)
        noTimeView.addSubview(noTimeImage)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(66)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(76)
            make.centerX.equalToSuperview()
            make.width.equalTo(220)
            make.height.equalTo(150)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-46)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(46)
        }
        
        noTimeView.snp.makeConstraints{ make in
            make.top.equalTo(pickerView.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
            make.height.equalTo(39)
            make.width.equalTo(207)
            
        }
        noTimeImage.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
        }
        
        noTimeLabel.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalTo(noTimeImage.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-10.5)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    func checkNoTimeButton(){
        if isNoTime {
            self.noTimeView.layer.borderColor = UIColor.Primary.cgColor
            noTimeImage.image = UIImage(named: "Checked")
        }
        else {
            self.noTimeView.layer.borderColor = UIColor.Gray2.cgColor
            noTimeImage.image = UIImage(named: "Unchecked")
        }
    }
    //MARK: - Actions
    @objc private func noTimeButtonTapped(_ sender: UITapGestureRecognizer) {
        if isNoTime {
            isNoTime = false
            checkNoTimeButton()
        }
        else {
            isNoTime = true
            checkNoTimeButton()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func accessoryButtonTapped() {
        // 버튼이 눌렸을 때의 동작
        dismissKeyboard()
        nextButtonTapped()
    }
    
    @objc func backButtonTapped() {
        // 뒤로 가기 로직을 구현
        navigationController?.popViewController(animated: true)
    }
    @objc func nextButtonTapped() {
        if isNoTime {
            ScriptTimeManager.shard.secTime = 180
        }
        let nextVC = TimeSpeedViewController()
        navigationController?.pushViewController(nextVC, animated: true)
        /*if scriptTitle.count >= 8 {
         let alert = UIAlertController(title: "대본 제목 길이 초과", message: "대본 제목은 8자 이하여야 합니다.", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
         present(alert, animated: true, completion: nil)
         return
         }*/
        
    }
    
    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2 // 분과 초 두 개의 구성 요소를 가집니다.
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if component == 0 {
                return minutes.count // 첫 번째 구성 요소는 분
            } else {
                if pickerView.selectedRow(inComponent: 0) == 3 {
                    return 1 // 분이 3일 때는 초는 0만 표시
                } else {
                    return seconds.count // 그 외에는 전체 초 표시
                }
            }
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if component == 0 {
                return "\(minutes[row])분"
            } else {
                if pickerView.selectedRow(inComponent: 0) == 3 {
                    return "0초" // 분이 3일 때는 초는 0만 표시
                } else {
                    return "\(seconds[row])초"
                }
            }
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            // 선택된 분과 초를 가져옵니다.
            let selectedMinute = minutes[pickerView.selectedRow(inComponent: 0)]
            let selectedSecond = seconds[pickerView.selectedRow(inComponent: 1)]
            
            ScriptTimeManager.shard.secTime =  selectedMinute * 60 + selectedSecond
            // 초 부분의 데이터를 업데이트
            pickerView.reloadComponent(1)
        }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 40 // 첫 번째 컴포넌트(분)의 행 높이
        } else {
            return 40 // 두 번째 컴포넌트(초)의 행 높이
        }
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 110
        } else {
            return 110
        }
    }
}
