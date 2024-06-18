//
//  ScriptResultViewController.swift
//  Balphyo
//
//  Created by jin on 6/15/24.
//

import UIKit
import Then

class ScriptResultViewController : UIViewController {
    
    var data : GenerateScriptResponse?
    let instructionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    let scriptTextView = UITextView().then{
        $0.isEditable = false
        $0.text = "연 1회 할인이라는 표현은 금융과 투자 분야에 사용되는 용어로, 일반적으로 이자율이나 할인율 1년에 한 번 적용된다는 의미입니다. 다시 말해 연간으로 계산되는 이자율이나 할인율을 사용해 미래 가치를 현재 가치로 환산할 때, 그 계산이 연단위로 1회만 이루어진다는 것을 나타냅니다. 예를 들어, 미래 가치를 현재 가치로 환산할 때, 연 1회 할인을 적용한다는 것은, 1년 동안의 연 1회 할인이라는 표현은 금융과 투자 분야에 사용되는 용어로, 일반적으로 이자율이나 할인율 1년에 한 번 적용된다는 의미입니다. 다시 말해 연간으로 계산되는 이자율이나 할인율 을 사용해미래 가치를 현재 가치로 환산할 때, 그 계산이 연단위로 1회만 이루어진다는 것을 나타냅니다. 예를 들어, 미래 가치를 현재 가치로 환산할 때,"
        $0.font = UIFont.Large()
        $0.textColor = .InputText
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .Gray1
        $0.isScrollEnabled = true
        $0.tintColor = .Primary
        $0.textAlignment = .justified
        $0.contentInset = UIEdgeInsets(top: 14, left: 14, bottom: 2, right: 14)
    }
    let editButton = UIButton().then {
        $0.titleLabel?.font = UIFont.Large()
        $0.setTitle("대본 수정하기", for: .normal)
        $0.setTitleColor(.Gray3, for: .normal)
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.Gray3.cgColor
        $0.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    let storeButton = UIButton().then {
        $0.setTitle("보관함에 저장하기", for: .normal)
        $0.setTitleColor(.White, for: .normal)
        $0.titleLabel?.font = UIFont.Large()
        $0.backgroundColor = .Primary
        $0.layer.cornerRadius = 10
        $0.isEnabled = true
        $0.addTarget(self, action: #selector(storeButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupNavigationBar()
        setupViews()
        setupKeyboardDismissal()
        if let resultText = data?.result.resultScript[0].message.content {
            scriptTextView.text = resultText
            GenerateScriptManager.shard.script = resultText
        }
        if let result = data {
            GenerateScriptManager.shard.gptId = result.result.gptId
        }
        
        // 텍스트와 색상 설정
        setupInstructionLabel()
    }
    private func setupInstructionLabel() {
        // 설정된 텍스트
        let secTime = GenerateScriptManager.shard.secTime
        let minutes = secTime / 60
        let seconds = secTime % 60
        let title = GenerateScriptManager.shard.title
        let fullText = "\(minutes)분 \(seconds)초에 맞는\n\(title) 대본이\n완성되었어요!"
        
        // NSMutableAttributedString 생성
        let attributedText = NSMutableAttributedString(string: fullText)
        
        // 전체 텍스트 스타일 설정
        attributedText.addAttribute(.font, value: UIFont.Title(), range: NSRange(location: 0, length: attributedText.length))
        attributedText.addAttribute(.foregroundColor, value: UIColor.Black, range: NSRange(location: 0, length: attributedText.length))
        
        // title 부분만 색상을 변경
        if let titleRange = fullText.range(of: title) {
            let nsRange = NSRange(titleRange, in: fullText)
            attributedText.addAttribute(.foregroundColor, value: UIColor.Primary, range: nsRange)
        }
        
        // instructionLabel에 적용
        instructionLabel.attributedText = attributedText
    }
    private func setupNavigationBar() {
        self.title = "대본 생성"
        
        // 네비게이션 바 타이틀 폰트 설정
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.Large(), NSAttributedString.Key.foregroundColor: UIColor.Gray4]
        
        // 네비게이션 바 백 버튼 이미지 설정
        let closeButtonImage = UIImage(named: "CloseButton")
        let closeButton = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action: #selector(closeButtonTapped))
        closeButton.tintColor = .Black
        self.navigationItem.rightBarButtonItem = closeButton
        self.navigationItem.hidesBackButton = true
    }
    private func setupKeyboardDismissal() {
        // 키보드가 활성화된 상태에서 화면을 터치했을 때 키보드가 사라지도록 설정합니다.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupViews() {
        view.addSubview(instructionLabel)
        view.addSubview(scriptTextView)
        view.addSubview(editButton)
        view.addSubview(storeButton)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(66)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        
        scriptTextView.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(21)
            make.bottom.equalTo(editButton.snp.top).offset(-19)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        
        storeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-46)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(46)
        }
        
        editButton.snp.makeConstraints{ make in
            make.bottom.equalTo(storeButton.snp.top).offset(-4)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(46)
        }
    }
    
    //MARK: - Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    deinit {
        // 이 ViewController가 해제될 때 Notification 관련 등록을 해제합니다.
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Keyboard Handling Methods
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        // 키보드의 높이를 구합니다.
        let keyboardHeight = keyboardFrame.height
        
        // 키보드가 텍스트뷰를 가릴 만큼 뷰를 위로 이동시킵니다.
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -keyboardHeight // 예시로 뷰를 키보드 높이만큼 위로 이동시킵니다.
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        // 키보드가 사라지면 원래 위치로 뷰를 되돌립니다.
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func editButtonTapped() {
        if scriptTextView.isEditable {
            scriptTextView.isEditable = false
            editButton.setTitle("대본 수정하기", for: .normal)
            editButton.setTitleColor(.Gray3, for: .normal)
            editButton.backgroundColor = .clear
            editButton.layer.borderWidth = 1
            editButton.layer.borderColor = UIColor.Gray3.cgColor
            GenerateScriptManager.shard.script = scriptTextView.text
        }
        else {
            scriptTextView.isEditable = true
            editButton.setTitle("대본 수정 완료", for: .normal)
            editButton.backgroundColor = .Gray2
            editButton.setTitleColor(.Gray4, for: .normal)
            editButton.layer.borderWidth = 0
        }
    }
    @objc func closeButtonTapped() {
        if let navController = navigationController {
            for controller in navController.viewControllers {
                if let HomeVC = controller as? HomeViewController {
                    navController.popToViewController(HomeVC, animated: true)
                    return
                }
            }
        }
    }
    @objc func storeButtonTapped() {
        apiStoreScript()
        storeButton.isEnabled = false
        storeButton.backgroundColor = .Gray2
        storeButton.setTitle("저장 완료", for: .normal)
        storeButton.setTitleColor(.Gray4, for: .normal)
        let alert = UIAlertController(title: "저장 완료!", message: "보관함에서 대본을 확인 해 보세요!", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { action in
            if let navController = self.navigationController {
                for controller in navController.viewControllers {
                    if let HomeVC = controller as? HomeViewController {
                        navController.popToViewController(HomeVC, animated: true)
                        return
                    }
                }
            }
        }
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
        return
    }
    func apiStoreScript(){
        let request = StoreScriptRequest(
            script: GenerateScriptManager.shard.script,
            gptId: GenerateScriptManager.shard.gptId,
            title: GenerateScriptManager.shard.title,
            secTime: GenerateScriptManager.shard.secTime
        )
        NetworkService.shared.scriptCrudService.storeScript(bodyDTO: request) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                print("저장 성공")
            default:
                print("저장 실패")
            }
        }
    }
}
