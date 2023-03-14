//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let addClientButton: UIButton = {
        let button = UIButton()
        button.setTitle("고객 10명 추가", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("초기화", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let stopWatchLabel: UILabel = {
        let label = UILabel()
        label.text = "업무시간 - 04:33:253"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let signalLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let waitingListLabel: UILabel = {
        let label = UILabel()
        label.text = "대기중"
        label.textAlignment = .center
        label.backgroundColor = .systemGreen
        label.textColor = .white
        label.font = .systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let taskingListLabel: UILabel = {
        let label = UILabel()
        label.text = "업무중"
        label.textAlignment = .center
        label.backgroundColor = .systemIndigo
        label.textColor = .white
        label.font = .systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let waitingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let waitingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .brown
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let taskingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let taskingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .lightGray
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubViews()
        configureViews()
    }
    
    private func addSubViews() {
        view.addSubview(mainStackView)
        view.addSubview(waitingScrollView)
        view.addSubview(taskingScrollView)
        
        mainStackView.addArrangedSubview(buttonStackView)
        mainStackView.addArrangedSubview(stopWatchLabel)
        mainStackView.addArrangedSubview(signalLabelStackView)
        
        buttonStackView.addArrangedSubview(addClientButton)
        buttonStackView.addArrangedSubview(resetButton)
        
        signalLabelStackView.addArrangedSubview(waitingListLabel)
        signalLabelStackView.addArrangedSubview(taskingListLabel)
        
        waitingScrollView.addSubview(waitingStackView)
        taskingScrollView.addSubview(taskingStackView)
    }
    
    private func configureViews() {
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            addClientButton.widthAnchor.constraint(equalTo: resetButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            waitingListLabel.widthAnchor.constraint(equalTo: taskingListLabel.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            waitingScrollView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            waitingScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            waitingScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            taskingScrollView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            taskingScrollView.leadingAnchor.constraint(equalTo: waitingScrollView.trailingAnchor),
            taskingScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskingScrollView.widthAnchor.constraint(equalTo: waitingScrollView.widthAnchor),
            taskingScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            waitingStackView.widthAnchor.constraint(equalTo: waitingScrollView.frameLayoutGuide.widthAnchor),
            taskingStackView.widthAnchor.constraint(equalTo: taskingScrollView.frameLayoutGuide.widthAnchor)
        ])
    }
}
