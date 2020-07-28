//
//  TodayCollectionViewDiffableDataSource.swift
//  PravdaUIKit
//
//  Created by Дмитрий Матвеенко on 23.07.2020.
//  Copyright © 2020 GkFoxes. All rights reserved.
//

import Models

typealias TodayDiffableDataSource = UICollectionViewDiffableDataSource<TodaySections, TodayNewsItem>

protocol TodayCollectionViewDiffableDataSourceProtocol: TodayDiffableDataSource {
	func setItems(_ todayNewsItems: TodayNewsItems)
	func getItem(for indexPath: IndexPath) -> TodayNewsItem?
	func setupDataSourceForView()
	func applyCurrentStateSnapshot()
}

final class TodayCollectionViewDiffableDataSource: TodayDiffableDataSource {

	private var todayNewsItems = TodayNewsItems()

	// MARK: Life Cycle

	init(collectionView: UICollectionView) {
		super.init(
		collectionView: collectionView
		) { (collectionView: UICollectionView, indexPath: IndexPath, detailItem: TodayNewsItem)
			-> UICollectionViewCell? in
			return TodayCollectionViewDiffableDataSource.setupCellsDataSource(
				collectionView: collectionView, indexPath: indexPath, detailItem: detailItem)
		}
	}
}

// MARK: Setup Interface

extension TodayCollectionViewDiffableDataSource: TodayCollectionViewDiffableDataSourceProtocol {
	func setItems(_ todayNewsItems: TodayNewsItems) {
		self.todayNewsItems = todayNewsItems
		applyCurrentStateSnapshot()
	}

	func getItem(for indexPath: IndexPath) -> TodayNewsItem? {
		return self.itemIdentifier(for: indexPath)
	}

	func setupDataSourceForView() {
		setupSectionHeaderProvider()
		applyCurrentStateSnapshot()
	}

	func applyCurrentStateSnapshot() {
		self.apply(self.getCurrentStateSnapshot(), animatingDifferences: true)
	}
}

// MARK: Data Snapshot

private extension TodayCollectionViewDiffableDataSource {
	static func setupCellsDataSource(
		collectionView: UICollectionView,
		indexPath: IndexPath,
		detailItem: TodayNewsItem
	) -> UICollectionViewCell? {
		var newsCell: TodayCollectionViewCellProtocol?

		switch TodaySections.allCases[indexPath.section] {
		case .topStories, .science:
			let titleNewsTopicCell = collectionView.tryDequeueReusableTodayCell(
				withReuseIdentifier: TitleNewsTopicCollectionViewCell.reuseIdentifer,
				for: indexPath)
			newsCell = titleNewsTopicCell
		case .otherTopStories, .otherScience:
			let newsTopicCell = collectionView.tryDequeueReusableTodayCell(
				withReuseIdentifier: OtherNewsTopicCollectionViewCell.reuseIdentifer,
				for: indexPath)
			newsCell = newsTopicCell
		}

		if let newsCell = newsCell {
			newsCell.setupContent(
				image: nil,
				source: detailItem.source,
				title: detailItem.title,
				timePublication: detailItem.timePublication)
			return newsCell
		} else {
			assertionFailure()
			return UICollectionViewCell()
		}
	}

	func setupSectionHeaderProvider() {
		self.supplementaryViewProvider = {
			(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
			guard
				let sectionItem = self.itemIdentifier(for: indexPath),
				let section = self.snapshot().sectionIdentifier(containingItem: sectionItem),
				let sectionHeader = collectionView.dequeueReusableSupplementaryView(
					ofKind: kind,
					withReuseIdentifier: TodaySectionHeaderCollectionReusableView.reuseIdentifer,
					for: indexPath) as? TodaySectionHeaderCollectionReusableViewProtocol
				else {
					assertionFailure("Couldn't create TodaySectionHeader")
					return nil
			}

			sectionHeader.setupContent(title: section.rawValue, textColor: section.color)
			return sectionHeader
		}
	}

	func getCurrentStateSnapshot() -> NSDiffableDataSourceSnapshot<TodaySections, TodayNewsItem> {
		var snapshot = NSDiffableDataSourceSnapshot<TodaySections, TodayNewsItem>()
		snapshot.appendSections([.topStories, .otherTopStories, .science, .otherScience])

		snapshot.appendItems(todayNewsItems.topStoriesItems, toSection: .topStories)
		snapshot.appendItems(todayNewsItems.otherTopStoriesItems, toSection: .otherTopStories)
		snapshot.appendItems(todayNewsItems.scienceItems, toSection: .science)
		snapshot.appendItems(todayNewsItems.otherScienceItems, toSection: .otherScience)

		return snapshot
	}
}
