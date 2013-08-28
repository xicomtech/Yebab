//
//  Globals.h
//  shareHappiness
//
//  Created by rahul mahajan on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


/*
 * Author:  Sudhanshu Srivastava
 * Purpose: To manage free/paid version of the app.
 * Date:    04Jan2013
 */

#define PASSWORD_REG_EXP @"[A-Z0-9a-z._-]{1,50}"
#define EMAIL_REG_EXP @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"


/******* STAGING URLs *******/


#define  userImagePlaceHolder [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NewPlaceholder" ofType:@"png"]]
#define  HOST_URL @"http://yebab.com/yebab_api/"

#define GET_IMAGE_HOST_URL    @"http://yebab.com"

/************ Api List **************/

#define REGISTER_NEW_EMAIL_USER     @"user_profile/add"
#define home_Screen_Tab             @"home_screen"
#define LIKE                        @"like_pin/like"
#define UNLIKE                      @"like_pin/unlike"
#define POST_COMMENT                @"comment_on_pin"
#define GET_COMMENT                 @"pin_comments"
#define DISCOVER_SCREEN             @"discover_screen"
#define HASH_TAGS                   @"trending_hashtags"
#define TRENDING_USERS              @"trending_users"
#define STORE_SCREEN                @"stores_screen"
#define ADD_ALBUM                   @"lists"
#define SAVE_ALBUM                  @"add_album"
#define EDIT_IMAGE_ALBUM            @"add_album_image"
#define SAVE_IMAGE                  @"upload_image"
/**************************/
#define kPostCreateProfile  @"http://demo.xicom.us/defindme/www/webservices/users/test_photo/"

/* * * * * * * * * * * * * */




#define COUNTRIES_LIST_ARR   [NSArray arrayWithObjects:@"United Arab Emirates", @"Saudi Arabia",@"Oman",@"Bahrain",@"Kuwait",@"Qatar",@"Egypt",@"Jordan",@"Iraq",@"Morocco",@"Syria",@"Algeria",@"Tunisia",@"Palestinian Territory",@"Libya",@"Lebanon",@"United States",@"United Kingdom",@"Spain",@"France",@"Germany",@"Italy",@"Netherlands",@"Sweden",@"Russia",@"Australia",@"Canada",nil];

#define COUNTRIES_CODE_LIST_ARR   [NSArray arrayWithObjects:@"ae", @"sa",@"om",@"bh",@"kw",@"qa",@"eg",@"jo",@"iq",@"ma",@"sy",@"al",@"tu",@"ps",@"ly",@"lb",@"am",@"uk",@"sp",@"fr",@"gr",@"it",@"nl",@"sw",@"rs",@"as",@"cd",nil];

