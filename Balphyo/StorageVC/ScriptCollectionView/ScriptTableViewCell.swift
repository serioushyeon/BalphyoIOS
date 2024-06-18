//
//  ScriptCollectionViewCell.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

import UIKit
import Then
import SnapKit

class ScriptTableViewCell: UITableViewCell {
    static let scriptListIdentifier = "scriptCell"
    var scriptId = 0
    var data = ScriptListResult(scriptId: 0,
                                script: "",
                                gptId: "",
                                uid: "",
                                title: "",
                                secTime: 0,
                                voiceFilePath: "")
    
    let container = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.backgroundColor = UIColor.white.cgColor
    }
    // UILabel 초기화
    let label = UILabel().then {
        $0.font = UIFont.Title().withSize(18)
        $0.textColor = .Text
    }
    
    // UIButton 초기화
    /*let playButton = UIButton().then {
     $0.setImage(UIImage(named: "CloseButton"), for: .normal)
     $0.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
     }*/
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
        setupGestureRecognizers()
    }
    
    private func setupViews() {
        contentView.backgroundColor = .Gray1
        contentView.addSubview(container)
        container.layer.shadowColor = UIColor.Black.cgColor
        container.layer.shadowOpacity = 0.1
        container.layer.shadowRadius = 2
        container.layer.shadowOffset = CGSize(width: 2, height: 2)
        container.addSubview(label)
        //contentView.addSubview(playButton)
    }
    
    private func setupConstraints() {
        container.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        label.snp.makeConstraints { make in
            make.top.bottom.equalTo(container).inset(16)
            make.leading.equalTo(container).offset(22)
            make.centerY.equalTo(container)
        }
        /*playButton.snp.makeConstraints {
         $0.top.bottom.equalToSuperview().inset(10)
         $0.leading.equalTo(label.snp.trailing).offset(8)
         $0.trailing.equalToSuperview().offset(-10.5)
         $0.centerY.equalToSuperview()
         }*/
    }
    
    func configure(with model: ScriptListResult) {
        label.text = model.title
        scriptId = model.scriptId
        data = model
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
        container.isUserInteractionEnabled = true
        container.addGestureRecognizer(tapGesture)
    }
    
    @objc private func containerTapped() {
        apiGetScriptDetail()
    }
    
    func apiGetScriptDetail(){
        let request = ScriptDetailDeleteRequest(
            scriptId: "\(data.scriptId)"
        )
        NetworkService.shared.scriptCrudService.getScriptDetail(bodyDTO: request) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                print("조회 성공")
                let nextVC = ScriptEditViewController()
                nextVC.data = data.result
                if let parentVC = self.parentViewController {
                    parentVC.navigationController?.pushViewController(nextVC, animated: true)
                }
            default:
                print("조회 실패")
            }
        }
    }
    
}
// UIView에 parentViewController를 확장하여 가져오기 위한 방법
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
