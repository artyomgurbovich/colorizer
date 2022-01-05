//
//  ProcessingViewController.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 14.11.21.
//

import UIKit

final class ProcessingViewController: UIViewController {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var stageLabel: UILabel!
    
    var viewModel: ProcessingViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onNewStage = { stage in
            DispatchQueue.main.async {
                if stage == 0 {
                    self.stageLabel.text = "Colorizing…"
                } else if stage == 1 {
                    self.stageLabel.text = "Extracting…"
                } else {
                    self.stageLabel.text = "Saving…"
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.startProcessing()
        }
    }
}
