//
//  MapView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import HexGrid
import SwiftUI

struct MapView: View {
    var game_map: Map
    @State var map_coord: MapCoord

    var body: some View {
        VStack {
            ScrollView([.horizontal, .vertical]) {
                Canvas { context, size in
                    var cellColor: Color
                    game_map.grid.origin = Point(x: 0, y: 0)
                    for cell in game_map.grid.cells {
                        let path = CellPath(
                            cell: cell,
                            corners: game_map.grid.polygonCorners(for: cell)
                        )
                        context.stroke(
                            path,
                            with: .color(red: 0.65, green: 0.9, blue: 1.0),
                            lineWidth: 3
                        )
                        
                        if cell.attributes["isHighlighted"] == true {
                            cellColor = Color(red: 0.0, green: 1.0, blue: 1.0)
                        } else if cell.isBlocked {
                            cellColor = Color(red: 0.5, green: 0.5, blue: 0.5)
                        } else {
                            cellColor = Color(.lightGray)
                        }
                        context.fill(path, with: .color(cellColor))
                    }
                }
                .scaledToFill()
                .frame(width: 500, height: 500)   // TODO Fill space
                .onTapGesture { location in
                    hexGesture(location: location)
                }
            }
        }
    }

    func hexGesture(location: CGPoint) {
        if let cell = try? game_map.grid.cellAt(location.hexPoint) {
            let coords = cell.coordinates.toOffset(
                orientation: .flatOnTop,
                offsetLayout: .even
            )
            map_coord = MapCoord(x: coords.row - 32, y: coords.column - 32)
            cell.toggleHighlight()
        } else {
            map_coord = MapCoord(x: 0, y: 0)
        }
    }

    func CellPath(cell: Cell, corners: [Point]) -> Path {
        var path = Path()
        guard let firstPoint = corners.first?.cgPoint else { return Path() }
        path.move(to: firstPoint)
        for i in 0..<corners.count {
            path.addLine(to: corners[i].cgPoint)
        }
        path.closeSubpath()
        return path
    }

}

extension Point {
    public var cgPoint: CGPoint {
        return CGPoint(x: x, y: y)
    }
}

extension CGPoint {
    public var hexPoint: Point {
        return Point(x: x, y: y)
    }
}

struct OnTap: ViewModifier {
    let response: (CGPoint) -> Void

    @State private var location: CGPoint = .zero
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                response(location)
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { location = $0.location }
            )
    }
}

extension View {
    func onTapGesture(_ handler: @escaping (CGPoint) -> Void) -> some View {
        self.modifier(OnTap(response: handler))
    }
}

extension Cell {
    var isHighlighted: Bool {
        return (self.attributes["isHighlighted"] == true)
    }

    func toggleHighlight() {
        if !self.isBlocked {
            if self.attributes["isHighlighted"] == true {
                self.attributes["isHighlighted"] = false
            } else {
                self.attributes["isHighlighted"] = true
            }
        }
    }
}

// MARK: -
#Preview {
    @Previewable @State var game_map = Map(x_size: 64, y_size: 64)
    @Previewable @State var map_coord = MapCoord(x: 0, y:0)
    MapView(game_map: game_map, map_coord: map_coord)
}
