//
//  TriggerTableViewCell.swift
//  TriggeriOSSDK
//
//  Created by Adrian on 9/2/16.
//  Copyright © 2016 Trigger Finance, Inc. All rights reserved.
//

import UIKit
import SnapKit

protocol TriggerTableViewCellDelegate
{
    func triggerWasToggled(trigger: Trigger)
}

class TriggerTableViewCell: UITableViewCell {

    // MARK: View References
    weak var bg: UIView?
    weak var bottomBorder: UIView?
    weak var label: UILabel?
    weak var triggerControl: UISwitch?
    
    let defaultBackgroundColor = TriggerSDK.sharedInstance.propertyForConfigurationOption(TriggerSDK.ConfigurationOptions.DefaultBackgroundColor) as! UIColor
    let defaultBorderColor = TriggerSDK.sharedInstance.propertyForConfigurationOption(TriggerSDK.ConfigurationOptions.DefaultBorderColor) as! UIColor
    let defaultTextColor = TriggerSDK.sharedInstance.propertyForConfigurationOption(TriggerSDK.ConfigurationOptions.DefaultFontColor) as! UIColor
    
    // MARK: Properties
    var trigger: Trigger? {
        didSet {
            if let isOn = self.trigger?.isOn
            {
                self.triggerControl?.on = isOn
            }
            self.label?.text = self.trigger?.fullDescription
        }
    }
    var delegate: TriggerTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initViews()
        self.initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Init Views
    private func initViews()
    {
        self.contentView.backgroundColor = self.defaultBackgroundColor
        self.selectionStyle = .None
        
        // bottom border
        let bottom = UIView()
        bottom.backgroundColor = self.defaultBorderColor
        self.contentView.addSubview(bottom)
        self.bottomBorder = bottom
        
        // center text
        let label = UILabel()
        label.textColor = self.defaultTextColor
        if #available(iOS 8.2, *) {
            label.font = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
        } else {
            label.font = UIFont.systemFontOfSize(16)
            // Fallback on earlier versions
        }
        
        self.contentView.addSubview(label)
        self.label = label
        
        // toggle
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(TriggerTableViewCell.triggerToggled), forControlEvents: UIControlEvents.ValueChanged)
        self.triggerControl = toggle
        self.contentView.addSubview(toggle)
    }
    
    // MARK: Init Constraints 
    private func initConstraints()
    {
        
        self.bottomBorder?.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(1)
            make.left.equalTo(self.contentView).offset(5)
            make.right.equalTo(self.contentView).offset(-5)
        }
        
        self.label?.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView).offset(25)
            make.top.equalTo(self.contentView).offset(20)
            make.bottom.equalTo(self.contentView).offset(-20)
            make.right.lessThanOrEqualTo(self.triggerControl!.snp_left).offset(-5)
        }
        
        self.triggerControl?.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self.contentView).offset(-25)
            make.centerY.equalTo(self.contentView)
        }
    }
    
    // MARK: Trigger Toggled
    func triggerToggled()
    {
        if let value = self.triggerControl?.on
        {
            self.trigger?.isOn = value
            self.delegate?.triggerWasToggled(self.trigger!)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
