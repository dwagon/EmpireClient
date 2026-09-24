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
    var radius: Int
    var cellText: ((Cell) -> String)?
    var cellImage: ((Cell) -> Image)?
    var cellFillColour: ((Cell) -> GraphicsContext.Shading)?
    var cellEdgeColour: ((Cell) -> GraphicsContext.Shading)?
    var cellOpacity: ((Cell) -> Double)?
    var hexGesture: ((CGPoint) -> Void)?

    init(
        hexmap: HexGrid,
        radius: Int,
        cellText: ((Cell) -> String)? = nil,
        cellImage: ((Cell) -> Image)? = nil,
        cellFillColour: ((Cell) -> GraphicsContext.Shading)? = nil,
        cellEdgeColour: ((Cell) -> GraphicsContext.Shading)? = nil,
        cellOpacity: ((Cell) -> Double)? = nil,
        hexGesture: ((CGPoint) -> Void)? = nil
    ) {
        self.hexmap = hexmap
        self.radius = radius
        self.cellText = cellText
        self.cellImage = cellImage
        self.cellFillColour = cellFillColour
        self.cellEdgeColour = cellEdgeColour
        self.cellOpacity = cellOpacity
        self.hexGesture = hexGesture
    }

    var body: some View {
        VStack {
            drawCanvas
                .border(Color.blue)
                .onTapGesture { location in
                    if let hexGesture {
                        hexGesture(location)
                    }
                }
        }
    }

    var drawCanvas: some View {
        Canvas { context, size in
            let center = try! Cell(CubeCoordinates(x: 0, y: 0, z: 0))
            hexmap.origin = Point(x: size.width / 2, y: size.height / 2)

            for cell in try! hexmap.filledRing(from: center, in: radius) {
                let center = hexmap.pixelCoordinates(for: cell)
                let path = cellPath(
                    cell: cell,
                    corners: hexmap.polygonCorners(for: cell)
                )
                if let cellOpacity {
                    context.opacity = cellOpacity(cell)
                }
                context.stroke(
                    path,
                    with: cellStrokeColour(cell: cell),
                    lineWidth: 2
                )
                if let cellFillColour {
                    context.fill(path, with: cellFillColour(cell))
                }
                if let cellText {
                    context.draw(
                        Text(cellText(cell))
                            .font(.caption2)
                            .foregroundStyle(.indigo),
                        at: center.cgPoint
                    )
                }
                if let cellImage {
                    context.draw(cellImage(cell), at: center.cgPoint)
                }
            }
        }
    }

    func cellStrokeColour(cell: Cell) -> GraphicsContext.Shading {
        if let cellEdgeColour {
            return cellEdgeColour(cell)
        }
        return .color(red: 0.65, green: 0.9, blue: 1.0)
    }

    func cellPath(cell: Cell, corners: [Point]) -> Path {
        var path = Path()
        guard let firstPoint = corners.first?.cgPoint else { return Path() }
        path.move(to: firstPoint)
        for idx in 0..<corners.count {
            path.addLine(to: corners[idx].cgPoint)
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
    let hexmap = HexGrid(
        shape: .hexagon(2),
        orientation: MapConfig.orientation,
        offsetLayout: MapConfig.offsetLayout,
        hexSize: MapConfig.hexSize,
    )
    DrawHex(
        hexmap: hexmap,
        radius: 3,
        cellText: previewCellText,
        cellFillColour: previewCellColour
    )
}
