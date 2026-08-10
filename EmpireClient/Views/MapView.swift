//
//  MapView.swift
//  EmpireClient
//
//  Created by Dougal Scott on 22/7/2026.
//

import HexGrid
import SwiftUI

struct MapView: View {
    let game_map: Map
    @Binding var center_coord: MapCoord

    var hexmap = HexGrid(
        shape: .hexagon(MapConfig.mapRadius),
        orientation: MapConfig.orientation,
        offsetLayout: MapConfig.offsetLayout,
        hexSize: MapConfig.hexSize
    )

    var body: some View {
        VStack {
            drawCanvas
                .border(Color.blue)
                .padding()
                .onTapGesture { location in
                    hexGesture(location: location)
                }
        }
    }

    /// Move pixel origin so map hex is centered in view
    func origin(canvas_size: CGSize, focus: Cell) -> Point {
        let center = hexmap.pixelCoordinates(for: focus)
        return Point(
            x: canvas_size.width / 2 - center.x,
            y: canvas_size.height / 2 - center.y
        )
    }

    var drawCanvas: some View {
        var focus: Cell

        do {
            focus = hexmap.cellAt(try CubeCoordinates(x: 0, y: 0, z: 0))!
        } catch {
            return Canvas { context, size in
                context.draw(
                    Text(
                        "Couldn't find center of grid: \(error.localizedDescription)"
                    ),
                    at: CGPoint(x: size.width / 2, y: size.height / 2)
                )
            }
        }

        return Canvas { context, size in
            hexmap.origin = origin(canvas_size: size, focus: focus)
            for cell in hexmap.cells {
                let center = hexmap.pixelCoordinates(for: cell)
                let path = CellPath(
                    cell: cell,
                    corners: hexmap.polygonCorners(for: cell)
                )
                context.stroke(
                    path,
                    with: .color(red: 0.65, green: 0.9, blue: 1.0),
                    lineWidth: 2
                )
                context.fill(path, with: cellColour(cell))
                context.draw(
                    Text(cellText(cell)).font(.caption2),
                    at: center.cgPoint
                )
            }
        }

        func cellText(_ cell: Cell) -> String {
            let map_coord = screenToMapCoord(cell.coordinates)
            if let sector = game_map[map_coord] {
                return sector.symbol
            } else {
                return "\(map_coord.x),\(map_coord.y)"
            }
        }

        func cellColour(_ cell: Cell) -> GraphicsContext.Shading {
            if cell == focus {
                return .color(Color.red)
            }
            let map_coord = screenToMapCoord(cell.coordinates)
            if let sector = game_map[map_coord] {
                switch sector.desig.desig {
                case .sea:
                    return .color(Color.blue)
                case .wilderness:
                    return .color(Color.green)
                default:
                    return .color(Color.gray)
                }
            }
            return .color(Color.clear)
        }
    }

    /// Adjust screen coordinates to map coordinates
    func screenToMapCoord(_ coord: CubeCoordinates) -> MapCoord {
        var adjusted = MapCoord(coord)
        adjusted.x += center_coord.x
        adjusted.y += center_coord.y
        return adjusted
    }

    func hexGesture(location: CGPoint) {
        if let cell = try? hexmap.cellAt(location.hexPoint) {
            let new_coord = cubeToDoubleWidth(
                from: cell.coordinates,
                orientation: MapConfig.orientation,
                offsetLayout: MapConfig.offsetLayout
            )
            print(
                "cell=\(cell.coordinates) new=\(new_coord) center=\(center_coord)"
            )
            center_coord.x += new_coord.x
            center_coord.y += new_coord.y
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

// MARK: -
#Preview {
    @Previewable var game = Game()
    @Previewable @State var center_coord = MapCoord(x: 0, y: 0)
    MapView(game_map: game.game_map, center_coord: $center_coord)
}
