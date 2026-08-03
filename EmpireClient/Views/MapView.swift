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
    @Binding var center_cell: Cell
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

    /// Move origin so map hex is centered in view
    func origin(canvas_size: CGSize, focus: Cell) -> Point {
        let center = hexmap.pixelCoordinates(for: focus)

        return Point(x: canvas_size.width / 2 - center.x, y: canvas_size.height / 2 - center.y )
    }

    var drawCanvas: some View {
        var focus: Cell

        do {
            focus = hexmap.cellAt(try CubeCoordinates(x: 0, y: 0, z: 0))!
        } catch {
            return Canvas { context, size in
                context.draw(
                    Text("Couldn't find center of grid: \(error.localizedDescription)"),
                    at: CGPoint(x: size.width/2, y: size.height/2))
            }
        }

        return Canvas { context, size in
            hexmap.origin = origin(canvas_size: size, focus: focus)
            for cell in hexmap.cells {
                var colour = Color.gray
                let center = hexmap.pixelCoordinates(for: cell)
                let offset_coord = cell.coordinates.toOffset(
                    orientation: MapConfig.orientation,
                    offsetLayout: MapConfig.offsetLayout
                )
                let path = CellPath(
                    cell: cell,
                    corners: hexmap.polygonCorners(for: cell)
                )
                context.stroke(
                    path,
                    with: .color(red: 0.65, green: 0.9, blue: 1.0),
                    lineWidth: 2
                )
                if cell == focus {
                    colour = Color.red
                }
                context.fill(path, with: .color(colour))
                context.draw(
                    Text("\(offset_coord.column),\(offset_coord.row)").font(
                        .caption2
                    ),
                    at: center.cgPoint
                )
            }
        }
    }

    func hexGesture(location: CGPoint) {
        if let cell = try? hexmap.cellAt(location.hexPoint) {
            center_cell = cell
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
//#Preview {
//    @Previewable var game = Game()
//    @Previewable @State var center_cell = game.game_map.cellAt(MapCoord(x: 10, y:10))!
//    MapView(game_map: game.game_map, center_cell: $center_cell)
//}