#define CITIES_DICTIONARY_ARR     [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"Dubai",@"1",@"Sharjah",@"2",@"Abudhabi",@"3",@"Al Ain",@"4",@"Ajman",@"5",@"Ras AlKhaima",@"6",@"Um AlQuwain",@"7",@"Fujairah",@"8",nil],@"United Arab Emirates",[NSDictionary dictionaryWithObjectsAndKeys:@"Riyadh",@"9", @"Jeddah",@"10", @"Mecca",@"11", @"Medina",@"12", @"Dammam",@"13", @"Taif",@"14", @"Khobar",@"15", @"Sharqeya",@"16", @"Yanbu",@"17", @"Others",@"18",nil],@"Saudi Arabia",[NSDictionary dictionaryWithObjectsAndKeys:@"Muscat",@"24", @"Sohar",@"25", @"Others",@"26",nil],@"Oman",[NSDictionary dictionaryWithObjectsAndKeys:@"Manama",@"29", @"Muharraq",@"30", @"Others",@"31",nil],@"Bahrain",[NSDictionary dictionaryWithObjectsAndKeys:@"Kuwait",@"32", @"Others",@"33",nil],@"Kuwait",[NSDictionary dictionaryWithObjectsAndKeys:@"Doha",@"27", @"Others",@"28",nil],@"Qatar",[NSDictionary dictionaryWithObjectsAndKeys:@"Cairo",@"19", @"Giza",@"20", @"Alexandria",@"21", @"Damietta",@"22", @"Others",@"23",nil],@"Egypt",[NSDictionary dictionaryWithObjectsAndKeys:@"Amman",@"34",@"Others",@"35",nil],@"Jordan",[NSDictionary dictionaryWithObjectsAndKeys:@"Baghdad",@"36",@"Others",@"37",nil],@"Iraq",[NSDictionary dictionaryWithObjectsAndKeys:@"Casablanca",@"38",@"Fas",@"39",@"Rabat",@"40",@"Others",@"41",nil],@"Morocco",[NSDictionary dictionaryWithObjectsAndKeys:@"Damascus",@"42",@"Others",@"43",nil],@"Syria",[NSDictionary dictionaryWithObjectsAndKeys:@"Algiers",@"44",@"Others",@"45",nil],@"Algeria",[NSDictionary dictionaryWithObjectsAndKeys:@"Tunis",@"46",@"Others",@"47",nil],@"Tunisia",[NSDictionary dictionaryWithObjectsAndKeys:@"Jerusalem",@"48",@"West Bank",@"49",@"Gaza",@"50",@"Others",@"51",nil],@"Palestinian Territory",[NSDictionary dictionaryWithObjectsAndKeys:@"Tripoli",@"52",@"Benghazi",@"53",@"Others",@"54",nil]],@"Libya",[NSDictionary dictionaryWithObjectsAndKeys:@"Bierut",@"55",@"Others",@"56",nil],@"Lebanon",[NSDictionary dictionaryWithObjectsAndKeys:@"Nebraska",@"57",@"California",@"58",@"New Jersey",@"59",@"New York",@"60",@"Illinois",@"61",@"Texas",@"62",@"Others",@"63",nil],@"United States",[NSDictionary dictionaryWithObjectsAndKeys:@"London",@"64",@"Manchester",@"65",@"Others",@"66",nil],@"United Kingdom",[NSDictionary dictionaryWithObjectsAndKeys:@"Madrid",@"67",@"Others",@"68",nil],@"Spain",[NSDictionary dictionaryWithObjectsAndKeys:@"Paris",@"69",@"Others",@"70",nil],@"France",[NSDictionary dictionaryWithObjectsAndKeys:@"Munich",@"71",@"Others",@"72",nil],@"Germany",[NSDictionary dictionaryWithObjectsAndKeys:@"Roma",@"73",@"Others",@"74",nil],@"Italy",[NSDictionary dictionaryWithObjectsAndKeys:@"Amsterdam",@"75",@"Others",@"76",nil],@"Netherlands",[NSDictionary dictionaryWithObjectsAndKeys:@"Stockholm",@"77",@"Others",@"78",nil],@"Sweden",[NSDictionary dictionaryWithObjectsAndKeys:@"Moscow",@"79",@"Others",@"80",nil],@"Russia",[NSDictionary dictionaryWithObjectsAndKeys:@"Sydney",@"81",@"Others",@"82",nil],@"Australia",[NSDictionary dictionaryWithObjectsAndKeys:@"Toronto",@"83",@"Others",@"84",nil],@"Canada",nil];

#define FB_PERMISSION_ARR [NSArray arrayWithObjects:@"user_birthday", @"email",@"publish_stream",@"offline_access",@"user_photos", nil]//@"publish_stream",



extern NSString* NAV_TITLE;
extern NSString* USER_ID;
extern NSString* IS_FB_USER;
extern NSString* DEVICE_TOKEN;
extern NSInteger ITEM_PER_PAGE;
extern NSString* TIME_STAMP;
extern BOOL fetchedInstagram;
extern NSString* GMAIL_ACCESS_TOKEN;

extern NSString* TWITTER_OAUTH_TOKEN;
extern NSString* TWITTER_OAUTH_SECRET;
extern NSString* TWITTER_OAUTH_VERIFIER;

extern BOOL IS_UPLOADING;
extern BOOL SHOULD_UPLOAD_MEDIA;
extern NSDictionary* SHARE_DIC;
extern BOOL SHOW_LOADER;


#define ITEM_PER_PAGE     8

typedef enum{
	kShareImage = 0,
	kShareMovie
} SHMediaType;