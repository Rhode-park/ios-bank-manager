//
//  Banker.swift
//  Created by Rhode.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

struct Banker {
    func work(client: Client) {
        print("\(client.clientWaitingNumber)번 고객 \(client)업무 시작")
        Thread.sleep(forTimeInterval: client.bankingTime)
        print("\(client.clientWaitingNumber)번 고객 \(client)업무 종료")
    }
}
