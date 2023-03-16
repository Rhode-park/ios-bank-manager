//
//  CustomUILabel.swift
//  BankManagerUIApp
//
//  Created by Jinah Park on 2023/03/16.
//

import UIKit

class CustomUILabel: UILabel {
    init(client: Client) {
        super.init(frame: .zero)
        
        text = "\(client.clientWaitingNumber) - \(client)"
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title3)
        
        switch client.banking {
        case .deposit:
            textColor = .black
            
        case .loan:
            textColor = .purple
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
