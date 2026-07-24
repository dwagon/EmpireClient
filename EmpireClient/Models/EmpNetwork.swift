//
//  Network.swift
//  EmpireClient
//
//  Created by Dougal Scott on 23/7/2026.
//

import Foundation
import Network

class TCPClient {
    private let host: NWEndpoint.Host
    private let port: NWEndpoint.Port
    private var connection: NWConnection?
    private var buffer: [String] = []
    private var commsQueue: DispatchQueue

    init(host: String = "127.0.0.1", port: Int = 6665) {
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(rawValue: UInt16(port))!
        commsQueue = DispatchQueue(label: "Comms")
    }

    private func connect() {
        if connection == nil {
            connection = NWConnection(host: host, port: port, using: .tcp)
            connection?.start(queue: self.commsQueue)
        }
    }

    private func disconnect() {
        connection?.cancel()
    }

    func send_message(
        message: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let data = message.data(using: .utf8)!
        connect()
        connection?.send(
            content: data,
            completion: .contentProcessed({ error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
                self.disconnect()
            })
        )
    }

    func receive_message() async {
        connect()
        connection?.receive(minimumIncompleteLength: 1, maximumLength: 1024) {
            data,
            _,
            isComplete,
            error in

            if let error {
                print("receive: Error \(error)")
                return
            }

            if let data, !data.isEmpty {
                let msg = String(data: data, encoding: .utf8) ?? "Unknown"
                self.buffer.append(msg.trimmingCharacters(in: .newlines))
                print("msg = >\(self.buffer)<")
            }
            
            if isComplete {
                print("isComplete")
            }
        }
    }
    
    func send(_ cmd: String) -> [String] {
        self.buffer = []
        let message = "\(cmd)\n"
    
        Task {
            self.send_message(message: message) { result in
                switch result {
                case .failure(let error):
                    print("Failed with \(error.localizedDescription)")
                default:
                    break                 // Success - do nothing
                }
            }
            await self.receive_message()
        }
        
        print("Sent \(cmd)\tReceived \(self.buffer)")
        return self.buffer
    }
}

enum EmpCommsProtocol: String {
    case C_CMDOK = "0"
    case C_DATA = "1"
    case C_INIT = "2"
    case C_EXIT = "3"
    case C_FLUSH = "4"
    case C_NOECHO = "5"
    case C_PROMPT = "6"
    case C_ABORT = "7"
    case C_REDIR = "8"
    case C_PIPE = "9"
    case C_CMDERR = "A"
    case C_BADCMD = "B"
    case C_EXECUTE = "C"
    case C_FLASH = "D"
    case C_LAST = "E"
}
