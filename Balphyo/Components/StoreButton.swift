//
//  StoreButton.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

import UIKit
import Then

class StoreButton: UIButton {

    private let iconImageView = UIImageView().then{
        $0.image = UIImage(named: "Store")
        $0.contentMode = .scaleAspectFit
    }
    private let storeLabel = UILabel().then{
        $0.text = "보관함"
        $0.font = UIFont.Title().withSize(10)
        $0.textColor = .Primary
        $0.textAlignment = .center
    }
    
    // Initializers
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
    
    private func setup() {
        addSubview(iconImageView)
        addSubview(storeLabel)

        iconImageView.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(19)
        }
        storeLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-9)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.width / 2
        clipsToBounds = true
    }
}

