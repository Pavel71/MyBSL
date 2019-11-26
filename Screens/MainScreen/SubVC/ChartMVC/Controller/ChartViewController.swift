//
//  ChartViewController.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 25.11.2019.
//  Copyright © 2019 PavelM. All rights reserved.
//

import UIKit
import Charts

// Класс отвечает за связь графика с другими контроллерами и всю логику передачи данных!

class ChartViewController: UIViewController {
  
  
  // 1. Добавить график на ViewController
  // 2. Сконфигурировать натсройик графика
  // 3. Наладить прием входных данных
  
  
  // Chart Properties
  
  let lineChartView = LineChartView()
  let chartWorker = ChartWorker()
  
  let highLimitLevel: Double = 7.5
  let lowLimittLevel: Double = 4.5
  
  // Chart Data
  var entryies: [ChartDataEntry] = []
  
  
  override func viewDidLoad() {
    print("ChartVC Did Load")
    view.backgroundColor = .orange
    
    setUpChartView()
    
    let lineSet = getChartDataSets()
    
    let lineChartData = LineChartData(dataSet: lineSet)

    lineChartView.data = lineChartData
    
  }
  
  // Возможно это надо будет переписать
  func setViewModel(viewModel:ChartViewModel) {
    entryies = viewModel.chartEntryModels.map(chartWorker.getCurrentChurtEntry)
  }
  

  
}


// MARK: Set Up Chart View
extension ChartViewController {
  
  private func setUpChartView() {
    view.addSubview(lineChartView)
    lineChartView.fillSuperview()
    configureChart()
  }
  
  // MARK: COnfigure Chart View
  
  private func configureChart() {

    lineChartView.chartDescription?.font = .systemFont(ofSize: 20)
    lineChartView.chartDescription?.text = "20.11.2019"

    // MArKer
    lineChartView.marker = getConfigureMarker()
    
    // Разместить ось x внизу
    
    lineChartView.delegate = self

    // TouchEnablded
    lineChartView.dragEnabled = true
    lineChartView.dragXEnabled = true
    
    lineChartView.scaleXEnabled = true
    
    //    lineChartView.extraLeftOffset = 100 // Сещение View
    
    
    // Auto Scale
    lineChartView.autoScaleMinMaxEnabled = true
    
    // Подсветочка Бэка
    lineChartView.drawGridBackgroundEnabled = true
    lineChartView.drawBordersEnabled = true
    
    
    lineChartView.autoScaleMinMaxEnabled = false
    lineChartView.notifyDataSetChanged()
    
    configureAxisChartView()
    
  }
  
  
   // MARK: Configure Marker
    
