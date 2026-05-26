const Map<dynamic, dynamic> vehicleListJson = {
  "version": "1.0",
  "screen": "vehicle_browse",

  "meta": {
    "generatedAt": "2026-05-16T10:00:00Z",
    "cacheKey": "vehicle_browse_list_v3_filter_sheet",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "tokens", "ui"],
  },

  "content": {
    "search": {"placeholder": "Range Rover for a Cotswolds weekend"},

    "locationSelector": {
      "title": "Book a vehicle",
      "tag": "Personal",
      "leadingIcon": "location",
      "items": [
        {
          "key": "pickupLocation",
          "label": "Pickup location",
          "value": "Enter pickup location",
          "icon": "location",
        },
        {
          "key": "pickupDate",
          "label": "Pickup Date & Time",
          "value": "mm/dd/yyyy --:-- --",
          "icon": "calendar",
        },
        {
          "key": "returnDate",
          "label": "Return Date & Time",
          "value": "mm/dd/yyyy --:-- --",
          "icon": "calendar",
        },
      ],
    },

    "sort": {
      "label": "Relevance",
      "icon": "sort",
      "options": [
        "Relevance",
        "Price: Low to High",
        "Price: High to Low",
        "Highest Rated",
      ],
    },
  },

  "dynamicData": {
    "vehicleResults": {
      "cache": false,
      "params": {
        "pickupLocation": null,
        "pickupDateTime": null,
        "returnDateTime": null,
        "vehicleCategory": "all",
        "transmission": "auto",
        "seats": "5",
        "budgetMin": 0,
        "budgetMax": 447,
        "sort": "relevance",
      },
      "fallback": {
        "total": 6,
        "currency": "GBP",
        "items": [
          {
            "vehicleId": "mercedes_s_class_001",
            "title": "Mercedes S-Class",
            "category": "sedan",
            "transmission": "auto",
            "seatCount": 5,
            "statusTag": {"label": "Green", "icon": "leaf"},
            "images": [
              {
                "url":
                    "https://images.unsplash.com/photo-1617814076367-b759c7d7e738?w=1200",
                "alt": "Mercedes S-Class exterior view",
              },
              {
                "url":
                    "https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=1200",
                "alt": "Mercedes luxury interior view",
              },
              {
                "url":
                    "https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=1200",
                "alt": "Mercedes rear exterior view",
              },
            ],
            "currentImageIndex": 0,
            "rating": {"icon": "star", "value": 4.9, "reviews": 167},
            "tags": [
              {"label": "Sedan", "icon": "car"},
              {"label": "Auto", "icon": "gear"},
              {"label": "Petrol", "icon": "fuel"},
              {"label": "5 Seats", "icon": "users"},
            ],
            "offer": {"icon": "trend_down", "text": "18% cheaper on weekdays"},
            "price": {
              "dayRate": {"value": 189},
              "total": {"value": 945, "days": 5, "align": "right"},
            },
          },
          {
            "vehicleId": "range_rover_vogue_001",
            "title": "Range Rover Vogue",
            "category": "suv",
            "transmission": "auto",
            "seatCount": 5,
            "statusTag": {"label": "Premium", "icon": "star"},
            "images": [
              {
                "url":
                    "https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=1200",
                "alt": "Range Rover Vogue front exterior view",
              },
              {
                "url":
                    "https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1200",
                "alt": "Range Rover Vogue side exterior view",
              },
              {
                "url":
                    "https://images.unsplash.com/photo-1502877338535-766e1452684a?w=1200",
                "alt": "Range Rover Vogue interior view",
              },
            ],
            "currentImageIndex": 0,
            "rating": {"icon": "star", "value": 4.8, "reviews": 142},
            "tags": [
              {"label": "SUV", "icon": "car"},
              {"label": "Auto", "icon": "gear"},
              {"label": "Diesel", "icon": "fuel"},
              {"label": "5 Seats", "icon": "users"},
            ],
            "offer": {
              "icon": "trend_down",
              "text": "12% cheaper for 3+ day bookings",
            },
            "price": {
              "dayRate": {"value": 215},
              "total": {"value": 1075, "days": 5},
            },
          },
          {
            "vehicleId": "bmw_7_series_001",
            "title": "BMW 7 Series",
            "category": "sedan",
            "transmission": "auto",
            "seatCount": 5,
            "statusTag": {"label": "Hybrid", "icon": "leaf"},
            "images": [
              {
                "url":
                    "https://images.unsplash.com/photo-1555215695-3004980ad54e?w=1200",
                "alt": "BMW 7 Series exterior view",
              },
              {
                "url":
                    "https://images.unsplash.com/photo-1517524008697-84bbe3c3fd98?w=1200",
                "alt": "BMW luxury interior view",
              },
              {
                "url":
                    "https://images.unsplash.com/photo-1556189250-72ba954cfc2b?w=1200",
                "alt": "BMW rear exterior view",
              },
            ],
            "currentImageIndex": 0,
            "rating": {"icon": "star", "value": 4.7, "reviews": 119},
            "tags": [
              {"label": "Sedan", "icon": "car"},
              {"label": "Auto", "icon": "gear"},
              {"label": "Hybrid", "icon": "fuel"},
              {"label": "5 Seats", "icon": "users"},
            ],
            "offer": {
              "icon": "trend_down",
              "text": "10% cheaper on weekend returns",
            },
            "price": {
              "dayRate": {"value": 175},
              "total": {"value": 875, "days": 5},
            },
          },
          {
            "vehicleId": "tesla_model_y_001",
            "title": "Tesla Model Y",
            "category": "electric",
            "transmission": "auto",
            "seatCount": 5,
            "statusTag": {"label": "Electric", "icon": "bolt"},
            "images": [
              {
                "url":
                    "https://images.unsplash.com/photo-1619767886558-efdc259cde1a?w=1200",
                "alt": "Tesla Model Y exterior view",
              },
              {
                "url":
                    "https://images.unsplash.com/photo-1536700503339-1e4b06520771?w=1200",
                "alt": "Tesla electric car view",
              },
            ],
            "currentImageIndex": 0,
            "rating": {"icon": "star", "value": 4.9, "reviews": 208},
            "tags": [
              {"label": "Electric", "icon": "bolt"},
              {"label": "Auto", "icon": "gear"},
              {"label": "5 Seats", "icon": "users"},
              {"label": "Digital Key", "icon": "key"},
            ],
            "offer": {
              "icon": "trend_down",
              "text": "Lower running cost for city trips",
            },
            "price": {
              "dayRate": {"value": 145},
              "total": {"value": 725, "days": 5},
            },
          },
          {
            "vehicleId": "vw_multivan_001",
            "title": "Volkswagen Multivan",
            "category": "van",
            "transmission": "auto",
            "seatCount": 7,
            "statusTag": {"label": "Family", "icon": "users"},
            "images": [
              {
                "url":
                    "https://images.unsplash.com/photo-1619767886558-efdc259cde1a?w=1200",
                "alt": "Van exterior view",
              },
            ],
            "currentImageIndex": 0,
            "rating": {"icon": "star", "value": 4.6, "reviews": 83},
            "tags": [
              {"label": "Van", "icon": "truck"},
              {"label": "Auto", "icon": "gear"},
              {"label": "7 Seats", "icon": "users"},
              {"label": "Luggage", "icon": "bag"},
            ],
            "offer": {
              "icon": "trend_down",
              "text": "Good value for group bookings",
            },
            "price": {
              "dayRate": {"value": 135},
              "total": {"value": 675, "days": 5},
            },
          },
          {
            "vehicleId": "aston_martin_db5_001",
            "title": "Aston Martin DB5",
            "category": "classic",
            "transmission": "manual",
            "seatCount": 2,
            "statusTag": {"label": "Classic", "icon": "crown"},
            "images": [
              {
                "url":
                    "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=1200",
                "alt": "Classic Aston Martin exterior view",
              },
            ],
            "currentImageIndex": 0,
            "rating": {"icon": "star", "value": 5.0, "reviews": 488},
            "tags": [
              {"label": "Classic", "icon": "crown"},
              {"label": "Manual", "icon": "gear"},
              {"label": "2 Seats", "icon": "users"},
              {"label": "Premium", "icon": "star"},
            ],
            "offer": {
              "icon": "trend_down",
              "text": "Special weekend collection available",
            },
            "price": {
              "dayRate": {"value": 449},
              "total": {"value": 2245, "days": 5},
            },
          },
        ],
      },
    },
  },

  "actions": {
    "openVehicleFilterSheet": {
      "type": "open_vehicle_filter_sheet",
      "params": {},
    },
  },

  "tokens": {
    "colors": {
      "surface": "bg-white",
      "card": "bg-card",
      "surfaceSoft": "bg-card-soft",
      "primary": "bg-primary",
      "muted": "bg-muted",
      "success": "bg-success",
      "border": "border-muted",
      "borderSuccess": "border-success",
      "textBody": "text-body",
      "textMuted": "text-muted",
      "textBlack": "text-black",
      "textWhite": "text-white",
      "textSurface": "text-surface",
    },
    "radius": {
      "md": "rounded-md",
      "lg": "rounded-lg",
      "xl": "rounded-xl",
      "full": "rounded-full",
    },
    "shadow": {"sm": "shadow-sm", "md": "shadow-md"},
    "text": {
      "xs": "text-xs",
      "sm": "text-sm",
      "md": "text-md",
      "xl": "text-xl",
      "medium": "font-medium",
      "semibold": "font-semibold",
      "bold": "font-bold",
      "extrabold": "font-extrabold",
    },
    "spacing": {
      "pSm": "p-sm",
      "pMd": "p-md",
      "pxSm": "px-sm",
      "pxMd": "px-md",
      "pyXs": "py-xs",
      "pySm": "py-sm",
      "mbMd": "mb-md",
      "mbLg": "mb-lg",
    },
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "vehicle_list_top_back",
        "type": "button_group",
        "classes": ["mb-md"],
        "theme": {
          "iconButton": [
            "bg-card-soft",
            "border-muted",
            "rounded-full",
            "p-md",
          ],
          "iconButtonIcon": ["text-body"],
        },
        "props": {
          "align": "start",
          "buttons": [
            {
              "icon": "arrow_back",
              "variant": "icon",
              "action": {"type": "go_back"},
            },
          ],
        },
        "config": {
          "layout": [
            {
              "type": "for_each",
              "itemsKey": "buttons",
              "itemName": "button",
              "layout": "row",
              "child": {
                "type": "container",
                "themeKey": "iconButton",
                "action": {"type": "go_back"},
                "child": {
                  "type": "icon",
                  "key": "button.icon",
                  "themeKey": "iconButtonIcon",
                  "size": "md",
                },
              },
            },
          ],
        },
      },

      {
        "id": "search_prompt",
        "type": "search_prompt",
        "bind": "content.search",
        "classes": [
          "bg-card-soft",
          "border-muted",
          "rounded-lg",
          "p-md",
          "mb-sm",
        ],
        "theme": {
          "placeholder": ["text-sm", "text-muted"],
          "leadingIcon": ["text-primary"],
          "trailing": ["bg-primary", "rounded-md", "p-sm"],
          "trailingIcon": ["text-surface"],
        },
        "config": {
          "layout": [
            {
              "type": "container",
              "action": {"type": "ai_chat"},
              "child": {
                "type": "row",
                "crossAxis": "center",
                "children": [
                  {
                    "type": "icon",
                    "key": "leadingIcon",
                    "themeKey": "leadingIcon",
                  },
                  {
                    "type": "text",
                    "key": "placeholder",
                    "themeKey": "placeholder",
                    "classes": ["ml-md"],
                    "flex": 1,
                  },
                  {
                    "type": "container",
                    "themeKey": "trailing",
                    "action": {"type": "ai_camera_search"},
                    "child": {
                      "type": "icon",
                      "key": "trailingIcon",
                      "themeKey": "trailingIcon",
                    },
                  },
                ],
              },
            },
          ],
        },
        "props": {
          "leadingIcon": "sparkles",
          "placeholderKey": "placeholder",
          "trailingIcon": "camera",
          "actionRef": "openAiSearch",
        },
      },

      {
        "id": "location_date_selector",
        "type": "location_date_selector",
        "bind": "content.locationSelector",
        "classes": ["bg-card", "border-muted", "rounded-lg", "p-md", "mb-lg"],
        "theme": {
          "leadingIcon": ["text-muted"],
          "title": ["text-primary", "text-md", "font-bold"],
          "itemIcon": ["text-muted"],
          "itemLabel": ["text-muted", "text-sm", "font-semibold"],
          "itemValue": ["text-muted", "text-xs"],
          "tag": ["bg-card-soft", "rounded-full", "px-sm", "py-xs"],
          "tagText": ["text-muted", "text-xs", "font-bold"],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "children": [
                {
                  "type": "row",
                  "crossAxis": "center",
                  "children": [
                    {
                      "type": "icon",
                      "key": "leadingIcon",
                      "themeKey": "leadingIcon",
                    },
                    {
                      "type": "text",
                      "key": "title",
                      "themeKey": "title",
                      "classes": ["ml-md"],
                      "flex": 1,
                    },
                    {
                      "type": "container",
                      "themeKey": "tag",
                      "child": {
                        "type": "text",
                        "key": "tag",
                        "themeKey": "tagText",
                      },
                    },
                  ],
                },
                {
                  "type": "for_each",
                  "itemsKey": "items",
                  "itemName": "item",
                  "layout": "column",
                  "classes": ["mt-lg"],
                  "child": {
                    "type": "container",
                    "classes": ["mb-md"],
                    "child": {
                      "type": "row",
                      "crossAxis": "center",
                      "children": [
                        {
                          "type": "icon",
                          "key": "item.icon",
                          "themeKey": "itemIcon",
                        },
                        {
                          "type": "column",
                          "classes": ["ml-sm"],
                          "flex": 1,
                          "children": [
                            {
                              "type": "text",
                              "key": "item.label",
                              "themeKey": "itemLabel",
                              "maxLines": 1,
                              "overflow": "ellipsis",
                            },
                            {
                              "type": "text",
                              "key": "item.value",
                              "themeKey": "itemValue",
                              "classes": ["mt-xs"],
                              "maxLines": 1,
                              "overflow": "ellipsis",
                            },
                          ],
                        },
                      ],
                    },
                  },
                },
              ],
            },
          ],
        },
        "props": {
          "variant": "booking_summary_bar",

          "titleKey": "title",
          "tagKey": "tag",
          "leadingIcon": "location",
          "itemsKey": "items",

          "actionRef": "openVehicleFilterSheet",

          "itemActionRefs": {
            "pickupLocation": "openVehicleFilterSheet",
            "pickupDate": "openVehicleFilterSheet",
            "returnDate": "openVehicleFilterSheet",
          },
        },
      },
      {
        "id": "available_vehicle_header",
        "type": "list_header",
        "bind": "dynamicData.vehicleResults",
        "classes": ["mb-md"],
        "theme": {
          "titleCount": ["text-body", "text-sm", "font-extrabold"],
          "titleLabel": ["text-muted", "text-sm", "font-bold"],
          "action": ["bg-card-soft", "rounded-lg", "px-md", "py-sm"],
          "actionText": ["text-body", "text-sm", "font-bold"],
          "actionIcon": ["text-muted"],
        },
        "config": {
          "layout": [
            {
              "type": "row",
              "mainAxis": "spaceBetween",
              "crossAxis": "center",
              "children": [
                {
                  "type": "row",
                  "crossAxis": "center",
                  "flex": 1,
                  "children": [
                    {
                      "type": "text",
                      "key": "titleCount",
                      "themeKey": "titleCount",
                    },
                    {
                      "type": "text",
                      "value": " vehicles available",
                      "themeKey": "titleLabel",
                      "classes": ["ml-xs"],
                    },
                  ],
                },
                {
                  "type": "container",
                  "themeKey": "action",
                  "child": {
                    "type": "row",
                    "crossAxis": "center",
                    "children": [
                      {
                        "type": "text",
                        "key": "selectedSortLabel",
                        "themeKey": "actionText",
                      },
                      {
                        "type": "icon",
                        "icon": "sort",
                        "themeKey": "actionIcon",
                        "classes": ["ml-md"],
                      },
                    ],
                  },
                },
              ],
            },
          ],
        },
        "props": {
          "titleCountKey": "total",
          "titleLabel": "vehicles available",
          "sortBind": "content.sort",
          "sortActionRef": "openSortSheet",
        },
      },

      {
        "id": "vehicle_results",
        "type": "list_cards",
        "bind": "dynamicData.vehicleResults",
        "classes": ["mb-lg"],
        "theme": {
          "card": [
            "bg-card",
            "border-muted",
            "rounded-xl",
            "mb-lg",
            "shadow-sm",
          ],
          "body": ["p-md"],
          "title": ["text-body", "text-md", "font-bold"],
          "ratingIcon": ["text-primary"],
          "ratingValue": ["text-body", "text-sm", "font-bold"],
          "ratingReviews": ["text-muted", "text-xs"],
          "imageSlider": {
            "classes": ["w-full", "h-vehicle-card", "object-cover"],
            "dotClasses": ["bg-white-opacity", "rounded-full"],
            "activeDotClasses": ["bg-black-opacity", "rounded-full"],
            "dotSize": "dot-sm",
            "activeDotSize": "dot-sm",
            "dotPosition": "bottom-sm",
          },
          "tag": [
            "bg-muted",
            "rounded-full",
            "px-sm",
            "py-xs",
            "text-muted",
            "text-xs",
          ],
          "tagIcon": ["text-muted"],
          "statusTag": [
            "bg-success",
            "border-success",
            "rounded-full",
            "px-sm",
            "py-xs",
            "text-primary",
            "text-xs",
            "font-bold",
          ],
          "statusTagIcon": ["text-primary"],
          "offerBox": ["bg-muted", "border-muted", "rounded-md", "p-sm"],
          "offerText": ["text-body", "text-sm"],
          "offerIcon": ["text-primary"],
          "priceBox": ["bg-card-soft", "rounded-lg", "p-md"],
          "priceLabel": ["text-muted", "text-xs"],
          "priceValue": ["text-body", "text-xl", "font-extrabold"],
          "totalPriceValue": ["text-body", "text-sm", "font-extrabold"],
          "priceSuffix": ["text-muted", "text-xs"],
        },
        "config": {
          "imageSlider": {"showDots": true},
          "layout": [
            {
              "type": "container",
              "action": {"type": "open_vehicle_detail_v2"},
              "child": {
                "type": "stack",
                "children": [
                  {
                    "type": "image_slider",
                    "key": "images",
                    "currentIndexKey": "currentImageIndex",
                    "themeKey": "imageSlider",
                  },
                  {
                    "type": "positioned",
                    "alignment": "topRight",
                    "classes": ["p-md"],
                    "child": {
                      "type": "chip",
                      "labelKey": "statusTag.label",
                      "iconKey": "statusTag.icon",
                      "themeKey": "statusTag",
                      "iconThemeKey": "statusTagIcon",
                    },
                  },
                ],
              },
            },
            {
              "type": "container",
              "action": {"type": "open_vehicle_detail_v2"},
              "themeKey": "body",
              "children": [
                {
                  "type": "column",
                  "children": [
                    {
                      "type": "row",
                      "crossAxis": "start",
                      "children": [
                        {
                          "type": "text",
                          "key": "title",
                          "themeKey": "title",
                          "flex": 1,
                          "maxLines": 1,
                          "overflow": "ellipsis",
                        },
                        {
                          "type": "rating",
                          "key": "rating",
                          "classes": ["ml-sm"],
                          "showReviews": true,
                        },
                      ],
                    },
                    {
                      "type": "for_each",
                      "itemsKey": "tags",
                      "itemName": "tag",
                      "layout": "wrap",
                      "classes": ["mt-md"],
                      "child": {
                        "type": "chip",
                        "labelKey": "tag.label",
                        "iconKey": "tag.icon",
                        "themeKey": "tag",
                        "iconThemeKey": "tagIcon",
                        "classes": ["mr-xs", "mb-sm"],
                      },
                    },
                    {
                      "type": "container",
                      "themeKey": "offerBox",
                      "classes": ["mt-sm"],
                      "children": [
                        {
                          "type": "row",
                          "crossAxis": "center",
                          "children": [
                            {
                              "type": "icon",
                              "key": "offer.icon",
                              "themeKey": "offerIcon",
                            },
                            {
                              "type": "text",
                              "key": "offer.text",
                              "themeKey": "offerText",
                              "classes": ["ml-sm"],
                              "flex": 1,
                            },
                          ],
                        },
                      ],
                    },
                    {
                      "type": "row",
                      "classes": ["mt-md"],
                      "children": [
                        {
                          "type": "price_box",
                          "key": "price.dayRate",
                          "flex": 1,
                          "label": "",
                          "suffix": "/day",
                          "valueThemeKey": "priceValue",
                        },
                        {
                          "type": "price_box",
                          "key": "price.total",
                          "classes": ["ml-sm"],
                          "flex": 1,
                          "label": "Total",
                          "suffixTemplate": "({days} days)",
                          "valueThemeKey": "totalPriceValue",
                        },
                      ],
                    },
                  ],
                },
              ],
            },
          ],
        },
        "props": {
          "currencyKey": "currency",
          "itemsKey": "items",
          "itemActionRef": "openVehicleDetail",
        },
      },
    ],
  },
};
