//
//  StorageListViewController.swift
//  Balphyo
//
//  Created by jin on 6/18/24.
//

import UIKit
import Then
import SnapKit

class StorageListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private lazy var scriptTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain).then {
            $0.separatorStyle = .none
            $0.backgroundColor = .Gray1
            $0.dataSource = self
            $0.delegate = self
            $0.register(ScriptTableViewCell.self, forCellReuseIdentifier: ScriptTableViewCell.scriptListIdentifier)
        }
        return tableView
    }()
    
    var scriptList: [ScriptListResult] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .White
        setupNavigationBar()
        setupViews()
        apiGetScriptList()
    }
    
    private func setupNavigationBar() {
        self.title = "나의 보관함"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.Large(),
            NSAttributedString.Key.foregroundColor: UIColor.Gray4
        ]
        
        let backButtonImage = UIImage(named: "BackArrow")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupViews() {
        view.addSubview(scriptTableView)
        
        scriptTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Actions
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScriptTableViewCell.scriptListIdentifier, for: indexPath) as! ScriptTableViewCell
        
        let script = scriptList[indexPath.row]
        cell.configure(with: script)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear // 헤더의 배경색을 투명으로 설정
        return headerView
    }
    func apiGetScriptList() {
        NetworkService.shared.scriptCrudService.getScriptList() { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                self.scriptList = data.result
                self.scriptTableView.reloadData()
            default:
                print("리스트 가져오기 실패")
            }
        }
    }
}
