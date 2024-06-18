//
//  CustomTextField.swift
//  Balphyo
//
//  Created by jin on 6/12/24.
//

import UIKit
import SnapKit
import Then

class CustomTextField: UIView {
    var customTextField = UITextField().then {
        $0.textColor = .InputText
        $0.tintColor = .Primary
        $0.borderStyle = .none
        $0.textAlignment = .left
        $0.font = UIFont.XLarge()
    }
    var customUnderLine = UIProgressView(progressViewStyle: .bar).then {
        $0.trackTintColor = .lightGray
        $0.progressTintColor = .Primary
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.customTextField.delegate = self
        self.drawCustomUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawCustomUI(){
        self.backgroundColor = .clear
        //TextField, UIProgressView 를 뷰에 추가
        self.addSubview(customTextField)
        self.addSubview(customUnderLine)
        
        //SnapKit을 이용하여 위치를 지정
        customTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(0)
        }
        
        customUnderLine.snp.makeConstraints {
            $0.height.equalTo(1.6)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(customTextField.snp.bottom).offset(5)
        }
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.20) {
            self.customUnderLine.setProgress(1.0, animated: true)
            self.customTextField.textColor = .InputText
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.20) {
            self.customUnderLine.setProgress(0.0, animated: true)
        }
    }
    
}
