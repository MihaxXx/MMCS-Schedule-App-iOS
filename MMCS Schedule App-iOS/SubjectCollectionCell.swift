//
//  SubjectCollectionCell.swift
//  mmcsShed
//
//  Created by Danya on 11.05.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import UIKit

class SubjectCollectionCell: UICollectionViewCell {
	
	@IBOutlet weak var timeSince: UILabel!
	@IBOutlet weak var timeUntil: UILabel!
	@IBOutlet weak var subjectName: UILabel!
	@IBOutlet weak var teacherName: UILabel!
	@IBOutlet weak var room: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	func configure(timeS: String, timeU: String, sbjName: String, tchName: String, roomS: String) {
		timeSince.text = timeS
		timeUntil.text = timeU
		subjectName.text = sbjName
		teacherName.text = tchName
		room.text = roomS
	}
}
