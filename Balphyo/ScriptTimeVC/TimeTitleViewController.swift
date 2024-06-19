//
//  TimeTitleViewController.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

import Foundation
import UIKit
import Then
import SnapKit

class TimeTitleViewController: UIViewController {
    
    let instructionLabel = UILabel().then {
        $0.text = "대본의 제목을 입력해주세요"
        $0.textColor = .Black
        $0.textAlignment = .left
        $0.font = UIFont.Title()
        $0.numberOfLines = 0
    }
    
    
    let scriptTitleTF = CustomTextField().then{
        $0.customTextField.then{
            $0.attributedPlaceholder = NSAttributedString(
                string: "대본 제목",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.Disabled]
            )
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.White, for: .normal)
        $0.titleLabel?.font = UIFont.Large()
        $0.backgroundColor = .PrimaryDisabled
        $0.layer.cornerRadius = 10
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    //키보드 위 버튼
    let keyboardAccessoryView = UIView().then{
        $0.backgroundColor = .clear
    }
    let accessoryButton = UIButton().then{
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.White, for: .normal)
        $0.titleLabel?.font = UIFont.Large()
        $0.backgroundColor = .PrimaryDisabled
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(accessoryButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupViews()
        setupKeyboardDismissal()
        setupKeyboardListeners()
        setupKeyboardAccessoryView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupKeyboardListeners() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupKeyboardAccessoryView() {
        keyboardAccessoryView.addSubview(accessoryButton)
        accessoryButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(46)
        }
        
        // 숨긴 상태에서 시작
        keyboardAccessoryView.isHidden = true
        view.addSubview(keyboardAccessoryView)
        keyboardAccessoryView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(46)
        }
    }
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
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
            $0.text = "1/4"
            $0.font = UIFont.Medium()
            $0.textColor = .Gray4
        }
        
        let progressButton = UIBarButtonItem(customView: progressLabel)
        self.navigationItem.rightBarButtonItem = progressButton
    }
    private func setupKeyboardDismissal() {
        // 키보드가 활성화된 상태에서 화면을 터치했을 때 키보드가 사라지도록 설정합니다.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupViews() {
        view.addSubview(instructionLabel)
        view.addSubview(scriptTitleTF)
        view.addSubview(nextButton)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(66)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        
        scriptTitleTF.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(22)
            make.height.equalTo(30)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-46)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(46)
        }
    }
    
    //MARK: - Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        // 키보드 위에 버튼을 표시
        keyboardAccessoryView.isHidden = false
        keyboardAccessoryView.snp.updateConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-keyboardFrame.height)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        // 키보드가 내려갈 때 버튼 숨기기
        keyboardAccessoryView.isHidden = true
    }
    
    @objc private func accessoryButtonTapped() {
        // 버튼이 눌렸을 때의 동작
        dismissKeyboard()
        nextButtonTapped()
    }
    
    // 텍스트 필드의 텍스트가 변경될 때 호출되는 메서드
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .Primary
            accessoryButton.isEnabled = true
            accessoryButton.backgroundColor = .Primary
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .PrimaryDisabled
            accessoryButton.isEnabled = false
            accessoryButton.backgroundColor = .PrimaryDisabled
        }
    }
    @objc func backButtonTapped() {
        // 뒤로 가기 로직을 구현
        navigationController?.popViewController(animated: true)
    }
    @objc func nextButtonTapped() {
        guard let scriptTitle = scriptTitleTF.customTextField.text, !scriptTitle.isEmpty else {
            let alert = UIAlertController(title: "대본 제목 입력", message: "대본 제목을 입력해 주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        /*if scriptTitle.count >= 8 {
         let alert = UIAlertController(title: "대본 제목 길이 초과", message: "대본 제목은 8자 이하여야 합니다.", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
         present(alert, animated: true, completion: nil)
         return
         }*/
        
        ScriptTimeManager.shard.title = scriptTitle
        let nextVC = TimeScriptViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
