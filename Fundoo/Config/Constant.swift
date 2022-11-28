//
//  Constant.swift
//  Randoo
//
//  Created by HTS-Product on 31/01/19.
//  Copyright © 2019 Hitasoft. All rights reserved.
//

import Foundation
import Lottie
import UIKit

//MARK: Size configuration
let FULL_WIDTH = UIScreen.main.bounds.width
let FULL_HEIGHT = UIScreen.main.bounds.height

//COLORS
let TEXT_PRIMARY_COLOR = UIColor().hexValue(hex: "#252525")
let TEXT_SECONDARY_COLOR = UIColor().hexValue(hex: "#6e6e6e")
let LINE_COLOR = UIColor().hexValue(hex: "#d5d5d5")
let CHAT_RIGHT_COLOR = UIColor().hexValue(hex: "#ffffff")
let GALLERY_CIRCLE_BG = UIColor().hexValue(hex: "#f0f0f0")
let MILD_PRIMARY_COLOR = UIColor().hexValue(hex: "#F6BCB3")
//Other colors
let CIRCLE_BG_COLOR = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
let PINK_DARK_COLOR = UIColor().hexValue(hex: "#A11771")
let STICKERVIEW_BORDER = UIColor().hexValue(hex: "#2A2A2A")
//let CHAT_SEND = UIColor.init(red: 255.0/255.0, green: 242.0/255.0, blue: 239.0/255.0, alpha: 1.0)

let CHAT_SEND = UIColor.init(red: 251.0/255.0, green: 232.0/255.0, blue: 232.0/255.0, alpha: 1.0)
let CHAT_RECEIVE = UIColor().hexValue(hex: "#FFFFFF")

let BLACK_COLOR = UIColor.black
let LIVE_COLOR = UIColor(red: 219.0/255.0, green: 32.0/255.0, blue: 70.0/255.0, alpha: 1.0)
let TEXT_COLOR = UIColor(red: 58.0/255.0, green: 58.0/255.0, blue: 58.0/255.0, alpha: 1.0)
let BLUE_BG = UIColor(red: 54, green: 13, blue: 225, alpha: 1.0)
let SECONDARY_COLOR = UIColor().hexValue(hex: "#eb6705")
let FOLLOW_BACKGROUND_COLOR = UIColor().hexValue(hex: "#999999")

let TABBAR_COLOR = UIColor().hexValue(hex: "#D1D1D1")
let TRENDING_TITLE_COLOR = UIColor().hexValue(hex: "#07090E")
let MUSIC_DESC_COLOR = UIColor().hexValue(hex: "#707070")
let PROFILE_TITLE_COLOR = UIColor().hexValue(hex: "#444444")

let cameraVcproperties = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)


let topColor = UIColor().hexValue(hex: "#DCDCDC")

//MARK: Config color
let mildcolor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
let TABBAR_SHADOW_COLOR = #colorLiteral(red: 0.2899999917, green: 0.2899999917, blue: 0.2899999917, alpha: 0.35)
let TABBAR_BACKGROUND_COLOR = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)

let PRIMARY_COLOR = #colorLiteral(red: 0.8666666667, green: 0.2, blue: 0.2, alpha: 1)
let PRIMARY_COLOR1 = #colorLiteral(red: 0.4392156899, green: 0.9072793477, blue: 0.1921568662, alpha: 0.3600127551)

let PRIMARY_COLOR_DISABLED = #colorLiteral(red: 0.8666666746, green: 0.2000000179, blue: 0.2000000179, alpha: 0.7589523619)

let SEPARATOR_COLOR = #colorLiteral(red: 0.262745098, green: 0.2705882353, blue: 0.2823529412, alpha: 1)
let PLACEHOLDER_COLOR = #colorLiteral(red: 0.6352941176, green: 0.6352941176, blue: 0.6352941176, alpha: 1)
let GRADIENT_PRIMARY_COLOR = [UIColor().hexValue(hex: "#F07964").cgColor, UIColor().hexValue(hex: "#F07964").cgColor]

let selectedTabBarItemColor = UIColor(named: "tabBar_SelectedImgTintColor")
let unselectedTabBarItemColor = UIColor(named: "tabBar_UnselectedImgTintColor")
let appBgColor = UIColor(named: "appBgColor")
let headingColor = UIColor(named: "HeadingColor")
let subHeadingDarkColor = UIColor(named: "subHeadingColor_DarkGray")
let subHeadingLightColor = UIColor(named: "subHeadingColor_lightGray")

// MARK: - image config
let PLACE_HOLDER_IMG = UIImage.init(named: "user_placeholder")

////MARK: Config Font
//let APP_FONT_REGULAR = "Proxima Nova Regular"
//let APP_FONT_LIGHT = "Proxima Nova Light"
//let APP_FONT_BOLD = "Proxima Nova Bold"

//MARK: Config Font
let APP_FONT_REGULAR = "Rubik-Regular"
let APP_FONT_LIGHT = "Rubik-Regular"
let APP_FONT_BOLD = "Rubik-Bold"
let APP_FONT_SEMI_BOLD = "Rubik-Medium"


