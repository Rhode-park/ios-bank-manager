//
//  ClientWaitingLine.swift
//  Created by Rhode.
//  Copyright © yagom academy. All rights reserved.
//

class ClientWaitingLine {
    var clientCount = Int.zero
    
    func manageClientQueue() -> Queue<Client>  {
        var clientQueue = Queue<Client>()
        
        for i in 1...10 {
            Client.Banking.allCases.randomElement().map {
                clientQueue.enqueue(Client(clientWaitingNumber: i, banking: $0))
            }
        }
        
        return clientQueue
    }
}
