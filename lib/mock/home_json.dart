const Map<dynamic, dynamic> qdriveHomeJson = {
  "version": "1.0",
  "screen": "qdrive_home",

  "meta": {
    "generatedAt": "2026-05-13T10:00:00Z",
    "cacheKey": "qdrive_home_v5",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "heroText": {
      "eyebrowIcon": "location",
      "eyebrow": "LONDON KING'S CROSS",
      "title": "RENT ANYWHERE\nTRAVEL\nEVERYWHERE",
    },

    "search": {"placeholder": "Range Rover for a Cotswolds weekend"},

    "fleetSection": {
      "eyebrow": "FROM THE FLEET",
      "title": "Featured vehicles",
      "subtitle":
          "Same live catalog as search — curated layout for the homepage. Tap a card to view full details.",
    },
  },

  "dynamicData": {
    "activeRental": {
      "cache": false,
      "params": {},
      "value": null,
      "fallback": {
        "vehicleName": "BMW 7 Series",
        "bookingId": "BK-2026-4521",
        "endDate": "Ends 2026-04-20",
        "status": "Active Rental",
        "canClose": true,
      },
    },

    "featuredVehicles": {
      "source": "api",
      "endpoint": "/vehicles/featured",
      "cache": false,
      "value": null,
      "fallback": {
        "items": [
          {
            "vehicleId": "bmw_7_sedan_001",
            "title": "BMW 7 Sedan",
            "category": "Sedan · Premium",
            "api_path": "/3d_view.json",
            "api_path_type": "POST",
            "api_path_data": {"vehicleId": "vehicleId"},
            "image":
                "http://100.30.214.39:3000/cars/bmw-7-sedan-4d-blue-2023-US.png",
            "price": {"label": "Per day", "value": 165, "currency": "GBP"},
            "backgroundImage": "http://100.30.214.39:3000/cars/bg.jpg",
            "tags": [
              {"icon": "car", "label": "Sedan"},
              {"icon": "speed", "label": "Automatic"},
              {"icon": "fuel", "label": "Diesel"},
              {"icon": "person", "label": "5 seats"},
              {"icon": "key", "label": "Digital key"},
            ],
          },
        ],
      },
    },
  },

  "actions": {
    "dismissActiveRental": {
      "type": "dismiss_widget",
      "params": {"target": "active_rental_card"},
    },

    "openAiSearch": {"type": "open_ai_search", "params": {}},

    "goToVehicleDetail": {
      "type": "navigate",
      "params": {"route": "vehicle_detail", "vehicleIdParamKey": "vehicleId"},
    },

    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": true,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "active_rental_card",
        "type": "active_card",
        "bind": "dynamicData.activeRental",
        "visibleWhen": "dynamicData.activeRental != null",
        "classes": ["bg-white", "rounded-lg", "p-md", "mb-lg", "shadow-sm"],

        "theme": {
          "title": ["text-black", "text-sm", "font-bold"],
          "subtitle": ["text-muted", "text-xs", "font-medium"],
          "bookingId": ["text-black", "text-xs", "font-semibold"],
          "endDate": ["text-muted", "text-xs", "font-medium"],

          "statusDot": ["bg-success", "rounded-full"],

          "close": ["bg-grey", "rounded-md", "p-sm"],
          "closeIcon": ["text-black"],
        },
        "config": {
          "layout": [
            {
              "type": "container",
              "action": {"type": "active_rental_tray"},
              "child": {
                "type": "row",
                "crossAxis": "center",
                "children": [
                  {
                    "type": "container",
                    "themeKey": "statusDot",

                    "width": 10,
                    "height": 10,
                    "classes": ["pl-xs"],
                  },

                  {
                    "type": "column",
                    "flex": 1,
                    "classes": ["ml-md"],
                    "crossAxis": "start",
                    "children": [
                      {"type": "text", "key": "title", "themeKey": "title"},
                      {
                        "type": "text",
                        "key": "subtitle",
                        "themeKey": "subtitle",
                        "classes": ["mt-xs"],
                      },
                    ],
                  },

                  {
                    "type": "column",
                    "crossAxis": "end",
                    "children": [
                      {
                        "type": "text",
                        "key": "bookingId",
                        "themeKey": "bookingId",
                      },
                      {
                        "type": "text",
                        "key": "endDate",
                        "themeKey": "endDate",
                        "classes": ["mt-xs"],
                      },
                    ],
                  },

                  {
                    "type": "container",
                    "themeKey": "close",
                    "visibleWhen": "canClose == true",
                    "classes": ["ml-md"],
                    "height": 34,
                    "width": 34,
                    "alignment": "center",
                    "action": {"type": "close"},
                    "child": {
                      "type": "icon",
                      "icon": "close",
                      "themeKey": "closeIcon",
                      "size": "lg",
                    },
                  },
                ],
              },
            },
          ],
        },

        "props": {
          "title": "Active Rental",
          "vehicleNameKey": "vehicleName",
          "bookingIdKey": "bookingId",
          "endDateKey": "endDate",
          "showCloseKey": "canClose",
          "closeActionRef": "dismissActiveRental",
        },
      },

      {
        "id": "hero_text",
        "type": "text_block",
        "bind": "content.heroText",
        "classes": ["mb-md"],

        "theme": {
          "eyebrow": ["text-muted", "text-xs", "font-bold"],
          "eyebrowIcon": ["text-muted"],
          "title": ["text-body", "text-3xl", "font-extrabold"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "start",
              "children": [
                {
                  "type": "row",
                  "crossAxis": "center",
                  "children": [
                    {
                      "type": "icon",
                      "key": "eyebrowIcon",
                      "themeKey": "eyebrowIcon",
                      "size": "sm",
                    },
                    {
                      "type": "text",
                      "key": "eyebrow",
                      "themeKey": "eyebrow",
                      "classes": ["ml-xs"],
                    },
                  ],
                },
                {
                  "type": "text",
                  "key": "title",
                  "themeKey": "title",
                  "classes": ["mt-sm"],
                },
              ],
            },
          ],
        },

        "props": {
          "eyebrowKey": "eyebrow",
          "titleKey": "title",
          "align": "start",
          "eyebrowIconKey": "eyebrowIcon",
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
        "id": "home_search_panel",
        "type": "home_search_panel",
        "classes": ["mb-2xl", 'mt-2xl'],

        "props": {
          "title": "Find your perfect QDrive vehicle",

          "departure": {
            "label": "Departure",
            "placeholder": "City, airport or station",
            "value": "",
            "leadingIcon": "location",
            "tabs": [
              {"id": "airport", "label": "Airport", "icon": "plane"},
              {"id": "station", "label": "Station", "icon": "train"},
            ],
            "airportItems": [
              "Leeds Bradford Airport",
              "Liverpool John Lennon Airport",
              "London City Airport",
              "London Gatwick Airport North Terminal",
              "London Gatwick Airport South Terminal",
              "London Heathrow Airport Terminal 2",
              "London Heathrow Airport Terminal 3",
            ],
            "stationItems": [
              "London King’s Cross",
              "London Paddington",
              "London Victoria",
              "London St Pancras International",
              "London Waterloo",
              "London Liverpool Street",
              "London Bridge",
            ],
          },

          "returnLocation": {
            "label": "Return Location",
            "placeholder": "City, airport or station",
            "value": "",
            "leadingIcon": "location",
          },

          "pickup": {
            "label": "Add date and time",
            "placeholder": "Add date and time",
            "leadingIcon": "calendar",
            "month": "May 2026",
            "times": [
              "9:00 AM",
              "9:30 AM",
              "10:00 AM",
              "10:30 AM",
              "11:00 AM",
              "11:30 AM",
              "12:00 PM",
              "12:30 PM",
            ],
          },

          "dropoff": {
            "label": "Add date and time",
            "placeholder": "Add date and time",
            "leadingIcon": "calendar",
            "month": "May 2026",
            "times": [
              "9:00 AM",
              "9:30 AM",
              "10:00 AM",
              "10:30 AM",
              "11:00 AM",
              "11:30 AM",
              "12:00 PM",
              "12:30 PM",
            ],
          },

          "buttonLabel": "Search",

          "moreFilters": {"label": "More filters", "icon": "search"},
        },
      },
      {
        "id": "fleet_heading",
        "type": "text_block",
        "bind": "content.fleetSection",
        "classes": ["mb-lg", 'mt-2xl'],

        "theme": {
          "eyebrow": ["text-muted", "text-xs", "font-bold"],
          "title": ["text-body", "text-xl", "font-bold"],
          "subtitle": ["text-muted", "text-sm"],
        },

        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "start",
              "children": [
                {"type": "text", "key": "eyebrow", "themeKey": "eyebrow"},
                {
                  "type": "text",
                  "key": "title",
                  "themeKey": "title",
                  "classes": ["mt-xs"],
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

        "props": {
          "eyebrowKey": "eyebrow",
          "titleKey": "title",
          "subtitleKey": "subtitle",
          "align": "start",
        },
      },

      {
        "id": "featured_vehicle_cards",
        "type": "featured_card",
        "bind": "dynamicData.featuredVehicles",
        "classes": ["mb-xl"],

        "theme": {
          "card": ["bg-muted", "border-muted", "rounded-2xl", "mb-lg"],
          "content": ["p-lg"],
          "backgroundImage": ["rounded-2xl"],
          "backgroundOverlay": ["bg-black-opacity", "rounded-2xl"],

          "title": ["text-white", "text-sm", "font-bold"],
          "category": ["text-muted", "text-xs"],

          "vehicleImage": ["rounded-xl"],

          "specText": ["text-muted", "text-xs"],
          "specIcon": ["text-muted"],

          "divider": ["border-muted"],

          "price": ["text-white", "text-sm", "font-bold"],
          "priceLabel": ["text-muted", "text-xs"],
        },

        "config": {
          "layout": [
            {
              "type": "for_each",
              "itemsKey": "items",
              "itemName": "vehicle",
              "layout": "column",
              "child": {
                "type": "container",
                "themeKey": "card",
                "fullWidth": true,
                "action": {
                  "type": "api_call",
                  "params": {
                    "apiPathKey": "vehicle.api_path",
                    "methodKey": "vehicle.api_path_type",
                    "body": {"vehicleIdKey": "vehicle.vehicleId"},
                  },
                },
                "child": {
                  "type": "stack",
                  "children": [
                    {
                      "type": "image",
                      "key": "vehicle.backgroundImage",
                      "themeKey": "backgroundImage",
                      "fit": "cover",
                      "height": 350,
                      "fullWidth": true,
                    },

                    {
                      "type": "container",
                      "themeKey": "backgroundOverlay",
                      "height": 350,
                      "fullWidth": true,
                    },

                    {
                      "type": "container",
                      "themeKey": "content",
                      "fullWidth": true,
                      "child": {
                        "type": "column",
                        "crossAxis": "stretch",
                        "children": [
                          {
                            "type": "text",
                            "key": "vehicle.title",
                            "themeKey": "title",
                            "maxLines": 1,
                            "overflow": "ellipsis",
                          },

                          {
                            "type": "text",
                            "key": "vehicle.category",
                            "themeKey": "category",
                            "classes": ["mt-xs"],
                            "maxLines": 1,
                            "overflow": "ellipsis",
                          },

                          {
                            "type": "align",
                            "alignment": "center",
                            "classes": ["mt-lg"],
                            "child": {
                              "type": "image",
                              "key": "vehicle.image",
                              "themeKey": "vehicleImage",
                              "height": 145,
                              "fit": "contain",
                            },
                          },

                          {
                            "type": "for_each",
                            "itemsKey": "vehicle.tags",
                            "itemName": "tag",
                            "layout": "wrap",
                            "classes": ["mt-lg"],
                            "spacing": 14,
                            "runSpacing": 10,
                            "child": {
                              "type": "row",
                              "mainAxisSize": "min",
                              "crossAxis": "center",
                              "children": [
                                {
                                  "type": "icon",
                                  "key": "tag.icon",
                                  "themeKey": "specIcon",
                                  "size": "sm",
                                },
                                {
                                  "type": "text",
                                  "key": "tag.label",
                                  "themeKey": "specText",
                                  "classes": ["ml-xs"],
                                  "maxLines": 1,
                                  "overflow": "ellipsis",
                                },
                              ],
                            },
                          },

                          {
                            "type": "divider",
                            "themeKey": "divider",
                            "classes": ["mt-lg", "mb-md"],
                          },

                          {
                            "type": "row",
                            "crossAxis": "end",
                            "children": [
                              {
                                "type": "column",
                                "crossAxis": "start",
                                "flex": 1,
                                "children": [
                                  {
                                    "type": "row",
                                    "mainAxisSize": "min",
                                    "crossAxis": "end",
                                    "children": [
                                      {
                                        "type": "text",
                                        "value": "£",
                                        "themeKey": "price",
                                      },
                                      {
                                        "type": "text",
                                        "key": "vehicle.price.value",
                                        "themeKey": "price",
                                      },
                                    ],
                                  },
                                  {
                                    "type": "text",
                                    "key": "vehicle.price.label",
                                    "themeKey": "priceLabel",
                                    "classes": ["mt-xs"],
                                  },
                                ],
                              },
                            ],
                          },
                        ],
                      },
                    },
                  ],
                },
              },
            },
          ],
        },
        "props": {
          "itemsKey": "items",
          "vehicleIdKey": "vehicleId",
          "titleKey": "title",
          "categoryKey": "category",
          "imageKey": "image",
          "priceKey": "price",
          "tagsKey": "tags",
          "actionRef": "goToVehicleDetail",
        },
      },
    ],
  },
};
