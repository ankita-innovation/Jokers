//
//  Config.swift
//  Randoo
//
//  Created by HTS-Product on 31/01/19.
//  Copyright © 2019 Hitasoft. All rights reserved.

import Foundation

//MARK: Default Language **************
let DEFAULT_LANGUAGE = "English" // default app language

//MARK: Encrypt Key **************
let ENCRYPT_KEY = "crypt@123" // message encryption key.

//MARK: PUSH NOTIFICATION **************

let DEVICE_MODE = "1" //0-Development, 1-Production

//Change entitlements APS Environment "development/production"
//AppDelegate change APNSToken type "sandbox/prod" under "didRegisterForRemoteNotificationsWithDeviceToken"

//MARK: In-App purchase Validation **************
let IAP_VALIDATION_URL = "https://sandbox.itunes.apple.com/verifyReceipt" // sandbox
//let IAP_VALIDATION_URL = "https://buy.itunes.apple.com/verifyReceipt" // live
let APP_NAME = "Jokerz"

// MARK: Dynamic links

let DYNAMIC_LINK = "https://jokerz.page.link" // create it from firebase dynamic link section
let IOS_BUNDLE_ID = "com.app.jokerz"
let ANDROID_PACKAGE_NAME = "com.app.jokerz" // android app package name
let APP_STORE_ID = "6443896837" // get it from itunes connect once create the app
////In-App purpose
let APP_SPECIFIC_SHARED_SECRET = "" // only do if you in app purchase don't disturb here
let APP_RTC_URL = "" // for webrtc don't disturb here
let GOOGLE_API_KEY = "AIzaSyD8S1BNDWS4yiPZuII49550Ya8DKh-Jp-Y"


// Joker addon
let SITE_URL = "https://jokerz.fun/" // site main url
let BASE_URL = "http://161.35.75.156:8989" //"https://jokerz.fun/api/"//"https://jokerz.fun:8989" // base url for all api
let WEB_SOCKET_CHAT_URL = "http://178.62.226.116:8990" // socket for chat
let INVITE_URL = "http://178.62.226.116"

// MARK: FUNDOO

//API - attachment URL **************
let PROFILE_IMAGE_URL = "\(SITE_URL)/fundoo_29/public/img/accounts/"
let GIFT_IMAGE_URL = "\(SITE_URL)/fundoo_29/public/img/gifts/"
let PRIME_IMAGE_URL = "\(SITE_URL)/fundoo_29/public/img/slider/"
let GEMS_IMAGE_URL = "\(SITE_URL)/fundoo_29/public/img/gems/"
let CHAT_IMAGE_URL = "\(SITE_URL)/fundoo_29/public/img/chats/"

//status
let SUCCESS = "true"
let FAILURE = "false"

// API's
let SIGNIN_API = "/accounts/signin"
let SIGNUP_API = "/accounts/signup"
let PROFILE_API = "/accounts/profile"
let PROFILE_PIC_API = "/accounts/uploadprofile"
let RTC_PARAMS_API = "/chats/rtcparams"
let FOLLOWERS_API = "/activities/followerslist"
let FOLLOWINGS_API = "/activities/followingslist"
let FOLLOW_API = "/activities/follow"
let ISMUTUAL_FOLLOW_API = "/activities/isMutualfollow"
let PUSH_SIGNIN_API = "/devices/register"
let PUSH_SIGNOUT_API = "/devices/unregister"
let TERMS_API = "/helps/loginterms"
let APP_DEFAULT_API = "/activities/appdefaults"
let GEMS_LIST_API = "/activities/gemstore"
let GEMS_PURCHASE_API = "/payments/purchasegems"
let PRIME_PURCHASE_API = "/payments/subscription"
let GIFT_TO_GEM_API = "/activities/gifttogems"
let HELP_API = "/helps/allterms"
let REWARD_VIDEO_API = "/accounts/rewardvideo"
let UPLOAD_CHAT_API = "/accounts/upmychat"
let ADMIN_MSG_API = "/activities/adminmessages"
let CHECK_ACTIVE_API = "/accounts/isActive"
let RENEWAL_SUBSCRIPTION = "/payments/autorenewalsubscription"
let INVITE_CREDITS = "/accounts/invitecredits"
let CHARGE_CALL_API = "/accounts/chargecalls"
let BLOCK_USER_API = "/activities/blockuser"
let BLOCKED_LIST_API = "/activities/blockeduserslist"
let END_CALL_API = "/activities/endcall"
let ALL_USER_API = "/accounts/showall"
let CREATE_STREAM_API = "/livestreams/createstream"
let UPLOAD_THUMBNAIL_API = "/livestreams/uploadstream"
let REPORT_STREAM_API = "/livestreams/reportstream"
let GET_HASHTAG_API = "/activities/hashtags"
let TRENDING_HASHTAG_API = "/activities/trendinghashtags"
let POST_VIDEO_API = "/livestreams/postvideo"
let SINGLE_VIDEO_API = "/livestreams/singlevideo"
let GET_ALL_VIDEOS_API = "/livestreams/getallvideos"

