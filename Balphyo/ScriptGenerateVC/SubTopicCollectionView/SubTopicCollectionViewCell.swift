//
//  SubTopicCollectionViewCell.swift
//  Balphyo
//
//  Created by jin on 6/14/24.
//

import UIKit
import Then

protocol SubTopicCollectionViewCellDelegate: AnyObject {
    func didTapDeleteButton(on cell: SubTopicCollectionViewCell)
}

class SubTopicCollectionViewCell: UICollectionViewCell {
    static let subTopicIdentifier = "SubTopicCell"
    weak var delegate: SubTopicCollectionViewCellDelegate?
    let label = UILabel().then{
        $0.font = UIFont.Medium()
        $0.textColor = .InputText
    }
    let deleteButton = UIButton().then{
        $0.setImage(UIImage(named: "CloseButton"), for: .normal)
        $0.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func addSubview() {
        contentView.addSubview(label)
        contentView.addSubview(deleteButton)
        contentView.layer.cornerRadius = 6
        contentView.layer.borderColor = UIColor.Gray2.cgColor
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = .clear
    }
    func configUI() {
        
        label.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
        }
        deleteButton.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalTo(label.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-10.5)
            $0.centerY.equalToSuperview()
        }
    }
    func configure(with tag: SubTopicModel) {
        label.text = tag.label
    }
    @objc private func deleteButtonTapped() {
        delegate?.didTapDeleteButton(on: self)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        configUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
