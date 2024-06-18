//
//  SplashViewController.swift
//  Balphyo
//
//  Created by jin on 6/17/24.
//

import Foundation
import UIKit
import Then

class SplashViewController: UIViewController {
    
    // 로고 또는 이미지뷰 선언
    private let logoImageView = UIImageView().then{
        $0.image = UIImage(named: "Splash")
        $0.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .Primary
        
        setupViews()
        setupConstraints()
        
        // 2초 후 메인 화면으로 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showMainScreen()
        }
    }
    
    private func setupViews() {
        view.addSubview(logoImageView)
    }
    
    private func setupConstraints() {
        logoImageView.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview().inset(29)
            make.leading.equalToSuperview()
        }
    }
    
    private func showMainScreen() {
        let nextVC = LoginViewController()
        nextVC.modalTransitionStyle = .crossDissolve
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
