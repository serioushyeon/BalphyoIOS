//
//  TimeResultViewController.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

import UIKit
import Then
import AVFoundation

class TimeResultViewController : UIViewController {
    
    var data : GenerateAudioResponse?

    let instructionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    let subLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    let scriptTextView = UITextView().then{
        $0.isEditable = false
        $0.text = ""
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
        $0.setTitle("대본 수정하고 다시 계산하기", for: .normal)
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
        // 텍스트와 색상 설정
        setupSubLabel()
        scriptTextView.text = ScriptTimeManager.shard.script
        let breakTimeToRealWord = breakTimeToRealWord(speechMarks: data!.speechMarks)
        let endByteToRealEndByte = endByteToRealEndByte(speechMarks: breakTimeToRealWord)
        let generateRealSpeechMark = generateRealSpeechMark(from: scriptTextView.text, speechMarks: endByteToRealEndByte)
        let findIndex = findIndex(speechMark: generateRealSpeechMark, time: Int(ScriptTimeManager.shard.secTime) * 1000)
        scriptTextView.attributedText = colorizeSubstring(originalText: scriptTextView.text, fromIndex: findIndex, color: .Primary)
    }
    func getAudioDurationFromRemoteURL(_ url: URL, completion: @escaping (TimeInterval?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { (localURL, response, error) in
            guard let localURL = localURL, error == nil else {
                print("Error downloading file: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: localURL)
                completion(audioPlayer.duration)
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }

    private func setupInstructionLabel(time: Int) {
        // 설정된 텍스트
        let secTime = time
        let minutes = secTime / 60
        let seconds = secTime % 60
        let highlightText = "\(minutes)분 \(seconds)초"
        let fullText = "발표 시간은 \(highlightText)에요!"
        
        // NSMutableAttributedString 생성
        let attributedText = NSMutableAttributedString(string: fullText)
        
        // 전체 텍스트 스타일 설정
        attributedText.addAttribute(.font, value: UIFont.Title(), range: NSRange(location: 0, length: attributedText.length))
        attributedText.addAttribute(.foregroundColor, value: UIColor.Black, range: NSRange(location: 0, length: attributedText.length))
        
        // title 부분만 색상을 변경
        if let highlightTextRange = fullText.range(of: highlightText) {
            let nsRange = NSRange(highlightTextRange, in: fullText)
            attributedText.addAttribute(.foregroundColor, value: UIColor.Primary, range: nsRange)
        }
        
        // instructionLabel에 적용
        instructionLabel.attributedText = attributedText
    }
    private func setupSubLabel() {
        // 원격 오디오 파일 URL
        print("오디오 불러오기")
        if let audioURL = URL(string: "\(data!.profileUrl)") {
            print("오디오 url 불러오기 성공")
            getAudioDurationFromRemoteURL(audioURL) { duration in
                if let duration = duration {
                    print("오디오 불러오기 성공")
                    let secTime = ScriptTimeManager.shard.secTime
                    var highlightText = ""
                    var fullText = ""
                    if secTime == Int(duration) {
                        highlightText = "목표 발표 시간을\n맞췄어요!"
                        fullText = "목표 발표 시간을\n맞췄어요!"
                    }
                    else if secTime < Int(duration) {//목표 시간보다 초과할때
                        let time = Int(duration) - secTime
                        let minutes = time / 60
                        let sec = time % 60
                        highlightText = "\(minutes)분 \(sec)초 초과"
                        fullText = "목표 발표 시간보다\n\(highlightText)해요"
                    }
                    else{
                        let time = secTime - Int(duration)
                        let minutes = time / 60
                        let sec = time % 60
                        highlightText = "\(minutes)분 \(sec)초 부족"
                        fullText = "목표 발표 시간보다\n\(highlightText)해요"
                    }
                    // NSMutableAttributedString 생성
                    let attributedText = NSMutableAttributedString(string: fullText)
                    
                    // 전체 텍스트 스타일 설정
                    attributedText.addAttribute(.font, value: UIFont.Title(), range: NSRange(location: 0, length: attributedText.length))
                    attributedText.addAttribute(.foregroundColor, value: UIColor.Black, range: NSRange(location: 0, length: attributedText.length))
                    
                    // title 부분만 색상을 변경
                    if let highlightTextRange = fullText.range(of: highlightText) {
                        let nsRange = NSRange(highlightTextRange, in: fullText)
                        attributedText.addAttribute(.foregroundColor, value: UIColor.Primary, range: nsRange)
                    }
                    
                    // instructionLabel에 적용
                    DispatchQueue.main.async {
                        self.subLabel.attributedText = attributedText
                        self.setupInstructionLabel(time: Int(duration))
                    }
                } else {
                    print("오디오 재생 시간을 가져오는 데 실패했습니다.")
                }
            }
        }
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
        view.addSubview(subLabel)
        view.addSubview(scriptTextView)
        view.addSubview(editButton)
        view.addSubview(storeButton)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(37)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        subLabel.snp.makeConstraints{ make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(22)
        }
        scriptTextView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(32)
            make.bottom.equalTo(editButton.snp.top).offset(-10)
            make.leading.trailing.equalToSuperview().inset(16)
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
        ScriptTimeManager.shard.script = scriptTextView.text
        if let navController = navigationController {
            for controller in navController.viewControllers {
                if let scriptVC = controller as? TimeScriptViewController {
                    scriptVC.scriptTextView.text = ScriptTimeManager.shard.script
                    navController.popToViewController(scriptVC, animated: true)
                    return
                }
            }
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
            script: ScriptTimeManager.shard.script,
            gptId: ScriptTimeManager.shard.gptId,
            title: ScriptTimeManager.shard.title,
            secTime: ScriptTimeManager.shard.secTime
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
    // Mark: - SpeechMark
    private func extractBreakTime(from breakMarkup: String) -> String {
        let pattern = "<break time=\"([0-9]+ms)\"/>"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        if let match = regex.firstMatch(in: breakMarkup, options: [], range: NSRange(location: 0, length: breakMarkup.utf16.count)) {
            if let range = Range(match.range(at: 1), in: breakMarkup) {
                return String(breakMarkup[range])
            }
        }
        return ""
    }
    private let breakTimeMap: [String: [String]] = [
        "601ms": ["."],
        "400ms": [","],
        "600ms": ["!"],
        "801ms": ["?"],
        "800ms": ["\n"]
    ]

    private func breakTimeToRealWord(speechMarks: [SpeechMark]) -> [SpeechMark] {
        var updatedSpeechMarks = [SpeechMark]()
        let firstByte = speechMarks.first?.start ?? 0
        
        for mark in speechMarks {
            let breakTime = extractBreakTime(from: mark.value)
            if !breakTime.isEmpty {
                let realWord = breakTimeMap[breakTime]?.first ?? ""
                updatedSpeechMarks.append(SpeechMark(
                    start: mark.start - firstByte,
                    end: mark.end - firstByte,
                    time: mark.time,
                    type: mark.type,
                    value: realWord
                ))
            } else if mark.value == "<amazon:breath/>" {
                updatedSpeechMarks.append(SpeechMark(
                    start: mark.start - firstByte,
                    end: mark.end - firstByte,
                    time: mark.time,
                    type: mark.type,
                    value: "\n\n"
                ))
            } else {
                updatedSpeechMarks.append(SpeechMark(
                    start: mark.start - firstByte,
                    end: mark.end - firstByte,
                    time: mark.time,
                    type: mark.type,
                    value: mark.value
                ))
            }
        }
        return updatedSpeechMarks
    }

    private func endByteToRealEndByte(speechMarks: [SpeechMark]) -> [SpeechMark] {
        var updatedSpeechMarks = [SpeechMark]()
        var byteOffset = 0
        
        for mark in speechMarks {
            let byteCount = mark.value.lengthOfBytes(using: .utf8)
            let originalByteCount = mark.end - mark.start
            byteOffset += byteCount - originalByteCount
            
            let newStart = mark.start + byteOffset
            let newEnd = mark.end + byteOffset
            
            updatedSpeechMarks.append(SpeechMark(
                start: newStart,
                end: newEnd,
                time: mark.time,
                type: mark.type,
                value: mark.value
            ))
        }
        
        return updatedSpeechMarks
    }

    func byteIndexToCharIndex(in text: String, byteIndex: Int) -> Int {
        let utf8Data = Array(text.utf8)
        let subData = utf8Data[0..<byteIndex]
        if let string = String(bytes: subData, encoding: .utf8) {
            return string.count
        }
        return 0
    }
    
    private func generateRealSpeechMark(from originalText: String, speechMarks: [SpeechMark]) -> [SpeechMark] {
        var updatedSpeechMarks = [SpeechMark]()
        
        for mark in speechMarks {
            let startCharIndex = byteIndexToCharIndex(in: originalText, byteIndex: mark.start)
            let endCharIndex = byteIndexToCharIndex(in: originalText, byteIndex: mark.end)
            
            updatedSpeechMarks.append(SpeechMark(
                start: startCharIndex,
                end: endCharIndex,
                time: mark.time,
                type: mark.type,
                value: mark.value
            ))
        }
        
        return updatedSpeechMarks
    }
    func findIndex(speechMark: [SpeechMark], time: Int) -> Int {
        print(time)
        var index = speechMark[speechMark.endIndex-1].end
        var previousMark : SpeechMark? = nil
        for mark in speechMark{
            if mark.time > time {
                if previousMark != nil{
                    index = previousMark!.end
                    print("index:" ,index)
                    break
                }
                else{
                    index = mark.end
                    print("cindex:" ,index)
                    break
                }
            }
            else{
                previousMark = mark
            }
        }
        return index
    }
    func colorizeSubstring(originalText: String, fromIndex: Int, color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: originalText)
        let range = NSRange(location: fromIndex, length: originalText.count - fromIndex)
        attributedString.addAttribute(.font, value: UIFont.Large(), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        return attributedString
    }
}
