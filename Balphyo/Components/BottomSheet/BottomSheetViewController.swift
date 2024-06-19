//
//  BottomSheetViewController.swift
//  Balphyo
//
//  Created by jin on 6/19/24.
//

import UIKit
import SnapKit
import Then

protocol BottomSheetViewControllerDelegate: AnyObject {
    func scriptSelectedRowAt(indexPath: Int)
}
final class BottomSheetViewController: UIViewController {
    private var selectedCellIndex: Int?

    weak var delegate: BottomSheetViewControllerDelegate?
    private let customTransitioningDelegate = BottomSheetDelegate()
    private var currentCell : String? = nil
    private let titleLabel = UILabel().then {
        $0.text = "대본 불러오기"
        $0.textColor = UIColor.Text
        $0.textAlignment = .center
        $0.font = UIFont.Medium()
    }
    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .equalSpacing
        $0.layoutMargins = UIEdgeInsets(top: 23, left: .zero, bottom: 20, right: .zero)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    private let finishButton = UIButton().then {
        $0.titleLabel?.font = UIFont.Large()
        $0.setTitle("대본 불러오기", for: .normal)
        $0.setTitleColor(.White, for: .normal)
        $0.backgroundColor = .PrimaryDisabled
        $0.layer.cornerRadius = 10
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
    }
    private let closeButton = UIButton().then {
        $0.setTitle("대본 직접 작성하기", for: .normal)
        $0.titleLabel?.font = UIFont.Medium()
        $0.setTitleColor(UIColor.Text, for: .normal)
        $0.setUnderline()
        $0.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.register(BottomSheetTableViewCell.self,
                           forCellReuseIdentifier: "modalCell")
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupModalStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupModalStyle() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .coverVertical
        transitioningDelegate = customTransitioningDelegate
    }
    
    private func setupInitialView() {
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = view.bounds.height / 15
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
    @objc private func finishButtonTapped() {
        // Finish 버튼을 터치했을 때의 동작
        delegate?.scriptSelectedRowAt(indexPath: selectedCellIndex!)
        self.dismiss(animated: true)
    }
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    // 선택된 위치가 없을 때 finishButton을 비활성화하는 메서드
    private func updateFinishButtonState() {
        if currentCell == nil {
            finishButton.isEnabled = false
            finishButton.layer.backgroundColor = UIColor.PrimaryDisabled.cgColor
        } else {
            finishButton.isEnabled = true
            finishButton.layer.backgroundColor = UIColor.Primary.cgColor
        }
    }
}
//MARK: -- 신고하기 UITableViewDelegate,UITableViewDataSource

extension BottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return BottomSheetManager.shard.scriptList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "modalCell",
                                                       for: indexPath) as? BottomSheetTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: .none)
        }
        if let title = BottomSheetManager.shard.scriptList?[indexPath.row].title {
            cell.setup(label: title)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        finishButton.layer.backgroundColor = UIColor.PrimaryDisabled.cgColor
        selectedCellIndex = indexPath.row
        if let cell = BottomSheetManager.shard.scriptList?[selectedCellIndex!].title {
            currentCell = cell
        }
        updateFinishButtonState()
    }
}

extension BottomSheetViewController {
    private func setupView() {
        setupInitialView()
        setupTableView()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(finishButton)
        verticalStackView.addArrangedSubview(closeButton)
        
        finishButton.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.height.equalTo(45)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(verticalStackView.snp.top)
        }
        verticalStackView.snp.makeConstraints {
            $0.height.equalTo(115)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
        
    }
}
extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}
