const Map<dynamic, dynamic> previousBookingsJson = {
  "version": "1.0",
  "screen": "previous_bookings",

  "meta": {
    "generatedAt": "2026-05-18T17:25:00Z",
    "cacheKey": "previous_bookings_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {"title": "Previous Bookings"},

    "bookings": {
      "searchPlaceholder": "Search by booking ID or location...",
      "filters": [
        {"id": "all", "label": "All Bookings"},
        {"id": "completed", "label": "Completed"},
        {"id": "cancelled", "label": "Cancelled"},
        {"id": "upcoming", "label": "Upcoming"},
      ],
      "sortOptions": ["Latest First", "Oldest First"],

      "items": [
        {
          "id": "BK-2026-0509",
          "dateTime": "2026-05-12 10:00",
          "status": "upcoming",
          "statusLabel": "Booked · Awaiting pickup",
          "vehicleName": "Hybrid Estate",
          "route": "Bristol Temple Meads → Bristol Airport",
          "image":
              "https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=300",
          "price": "£189",
          "priceType": "One-way",
          "primaryAction": "Pre-rental",
          "primaryActionType": "pre_rental",
          "showBookAgain": false,
          "showRating": false,
          "rating": "",
        },
        {
          "id": "BK-2026-0415",
          "dateTime": "2026-04-15 09:00",
          "status": "completed",
          "statusLabel": "Completed",
          "vehicleName": "Premium Sedan",
          "route": "London Heathrow → London Heathrow",
          "image":
              "https://images.unsplash.com/photo-1549924231-f129b911e442?w=300",
          "price": "£267",
          "priceType": "Return",
          "primaryAction": "Book Again",
          "primaryActionType": "book_again",
          "showBookAgain": true,
          "showRating": true,
          "rating": "4.8",
        },
        {
          "id": "BK-2026-0325",
          "dateTime": "2026-03-25 10:00",
          "status": "completed",
          "statusLabel": "Completed",
          "vehicleName": "Electric Premium",
          "route": "Birmingham → Birmingham",
          "image":
              "https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=300",
          "price": "£447",
          "priceType": "Return",
          "primaryAction": "Book Again",
          "primaryActionType": "book_again",
          "showBookAgain": true,
          "showRating": true,
          "rating": "5.0",
        },
        {
          "id": "BK-2026-0315",
          "dateTime": "2026-03-15 11:00",
          "status": "cancelled",
          "statusLabel": "Cancelled",
          "vehicleName": "City Compact",
          "route": "London City → London City",
          "image":
              "https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=300",
          "price": "£180",
          "priceType": "Hourly",
          "primaryAction": "",
          "primaryActionType": "",
          "showBookAgain": false,
          "showRating": false,
          "rating": "",
        },
        {
          "id": "BK-2026-0301",
          "dateTime": "2026-03-01 08:00",
          "status": "cancelled",
          "statusLabel": "No-show",
          "vehicleName": "Executive SUV",
          "route": "Manchester Airport → Manchester City",
          "image":
              "https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=300",
          "price": "£315",
          "priceType": "One-way",
          "primaryAction": "",
          "primaryActionType": "",
          "showBookAgain": false,
          "showRating": false,
          "rating": "",
        },
        {
          "id": "BK-2026-0224",
          "dateTime": "2026-02-24 14:30",
          "status": "completed",
          "statusLabel": "Completed",
          "vehicleName": "Luxury Saloon",
          "route": "Oxford Station → Oxford City Centre",
          "image":
              "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=300",
          "price": "£225",
          "priceType": "One-way",
          "primaryAction": "Book Again",
          "primaryActionType": "book_again",
          "showBookAgain": true,
          "showRating": true,
          "rating": "4.9",
        },
      ],
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},
    "viewBooking": {"type": "view_booking", "params": {}},
    "openPreRental": {"type": "open_pre_rental", "params": {}},
    "bookAgain": {"type": "book_again", "params": {}},
    "downloadReceipt": {"type": "download_receipt", "params": {}},
    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "previous_bookings_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-md"],
        "theme": {
          "backButton": ["bg-card-soft", "rounded-full", "p-md"],
          "backIcon": ["text-body"],
          "title": ["text-body", "text-lg", "font-bold", "text-center"],
          "divider": ["bg-muted"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "row",
                  "crossAxis": "center",
                  "children": [
                    {
                      "type": "container",
                      "width": 42,
                      "height": 42,
                      "themeKey": "backButton",
                      "alignment": "center",
                      "action": {"type": "go_back"},
                      "child": {
                        "type": "icon",
                        "icon": "arrow_back",
                        "themeKey": "backIcon",
                        "size": "md",
                      },
                    },
                    {
                      "type": "text",
                      "key": "title",
                      "themeKey": "title",
                      "flex": 1,
                      "textAlign": "center",
                    },
                    {"type": "container", "width": 42, "height": 42},
                  ],
                },
                {
                  "type": "container",
                  "themeKey": "divider",
                  "height": 1,
                  "classes": ["mt-md"],
                },
              ],
            },
          ],
        },
      },

      {
        "id": "previous_bookings_list",
        "type": "previous_bookings_section",
        "bind": "content.bookings",
        "classes": ["mb-xl"],
        "theme": {
          "search": [
            "bg-transparent",
            "border-muted",
            "rounded-xl",
            "px-md",
            "py-md",
          ],
          "searchIcon": ["text-muted"],
          "searchText": ["text-body", "text-sm"],

          "chip": ["bg-card-soft", "rounded-full", "px-md", "py-sm"],
          "activeChip": ["bg-white", "rounded-full", "px-md", "py-sm"],
          "chipText": ["text-body", "text-xs", "font-bold"],
          "activeChipText": ["text-black", "text-xs", "font-bold"],

          "countText": ["text-muted", "text-xs"],
          "sortBox": ["bg-transparent", "border-muted", "rounded-lg"],
          "sortText": ["text-body", "text-xs", "font-bold"],

          "card": ["bg-card-soft", "border-muted", "rounded-xl", "p-md"],
          "bookingId": ["text-body", "text-xs", "font-bold"],
          "date": ["text-muted", "text-xs"],
          "status": ["text-body", "text-xs", "font-bold"],

          "image": ["rounded-md"],
          "vehicleName": ["text-body", "text-sm", "font-bold"],
          "route": ["text-muted", "text-xs"],
          "routeIcon": ["text-muted"],

          "divider": ["bg-muted"],

          "price": ["text-body", "text-lg", "font-bold"],
          "priceType": ["text-muted", "text-xs"],

          "darkButton": ["bg-muted", "rounded-lg", "px-md", "py-sm"],
          "darkButtonText": ["text-body", "text-xs", "font-bold"],
          "darkButtonIcon": ["text-body"],

          "lightButton": ["bg-white", "rounded-lg", "px-md", "py-sm"],
          "lightButtonText": ["text-black", "text-xs", "font-bold"],
          "lightButtonIcon": ["text-black"],

          "receiptButton": [
            "bg-transparent",
            "border-muted",
            "rounded-lg",
            "px-md",
            "py-sm",
          ],
          "receiptText": ["text-body", "text-xs", "font-bold"],
          "receiptIcon": ["text-body"],

          "ratingBox": [
            "bg-transparent",
            "border-muted",
            "rounded-lg",
            "px-md",
            "py-sm",
          ],
          "ratingText": ["text-body", "text-xs", "font-bold"],
          "ratingIcon": ["text-body"],
        },
        "props": {},
      },
    ],
  },
};
