/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The localized strings the onboarding tutorial view uses.
*/

import Foundation

extension OnboardingTutorialView {
    struct LocalizedString {
        static let tooFewImagesTitle = NSLocalizedString(
            "Keep moving around your object. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "사물 주위를 계속 움직이세요.",
            comment: "Feedback title for when user has less than the minimum images required."
        )

        static let tooFewImagesDetailText = NSLocalizedString(
            "You need at least \(AppDataModel.minNumImages) images of your object to create a model. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "모델을 생성하려면 사물의 이미지가 최소 %d개 이상 필요합니다.",
            comment: "Feedback for when user has less than the minimum images required."
        )

        static let firstSegmentNeedsWorkTitle = NSLocalizedString(
            "Keep going to complete the first segment. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "계속해서 첫 번째 세그먼트를 완료하세요.",
            comment: "Feedback title for when user still has work to do to complete the first segment."
        )

        static let firstSegmentNeedsWorkDetailText = NSLocalizedString(
            """
            For best quality, capture three segments.
            Tap Skip if you can't make it all the way around, but your final model may have missing areas. (Review, Object Capture, 1st Segment)
            """,
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: """
                모델의 품질을 높이려면, 세그먼트 3개를 캡처하세요.
                모든 부분을 캡처하지 못하여 누락된 부분이 있을 수 있습니다. 이럴경우 skip을 탭하세요.
                """,
            comment: "Feedback for when user still has work to do to complete the first segment."
        )

        static let firstSegmentCompleteTitle = NSLocalizedString(
            "First segment complete. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "첫 번째 세그먼트가 완료되었습니다.",
            comment: "Feedback title for when user has finished capturing first segment."
        )

        static let firstSegmentCompleteDetailText = NSLocalizedString(
            "For best quality, capture three segments. (Review, Object Capture, 1st Segment)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "모델의 품질을 높이려면, 세그먼트 3개를 캡처하세요.",
            comment: "Feedback for when user has finished capturing first segment."
        )

        static let flipObjectTitle = NSLocalizedString(
            "Flip object on its side and capture again. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "사물을 옆으로 뒤집은 후 캡처를 진행하세요",
            comment: "Feedback title for when user should flip the object and capture again."
        )

        static let flipObjectDetailText = NSLocalizedString(
            "Make sure that areas you captured previously can still be seen. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "이전의 캡처한 영역이 계속 표시되는지 확인하세요. 사물의 모양이 바뀌었다면 뒤집지 마세요",
            comment: "Feedback for when user should flip the object and capture again"
        )

        static let flippingObjectNotRecommendedTitle = NSLocalizedString(
            "Flipping this object is not recommended. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "이 사물을 뒤집는 것은 권장되지 않습니다.",
            comment: "Feedback title that this object is likely to fail if flipped."
        )

        static let flippingObjectNotRecommendedDetailText = NSLocalizedString(
            """
            Your object may have single color surfaces or be too reflective to add more segments.
            Tap Continue to capture more detail without flipping, or Flip Object Anyway. (Review, Object Capture)
            """,
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: """
                사물의 단일 색상 표면이 있거나 너무 반사되어 세그먼트를 추가할 수 없습니다.
                Continue를 탭하지 않고 더 자세히 캡처하거나, 사물을 뒤집습니다.
                """,
            comment: "Feedback that this object is likely to fail if flipped."
        )

        static let captureFromLowerAngleTitle = NSLocalizedString(
            "Capture your object again from a lower angle. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "낮은 각도에서 사물을 다시 포착합니다.",
            comment: "Feedback title for when user should capture again from a lower angle given flipping isn't recommended."
        )

        static let captureFromLowerAngleDetailText = NSLocalizedString(
            "Move down to be level with the base of your object and capture again. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "아래로 이동하여 사물의 바닥과 수평을 이루고 다시 캡처합니다.",
            comment: "Feedback for when user should capture again from a lower angle given flipping isn't recommended."
        )

        static let secondSegmentNeedsWorkTitle = NSLocalizedString(
            "Keep going to complete the second segment. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "계속해서 두 번째 세그먼트를 완성합니다.",
            comment: "Feedback title for when user has not finished capturing second segment."
        )

        static let secondSegmentNeedsWorkDetailText = NSLocalizedString(
            """
            For best quality, capture three segments.
            Tap Skip if you can't make it all the way around but your final model may have missing areas. (Review, Object Capture, 2nd Segment)
            """,
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: """
                모델의 품질을 높이려면, 세그먼트 3개를 캡처하세요.
                모든 부분을 캡처하지 못하여 누락된 부분이 있을 수 있습니다. 이럴경우 skip을 탭하세요.
                """,
            comment: "Feedback title for when user has not finished capturing second segment."
        )

        static let secondSegmentCompleteTitle = NSLocalizedString(
            "Second segment complete. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "두 번째 세그먼트 완료.",
            comment: "Feedback title for when user has finished capturing second segment."
        )

        static let secondSegmentCompleteDetailText = NSLocalizedString(
            "For best quality, capture three segments. (Review, Object Capture, 2nd segment)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "모델의 품질을 높이려면, 세그먼트 3개를 캡처하세요.",
            comment: "Feedback title for when user has finished capturing second segment."
        )

        static let flipObjectASecondTimeTitle = NSLocalizedString(
            "Flip object on the opposite side and capture again. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "반대쪽으로 사물을 뒤집은 후 다시 캡처를 진행합니다.",
            comment: "Feedback title for when user has not flipped object on the opposite side."
        )

        static let flipObjectASecondTimeDetailText = NSLocalizedString(
            "Make sure that areas you captured previously can still be seen. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "이전에 캡처한 영역이 계속 표시되는지 확인합니다. 모양이 바뀌면 사물을 뒤집지 마십시오.",
            comment: "Feedback for when user has not flipped object on the opposite side."
        )

        static let captureFromHigherAngleTitle = NSLocalizedString(
            "Capture your object again from a higher angle. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "더 높은 각도에서 사물을 다시 포착합니다.",
            comment: "Feedback title for when user should capture again from a higher angle given flipping isn't recommended."
        )

        static let captureFromHigherAngleDetailText = NSLocalizedString(
            "Move above your object and make sure that areas you captured previously can still be seen. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "사물 위로 이동하여 이전에 캡처한 영역이 여전히 표시되는지 확인합니다.",
            comment: "Feedback for when user should capture again from above given flipping isn't recommended."
        )

        static let thirdSegmentNeedsWorkTitle = NSLocalizedString(
            "Keep going to complete the final segment. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "계속해서 최종 세그먼트를 완성합니다.",
            comment: "Feedback title for when user still has work to do to complete the final segment."
        )

        static let thirdSegmentNeedsWorkDetailText = NSLocalizedString(
            "For best quality, capture three segments. When you're done, tap Finish to complete your object. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "모델의 품질을 높이려면, 세그먼트 3개를 캡처하세요. 캡처를 완료했으면 Finish를 탭하여 모델을 생성합니다.",
            comment: "Feedback for when user still has work to do to complete the final segment."
        )

        static let thirdSegmentCompleteTitle = NSLocalizedString(
            "All segments complete. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "모든 세그먼트를 완료했습니다.",
            comment: "Feedback title for when user has finished capturing final segment."
        )

        static let thirdSegmentCompleteDetailText = NSLocalizedString(
            "Tap Finish to process your object. (Review, Object Capture)",
            bundle: AppDataModel.bundleForLocalizedStrings,
            value: "Finish를 탭하여 모델을 생성합니다.",
            comment: "Feedback for when user has finished capturing final segment."
        )
    }
}
