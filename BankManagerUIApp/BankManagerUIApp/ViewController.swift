//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    var bankManager = BankManager()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var addClientButton: UIButton = {
        let button = UIButton()
        button.setTitle("고객 10명 추가", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemIndigo, for: .highlighted)
        button.addTarget(self, action: #selector(touchUpInsideAddClientButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("초기화", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.setTitleColor(.systemBrown, for: .highlighted)
        button.addTarget(self, action: #selector(touchUpInsideResetButton), for: .touchUpInside)
        
        return button
    }()
    
    private let timeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "업무시간 - 04:33:253"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        
        return label
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let waitingHeaderLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGreen
        label.text = "대기중"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        
        return label
    }()
    
    private let workingHeaderLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemIndigo
        label.text = "업무중"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        
        return label
    }()
    
    private let clientLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let waitingLineScrollView = UIScrollView()
    
    private let workingLineScrollView = UIScrollView()
    
    private let waitingLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let workingLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        configureViews()
    }
    
    private func addViews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(addClientButton)
        buttonStackView.addArrangedSubview(resetButton)
        mainStackView.addArrangedSubview(timeCountLabel)
        mainStackView.addArrangedSubview(headerStackView)
        headerStackView.addArrangedSubview(waitingHeaderLabel)
        headerStackView.addArrangedSubview(workingHeaderLabel)
        mainStackView.addArrangedSubview(clientLineStackView)
        clientLineStackView.addArrangedSubview(waitingLineScrollView)
        clientLineStackView.addArrangedSubview(workingLineScrollView)
        waitingLineScrollView.addSubview(waitingLineStackView)
        workingLineScrollView.addSubview(workingLineStackView)
    }
    
    private func configureViews() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            waitingLineStackView.topAnchor.constraint(equalTo: waitingLineScrollView.contentLayoutGuide.topAnchor),
            waitingLineStackView.leadingAnchor.constraint(equalTo: waitingLineScrollView.contentLayoutGuide.leadingAnchor),
            waitingLineStackView.trailingAnchor.constraint(equalTo: waitingLineScrollView.contentLayoutGuide.trailingAnchor),
            waitingLineStackView.bottomAnchor.constraint(equalTo: waitingLineScrollView.contentLayoutGuide.bottomAnchor),
            waitingLineStackView.leadingAnchor.constraint(equalTo: waitingLineScrollView.frameLayoutGuide.leadingAnchor),
            waitingLineStackView.trailingAnchor.constraint(equalTo: waitingLineScrollView.frameLayoutGuide.trailingAnchor),
            workingLineStackView.topAnchor.constraint(equalTo: workingLineScrollView.contentLayoutGuide.topAnchor),
            workingLineStackView.leadingAnchor.constraint(equalTo: workingLineScrollView.contentLayoutGuide.leadingAnchor),
            workingLineStackView.trailingAnchor.constraint(equalTo: workingLineScrollView.contentLayoutGuide.trailingAnchor),
            workingLineStackView.bottomAnchor.constraint(equalTo: workingLineScrollView.contentLayoutGuide.bottomAnchor),
            workingLineStackView.leadingAnchor.constraint(equalTo: workingLineScrollView.frameLayoutGuide.leadingAnchor),
            workingLineStackView.trailingAnchor.constraint(equalTo: workingLineScrollView.frameLayoutGuide.trailingAnchor),
        ])
    }
    
    @objc func touchUpInsideAddClientButton() {
        var clientQueue = bankManager.clientWaitingLine.manageClientQueue()
        
        while let client = clientQueue.dequeue() {
            let label = CustomUILabel(client: client)
            waitingLineStackView.addArrangedSubview(label)
            bankManager.clientWaitingLineQueue.enqueue(client)
        }
        view.layoutIfNeeded()
    }
    
    @objc func touchUpInsideResetButton() {
        print("reset버튼 눌림")
    }
}