//MARK: Font sizes
let headHigh = UIFont.init(name: APP_FONT_REGULAR, size: 40)
let titleHigh = UIFont.init(name: APP_FONT_REGULAR, size: 30)
let subHigh = UIFont.init(name: APP_FONT_REGULAR, size: 35)
let high = UIFont.init(name: APP_FONT_REGULAR, size: 28)
let averageReg = UIFont.init(name: APP_FONT_REGULAR, size: 19)
let mediumReg = UIFont.init(name: APP_FONT_REGULAR, size: 17)
let liteReg = UIFont.init(name: APP_FONT_REGULAR, size: 15)
let smallReg = UIFont.init(name: APP_FONT_REGULAR, size: 13)
let regular_14 = UIFont.init(name: APP_FONT_REGULAR, size: 14)
let regular_16 = UIFont.init(name: APP_FONT_REGULAR, size: 16)
let regular_12 = UIFont.init(name: APP_FONT_REGULAR, size: 12)
let lowReg = UIFont.init(name: APP_FONT_REGULAR, size: 11)
let small_lowReg = UIFont.init(name: APP_FONT_REGULAR, size: 9)

let average = UIFont.init(name: APP_FONT_LIGHT, size: 19)
let medium = UIFont.init(name: APP_FONT_LIGHT, size: 17)
let lite = UIFont.init(name: APP_FONT_LIGHT, size: 15)
let small = UIFont.init(name: APP_FONT_LIGHT, size: 13)
let low = UIFont.init(name: APP_FONT_LIGHT, size: 11)

let medium_15 = UIFont.init(name: APP_FONT_SEMI_BOLD, size: 15)
let medium_14 = UIFont.init(name: APP_FONT_SEMI_BOLD, size: 14)
let medium_16 = UIFont.init(name: APP_FONT_SEMI_BOLD, size: 16)
let medium_12 = UIFont.init(name: APP_FONT_SEMI_BOLD, size: 12)
let medium_13 = UIFont.init(name: APP_FONT_SEMI_BOLD, size: 13)
let medium_10 = UIFont.init(name: APP_FONT_SEMI_BOLD, size: 10)
let medium_8 = UIFont.init(name: APP_FONT_SEMI_BOLD, size: 8)


let subHighBold = UIFont.init(name: APP_FONT_BOLD, size: 35)
let titleHighBold = UIFont.init(name: APP_FONT_BOLD, size: 30)
let averageBold = UIFont.init(name: APP_FONT_BOLD, size: 19)
let mediumBold = UIFont.init(name: APP_FONT_BOLD, size: 17)
let liteBold = UIFont.init(name: APP_FONT_BOLD, size: 15)
let lowbold = UIFont.init(name: APP_FONT_BOLD, size: 13)



//MARK: user status
let OFFLINE = "0"
let ONLINE = "1"
let IN_SEARCH = "2"
let IN_CHAT =  "3"

let RISTRICTED_CHARACTERS = "'*=+[]\\|;:'\",<>/?%!@#$^&(){}[].~-_£€₹"
let USERNAME_CHARACTERS = "'*=+[]\\|;:'\",<>/?%!@#$^&(){}[].~-_£€₹ "
let PHOTO_LIBRARY = "Please enable the Photo Library authentication"
let URL_EMPTY = "This Video URL doesn't exist!"
let INSTA_ALERT = "Instagram is not opening!"
let INSTA_APPSTORE_URL = "https://apps.apple.com/us/app/instagram/id389801252?mt=8"
let WHATSAPP_APPSTORE_URL = "https://apps.apple.com/us/app/whatsapp-messenger/id310633997?mt=8"
let MESSANGER_APPSTORE_URL = "https://apps.apple.com/us/app/messenger/id454638411?mt=8"
let FACEBOOK_APPSTORE_URL = "https://apps.apple.com/in/app/facebook/id284882215?mt=8"
let APPLE_MUSIC_APPSTORE_URL = "https://apps.apple.com/us/app/apple-music/id1108187390?mt=8"
let NO_VIDEOS = "NO Video's Found!"
let INSTALL_WHATSAPP = "Please Install WhatsApp"
let INSTALL_INSTAGRAM = "Please Install Instagram"
let INSTALL_MESSANGER = "Please Install Messenger"
let ALERT = "Alert!"
let OK = "OK"
let CANCEL = "Cancel"
let LINK_COPIED = "Link Copied to Clipboard"
let FB_ALERT = "Please install Facebook"
let MUSIC_ALERT = "Please install Apple Music App to access media library"

let navigationCo = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController

let EMPTY_STRING = ""

//MARK: -Device names
let kIphone_4s : Bool =  (UIScreen.main.bounds.size.height == 480)
let kIphone_SE: Bool =  (UIScreen.main.bounds.size.height == 568)
let kIphone_8 : Bool =  (UIScreen.main.bounds.size.height == 667)
let kIphone_8_Plus : Bool =  (UIScreen.main.bounds.size.height == 736)
let kIphone_11_Pro : Bool =  (UIScreen.main.bounds.size.height == 812)
let kIphone_11_ProMAX : Bool =  (UIScreen.main.bounds.size.height >= 896)
let kIphone_ABOVE_X : Bool = (UIScreen.main.bounds.size.height >= 812)

let IS_IPHONE_X = UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
let IS_IPHONE_XS_MAX_11_PRO_MAX = UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2688
let IS_IPHONE_11 = UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 1792
let IS_IPHONE_XR = UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 1624
let IS_IPHONE_PLUS = UIDevice().userInterfaceIdiom == .phone && (UIScreen.main.nativeBounds.height == 2208 || UIScreen.main.nativeBounds.height == 1920)
let IS_IPHONE_678 = UIDevice().userInterfaceIdiom == .phone && (UIScreen.main.nativeBounds.height == 1334)
let IS_IPHONE_5 = UIDevice().userInterfaceIdiom == .phone && (UIScreen.main.nativeBounds.height == 1136)


//MARK: -IMAGES
let PLACEHOLDER_IMG = UIImage(named: "placeholder_image")
let PAYPAL_RESTRICTED_CHARACTERS = "'*=+[]\\|;:'\",<>/?%!#$^&(){}[]~-_£€₹"
