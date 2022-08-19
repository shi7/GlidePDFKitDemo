// Copyright © Compass. All rights reserved.

import Foundation
import SwiftUI

/// Icons are assets meant to represent actions: Email, Print, Save, Comment, Close.
/// Icons can exist on their own and do not require written description. They are often used in buttons.
public enum Icon: String, CaseIterable {
    case alert
    case arrowDown = "arrow_down"
    case arrowDownPCI = "icon_nakedpci_arrowdown"
    case arrowDownWithLines = "arrow_down_with_lines"
    case arrowLeft = "arrow_left"
    case arrowLocator = "arrow_locator"
    case arrowRight = "arrow_right"
    case arrowRightInRectangle = "arrow_right_in_rectangle"
    case arrowUp = "arrow_up"
    case arrowUpInRectangle = "arrow_up_in_rectangle"
    case arrowUpPCI = "icon_nakedpci_arrowup"
    case arrowWithLineBelow = "arrow_with_line_below"
    case arrowWithSquares = "arrow_with_squares"
    case arrowsFourCorners = "arrows_four_corners"
    case bell
    case boxMultiple = "box_multiple"
    case bus
    case calendar
    case camera
    case car
    case chatBubble = "chat_bubble"
    case chatBubbles = "chat_bubbles"
    case checklist
    case checkmark
    case chevronDown = "chevron_down"
    case chevronLeft = "chevron_left"
    case chevronRight = "chevron_right"
    case chevronUp = "chevron_up"
    case circleCheckmark = "circle_checkmark"
    case circleEmpty = "circle_empty"
    case circleInfo = "circle_info"
    case circleMinus = "circle_minus"
    case circleOutlined = "circle_outlined"
    case circlePlus = "circle_plus"
    case circleQuestion = "circle_question"
    case circleWithCheckmark = "circle_with_checkmark"
    case circleWithLowerCaseI = "circle_with_lowercase_i"
    case circleWithMinus = "circle_with_minus"
    case circleWithPlus = "circle_with_plus"
    case circleWithQuestionMark = "circle_with_question_mark"
    case circleWithSlash = "circle_with_slash"
    case circleWithX = "circle_with_x"
    case circleX = "circle_x"
    case clock
    case compass
    case compassLogo = "compass_logo"
    case download
    case dotsInTwoVerticalRows = "dots_in_two_vertical_rows"
    case drafts
    case drag
    case drawHand = "draw_hand"
    case drawPencil = "draw_pencil"
    case duplicate
    case edit
    case ellipsisHorizontal = "ellipsis_horizontal"
    case envelope
    case expand
    case export
    case filters
    case gear
    case globe
    case government
    case governmentBuilding = "government_building"
    case grid
    case handDrawing = "hand_drawing"
    case heartFilled = "heart_filled"
    case heartOutlined = "heart_outlined"
    case linesStackedFour = "lines_stacked_four"
    case linesStackedThree = "lines_stacked_three"
    case link
    case list
    case locator
    case lock
    case mail
    case magnifyingGlass = "magnifying_glass"
    case map
    case mapTrifold = "map_trifold"
    case mapTrifoldWithLocationMarkers = "map_trifold_with_location_markers"
    case marketingCenter = "marketing_center"
    case menu
    case minus
    case more
    case no
    case notification
    case openInNew = "open_in_new"
    case padlock
    case paperclip
    case pencil
    case pencilDrawing = "pencil_drawing"
    case pencilWithPaper = "pencil_with_paper"
    case people
    case person
    case personWalking = "person_walking"
    case personWithCheckmark = "person_with_checkmark"
    case personWithPlus = "person_with_plus"
    case phone
    case plus
    case print
    case printer
    case radius
    case search
    case settings
    case share
    case signPost = "sign_post"
    case sliderControls = "slider_controls"
    case sort
    case starFilled = "star_filled"
    case starOutlined = "star_outlined"
    case squareWithCopy = "square_with_copy"
    case squaresInThreeRows = "squares_in_three_rows"
    case squaresLayered = "squares_layered"
    case squareTriangleCircle = "square_triangle_circle"
    case thumbsDownFilled = "thumbs_down_filled"
    case thumbsDownOutlined = "thumbs_down_outlined"
    case thumbsUpFilled = "thumbs_up_filled"
    case thumbsUpOutlined = "thumbs_up_outlined"
    case tour
    case transit
    case trash
    case trashCan = "trash_can"
    case triangleDown = "triangle_down"
    case triangleUp = "triangle_up"
    case triangleUpDown = "triangle_up_down"
    case triangleUpAndDown = "triangle_up_and_down"
    case triangleWithExclamationPoint = "triangle_with_exclamation_point"
    case user
    case userCheckmark = "user_checkmark"
    case userPlus = "user_plus"
    case users
    case video
    case videoCamera = "video_camera"
    case walking
    case x

    case coreLogic = "corelogic"
    case excel
    case facebook
    case googleMaps = "g_maps"
    case gSuite = "g_suite"
    case instagram
    case linkedIn = "linked_in"
    case lyft
    case mailchimp
    case pinterest
    case showingTime = "showingtime"
    case streetEasy = "streeteasy"
    case twitter
    case uber
    case waze
    case wsj
    case zillow
}
