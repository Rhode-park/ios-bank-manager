//
//  Bank.swift
//  Created by Rhode, sehong.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

struct Bank {
    private var clientCount: Int = Int.zero
    
    private let depositSemaphore = DispatchSemaphore(value: 2)
    private let depositQueue = DispatchQueue(label: "loan", attributes: .concurrent)
    
    private let loanQueue = DispatchQueue(label: "deposit")
    
    private enum BankStatus: String {
        case open = "1"
        case close = "2"
    }
    
    mutating func openBank() {
        displayBankMenu()
        let bankStatus = readMenuNumber()
        startWork(bankStatus)
    }
    
    private func displayBankMenu() {
        print(Constants.bankMenuText, terminator: " ")
    }
    
    private mutating func readMenuNumber() -> BankStatus? {
        guard let status = readLine(),
              let bankStatus = BankStatus(rawValue: status) else {
            print(Constants.InvalidInputText)
            openBank()
            
            return nil
        }
        return bankStatus
    }
    
    private mutating func startWork(_ status: BankStatus?) {
        switch status {
        case .open:
            manageBank()
        case .close:
            return
        default:
            return
        }
    }
    
    private mutating func manageClientQueue() -> Queue<Client>  {
        var clientQueue = Queue<Client>()
        clientCount = Int.random(in: 10...30)
        
        for i in 1...clientCount {
            Client.BankingType.allCases.randomElement().map {
                clientQueue.enqueue(Client(clientWaitingNumber: i, bankingType: $0))
            }
        }
        
        return clientQueue
    }
    
    private mutating func distributeClient() {
        let group = DispatchGroup()
        var clientQueue = manageClientQueue()
        let bankManager = BankManager()
        
        while let client = clientQueue.dequeue() {
            switch client.bankingType {
            case .deposit:
                depositQueue.async(group: group) { [self] in
                    depositSemaphore.wait()
                    
                    bankManager.work(client: client)
                    depositSemaphore.signal()
                }
                
            case .loan:
                loanQueue.async(group: group) {
                    bankManager.work(client: client)
                }
            }
        }
        
        group.wait()
    }
    
    private mutating func manageBank() {
        let workTime = workTime {
            distributeClient()
        }
        
        completeManagingBank(count: clientCount, time: workTime)
        openBank()
    }
    
    private func workTime(workTimeHandler: () -> Void) -> TimeInterval {
        let startTime = Date()
        
        workTimeHandler()
        
        let endTime = Date()
        let workTime = endTime.timeIntervalSince(startTime)
        
        return workTime
    }
    
    private func completeManagingBank(count: Int, time: Double) {
        let workingTime = String(format: "%.2f", time)
        
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총\(count)명이며, 총 업무시간은 \(workingTime)초 입니다.")
    }
}

extension Bank {
    enum Constants {
        static let bankMenuText = "1 : 은행개점 \n2 : 종료\n입력 :"
        static let InvalidInputText = "입력이 잘못되었습니다."
    }
}
