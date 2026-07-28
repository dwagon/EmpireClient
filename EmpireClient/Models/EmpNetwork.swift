//
//  Network.swift
//  EmpireClient
//
//  Created by Dougal Scott on 23/7/2026.
//

import Foundation
import Network

struct Payload: nonisolated Codable {
    var command: String
    var result: [String]
}

class TCPClient {
    private let host: NWEndpoint.Host
    private let port: NWEndpoint.Port
    private var connection: NWConnection?
    private var commsQueue: DispatchQueue
    private var buffer = Data()

    init(host: String = "127.0.0.1", port: Int = 6666) {
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

//    /// Send a command to the proxy
//    func run_cmd(_ cmd: String) -> [String] {
//        var payload: Payload = Payload(command: "", result: [])
//        connect()
//        
//        let cmd_str = cmd.addingPercentEncoding(
//            withAllowedCharacters: .urlHostAllowed
//        )
//        if let url = URL(string: "http://127.0.0.1:6666/cmd/\(cmd_str!)") {
//            print("url=\(url)")
//            let task = URLSession.shared.data(with: url) {
//                (data, response, error) in
//                if let error {
//                    print("cmd=\(cmd) error=\(error.localizedDescription)")
//                    return
//                }
//                print("response=\(response, default: "nil")")   // Debug
//                if let data {
//                    print("data=\(data, default: "nil")")   // Debug
//                    do {
//                        payload = try JSONDecoder().decode(Payload.self, from: data)
//                    }
//                    catch {
//                        print("Failure on \(cmd)")
//                    }
//                }
//            }
//            task.resume()
//        }
//        return payload.result
//    }
    
    func fetchData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func run_cmd(_ cmd: String) async -> [String] {
        var response = [String]()
        let cmd_str = cmd.addingPercentEncoding(
            withAllowedCharacters: .urlHostAllowed
        )
        Task {
        let url = URL(string: "http://127.0.0.1:6666/cmd/\(cmd_str!)")!
            for try await line in url.lines {
                print("line=\(line)")
                response.append(line)
            }
        }
        return response
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
