//
//  ClientWaitingLine.swift
//  Created by Rhode.
//  Copyright © yagom academy. All rights reserved.
//

class ClientWaitingLine {
    var clientCount = Int.zero
    var count = 0
    
    func manageClientQueue() -> Queue<Client>  {
        var clientQueue = Queue<Client>()
        
        for number in 1...10 {
            Client.Banking.allCases.randomElement().map {
                clientQueue.enqueue(Client(clientWaitingNumber: number + count, banking: $0))
            }
        }
        count += 10
        
        return clientQueue
    }
}
