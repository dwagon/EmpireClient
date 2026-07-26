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
    private var commsQueue: DispatchQueue
    private var buffer = Data()


    init(host: String = "127.0.0.1", port: Int = 6665) {
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(rawValue: UInt16(port))!
        commsQueue = DispatchQueue(label: "Comms")
        buffer = Data()
    }

    private func connect() {
        if connection == nil {
            print("Connecting")
            connection = NWConnection(host: host, port: port, using: .tcp)
            connection?.start(queue: self.commsQueue)
        }
    }

    private func disconnect() {
        print("Disconnect")
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
            })
        )
    }

    func receive_message() {
        connect()
        buffer = Data()
        connection?.receive(minimumIncompleteLength: 1, maximumLength: 1024 * 8) {
            data,
            _,
            isComplete,
            error in

            if let error {
                print("receive: Error \(error)")
                return
            }

            if let data, !data.isEmpty {
                self.buffer.append(data)
            }

            if isComplete {
                print("isComplete")
            } else {
                self.receive_message()
            }
        }
    }

    func run_cmd(_ cmd: String) async -> [String] {
        let send_msg = "\(cmd)\n"
        var recv_msg: [String] = []

        self.send_message(message: send_msg) { result in
            switch result {
            case .failure(let error):
                print("Failed with \(error.localizedDescription)")
            default:
                break  // Success - do nothing
            }
        }
        self.receive_message()
        
        while (recv_msg == []) {
            let messages = String(data: self.buffer, encoding: .utf8) ?? "Unknown"
            for line in messages.split(whereSeparator: \.isNewline) {
                print("line=\(line)")
                let elements = line.split(maxSplits: 1, whereSeparator: { $0 == " "})
                let status = String(elements[0])
                let result = String(elements[1])
                recv_msg.append(result)
            }
        }

        return recv_msg
    }
}

// MARK: -
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
