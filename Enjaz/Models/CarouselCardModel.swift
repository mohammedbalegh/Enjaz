import UIKit

struct CarouselCardModel {
    let carouselImage = [UIImage(named: "carousel1"), UIImage(named: "carousel2"), UIImage(named: "carousel3"), UIImage(named: "carousel4")]
    let mainLabel = [
		"Welcome to Enjaz App".localized,
		"Finish Tasks on Time".localized,
		"Reminding You of Repeating Habits".localized,
		"Keep Track of Your Achievements' Stats".localized
	]
	
    let secondaryLabel = [
        "We're delighted to have you on board. Because your life desreves achievement, we're here".localized,
        "Register your appintments, write down your goals and keep track of them".localized,
        "Keep track of your personal habits".localized,
        "Keep trck of your progress and see your rewards".localized
	]
}
