//
//  DrawHex.swift
//  Generic HexGrid drawer
//
//  Created by Dougal Scott on 11/8/2026.
//

import HexGrid
import SwiftUI

struct DrawHex: View {
    var hexmap: HexGrid
    var cellText: ((Cell) -> String)?
    var cellColour: ((Cell) -> GraphicsContext.Shading)?
    var hexGesture: ((CGPoint) -> Void)?

    init(
        hexmap: HexGrid,
        cellText: ((Cell) -> String)? = nil,
        cellColour: ((Cell) -> GraphicsContext.Shading)? = nil,
        hexGesture: ((CGPoint) -> Void)? = nil
    ) {
        self.hexmap = hexmap
        self.cellText = cellText
        self.cellColour = cellColour
        self.hexGesture = hexGesture
    }

    var body: some View {
        VStack {
            drawCanvas
                .border(Color.blue)
                .padding()
                .onTapGesture { location in
                    if let hexGesture {
                        hexGesture(location)
                    }
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
                if let cellColour {
                    context.fill(path, with: cellColour(cell))
                }
                if let cellText {
                    context.draw(
                        Text(cellText(cell)).font(.caption2),
                        at: center.cgPoint
                    )
                }
            }
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

func previewCellText(_ cell: Cell) -> String {
    return "!"
}

func previewCellColour(_ cell: Cell) -> GraphicsContext.Shading {
    return .color(Color.red)
}

#Preview {
    var hexmap = HexGrid(
        shape: .hexagon(2),
        orientation: MapConfig.orientation,
        offsetLayout: MapConfig.offsetLayout,
        hexSize: MapConfig.hexSize,
    )
    DrawHex(hexmap: hexmap, cellText: previewCellText, cellColour: previewCellColour)
}
