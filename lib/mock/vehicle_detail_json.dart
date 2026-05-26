const Map<dynamic, dynamic> vehicleDetailJson = {
  "version": "1.0",
  "screen": "vehicle_detail",

  "meta": {
    "generatedAt": "2026-04-15T10:00:00Z",
    "cacheKey": "vehicle_detail_v2_black_layout",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "tokens", "ui"],
  },

  "content": {
    "priceIntelligence": {
      "icon": "trend_down",
      "titleIcon": "sparkles",
      "title": "AI Price Intelligence",
      "text":
          "This vehicle is typically 18% cheaper on weekdays. Booking Thursday-Monday saves you £20/day on average.",
    },

    "features": {
      "title": "Features",
      "itemIcon": "check",
      "items": [
        "Air Conditioning",
        "Bluetooth",
        "GPS Navigation",
        "Backup Camera",
        "Cruise Control",
        "Apple CarPlay",
      ],
    },

    "extras": {
      "title": "Available Extras",
      "currency": "USD",
      "suffix": "/day",
      "items": [
        {"label": "Child Seat", "price": 10},
        {"label": "GPS Device", "price": 8},
        {"label": "Additional Driver", "price": 15},
        {"label": "WiFi Hotspot", "price": 12},
      ],
    },

    "rentalPolicy": {
      "title": "Rental Policy",
      "items": [
        "Minimum age: 25 years",
        "Valid driver's license required",
        "500 km/day mileage allowance",
        "Full tank policy: return as received",
        "Cancellation free up to 48 hours before pickup",
      ],
    },

    "pickupLocation": {
      "title": "Pickup Location",
      "icon": "location",
      "locationTitle": "Downtown Location",
      "address": "123 Main Street, City Centre",
      "hours": "Open 24/7",
    },
  },

  "dynamicData": {
    "vehicleDetail": {
      "source": "api",
      "endpoint": "/vehicles/detail",
      "cache": false,
      "params": {"vehicleId": "range_rover_vogue_001"},
      "value": null,
      "fallback": {
        "vehicleId": "range_rover_vogue_001",
        "title": "Range Rover Vogue",
        "subtitle": "Luxury SUV",
        "currency": "USD",
        "suffix": "/day",
        "price": {
          "label": "Total price",
          "value": 189,
          "currency": "USD",
          "suffix": "/day",
        },
        "rating": {"icon": "star", "value": 4.9, "reviews": 234},
        "images": [
          {
            "url":
                "http://100.30.214.39:3000/cars/bmw-7-sedan-4d-blue-2023-US.png",
            "alt": "Range Rover Vogue side exterior view",
          },
          {
            "url":
                "https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=1200",
            "alt": "Range Rover Vogue front exterior view",
          },
          {
            "url":
                "http://100.30.214.39:3000/cars/bmw-7-sedan-4d-blue-2023-US.png",
            "alt": "Range Rover Vogue interior dashboard view",
          },
        ],
        "currentImageIndex": 0,
        "specs": [
          {"icon": "users", "label": "5 Seats"},
          {"icon": "suitcase", "label": "2 Suitcase(s)"},
          {"icon": "bag", "label": "2 Bag(s)"},
          {"icon": "speed", "label": "Automatic"},
          {"icon": "door", "label": "4 Doors"},
          {"icon": "navigation", "label": "GPS"},
          {"icon": "age", "label": "Minimum driver age: 25"},
        ],
      },
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},

    "open3DView": {
      "type": "open_3d_view",
      "params": {"vehicleIdParamKey": "vehicleId"},
    },

    "continueCheckout": {
      "type": "navigate",
      "params": {"route": "booking_checkout", "vehicleIdParamKey": "vehicleId"},
    },

    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "vehicle_detail_gallery",
        "type": "detail_gallery",
        "bind": "dynamicData.vehicleDetail",
        "classes": ["mb-md"],

        "theme": {
          "control": ["bg-black-opacity", "rounded-full", "p-md"],
          "controlIcon": ["text-white"],

          "imageSlider": {
            "classes": [
              "w-screen",
              "h-vehicle-card",
              "object-cover",
              "bg-card-soft",
            ],
            "backgroundImageUrl": "http://100.30.214.39:3000/cars/bg.jpg",

            "dotClasses": ["bg-black-opacity", "rounded-full"],
            "activeDotClasses": ["bg-black", "rounded-full"],
            "dotSize": "dot-sm",
            "activeDotSize": "dot-sm",
            "dotPosition": "bottom-md",
          },
        },

        "config": {
          "imageSlider": {"showDots": true},

          "controls": {"size": "size-lg", "iconSize": "icon-md"},

          "layout": [
            {
              "type": "stack",
              "children": [
                {
                  "type": "image_slider",
                  "key": "images",
                  "currentIndexKey": "currentImageIndex",
                  "themeKey": "imageSlider",
                  "fullBleed": true,
                },

                {
                  "type": "positioned",
                  "alignment": "topLeft",
                  "classes": ["p-md"],
                  "child": {
                    "type": "container",
                    "themeKey": "control",
                    "action": {"type": "go_back"},
                    "child": {
                      "type": "icon",
                      "key": "backIcon",
                      "themeKey": "controlIcon",
                      "size": "lg",
                    },
                  },
                },

                // {
                //   "type": "positioned",
                //   "alignment": "bottomRight",
                //   "classes": ["p-md"],
                //   "child": {
                //     "type": "container",
                //     "themeKey": "control",
                //     "action": {"type": "3D_view"},
                //     "child": {
                //       "type": "icon",
                //       "key": "viewIcon",
                //       "themeKey": "controlIcon",
                //       "size": "lg",
                //     },
                //   },
                // },
              ],
            },
          ],
        },

        "props": {
          "showBack": true,
          "backIcon": "arrow_back",
          "backActionRef": "goBack",
          "show3DView": true,
          "viewIcon": "3D",
          "viewActionRef": "open3DView",
          "imagesKey": "images",
          "currentImageIndexKey": "currentImageIndex",
        },
      },

      {
        "id": "vehicle_detail_summary",
        "type": "detail_summary",
        "bind": "dynamicData.vehicleDetail",
        "classes": ["mb-lg", "mt-md"],

        "theme": {
          "title": ["text-body", "text-2xl", "font-bold"],
          "subtitle": ["text-muted", "text-sm"],
          "specChip": ["px-sm", "py-xs", "text-body", "text-sm"],
          "specIcon": ["text-muted"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "children": [
                {
                  "type": "row",
                  "crossAxis": "start",
                  "children": [
                    {
                      "type": "column",
                      "flex": 1,
                      "children": [
                        {
                          "type": "text",
                          "key": "title",
                          "themeKey": "title",
                          "maxLines": 1,
                          "overflow": "ellipsis",
                        },
                        {
                          "type": "text",
                          "key": "subtitle",
                          "themeKey": "subtitle",
                          "classes": ["mt-xs"],
                        },
                      ],
                    },
                  ],
                },

                {
                  "type": "for_each",
                  "itemsKey": "specs",
                  "itemName": "spec",
                  "layout": "wrap",
                  "spacing": 2,
                  "runSpacing": 0,
                  "classes": ["mt-xl"],
                  "child": {
                    "type": "chip",
                    "labelKey": "spec.label",
                    "iconKey": "spec.icon",
                    "themeKey": "specChip",
                    "iconThemeKey": "specIcon",
                  },
                },
              ],
            },
          ],
        },

        "props": {
          "vehicleIdKey": "vehicleId",
          "titleKey": "title",
          "subtitleKey": "subtitle",
          "ratingKey": "rating",
          "currencyKey": "currency",
          "suffixKey": "suffix",
          "specsKey": "specs",
        },
      },

      {
        "id": "ai_price_intelligence",
        "type": "insight_card",
        "bind": "content.priceIntelligence",
        "classes": ["mb-lg"],

        "theme": {
          "card": ["bg-card-soft", "border-muted", "rounded-md", "p-lg"],
          "iconBox": ["bg-black", "rounded-md", "p-md"],
          "icon": ["text-white"],
          "titleIcon": ["text-primary"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-sm"],
        },

        "config": {
          "layout": [
            {
              "type": "container",
              "themeKey": "card",
              "child": {
                "type": "row",
                "crossAxis": "start",
                "children": [
                  // {
                  //   "type": "container",
                  //   "themeKey": "iconBox",
                  //   "child": {
                  //     "type": "icon",
                  //     "key": "icon",
                  //     "themeKey": "icon",
                  //     "size": "lg",
                  //   },
                  // },
                  {
                    "type": "column",
                    "flex": 1,
                    "classes": ["ml-md"],
                    "children": [
                      {
                        "type": "row",
                        "crossAxis": "center",
                        "children": [
                          {
                            "type": "icon",
                            "key": "titleIcon",
                            "themeKey": "titleIcon",
                          },
                          {
                            "type": "text",
                            "key": "title",
                            "themeKey": "title",
                            "classes": ["ml-sm"],
                            "flex": 1,
                          },
                        ],
                      },
                      {
                        "type": "text",
                        "key": "text",
                        "themeKey": "text",
                        "classes": ["mt-sm"],
                      },
                    ],
                  },
                ],
              },
            },
          ],
        },

        "props": {
          "iconKey": "icon",
          "titleIconKey": "titleIcon",
          "titleKey": "title",
          "textKey": "text",
        },
      },

      {
        "id": "features_section",
        "type": "check_list_section",
        "bind": "content.features",
        "classes": ["mb-lg", "mt-sm"],

        "theme": {
          "title": ["text-body", "text-lg", "font-bold"],
          "itemIconBox": ["bg-muted", "rounded-full", "p-xs"],
          "itemIcon": ["text-white"],
          "itemText": ["text-body", "text-sm"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "for_each",
                  "itemsKey": "items",
                  "itemName": "feature",
                  "layout": "column",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "row",
                    "crossAxis": "center",
                    "classes": ["mb-sm"],
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "itemIconBox",
                        "width": 20,
                        "height": 20,
                        "alignment": "center",
                        "child": {
                          "type": "icon",
                          "key": "itemIcon",
                          "themeKey": "itemIcon",
                          "size": "sm",
                        },
                      },
                      {
                        "type": "text",
                        "key": "feature",
                        "themeKey": "itemText",
                        "classes": ["ml-sm"],
                        "flex": 1,
                      },
                    ],
                  },
                },
              ],
            },
          ],
        },

        "props": {
          "titleKey": "title",
          "itemIconKey": "itemIcon",
          "itemsKey": "items",
        },
      },

      {
        "id": "available_extras",
        "type": "extras_list_section",
        "bind": "content.extras",
        "classes": ["mb-lg"],

        "theme": {
          "title": ["text-body", "text-lg", "font-bold"],
          "item": ["bg-black", "border-muted", "rounded-lg", "p-md"],
          "label": ["text-body", "text-sm"],
          "price": ["text-body", "text-sm", "font-bold"],
          "suffix": ["text-body", "text-sm", "font-bold"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "for_each",
                  "itemsKey": "items",
                  "itemName": "extra",
                  "layout": "column",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "container",
                    "themeKey": "item",
                    "classes": ["mb-sm"],
                    "skipBottomMarginWhenLast": true,
                    "child": {
                      "type": "row",
                      "crossAxis": "center",
                      "children": [
                        {
                          "type": "text",
                          "key": "extra.label",
                          "themeKey": "label",
                          "flex": 1,
                        },
                        {
                          "type": "row",
                          "crossAxis": "center",
                          "children": [
                            {
                              "type": "text",
                              "value": "+\$",
                              "themeKey": "price",
                            },
                            {
                              "type": "text",
                              "key": "extra.price",
                              "themeKey": "price",
                            },
                            {
                              "type": "text",
                              "key": "suffix",
                              "themeKey": "suffix",
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
          "titleKey": "title",
          "currencyKey": "currency",
          "suffixKey": "suffix",
          "itemsKey": "items",
        },
      },

      {
        "id": "rental_policy",
        "type": "policy_section",
        "bind": "content.rentalPolicy",
        "classes": ["mb-lg"],

        "theme": {
          "title": ["text-body", "text-lg", "font-bold"],
          "content": ["bg-card-soft", "rounded-xl", "p-lg"],
          "item": ["text-muted", "text-sm"],
          "dotIcon": ["text-muted"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "container",
                  "themeKey": "content",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "for_each",
                    "itemsKey": "items",
                    "itemName": "policy",
                    "layout": "column",
                    "child": {
                      "type": "row",
                      "crossAxis": "start",
                      "classes": ["mb-sm"],
                      "children": [
                        {"type": "text", "value": "•", "themeKey": "dotIcon"},
                        {
                          "type": "text",
                          "key": "policy",
                          "themeKey": "item",
                          "classes": ["ml-xs"],
                          "flex": 1,
                        },
                      ],
                    },
                  },
                },
              ],
            },
          ],
        },

        "props": {"titleKey": "title", "itemsKey": "items"},
      },

      {
        "id": "pickup_location",
        "type": "location_card_section",
        "bind": "content.pickupLocation",
        "classes": ["mb-lg", "mt-sm"],

        "theme": {
          "title": ["text-body", "text-lg", "font-bold"],
          "card": ["bg-black", "border-muted", "rounded-xl", "p-lg"],
          "iconBox": ["bg-info-soft", "rounded-md", "p-md"],
          "icon": ["text-info"],
          "locationTitle": ["text-body", "text-base", "font-bold"],
          "address": ["text-body", "text-sm"],
          "hours": ["text-body", "text-sm"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "row",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "iconBox",
                        "width": 42,
                        "height": 42,
                        "alignment": "center",
                        "child": {
                          "type": "icon",
                          "key": "icon",
                          "themeKey": "icon",
                          "size": "lg",
                        },
                      },
                      {
                        "type": "column",
                        "flex": 1,
                        "classes": ["ml-md"],
                        "children": [
                          {
                            "type": "text",
                            "key": "locationTitle",
                            "themeKey": "locationTitle",
                          },
                          {
                            "type": "text",
                            "key": "address",
                            "themeKey": "address",
                            "classes": ["mt-xs"],
                          },
                          {
                            "type": "text",
                            "key": "hours",
                            "themeKey": "hours",
                            "classes": ["mt-xs"],
                          },
                        ],
                      },
                    ],
                  },
                },
              ],
            },
          ],
        },

        "props": {
          "titleKey": "title",
          "iconKey": "icon",
          "locationTitleKey": "locationTitle",
          "addressKey": "address",
          "hoursKey": "hours",
        },
      },

      {
        "id": "vehicle_detail_bottom_bar",
        "type": "bottom_bar",
        "bind": "dynamicData.vehicleDetail",
        "classes": ["bg-black", "border-muted", "p-md"],
        "theme": {
          "priceLabel": ["text-muted", "text-sm"],
          "priceValue": ["text-body", "text-xl", "font-bold"],
          "priceSuffix": ["text-muted", "text-sm"],
          "button": ["bg-white", "rounded-lg", "px-lg", "py-md"],
          "buttonLabel": ["text-black", "text-base", "font-bold"],
        },
        "props": {
          "priceKey": "price",
          "button": {
            "label": "Continue",
            "action": {"type": "open_checkout"},
          },
        },
      },
    ],
  },
};

