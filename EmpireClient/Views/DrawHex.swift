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
    var cellImage: ((Cell) -> Image)?
    var cellColour: ((Cell) -> GraphicsContext.Shading)?
    var hexGesture: ((CGPoint) -> Void)?

    init(
        hexmap: HexGrid,
        cellText: ((Cell) -> String)? = nil,
        cellImage: ((Cell) -> Image)? = nil,
        cellColour: ((Cell) -> GraphicsContext.Shading)? = nil,
        hexGesture: ((CGPoint) -> Void)? = nil
    ) {
        self.hexmap = hexmap
        self.cellText = cellText
        self.cellImage = cellImage
        self.cellColour = cellColour
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
            hexmap.origin = Point(x: size.width / 2, y: size.height / 2)
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
    let hexmap = HexGrid(
        shape: .hexagon(2),
        orientation: MapConfig.orientation,
        offsetLayout: MapConfig.offsetLayout,
        hexSize: MapConfig.hexSize,
    )
    DrawHex(
        hexmap: hexmap,
        cellText: previewCellText,
        cellColour: previewCellColour
    )
}
