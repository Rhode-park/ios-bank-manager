//
//  BankManager.swift
//  Created by Rhode.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

struct BankManager {
    private let clientWaitingLine = ClientWaitingLine()
    private let depositSemaphore = DispatchSemaphore(value: 2)
    private let depositQueue = DispatchQueue(label: "loan", attributes: .concurrent)
    private let loanQueue = DispatchQueue(label: "deposit")
    
    mutating func manageBank() {
        let workTime = workTime {
            distributeClient()
        }
        
        completeManagingBank(count: clientWaitingLine.clientCount, time: workTime)
    }
    
    private mutating func distributeClient() {
        let group = DispatchGroup()
        var clientQueue = clientWaitingLine.manageClientQueue()
        let banker = Banker()
        
        while let client = clientQueue.dequeue() {
            switch client.banking {
            case .deposit:
                depositQueue.async(group: group) { [self] in
                    depositSemaphore.wait()
                    
                    banker.work(client: client)
                    depositSemaphore.signal()
                }
                
            case .loan:
                loanQueue.async(group: group) {
                    banker.work(client: client)
                }
            }
        }
        
        group.wait()
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
