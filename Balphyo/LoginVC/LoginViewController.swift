//
//  LoginViewController.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation
import UIKit
import Then

class LoginViewController: UIViewController {
    let tokenManager = TokenManager()
    // 로고 또는 이미지뷰 선언
    private let logoImageView = UIImageView().then{
        $0.image = UIImage(named: "Logo") // 로고 이미지 이름으로 대체하세요
        $0.contentMode = .scaleAspectFit
    }
    private let titleLabel = UILabel().then{
        $0.font = UIFont.Title().withSize(24)
        $0.text = "발표가 쉬워지는 시간"
        $0.textColor = .White
    }
    private let loginButton = UIButton().then{
        $0.setTitle("로그인 없이 시작하기", for: .normal)
        $0.setTitleColor(.Text, for: .normal)
        $0.backgroundColor = .White
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = UIFont.Title().withSize(16)
        $0.addTarget(self, action: #selector(apiVerifyUid), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .Primary
        navigationController?.isNavigationBarHidden = true
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        logoImageView.snp.makeConstraints{ make in
            make.centerX.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(logoImageView.snp.top).offset(-18)
        }
        loginButton.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(38)
            make.width.equalTo(252)
            make.height.equalTo(42)
        }
    }
    
    private func showHomeVC() {
        let nextVC = HomeViewController()
        nextVC.modalTransitionStyle = .crossDissolve
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextVC, animated: true)
    }
    func apiGenerateUid() -> Void{
        NetworkService.shared.loginService.generateUid() { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                guard let data = data.result else { return }
                tokenManager.saveUid(data.uid)
                showHomeVC()
            default:
                print("uid 생성 실패")
                
            }
        }
    }
    @objc func apiVerifyUid() -> Void{
        NetworkService.shared.loginService.verifyUid() { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                guard let data = data.result else { return }
                if data.verified == false {
                    apiGenerateUid()
                }
                else {
                    showHomeVC()
                }
            default:
                print("uid 생성 실패")
                apiGenerateUid()
                
            }
        }
    }
}
