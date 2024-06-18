//
//  ScriptEditViewController.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

import Foundation
import UIKit
import Then

class ScriptEditViewController : UIViewController {
    
    var data : ScriptDetailResult?

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
        $0.setTitleColor(.White, for: .normal)
        $0.titleLabel?.font = UIFont.Large()
        $0.backgroundColor = .Primary
        $0.layer.cornerRadius = 10
        $0.isEnabled = true
        $0.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    let deleteButton = UIButton().then {
        $0.setTitle("삭제하기", for: .normal)
        $0.setTitleColor(.Gray3, for: .normal)
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.Gray3.cgColor
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
        scriptTextView.text = data!.script
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    private func setupNavigationBar() {
        self.title = data!.title
        
        // 네비게이션 바 타이틀 폰트 설정
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.Large(), NSAttributedString.Key.foregroundColor: UIColor.Gray4]
        
        // 네비게이션 바 백 버튼 이미지 설정
        let backButtonImage = UIImage(named: "BackArrow")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
    private func setupKeyboardDismissal() {
        // 키보드가 활성화된 상태에서 화면을 터치했을 때 키보드가 사라지도록 설정합니다.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupViews() {
        view.addSubview(scriptTextView)
        view.addSubview(editButton)
        view.addSubview(deleteButton)
        
        scriptTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
            make.bottom.equalTo(editButton.snp.top).offset(-19)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-46)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(46)
        }
        
        editButton.snp.makeConstraints{ make in
            make.bottom.equalTo(deleteButton.snp.top).offset(-4)
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
    //MARK: - Actions
    @objc func backButtonTapped() {
        if let navController = self.navigationController {
            for controller in navController.viewControllers {
                if let scriptListVC = controller as? StorageListViewController {
                    scriptListVC.apiGetScriptList()
                    navController.popToViewController(scriptListVC, animated: true)
                    return
                }
            }
        }
    }
    @objc private func editButtonTapped() {
        if scriptTextView.isEditable {
            apiEditScript()
            scriptTextView.isEditable = false
            editButton.setTitle("대본 수정하기", for: .normal)
            editButton.setTitleColor(.White, for: .normal)
            editButton.backgroundColor = .Primary
        }
        else {
            scriptTextView.isEditable = true
            editButton.setTitle("대본 저장하기", for: .normal)
            editButton.backgroundColor = .Gray4
            editButton.setTitleColor(.White, for: .normal)
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
        let alert = UIAlertController(title: "대본 삭제", message: "보관함에서 대본을 삭제하시겠습니까?", preferredStyle: .alert)
        
        // 확인 버튼 추가
        let confirmAction = UIAlertAction(title: "확인", style: .default) { action in
            self.apiDeleteScript()
        }
        
        // 취소 버튼 추가
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        return
    }
    func apiEditScript(){
        let request = ScriptEditRequest(
            scriptId: data!.scriptId,
            script: scriptTextView.text,
            title: data!.title,
            secTime: data!.secTime
        )
        NetworkService.shared.scriptCrudService.editScript(bodyDTO: request) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                print("수정 성공")
            default:
                print("수정 실패")
            }
        }
    }
    func apiDeleteScript(){
        let request = ScriptDetailDeleteRequest(
            scriptId: "\(data!.scriptId)"
        )
        NetworkService.shared.scriptCrudService.deleteScript(bodyDTO: request) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                print("삭제 성공")
                if let navController = self.navigationController {
                    for controller in navController.viewControllers {
                        if let scriptListVC = controller as? StorageListViewController {
                            scriptListVC.apiGetScriptList()
                            navController.popToViewController(scriptListVC, animated: true)
                            return
                        }
                    }
                }
            default:
                print("삭제 실패")
            }
        }
    }
}
