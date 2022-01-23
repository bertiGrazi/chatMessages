//
//  Message.swift
//  chatMessages
//
//  Created by Grazielli Berti on 23/01/22.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