let HOME_API = "/livestreams/home"
let HEART_API = "/livestreams/heart"
let SEND_GIFTS_API = "/livestreams/sendgift"
let POST_COMMENTS_API = "/chats/postcomment"
let GET_COMMENTS_API = "/chats/getcomment"
let GET_NOTIFICATION_API = "/activities/notifications"
let DELETE_COMMENTS_API = "/chats/deletecomment"
let SOUND_FIND_URL_API = "/activities/findsounds"
let SEARCH_API = "/activities/search"
let HOME_SEARCH_API = "/activities/homesearch"
let CATEGORY_SEARCH_API = "/activities/categorysearch"

let GET_FAVOURITE = "/activities/getfavorites"
let GETVIDEO_API = "/livestreams/getvideos"
let ADD_FAVORITE = "/activities/addfavorite"
let DELETE_VIDEO_API = "/livestreams/deleteVideo"
let UPDATE_VIDEO_API = "/livestreams/updatevideo"
let SAVE_INTEREST_API = "/accounts/saveinterest"
let INTEREST_API = "/accounts/getInterests"
let UPLOAD_SOUND_API = "/activities/uploadsound"
let UPLOAD_ALBUM_IMAGE_API = "/activities/albumimage"

//Unused

let REPORT_ATTACHMENT_API = "/activities/uploadreport"
let REPORT_USER_API = "/activities/reportuser"
let UPDATE_WATCH_API = "/activities/updatewatchcount"
let SHARE_STREAM_API = "/livestreams/sharestream"
let EXPLORE_STREAMS_API = "/activities/explorestreams"
let WATCH_HISTORY_API = "/activities/watchhistory"
let CLEAR_WATCH_HISTORY_API = "/activities/clearwatchhistory"
let MUTUAL_LIST_API = "/activities/mutualfollowers"
let TRENDING_COUNTRIES_API = "/activities/popularcountries"
let LIVE_STREAM_API = "/livestreams"
let NEAR_USER_API = "/accounts/nearbyusers"
let UNLOCK_USER_API = "/activities/unlockinterest"
let RECENT_VIDEOCHATS_API = "/chats/recentvideochats"
let DELETE_VIDEOCHATS_API = "/chats/clearvideochats"
let IN_SEARCH_API = "/chats/insearch"
let MAKE_INTEREST_API = "/activities/interest"
let SEARCH_USER_API = "/accounts/searchuser"
let CHARGE_FILTERS_API = "/accounts/chargefilters"
let START_STREAM_API = "/livestreams/startstream"
let STOP_STREAM_API = "/livestreams/stopstream"
let STREAM_INFO_API = "/livestreams/streamdetails"

let BLOCK_DETAILS_API = "/activities/blockdetails"
let DELETE_ACCOUNT_API = "/accounts/deleteaccount"

// addon
let GIPHY_API_KEY = "or4yESJhLlDX0DHe65nAZxtYps4Ve5EM"
let VALIDATE_POPUP = "/accounts/validate_popup"
