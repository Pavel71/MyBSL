//
//  PieChartVC.swift
//  InsulinProjectBSL
//
//  Created by Павел Мишагин on 26.06.2020.
//  Copyright © 2020 PavelM. All rights reserved.
//



import UIKit
import Charts


protocol PieChartModalable {
  var goodCompObjCount : Double {get set}
  var badCompObjCount  : Double {get set}
}

class PieChartViewController: DemoBaseViewController {
  


  var chartView = PieChartView()
//     var sliderX: UISlider!
//     var sliderY: UISlider!
//     var sliderTextX: UITextField!
//     var sliderTextY: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//      self.view.backgroundColor = .red
      
      self.view.addSubview(chartView)
      chartView.fillSuperview()
        // Do any additional setup after loading the view.
        self.title = "Half Pie Bar Chart"
        
//        self.options = [.toggleValues,
//                               .toggleXValues,
//                               .togglePercent,
//                               .toggleHole,
//                               .toggleIcons,
//                               .animateX,
//                               .animateY,
//                               .animateXY,
//                               .spin,
//                               .drawCenter,
//                               .saveToGallery,
//                               .toggleData]
        
        self.setup(pieChartView: chartView)
        
        chartView.delegate = self
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
//        chartView.legend = l

        // entry label styling
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
//        sliderX.value = 4
//        sliderY.value = 100
        self.slidersValueChanged(nil)
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
  override func updateChartData() {
      print("Update Data")
        if self.shouldHideData {
            chartView.data = nil
            return
        }
//    self.setDataCount(goodCompansations:15, badCompansations: 98)
//        self.setDataCount(Int(sliderX.value), range: UInt32(sliderY.value))
    }
    
  func setDataCount(pieChartModel : PieChartModalable) {
      
    let goodCompansations = pieChartModel.goodCompObjCount
    let badCompansations  = pieChartModel.badCompObjCount
    
    let totalCOmps = goodCompansations + badCompansations
    
      let goodComp : Double = goodCompansations / totalCOmps
      let badComp  : Double = badCompansations / totalCOmps

      let goodCompansationsEntry = PieChartDataEntry(value: goodComp,label: "Хорошие обеды")
      let badCompansationsEntry  = PieChartDataEntry(value: badComp,label: "Плохие обеды")
//        [goodCompansations,badCompansations]
      let set = PieChartDataSet(entries: [goodCompansationsEntry,badCompansationsEntry],label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
      set.colors = [UIColor.green,UIColor.red]
//        set.colors = ChartColorTemplates.vordiplom()
//            + ChartColorTemplates.joyful()
//            + ChartColorTemplates.colorful()
//            + ChartColorTemplates.liberty()
//            + ChartColorTemplates.pastel()
//            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
       
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
      data.setValueFont(.systemFont(ofSize: 14, weight: .medium))
        data.setValueTextColor(.black)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
//    override func optionTapped(_ option: Option) {
//        switch option {
//        case .toggleXValues:
//            chartView.drawEntryLabelsEnabled = !chartView.drawEntryLabelsEnabled
//            chartView.setNeedsDisplay()
//
//        case .togglePercent:
//            chartView.usePercentValuesEnabled = !chartView.usePercentValuesEnabled
//            chartView.setNeedsDisplay()
//
//        case .toggleHole:
//            chartView.drawHoleEnabled = !chartView.drawHoleEnabled
//            chartView.setNeedsDisplay()
//
//        case .drawCenter:
//            chartView.drawCenterTextEnabled = !chartView.drawCenterTextEnabled
//            chartView.setNeedsDisplay()
//
//        case .animateX:
//            chartView.animate(xAxisDuration: 1.4)
//
//        case .animateY:
//            chartView.animate(yAxisDuration: 1.4)
//
//        case .animateXY:
//            chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4)
//
//        case .spin:
//            chartView.spin(duration: 2,
//                           fromAngle: chartView.rotationAngle,
//                           toAngle: chartView.rotationAngle + 360,
//                           easingOption: .easeInCubic)
//
//        default:
//            handleOption(option, forChartView: chartView)
//        }
//    }
    
    // MARK: - Actions
    @IBAction func slidersValueChanged(_ sender: Any?) {
//        sliderTextX.text = "\(Int(sliderX.value))"
//        sliderTextY.text = "\(Int(sliderY.value))"
        
        self.updateChartData()
    }
}
