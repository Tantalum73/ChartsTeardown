//
//  ViewController.swift
//  ChartTest1
//
//  Created by Andreas Neusüß on 09.05.19.
//  Copyright © 2019 Anerma. All rights reserved.
//

import UIKit

/// ViewController that instantiats the data store and configures the chart view. Interactions with the chart are done in the ChartView itself.
/// Changes in the selected range are handled in `segmentedControlValueChanged` where the data source is asked to give new data. It is converted into points for the ChartsView to display.
/// Interactions with the chart are handled in the methods of `ChartViewDelegate` which this viewcontroller implements.
class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var chartView: ChartView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var demoDataExplanationLabel: UILabel!
    
    private lazy var model: DataStore = {
        let path = Bundle.main.path(forResource: "GDAXI", ofType: "csv")
        let input = try! String(contentsOfFile: path!)
        
        return DataStore(contentsOfCSV: input)
    }()

    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private let colorMinus = UIColor(named: "ColorMinus")!
    private let colorPlus = UIColor(named: "ColorPlus")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chartView.delegate = self
        segmentedControlValueChanged(segmentedControl)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        feedbackGenerator.prepare()
    }

    /// Get the new data from the data store according to the selected segment. That data is transformed into points and passed to the ChartView.
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        let newData: [StockData]
        switch sender.selectedSegmentIndex {
        case 0: // 5T
            newData = model.firstFiveDays
            demoDataExplanationLabel.isHidden = false
        case 1: // 1M
            newData = model.month
            demoDataExplanationLabel.isHidden = true
        case 2: // 6M
            newData = model.sixMonths
            demoDataExplanationLabel.isHidden = true
        case 3: // 1Y
            newData = model.year
            demoDataExplanationLabel.isHidden = true
        case 4: // 5Y
            newData = model.fiveYears
            demoDataExplanationLabel.isHidden = true
        default:
            fatalError()
        }
        
        // Store the current data set for later.
        model.currentDataSet = newData
        
        // Define the color of the chart:
        if let rightElement = model.currentDataSet.first, let leftElement = model.currentDataSet.last {
            let chartColor: UIColor = rightElement.close < leftElement.close ? colorMinus : colorPlus
            chartView.chartColor = chartColor
        }
        
        // Convert data points to CGPoints so that they can be displayed by the ChartView. They are scaled by the view afterwards.
        let newPoints: [CGPoint] = newData.map { (data) -> CGPoint in
            let xComponent = data.date.timeIntervalSince1970
            return CGPoint(x: xComponent, y: data.close)
        }
        
        chartView.transform(to: newPoints)
        highlightDidChanged(to: 0)
    }
    
}

extension ViewController: ChartViewDelegate {
    func highlightDidChanged(to elementAtIndex: Int) {
        guard elementAtIndex < model.currentDataSet.count else { return }
        let selectedElement = model.currentDataSet[elementAtIndex]
        let leftElement = model.currentDataSet.last!
        
        // Color is chosen relative to the first element which sets the baseline.
        let colorOfPriceLabel: UIColor = leftElement.close > selectedElement.close ? colorMinus : colorPlus
        
        updatePriceLabel(to: String.init(format: "%.2f", selectedElement.close), in: colorOfPriceLabel)
        
        // Only give feedback when not too many points are displayed. That is the case in the 1Y and 5Y state.
        if segmentedControl.selectedSegmentIndex != 4 && segmentedControl.selectedSegmentIndex != 5 {
            feedbackGenerator.selectionChanged()
        }
    }
    
    func hightlightDidEnd() {
        if let rightElement = model.currentDataSet.first, let leftElement = model.currentDataSet.last {
            let colorOfPriceLabel: UIColor = rightElement.close < leftElement.close ? colorMinus : colorPlus
            updatePriceLabel(to: String.init(format: "%.2f", rightElement.close), in: colorOfPriceLabel)
        } else {
            updatePriceLabel(to: "-", in: .black)
        }
        
    }
    
    private func updatePriceLabel(to newText: String, in color: UIColor) {
        UIView.transition(with: priceLabel, duration: 0.2, options: [.beginFromCurrentState, .transitionCrossDissolve], animations: {
            self.priceLabel.text = newText
            self.priceLabel.textColor = color
        }, completion: nil)
        
    }
    
}
