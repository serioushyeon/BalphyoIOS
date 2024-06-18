//
//  ScriptSubTopicViewController.swift
//  Balphyo
//
//  Created by jin on 6/12/24.
//

import UIKit
import Then
import SnapKit

class ScriptSubTopicViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SubTopicCollectionViewCellDelegate{
    
    let instructionLabel = UILabel().then {
        $0.text = "발표의 소주제를 알려주세요"
        $0.textColor = .Black
        $0.textAlignment = .left
        $0.font = UIFont.Title()
        $0.numberOfLines = 0
    }
    
    
    let scriptTopicTextField = CustomTextField().then{
        $0.customTextField.then{
            $0.attributedPlaceholder = NSAttributedString(
                string: "소주제",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.Disabled]
            )
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    let registerButton = UIButton().then {
        $0.setTitle("등록", for: .normal)
        $0.setTitleColor(.PrimaryDisabled, for: .normal)
        $0.titleLabel?.font = UIFont.Large()
        $0.backgroundColor = .clear
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
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
    private lazy var subTopicCollectionView : UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then{
            $0.isScrollEnabled = false
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.dataSource = self
            $0.delegate = self
            $0.register(SubTopicCollectionViewCell.self, forCellWithReuseIdentifier: SubTopicCollectionViewCell.subTopicIdentifier)
        }
        
        return collectionView
    }()
    
    var subTopics: [SubTopicModel] = []
    let maxSubTopics = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        subTopicCollectionView.dataSource = self
        subTopicCollectionView.delegate = self
        subTopicCollectionView.register(SubTopicCollectionViewCell.self, forCellWithReuseIdentifier: SubTopicCollectionViewCell.subTopicIdentifier)
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
        self.title = "대본 생성"
        
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
    private func setupKeyboardDismissal() {
        // 키보드가 활성화된 상태에서 화면을 터치했을 때 키보드가 사라지도록 설정합니다.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupViews() {
        view.addSubview(instructionLabel)
        view.addSubview(scriptTopicTextField)
        view.addSubview(registerButton)
        view.addSubview(subTopicCollectionView)
        view.addSubview(nextButton)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(66)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        
        scriptTopicTextField.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(72)
            make.leading.trailing.equalToSuperview().inset(22)
            make.height.equalTo(30)
        }
        
        registerButton.snp.makeConstraints { make in
            make.centerY.equalTo(scriptTopicTextField.snp.centerY)
            make.trailing.equalTo(scriptTopicTextField)
        }
        
        subTopicCollectionView.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(70)
            make.leading.trailing.equalToSuperview().inset(22)
            make.bottom.equalTo(nextButton.snp.top).offset(-20)
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
            registerButton.isEnabled = true
            registerButton.setTitleColor(.Primary, for: .normal)
        } else {
            registerButton.isEnabled = false
            registerButton.setTitleColor(.PrimaryDisabled, for: .normal)
        }
        if subTopics.count >= maxSubTopics {
            registerButton.isEnabled = false
            registerButton.setTitleColor(.PrimaryDisabled, for: .normal)
        }
    }
    @objc func backButtonTapped() {
        // 뒤로 가기 로직을 구현
        navigationController?.popViewController(animated: true)
    }
    @objc func registerButtonTapped() {
        // 뒤로 가기 로직을 구현
        guard let topic = scriptTopicTextField.customTextField.text, !topic.isEmpty else {
            return
        }
        if subTopics.count >= maxSubTopics {
            registerButton.isEnabled = false
            registerButton.setTitleColor(.PrimaryDisabled, for: .normal)
            let alert = UIAlertController(title: "Error", message: "You can add up to 5 topics only.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        subTopics.append(SubTopicModel(label: topic))
        subTopicCollectionView.reloadData()
        subTopicCollectionView.layoutIfNeeded()
        
        if subTopics.count == 0 {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .PrimaryDisabled
            accessoryButton.isEnabled = false
            accessoryButton.backgroundColor = .PrimaryDisabled
        }
        else{
            nextButton.isEnabled = true
            nextButton.backgroundColor = .Primary
            accessoryButton.isEnabled = true
            accessoryButton.backgroundColor = .Primary
        }
        
        scriptTopicTextField.customTextField.text = ""
        textFieldDidChange(scriptTopicTextField.customTextField)
    }
    
    @objc func nextButtonTapped() {
        guard !subTopics.isEmpty else {
            let alert = UIAlertController(title: "소주제 입력", message: "소주제를 하나 이상 추가해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        // 소주제들을 콤마와 스페이스로 연결하여 하나의 문자열로 만듭니다.
        let combinedSubTopics = subTopics.map { $0.label }.joined(separator: ", ")
        
        GenerateScriptManager.shard.keywords = combinedSubTopics
        /*if scriptTitle.count >= 8 {
         let alert = UIAlertController(title: "대본 제목 길이 초과", message: "대본 제목은 8자 이하여야 합니다.", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
         present(alert, animated: true, completion: nil)
         return
         }*/
        
        //SignDataManager.shared.nickName = nickname
        let nextVC = ScriptTimeViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subTopics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubTopicCollectionViewCell.subTopicIdentifier, for: indexPath) as! SubTopicCollectionViewCell
        
        let subTopic = subTopics[indexPath.item]
        cell.configure(with: subTopic)
        cell.delegate = self
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let topic = subTopics[indexPath.item]
        let tagLabel = UILabel()
        tagLabel.text = topic.label
        tagLabel.sizeToFit()

        return CGSize(width: tagLabel.frame.width + 42, height: 39) // 20은 여유 공간을 주기 위한 값입니다
    }
    func didTapDeleteButton(on cell: SubTopicCollectionViewCell) {
        if let indexPath = subTopicCollectionView.indexPath(for: cell) {
            subTopics.remove(at: indexPath.item)
            subTopicCollectionView.deleteItems(at: [indexPath])
        }
    }
}
