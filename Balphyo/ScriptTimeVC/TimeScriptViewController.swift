//
//  TimeScriptViewController.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//


import UIKit
import Then

class TimeScriptViewController : UIViewController, UITextViewDelegate{

    let instructionLabel = UILabel().then {
        $0.text = "계산하려는 대본을 입력해주세요"
        $0.textColor = .Black
        $0.textAlignment = .left
        $0.font = UIFont.Title()
        $0.numberOfLines = 0
    }
    
    let placeholderLabel = UILabel().then {
        $0.text = "발표 대본을 입력해 주세요"
        $0.font = UIFont.Medium()
        $0.textColor = .Disabled
        $0.isHidden = false
    }
    let scriptTextView = UITextView().then{
        $0.font = UIFont.Medium()
        $0.textColor = .InputText
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .Gray1
        $0.isScrollEnabled = true
        $0.tintColor = .Primary
        $0.textAlignment = .justified
        $0.contentInset = UIEdgeInsets(top: 14, left: 14, bottom: 2, right: 14)
    }
    let loadButton = UIButton().then {
        $0.titleLabel?.font = UIFont.Large()
        $0.setTitle("보관함에서 불러오기", for: .normal)
        $0.setTitleColor(.Text, for: .normal)
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.Gray3.cgColor
        $0.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        scriptTextView.delegate = self // 델리게이트 설정
        scriptTextView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(scriptTextView).offset(6)
            make.leading.equalTo(scriptTextView).offset(6)
        }
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
    
    private func setupKeyboardDismissal() {
        // 키보드가 활성화된 상태에서 화면을 터치했을 때 키보드가 사라지도록 설정합니다.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
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
            $0.text = "2/4"
            $0.font = UIFont.Medium()
            $0.textColor = .Gray4
        }
        
        let progressButton = UIBarButtonItem(customView: progressLabel)
        self.navigationItem.rightBarButtonItem = progressButton
    }
    
    private func setupViews() {
        view.addSubview(instructionLabel)
        view.addSubview(scriptTextView)
        view.addSubview(loadButton)
        view.addSubview(nextButton)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(66)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        scriptTextView.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(21)
            make.bottom.equalTo(loadButton.snp.top).offset(-10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-46)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(46)
        }
        
        loadButton.snp.makeConstraints{ make in
            make.bottom.equalTo(nextButton.snp.top).offset(-37)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(46)
        }
    }
    
    //MARK: - Actions
    @objc func backButtonTapped() {
        // 뒤로 가기 로직을 구현
        navigationController?.popViewController(animated: true)
    }
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
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        if let text = textView.text, !text.isEmpty {
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
    @objc private func loadButtonTapped() {
        apiGetScriptList()
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.delegate = self
        self.present(bottomSheetVC, animated: true)
    }
    
    @objc func nextButtonTapped() {
        guard let scriptTitle = scriptTextView.text, !scriptTitle.isEmpty else {
            let alert = UIAlertController(title: "대본 입력", message: "대본을 입력해 주세요.", preferredStyle: .alert)
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
        
        ScriptTimeManager.shard.script = scriptTextView.text
        let nextVC = TimeTimeViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func apiGetScriptList() {
        NetworkService.shared.scriptCrudService.getScriptList() { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                BottomSheetManager.shard.scriptList = data.result
            default:
                print("리스트 가져오기 실패")
            }
        }
    }
    func apiGetScriptDetail(selectedCellIndex : Int){
        if let scriptId = BottomSheetManager.shard.scriptList?[selectedCellIndex].scriptId{
            let request = ScriptDetailDeleteRequest(
                scriptId: "\(scriptId)"
            )
            NetworkService.shared.scriptCrudService.getScriptDetail(bodyDTO: request) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let data):
                    print("조회 성공")
                    BottomSheetManager.shard.script = data.result.script
                default:
                    print("조회 실패")
                }
            }
        }
    }
}
//MARK: -- 음성 delegate
extension TimeScriptViewController: BottomSheetViewControllerDelegate {
    func scriptSelectedRowAt(indexPath: Int) {
        apiGetScriptDetail(selectedCellIndex: indexPath)
        print("scriptSelectedRowAt")
        scriptTextView.text = BottomSheetManager.shard.script
        textViewDidChange(scriptTextView)
    }
}
