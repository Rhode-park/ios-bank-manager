//
//  Bank.swift
//  Created by Rhode.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

struct Bank {
    private var bankManager = BankManager()
    
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
            return nil
        }
        return bankStatus
    }
    
    private mutating func startWork(_ status: BankStatus?) {
        switch status {
        case .open:
            bankManager.manageBank()
        case .close:
            return
        default:
            print(Constants.InvalidInputText)
        }
        openBank()
    }
}

extension Bank {
    enum Constants {
        static let bankMenuText = "1 : 은행개점 \n2 : 종료\n입력 :"
        static let InvalidInputText = "입력이 잘못되었습니다."
    }
}
