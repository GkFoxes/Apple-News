//
//  OtherNewsTopicCollectionViewCell.swift
//  PravdaUIKit
//
//  Created by Дмитрий Матвеенко on 23.07.2020.
//  Copyright © 2020 GkFoxes. All rights reserved.
//

final class OtherNewsTopicCollectionViewCell: UICollectionViewCell {

	// MARK: Properties

	private enum Constants: CGFloat {
		case labelsVerticalDistance = 4
		case sourceLabelHeight = 14
		case titleLabelHeight = 86
		case timePublicationLabelHeight = 12
	}

	// MARK: Views

	private let headerImageView = initHeaderImageView()
	private let sourceLabel = initSourceLabel()
	private let titleLabel = initTitleLabel()
	private let timePublicationLabel = initTimePublicationLabel()

	// MARK: Life Cycle

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupViewsLayout()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: Interface

extension OtherNewsTopicCollectionViewCell: TodayCollectionViewCellProtocol {
	static var reuseIdentifer: String {
		return String(describing: OtherNewsTopicCollectionViewCell.self)
	}

	static func getEstimatedHeight() -> CGFloat {
		return 132
	}

	func setupContent(headerImage: UIImage?, source: String, title: String, timePublication: String) {
		headerImageView.image = Assets.test.image // temp
		sourceLabel.text = source
		titleLabel.text = title
		timePublicationLabel.text = timePublication
	}
}

// MARK: Views Appearances

private extension OtherNewsTopicCollectionViewCell {
	static func initHeaderImageView() -> UIImageView {
		let headerImageView = UIImageView()
		headerImageView.backgroundColor = .systemBackground
		headerImageView.layer.cornerRadius = 4
		headerImageView.contentMode = .scaleAspectFill
		headerImageView.clipsToBounds = true
		return headerImageView
	}

	static func initSourceLabel() -> UILabel {
		let sourceLabel = UILabel()
		sourceLabel.backgroundColor = .systemBackground
		sourceLabel.font = .systemFont(ofSize: 11.0, weight: .semibold)
		sourceLabel.textColor = .systemGray
		return sourceLabel
	}

	static func initTitleLabel() -> UILabel {
		let titleLabel = UILabel()
		titleLabel.backgroundColor = .systemBackground
		titleLabel.font = .systemFont(ofSize: 18.0, weight: .bold)
		titleLabel.numberOfLines = 4
		return titleLabel
	}

	static func initTimePublicationLabel() -> UILabel {
		let timePublicationLabel = UILabel()
		timePublicationLabel.backgroundColor = .systemBackground
		timePublicationLabel.font = .systemFont(ofSize: 10.0, weight: .medium)
		timePublicationLabel.textColor = .systemGray2
		return timePublicationLabel
	}
}

// MARK: Views Layout

private extension OtherNewsTopicCollectionViewCell {
	func setupViewsLayout() {
		setupSourceLabelLayout()
		setupTitleLabelLayout()
		setupTimePublicationLabelLayout()
		setupImageViewLayout()
	}

	func setupSourceLabelLayout() {
		contentView.addSubview(sourceLabel)
		sourceLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			sourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			sourceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			sourceLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
			sourceLabel.heightAnchor.constraint(equalToConstant: Constants.sourceLabelHeight.rawValue)
		])
	}

	func setupTitleLabelLayout() {
		contentView.addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			titleLabel.topAnchor.constraint(
				equalTo: sourceLabel.bottomAnchor, constant: Constants.labelsVerticalDistance.rawValue),
			titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: Constants.titleLabelHeight.rawValue)
		])
	}

	func setupTimePublicationLabelLayout() {
		contentView.addSubview(timePublicationLabel)
		timePublicationLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			timePublicationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			timePublicationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			timePublicationLabel.topAnchor.constraint(
				greaterThanOrEqualTo: titleLabel.bottomAnchor,
				constant: Constants.labelsVerticalDistance.rawValue),
			timePublicationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			timePublicationLabel.heightAnchor.constraint(equalToConstant: Constants.timePublicationLabelHeight.rawValue)
		])
	}

	func setupImageViewLayout() {
		contentView.addSubview(headerImageView)
		headerImageView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			headerImageView.leadingAnchor.constraint(
				equalTo: titleLabel.trailingAnchor, constant: Constants.labelsVerticalDistance.rawValue),
			headerImageView.topAnchor.constraint(
				equalTo: sourceLabel.bottomAnchor, constant: Constants.labelsVerticalDistance.rawValue),
			headerImageView.bottomAnchor.constraint(
				equalTo: timePublicationLabel.topAnchor, constant: -Constants.labelsVerticalDistance.rawValue),
			// Aspect ratio 1 : 1 == Square
			headerImageView.heightAnchor.constraint(equalTo: headerImageView.widthAnchor)
		])
	}
}