  private func getConfigureMarker() -> BalloonMarker {
    
    let marker = BalloonMarker(color: #colorLiteral(red: 0.4160000086, green: 0.6200000048, blue: 0.851000011, alpha: 1), font: .systemFont(ofSize: 14), textColor: .white, insets: .init(top: 5, left: 5, bottom: 20, right: 5))
    marker.minimumSize = CGSize(width: 75.0, height: 35.0)//CGSize(75.0, 35.0)
    //    marker.arrowSize = .init(width: 20, height: 20)
    //    marker.offset = .init(x: 0, y: -30)
    
    return marker
  }
  
  // MARK: Configure Axis
  
  private func configureAxisChartView() {
      
      lineChartView.gridBackgroundColor = .white
      
      lineChartView.xAxis.labelPosition = .bottom // Ось снизу

      lineChartView.getAxis(.right).enabled = false     // Убрать Ось справа
      
      let leftAxis = lineChartView.getAxis(.left)
      
       leftAxis.drawLimitLinesBehindDataEnabled = true
       leftAxis.drawZeroLineEnabled = true
       leftAxis.spaceBottom = 0.3
       leftAxis.spaceTop = 0.3
       leftAxis.xOffset = 10
      
  //    lineChartView.getAxis(.left).draw
      
  //    leftAxis.drawGridLinesEnabled = true
  //    leftAxis.gridLineWidth = 10
      
      
      // Как будут отображатся данные по оси X
      lineChartView.xAxis.valueFormatter = MyAxisFormater()
      //    lineChartView?.xAxis.granularity = 1
      
      lineChartView.xAxis.spaceMin = 1
      lineChartView.xAxis.spaceMax = 2
      
      lineChartView.xAxis.yOffset = 10
      
  //    lineChartView.xAxis.avoidFirstLastClippingEnabled = false
      
      setLimitLine(aXis: leftAxis)
          
    }
  
  // MARK: Set Limitt Line
  
  private func setLimitLine(aXis: YAxis) {
    
    // Limit Line
    let hightLimit = ChartLimitLine(limit: highLimitLevel, label: "")

    hightLimit.lineColor = .clear
    
    
    //    hightLimit.lineDashLengths = [1,2]
    //    hightLimit.lineDashPhase = 10
    
    // Сделать подсветку лимит лайн
    
    let bottomLimit = ChartLimitLine(limit: lowLimittLevel, label: "")
    bottomLimit.lineWidth = 3
    bottomLimit.lineColor = .red

    aXis.addLimitLine(hightLimit)
    aXis.addLimitLine(bottomLimit)
    
    
    // Заполним цветом этот участок
    aXis.isLimitLineFillEnabled = true
    aXis.limitLineFillColor = #colorLiteral(red: 0.6462503076, green: 0.8092395663, blue: 0.9768106341, alpha: 1)
        
      
  }
  
}


// MARK: Configure Line Data Set

extension ChartViewController {
  
  private func getChartDataSets() -> LineChartDataSet {
      
      let lineChartDataSets = LineChartDataSet(entries: entryies, label: "Simple Line")

      lineChartDataSets.setColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)) // Line COlor
      
      // Value Formatter
      lineChartDataSets.valueFormatter = MyValueFormatter()
      
      // Fill Line
      
  //    lineChartDataSets.drawFilledEnabled = true // Если нужно заполнить
  //    let fill = Fill(CGColor: UIColor.brown.cgColor)
  //    lineChartDataSets.fillColor = .brown
  //
  //    lineChartDataSets.fill = fill

      

      
      lineChartDataSets.drawValuesEnabled = false // не показывать переданные значения
  //    lineChartDataSets.valueTextColor = .green
  //    lineChartDataSets.valueFont = .systemFont(ofSize: 16)
      
      lineChartDataSets.drawCirclesEnabled = false // не показывать кружки
  //    lineChartDataSets.circleRadius = 4
  //    lineChartDataSets.circleColors = [#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)]
        
      
  //        lineChartDataSets.lineCapType = .square // хз
      
      // не хочет разукрашивать линии в безейр моде
      lineChartDataSets.mode = .horizontalBezier
      
      
      
      lineChartDataSets.iconsOffset = .init(x: 0, y: -15) // отсуп иконки

      
      // Highlited
      lineChartDataSets.highlightEnabled = true
      
          lineChartDataSets.drawVerticalHighlightIndicatorEnabled = false
      lineChartDataSets.drawHorizontalHighlightIndicatorEnabled = false
  //    lineChartDataSets.setDrawHighlightIndicators(true)
      lineChartDataSets.highlightColor = .blue
      
      lineChartDataSets.highlightLineDashLengths = [5.0, 2.5]
      
      lineChartDataSets.highlightLineWidth = 2.0
      
      
      return lineChartDataSets
    }
    
  
}


// MARK: Chart View Delegate

extension ChartViewController : ChartViewDelegate {
  
  func chartViewDidEndPanning(_ chartView: ChartViewBase) {
    print("Did end panning")
  }
  
  func chartValueNothingSelected(_ chartView: ChartViewBase) {
    print("nothing selected")
  }
  
  func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    print(entry.data)
  }
  
}

// MARK: Value Formatter

class MyValueFormatter: IValueFormatter {
  
  func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
    return "\(value)"
  }
  
  
}


// MARK: Axis Value Formatter

class MyAxisFormater: IAxisValueFormatter {
  
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    
    axis?.setLabelCount(3, force: true)
    return String(format: "%.f:00", value)
    
  }
  
}