const Map<dynamic, dynamic> vehicleDetailJsonV2 = {
  "version": "1.0",
  "screen": "vehicle_detail",

  "meta": {
    "generatedAt": "2026-05-19T11:25:00Z",
    "cacheKey": "vehicle_detail_v3",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "tokens", "ui"],
  },

  "content": {
    "priceIntelligence": {
      "icon": "trend_down",
      "titleIcon": "sparkles",
      "title": "AI Price Intelligence",
      "text":
          "This vehicle is usually 14% cheaper for midweek bookings. Choosing Tuesday-Friday can save you \$16/day on average.",
    },

    "features": {
      "title": "Features",
      "itemIcon": "check",
      "items": [
        "Heated Seats",
        "Bluetooth",
        "Apple CarPlay",
        "Rear Parking Camera",
        "Cruise Control",
        "Dual-Zone Climate Control",
      ],
    },

    "extras": {
      "title": "Available Extras",
      "currency": "USD",
      "suffix": "/day",
      "items": [
        {"label": "Child Seat", "price": 12},
        {"label": "GPS Device", "price": 7},
        {"label": "Additional Driver", "price": 18},
        {"label": "Premium WiFi", "price": 10},
      ],
    },

    "rentalPolicy": {
      "title": "Rental Policy",
      "items": [
        "Minimum age: 25 years",
        "Valid driver's license required",
        "450 km/day mileage allowance",
        "Return with the same fuel level",
        "Free cancellation up to 48 hours before pickup",
      ],
    },

    "pickupLocation": {
      "title": "Pickup Location",
      "icon": "location",
      "locationTitle": "City Airport Branch",
      "address": "Terminal Road, Airport Business Park",
      "hours": "Open 24/7",
    },
  },

  "dynamicData": {
    "vehicleDetail": {
      "source": "api",
      "endpoint": "/vehicles/detail",
      "cache": false,
      "params": {"vehicleId": "mercedes_c_class_001"},
      "value": null,
      "fallback": {
        "vehicleId": "mercedes_c_class_001",
        "title": "Mercedes-Benz",
        "subtitle": "Executive Saloon",
        "currency": "USD",
        "suffix": "/day",
        "price": {
          "label": "Total price",
          "value": 118,
          "currency": "USD",
          "suffix": "/day",
        },
        "rating": {"icon": "star", "value": 4.7, "reviews": 142},
        "images": [
          {
            "url":
                "http://100.30.214.39:3000/cars/bmw-x5-suv-black-2025-US.png",
            "alt": "Mercedes-Benz C-Class centred front exterior view",
          },
          {
            "url":
                "https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=1920&h=1200&q=85&fm=png",
            "alt": "Mercedes-Benz C-Class side exterior view",
          },
          {
            "url":
                "https://images.unsplash.com/photo-1617531653332-bd46c24f2068?auto=format&fit=crop&w=1920&h=1200&q=85&fm=png&sat=-10",
            "alt": "Mercedes-Benz C-Class interior dashboard view",
          },
        ],
        "currentImageIndex": 0,
        "specs": [
          {"icon": "users", "label": "5 Seats"},
          {"icon": "suitcase", "label": "2 Suitcase(s)"},
          {"icon": "bag", "label": "2 Bag(s)"},
          {"icon": "speed", "label": "Automatic"},
          {"icon": "door", "label": "4 Doors"},
          {"icon": "navigation", "label": "GPS"},
          {"icon": "age", "label": "Minimum driver age: 25"},
        ],
      },
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},

    "open3DView": {
      "type": "open_3d_view",
      "params": {"vehicleIdParamKey": "vehicleId"},
    },

    "continueCheckout": {
      "type": "navigate",
      "params": {"route": "booking_checkout", "vehicleIdParamKey": "vehicleId"},
    },

    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "vehicle_detail_gallery",
        "type": "detail_gallery",
        "bind": "dynamicData.vehicleDetail",
        "classes": ["mb-md"],

        "theme": {
          "control": ["bg-black-opacity", "rounded-full", "p-md"],
          "controlIcon": ["text-white"],

          "imageSlider": {
            "classes": [
              "w-screen",
              "h-vehicle-card",
              "object-cover",
              "bg-card-soft",
            ],
            "backgroundImageUrl": "http://100.30.214.39:3000/cars/bg.jpg",

            "dotClasses": ["bg-black-opacity", "rounded-full"],
            "activeDotClasses": ["bg-black", "rounded-full"],
            "dotSize": "dot-sm",
            "activeDotSize": "dot-sm",
            "dotPosition": "bottom-md",
          },
        },

        "config": {
          "imageSlider": {"showDots": true},

          "controls": {"size": "size-lg", "iconSize": "icon-md"},

          "layout": [
            {
              "type": "stack",
              "children": [
                {
                  "type": "image_slider",
                  "key": "images",
                  "currentIndexKey": "currentImageIndex",
                  "themeKey": "imageSlider",
                  "fullBleed": true,
                },

                {
                  "type": "positioned",
                  "alignment": "topLeft",
                  "classes": ["p-md"],
                  "child": {
                    "type": "container",
                    "themeKey": "control",
                    "action": {"type": "go_back"},
                    "child": {
                      "type": "icon",
                      "key": "backIcon",
                      "themeKey": "controlIcon",
                      "size": "lg",
                    },
                  },
                },

                // {
                //   "type": "positioned",
                //   "alignment": "bottomRight",
                //   "classes": ["p-md"],
                //   "child": {
                //     "type": "container",
                //     "themeKey": "control",
                //     "action": {"type": "3D_view"},
                //     "child": {
                //       "type": "icon",
                //       "key": "viewIcon",
                //       "themeKey": "controlIcon",
                //       "size": "lg",
                //     },
                //   },
                // },
              ],
            },
          ],
        },

        "props": {
          "showBack": true,
          "backIcon": "arrow_back",
          "backActionRef": "goBack",
          "show3DView": true,
          "viewIcon": "3D",
          "viewActionRef": "open3DView",
          "imagesKey": "images",
          "currentImageIndexKey": "currentImageIndex",
        },
      },

      {
        "id": "vehicle_detail_summary",
        "type": "detail_summary",
        "bind": "dynamicData.vehicleDetail",
        "classes": ["mb-lg", "mt-md"],

        "theme": {
          "title": ["text-body", "text-2xl", "font-bold"],
          "subtitle": ["text-muted", "text-sm"],
          "specChip": ["px-sm", "py-xs", "text-body", "text-sm"],
          "specIcon": ["text-muted"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "children": [
                {
                  "type": "row",
                  "crossAxis": "start",
                  "children": [
                    {
                      "type": "column",
                      "flex": 1,
                      "children": [
                        {
                          "type": "text",
                          "key": "title",
                          "themeKey": "title",
                          "maxLines": 1,
                          "overflow": "ellipsis",
                        },
                        {
                          "type": "text",
                          "key": "subtitle",
                          "themeKey": "subtitle",
                          "classes": ["mt-xs"],
                        },
                      ],
                    },
                  ],
                },

                {
                  "type": "for_each",
                  "itemsKey": "specs",
                  "itemName": "spec",
                  "layout": "wrap",
                  "spacing": 2,
                  "runSpacing": 0,
                  "classes": ["mt-xl"],
                  "child": {
                    "type": "chip",
                    "labelKey": "spec.label",
                    "iconKey": "spec.icon",
                    "themeKey": "specChip",
                    "iconThemeKey": "specIcon",
                  },
                },
              ],
            },
          ],
        },

        "props": {
          "vehicleIdKey": "vehicleId",
          "titleKey": "title",
          "subtitleKey": "subtitle",
          "ratingKey": "rating",
          "currencyKey": "currency",
          "suffixKey": "suffix",
          "specsKey": "specs",
        },
      },

      {
        "id": "ai_price_intelligence",
        "type": "insight_card",
        "bind": "content.priceIntelligence",
        "classes": ["mb-lg"],

        "theme": {
          "card": ["bg-card-soft", "border-muted", "rounded-md", "p-lg"],
          "iconBox": ["bg-black", "rounded-md", "p-md"],
          "icon": ["text-white"],
          "titleIcon": ["text-primary"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-sm"],
        },

        "config": {
          "layout": [
            {
              "type": "container",
              "themeKey": "card",
              "child": {
                "type": "row",
                "crossAxis": "start",
                "children": [
                  // {
                  //   "type": "container",
                  //   "themeKey": "iconBox",
                  //   "child": {
                  //     "type": "icon",
                  //     "key": "icon",
                  //     "themeKey": "icon",
                  //     "size": "lg",
                  //   },
                  // },
                  {
                    "type": "column",
                    "flex": 1,
                    "classes": ["ml-md"],
                    "children": [
                      {
                        "type": "row",
                        "crossAxis": "center",
                        "children": [
                          {
                            "type": "icon",
                            "key": "titleIcon",
                            "themeKey": "titleIcon",
                          },
                          {
                            "type": "text",
                            "key": "title",
                            "themeKey": "title",
                            "classes": ["ml-sm"],
                            "flex": 1,
                          },
                        ],
                      },
                      {
                        "type": "text",
                        "key": "text",
                        "themeKey": "text",
                        "classes": ["mt-sm"],
                      },
                    ],
                  },
                ],
              },
            },
          ],
        },

        "props": {
          "iconKey": "icon",
          "titleIconKey": "titleIcon",
          "titleKey": "title",
          "textKey": "text",
        },
      },

      {
        "id": "features_section",
        "type": "check_list_section",
        "bind": "content.features",
        "classes": ["mb-lg", "mt-sm"],

        "theme": {
          "title": ["text-body", "text-lg", "font-bold"],
          "itemIconBox": ["bg-muted", "rounded-full", "p-xs"],
          "itemIcon": ["text-white"],
          "itemText": ["text-body", "text-sm"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "for_each",
                  "itemsKey": "items",
                  "itemName": "feature",
                  "layout": "column",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "row",
                    "crossAxis": "center",
                    "classes": ["mb-sm"],
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "itemIconBox",
                        "width": 20,
                        "height": 20,
                        "alignment": "center",
                        "child": {
                          "type": "icon",
                          "key": "itemIcon",
                          "themeKey": "itemIcon",
                          "size": "sm",
                        },
                      },
                      {
                        "type": "text",
                        "key": "feature",
                        "themeKey": "itemText",
                        "classes": ["ml-sm"],
                        "flex": 1,
                      },
                    ],
                  },
                },
              ],
            },
          ],
        },

        "props": {
          "titleKey": "title",
          "itemIconKey": "itemIcon",
          "itemsKey": "items",
        },
      },

      {
        "id": "available_extras",
        "type": "extras_list_section",
        "bind": "content.extras",
        "classes": ["mb-lg"],

        "theme": {
          "title": ["text-body", "text-lg", "font-bold"],
          "item": ["bg-black", "border-muted", "rounded-lg", "p-md"],
          "label": ["text-body", "text-sm"],
          "price": ["text-body", "text-sm", "font-bold"],
          "suffix": ["text-body", "text-sm", "font-bold"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "for_each",
                  "itemsKey": "items",
                  "itemName": "extra",
                  "layout": "column",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "container",
                    "themeKey": "item",
                    "classes": ["mb-sm"],
                    "skipBottomMarginWhenLast": true,
                    "child": {
                      "type": "row",
                      "crossAxis": "center",
                      "children": [
                        {
                          "type": "text",
                          "key": "extra.label",
                          "themeKey": "label",
                          "flex": 1,
                        },
                        {
                          "type": "row",
                          "crossAxis": "center",
                          "children": [
                            {
                              "type": "text",
                              "value": "+\$",
                              "themeKey": "price",
                            },
                            {
                              "type": "text",
                              "key": "extra.price",
                              "themeKey": "price",
                            },
                            {
                              "type": "text",
                              "key": "suffix",
                              "themeKey": "suffix",
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
          "titleKey": "title",
          "currencyKey": "currency",
          "suffixKey": "suffix",
          "itemsKey": "items",
        },
      },

      {
        "id": "rental_policy",
        "type": "policy_section",
        "bind": "content.rentalPolicy",
        "classes": ["mb-lg"],

        "theme": {
          "title": ["text-body", "text-lg", "font-bold"],
          "content": ["bg-card-soft", "rounded-xl", "p-lg"],
          "item": ["text-muted", "text-sm"],
          "dotIcon": ["text-muted"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "container",
                  "themeKey": "content",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "for_each",
                    "itemsKey": "items",
                    "itemName": "policy",
                    "layout": "column",
                    "child": {
                      "type": "row",
                      "crossAxis": "start",
                      "classes": ["mb-sm"],
                      "children": [
                        {"type": "text", "value": "•", "themeKey": "dotIcon"},
                        {
                          "type": "text",
                          "key": "policy",
                          "themeKey": "item",
                          "classes": ["ml-xs"],
                          "flex": 1,
                        },
                      ],
                    },
                  },
                },
              ],
            },
          ],
        },

        "props": {"titleKey": "title", "itemsKey": "items"},
      },

      {
        "id": "pickup_location",
        "type": "location_card_section",
        "bind": "content.pickupLocation",
        "classes": ["mb-lg", "mt-sm"],

        "theme": {
          "title": ["text-body", "text-lg", "font-bold"],
          "card": ["bg-black", "border-muted", "rounded-xl", "p-lg"],
          "iconBox": ["bg-info-soft", "rounded-md", "p-md"],
          "icon": ["text-info"],
          "locationTitle": ["text-body", "text-base", "font-bold"],
          "address": ["text-body", "text-sm"],
          "hours": ["text-body", "text-sm"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "row",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "iconBox",
                        "width": 42,
                        "height": 42,
                        "alignment": "center",
                        "child": {
                          "type": "icon",
                          "key": "icon",
                          "themeKey": "icon",
                          "size": "lg",
                        },
                      },
                      {
                        "type": "column",
                        "flex": 1,
                        "classes": ["ml-md"],
                        "children": [
                          {
                            "type": "text",
                            "key": "locationTitle",
                            "themeKey": "locationTitle",
                          },
                          {
                            "type": "text",
                            "key": "address",
                            "themeKey": "address",
                            "classes": ["mt-xs"],
                          },
                          {
                            "type": "text",
                            "key": "hours",
                            "themeKey": "hours",
                            "classes": ["mt-xs"],
                          },
                        ],
                      },
                    ],
                  },
                },
              ],
            },
          ],
        },

        "props": {
          "titleKey": "title",
          "iconKey": "icon",
          "locationTitleKey": "locationTitle",
          "addressKey": "address",
          "hoursKey": "hours",
        },
      },

      {
        "id": "vehicle_detail_bottom_bar",
        "type": "bottom_bar",
        "bind": "dynamicData.vehicleDetail",
        "classes": ["bg-black", "border-muted", "p-md"],
        "theme": {
          "priceLabel": ["text-muted", "text-sm"],
          "priceValue": ["text-body", "text-xl", "font-bold"],
          "priceSuffix": ["text-muted", "text-sm"],
          "button": ["bg-white", "rounded-lg", "px-lg", "py-md"],
          "buttonLabel": ["text-black", "text-base", "font-bold"],
        },
        "props": {
          "priceKey": "price",
          "button": {
            "label": "Continue",
            "action": {"type": "open_checkout"},
          },
        },
      },
    ],
  },
};
