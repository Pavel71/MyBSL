//
//  BallonMarker.swift
//  SwiftyStats
//
//  Created by Павел Мишагин on 21.11.2019.
//  Copyright © 2019 Brian Advent. All rights reserved.
//

import UIKit
import Charts

open class BalloonMarker: MarkerImage
{
    open var color: UIColor?
    open var arrowSize = CGSize(width: 15, height: 11)
    open var font: UIFont?
    open var textColor: UIColor?
    open var insets = UIEdgeInsets()
    open var minimumSize = CGSize()

    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
  fileprivate var _drawAttributes = [NSAttributedString.Key : Any]()

    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        super.init()

        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets

        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
    }

    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        let size = self.size
        var point = point
        point.x -= size.width / 2.0
        point.y -= size.height
        return super.offsetForDrawing(atPoint: point)
    }

    open override func draw(context: CGContext, point: CGPoint)
    {
        guard let label = label else { return }

        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size

        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height

        context.saveGState()

        if let color = color
        {
            context.setFillColor(color.cgColor)
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width / 2.0,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.fillPath()
        }

        rect.origin.y += self.insets.top
        rect.size.height -= self.insets.top + self.insets.bottom

        UIGraphicsPushContext(context)

        label.draw(in: rect, withAttributes: _drawAttributes)

        UIGraphicsPopContext()

        context.restoreGState()
    }
  
    // MARK: Refresh Content

    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
      // My Configure
      offset = getCurrentPointByIcon(isIcon: entry.icon != nil)
      let text = configureLabelMarker(entry: entry)
      
      setLabel(text)
    }
  
  
  
  
  // MARK: Set Label

    open func setLabel(_ newLabel: String)
    {
        label = newLabel

        _drawAttributes.removeAll()
      _drawAttributes[NSAttributedString.Key.font] = self.font
      _drawAttributes[NSAttributedString.Key.paragraphStyle] = _paragraphStyle
      _drawAttributes[NSAttributedString.Key.foregroundColor] = self.textColor

      _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero

        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}


// MARK: My Configure
extension BalloonMarker {
  
  // MARK: Configure Label
  
  private func configureLabelMarker(entry:ChartDataEntry) -> String {
    
    let hour = entry.x.rounded(.down)

    let minutes = Int(((entry.x - hour) * 100).rounded(.up))
    
    let minutesString = minutes == 0 ? "00" : "\(minutes)"
    let minutesZero = minutesString.count == 1 ? "0" : ""
    let time = "\(Int(hour)):\(minutesZero)\(minutesString)"
    
    var markerText: String = "Сахар: \(entry.y) \n Время: \(time)"

    
    // Если идет компенсационны инсулин
    if let data = entry.data {
      
      let dictData = data as! [String: Any]
      
      guard let correctInsulin = dictData[ChartDataKey.insulin.rawValue] as? Double else {
        // Если инсулин не пришел то вернем обычные показатели
        return markerText
      }
      
      markerText += "\n \(ChartDataKey.insulin.rawValue): \(correctInsulin)"
   
    }
    
    return markerText
  }
  
  // MARK: Get Current Offset
  
  private func getCurrentPointByIcon(isIcon: Bool) -> CGPoint {
    let y = isIcon ? -25 : -5
    return CGPoint(x: 0, y: y)
  }
  
}
