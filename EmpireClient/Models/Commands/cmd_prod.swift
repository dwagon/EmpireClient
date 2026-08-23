//
//  cmd_prod.swift
//  EmpireClient
//
//  Created by Dougal Scott on 23/8/2026.
//  See https://www.empire.cx/infopages/production.html
//

import Foundation

//prod #
// Sun Aug 23 09:44:50 2026
// PRODUCTION SIMULATION
//    sect  des eff avail  make p.e. cost   use1 use2 use3  max1 max2 max3   max
//    5,-3   a 100%   650    0f 4.50 $0                                      999
//    4,-2   j 100%   650    0l 0.50 $0       0i            650i             325
//   -4,0    o   0%   650    0o 0.50 $0                                        0
//   -2,0    l 100%   413  200  1.00 $1800  200l            413l             413
// 4 sectors

extension Game {
    func cmd_prod() async {
        var sector: Sector
        let result = await client.run_cmd("prod #")
        guard result != [] else {
            print("prod returned empty")
            return
        }
        for line in result[3..<result.count - 1] {
            let bits = line.split(separator: " ")
            if let coord = MapCoord(coord: String(bits[0])) {
                if self[coord] == nil {
                    self[coord] = Sector(coords: coord)
                }
                sector = self[coord]!
                sector[.make] = MapKeyValue(bits[4])
                sector[.prodeff] = MapKeyValue(bits[5])
                sector[.cost] = MapKeyValue(bits[6])
                if bits.count == 8 {  // No use/max
                } else if bits.count == 10 {  // One use/max
                    sector[.use1] = MapKeyValue(bits[7])
                    sector[.max1] = MapKeyValue(bits[8])
                } else if bits.count == 12 {  // Two use/max
                    sector[.use1] = MapKeyValue(bits[7])
                    sector[.use2] = MapKeyValue(bits[8])
                    sector[.max1] = MapKeyValue(bits[9])
                    sector[.max2] = MapKeyValue(bits[10])
                } else if bits.count == 14 {  // Three use/max
                    sector[.use1] = MapKeyValue(bits[7])
                    sector[.use2] = MapKeyValue(bits[8])
                    sector[.use3] = MapKeyValue(bits[9])
                    sector[.max1] = MapKeyValue(bits[10])
                    sector[.max2] = MapKeyValue(bits[11])
                    sector[.max3] = MapKeyValue(bits[12])
                } else {
                    print("Unhandled number of bits \(bits.count) in \(bits)")
                }

                sector[.max] = MapKeyValue(bits.last!)
            } else {
                print("cmd_prod: No coordinate from \(line)")
                continue
            }
        }
    }
}
