//
//  FeedTableViewCell.swift
//  Fidipu
//
//  Created by Yaşar Enes Dursun on 2.06.2022.
//

import UIKit


class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var moviesSeriesImageView: UIImageView!
    @IBOutlet weak var moviesSeriesNameLabel: UILabel!
    @IBOutlet weak var moviesSeriesLabel: UILabel!
    @IBOutlet weak var moviesSeriesReleaseYearLabel: UILabel!
    @IBOutlet weak var moviesSeriesDirectorLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var moviesSeriesGenreLabel: UILabel!
    @IBOutlet weak var moviesSeriesSubjectTextView: UITextView!
    @IBOutlet weak var moviesSeriesCastsLabel: UILabel!
    @IBOutlet weak var moviesSeriesDocumentIdLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
