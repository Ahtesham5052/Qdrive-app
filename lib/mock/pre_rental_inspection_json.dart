const Map<dynamic, dynamic> preRentalInspectionJson = {
  "version": "1.0",
  "screen": "pre_rental_inspection",

  "meta": {
    "generatedAt": "2026-05-18T10:00:00Z",
    "cacheKey": "pre_rental_inspection_v4_fixed_row_height",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "tokens", "ui"],
  },

  "content": {
    "header": {"title": "Almost Ready!", "subtitle": "Your rental starts soon"},

    "status": {
      "label": "Status",
      "title": "Ready for Pickup",
      "description":
          "Your vehicle is prepared and ready. We'll notify you 24 hours before pickup.",
    },

    "quickLinks": {"title": "QUICK LINKS"},

    "countdown": {
      "title": "Time Until Pickup",
      "items": [
        {"value": "02", "label": "Days"},
        {"value": "14", "label": "Hours"},
        {"value": "32", "label": "Minutes"},
        {"value": "18", "label": "Seconds"},
      ],
    },

    "pickupDetails": {
      "title": "Pickup Details",
      "items": [
        {
          "icon": "calendar",
          "label": "Pickup Date & Time",
          "value": "April 20, 2026",
          "meta": "10:00 AM",
        },
        {
          "icon": "location",
          "label": "Pickup Location",
          "value": "Downtown Location",
          "meta": "123 Main Street, City Center",
          "linkLabel": "Get Directions →",
        },
        {
          "icon": "car",
          "label": "Your Vehicle",
          "value": "Premium Sedan",
          "meta": "License plate will be revealed on pickup day",
        },
      ],
    },

    "flight": {
      "title": "Traveling by plane? Add your flight number",
      "subtitle":
          "Let your car supplier know when and where to expect you, especially if your flight is delayed.",
      "icon": "plane",
      "fields": [
        {
          "id": "departureDate",
          "label": "Departure date",
          "placeholder": "mm/dd/yyyy",
          "value": "",
          "icon": "calendar",
          "type": "date",
          "keyboardType": "datetime",
          "width": "half",
        },
        {
          "id": "flightNumber",
          "label": "Flight number",
          "placeholder": "AA 123",
          "value": "",
          "type": "text",
          "keyboardType": "text",
          "width": "half",
        },
      ],
    },
    "bring": {
      "title": "What to Bring",
      "items": [
        "Valid driving license",
        "Credit/debit card used for booking",
        "Booking reference: QD-7X9K2M",
      ],
    },

    "pickupOptions": {
      "title": "Pickup Options",
      "collect": {
        "title": "Collect at Location",
        "description": "Visit our downtown branch to collect your vehicle",
        "infoLabel": "Opening Hours",
        "infoValue": "24/7 Available",
      },
      "delivery": {
        "title": "Delivery to Address",
        "description": "Not selected for this booking",
      },
    },

    "tripIntelligence": {
      "title": "Trip Intelligence",
      "cardTitle": "AI-Powered Recommendations",
      "description":
          "Based on your destination and travel dates, we recommend:",
      "items": [
        {
          "label": "Nearest fuel station",
          "value": "0.3 miles from pickup location",
        },
        {
          "label": "Parking at destination",
          "value": "£8/day · Book via our partner",
        },
        {
          "label": "Traffic prediction",
          "value": "Light traffic expected on your route",
        },
      ],
    },

    "support": {
      "title": "Need Help?",
      "buttonLabel": "Contact Support",
      "notificationsLabel": "We'll send you notifications via:",
      "channels": ["Email", "SMS", "WhatsApp"],
    },

    "bottomBar": {"buttonLabel": "Start Rental (Demo)"},
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},

    "changeTrip": {
      "type": "navigate",
      "params": {"route": "/booking/change-trip"},
    },

    "confirmation": {
      "type": "navigate",
      "params": {"route": "/booking/confirmation"},
    },

    "conditions": {
      "type": "navigate",
      "params": {"route": "/booking/conditions"},
    },

    "receipt": {
      "type": "navigate",
      "params": {"route": "/booking/receipt"},
    },

    "cancelRental": {
      "type": "show_policy_detail_snackbar",
      "params": {"message": "Cancellation options will be available soon."},
    },

    "getDirections": {
      "type": "show_policy_detail_snackbar",
      "params": {"message": "Directions will open from the supplier address."},
    },

    "contactSupport": {"type": "open_chat", "params": {}},

    "startRental": {
      "type": "navigate",
      "params": {"route": "rental_start_inspection"},
    },

    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "pre_rental_top_back",
        "type": "button_group",
        "classes": ["mb-md"],
        "theme": {
          "iconButton": [
            "bg-card-soft",
            "border-muted",
            "rounded-full",
            "p-sm",
          ],
          "iconButtonIcon": ["text-body"],
        },
        "props": {
          "align": "start",
          "buttons": [
            {
              "icon": "arrow_back",
              "variant": "icon",
              "action": {"type": "go_back", "params": {}},
            },
          ],
        },
        "config": {
          "layout": [
            {
              "type": "row",
              "crossAxis": "center",
              "children": [
                {
                  "type": "container",
                  "themeKey": "iconButton",
                  "action": {"type": "go_back", "params": {}},
                  "child": {
                    "type": "icon",
                    "icon": "arrow_back",
                    "themeKey": "iconButtonIcon",
                    "size": "lg",
                  },
                },
              ],
            },
          ],
        },
      },

      {
        "id": "pre_rental_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-md"],
        "theme": {
          "title": ["text-body", "text-lg", "font-bold"],
          "subtitle": ["text-muted", "text-xs"],
          "divider": ["border-muted"],
        },
        "props": {"titleKey": "title", "subtitleKey": "subtitle"},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "text",
                  "key": "subtitle",
                  "themeKey": "subtitle",
                  "classes": ["mt-xs"],
                },
                {
                  "type": "divider",
                  "themeKey": "divider",
                  "classes": ["mt-lg"],
                },
              ],
            },
          ],
        },
      },

      {
        "id": "pre_rental_status",
        "type": "text_block",
        "bind": "content.status",
        "classes": ["mb-lg"],
        "theme": {
          "card": ["bg-success", "rounded-lg", "p-md"],
          "iconBox": ["bg-success-soft", "rounded-full", "p-sm"],
          "icon": ["text-white"],
          "label": ["text-white", "text-xs", "font-bold"],
          "title": ["text-white", "text-sm", "font-bold"],
          "description": ["text-white", "text-xs", "font-bold"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "container",
              "themeKey": "card",
              "child": {
                "type": "row",
                "crossAxis": "start",
                "children": [
                  {
                    "type": "container",
                    "themeKey": "iconBox",
                    "child": {
                      "type": "icon",
                      "icon": "check_circle",
                      "themeKey": "icon",
                      "size": "md",
                    },
                  },
                  {
                    "type": "column",
                    "classes": ["ml-md"],
                    "flex": 1,
                    "children": [
                      {"type": "text", "key": "label", "themeKey": "label"},
                      {
                        "type": "text",
                        "key": "title",
                        "themeKey": "title",
                        "classes": ["mt-xs"],
                      },
                      {
                        "type": "text",
                        "key": "description",
                        "themeKey": "description",
                        "classes": ["mt-sm"],
                      },
                    ],
                  },
                ],
              },
            },
          ],
        },
      },

      {
        "id": "pre_rental_quick_links",
        "type": "text_block",
        "bind": "content.quickLinks",
        "classes": ["mb-lg"],
        "theme": {
          "label": ["text-muted", "text-2xs", "font-bold", "uppercase"],
          "button": [
            "bg-card-soft",
            "border-muted",
            "rounded-md",
            "px-sm",
            "py-sm",
          ],
          "dangerButton": [
            "bg-danger-soft",
            "border-danger",
            "rounded-md",
            "px-sm",
            "py-sm",
          ],
          "icon": ["text-body"],
          "dangerIcon": ["text-danger"],
          "buttonText": ["text-body", "text-2xs", "font-bold", "text-center"],
          "dangerText": ["text-danger", "text-2xs", "font-bold", "text-center"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "text",
                  "key": "title",
                  "themeKey": "label",
                  "classes": ["mb-sm"],
                },
                {
                  "type": "wrap",
                  "crossAxis": "center",
                  "children": [
                    {
                      "type": "container",
                      "flex": 1,
                      "themeKey": "button",
                      "classes": ["mr-xs"],
                      "width": 90,
                      "action": {"type": "open_vehicle_list_tray"},
                      "child": {
                        "type": "column",
                        "mainAxis": "center",
                        "crossAxis": "center",
                        "children": [
                          {
                            "type": "icon",
                            "icon": "calendar",
                            "themeKey": "icon",
                            "size": "xs",
                          },
                          {
                            "type": "text",
                            "value": "Change trip",
                            "themeKey": "buttonText",
                            "classes": ["mt-xs"],
                            "maxLines": 1,
                            "overflow": "ellipsis",
                          },
                        ],
                      },
                    },
                    {
                      "type": "container",
                      "flex": 1,
                      "themeKey": "button",
                      "classes": ["mr-xs"],
                      "width": 90,
                      "action": {"type": "open_confirmation_tray"},
                      "child": {
                        "type": "column",
                        "mainAxis": "center",
                        "crossAxis": "center",
                        "children": [
                          {
                            "type": "icon",
                            "icon": "confirmation",
                            "themeKey": "icon",
                            "size": "xs",
                          },
                          {
                            "type": "text",
                            "value": "Confirmation",
                            "themeKey": "buttonText",
                            "classes": ["mt-xs"],
                            "maxLines": 1,
                            "overflow": "ellipsis",
                          },
                        ],
                      },
                    },
                    {
                      "type": "container",
                      "flex": 1,
                      "themeKey": "button",
                      "classes": ["mr-xs"],
                      "width": 90,
                      "action": {"type": "open_condition_tray"},
                      "child": {
                        "type": "column",
                        "mainAxis": "center",
                        "crossAxis": "center",
                        "children": [
                          {
                            "type": "icon",
                            "icon": "conditions",
                            "themeKey": "icon",
                            "size": "xs",
                          },
                          {
                            "type": "text",
                            "value": "Conditions",
                            "themeKey": "buttonText",
                            "classes": ["mt-xs"],
                            "maxLines": 1,
                            "overflow": "ellipsis",
                          },
                        ],
                      },
                    },
                    {
                      "type": "container",
                      "flex": 1,
                      "themeKey": "button",
                      "classes": ["mr-xs"],
                      "width": 90,
                      "action": {"type": "open_receipt_tray"},
                      "child": {
                        "type": "column",
                        "mainAxis": "center",
                        "crossAxis": "center",
                        "children": [
                          {
                            "type": "icon",
                            "icon": "receipt",
                            "themeKey": "icon",
                            "size": "xs",
                          },
                          {
                            "type": "text",
                            "value": "Receipt",
                            "themeKey": "buttonText",
                            "classes": ["mt-xs"],
                            "maxLines": 1,
                            "overflow": "ellipsis",
                          },
                        ],
                      },
                    },
                    {
                      "type": "container",
                      "flex": 1,
                      "themeKey": "dangerButton",
                      "width": 90,
                      "action": {"type": "open_cancellation_tray"},
                      "child": {
                        "type": "column",
                        "mainAxis": "center",
                        "crossAxis": "center",
                        "children": [
                          {
                            "type": "icon",
                            "icon": "cancel",
                            "themeKey": "dangerIcon",
                            "size": "xs",
                          },
                          {
                            "type": "text",
                            "value": "Cancel",
                            "themeKey": "dangerText",
                            "classes": ["mt-xs"],
                            "maxLines": 1,
                            "overflow": "ellipsis",
                          },
                        ],
                      },
                    },
                  ],
                },
              ],
            },
          ],
        },
      },

      {
        "id": "pre_rental_countdown",
        "type": "text_block",
        "bind": "content.countdown",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-sm", "font-bold"],
          "card": ["bg-card-soft", "rounded-lg", "py-md"],
          "value": ["text-body", "text-base", "font-bold", "text-center"],
          "label": ["text-muted", "text-2xs", "text-center"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "text",
                  "key": "title",
                  "themeKey": "title",
                  "classes": ["mb-sm"],
                },
                {
                  "type": "for_each",
                  "itemsKey": "items",
                  "itemName": "time",
                  "layout": "row",
                  "expanded": true,
                  "child": {
                    "type": "container",
                    "themeKey": "card",
                    "classes": ["mr-sm"],
                    "child": {
                      "type": "column",
                      "crossAxis": "center",
                      "children": [
                        {
                          "type": "text",
                          "key": "time.value",
                          "themeKey": "value",
                        },
                        {
                          "type": "text",
                          "key": "time.label",
                          "themeKey": "label",
                          "classes": ["mt-xs"],
                        },
                      ],
                    },
                  },
                },
              ],
            },
          ],
        },
      },

      {
        "id": "pre_rental_pickup_details",
        "type": "text_block",
        "bind": "content.pickupDetails",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-sm", "font-bold"],
          "card": ["bg-card-soft", "rounded-lg", "p-md", "mb-sm"],
          "icon": ["text-muted"],
          "label": ["text-muted", "text-xs"],
          "value": ["text-body", "text-xs", "font-bold"],
          "meta": ["text-muted", "text-xs"],
          "link": ["text-info", "text-xs", "font-bold"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "text",
                  "key": "title",
                  "themeKey": "title",
                  "classes": ["mb-sm"],
                },
                {
                  "type": "for_each",
                  "itemsKey": "items",
                  "itemName": "detail",
                  "layout": "column",
                  "child": {
                    "type": "container",
                    "classes": ["mb-md"],

                    "themeKey": "card",
                    "child": {
                      "type": "row",
                      "crossAxis": "start",
                      "children": [
                        {
                          "type": "icon",
                          "key": "detail.icon",
                          "themeKey": "icon",
                          "size": "xs",
                        },
                        {
                          "type": "column",
                          "classes": ["ml-md"],
                          "flex": 1,
                          "children": [
                            {
                              "type": "text",
                              "key": "detail.label",
                              "themeKey": "label",
                            },
                            {
                              "type": "text",
                              "key": "detail.value",
                              "themeKey": "value",
                              "classes": ["mt-xs"],
                            },
                            {
                              "type": "text",
                              "key": "detail.meta",
                              "themeKey": "meta",
                              "classes": ["mt-xs"],
                            },
                            {
                              "type": "container",
                              "visibleWhen": "detail.linkLabel != null",
                              "classes": ["mt-sm"],
                              "action": {
                                "type": "show_policy_detail_snackbar",
                                "params": {
                                  "message":
                                      "Directions will open from the supplier address.",
                                },
                              },
                              "child": {
                                "type": "text",
                                "key": "detail.linkLabel",
                                "themeKey": "link",
                              },
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
      },

      {
        "id": "pre_rental_flight",
        "type": "form_section",
        "bind": "content.flight",
        "classes": ["mb-lg"],
        "theme": {
          "card": ["bg-card-soft", "border-muted", "rounded-lg", "p-md"],
          "title": ["text-body", "text-sm", "font-bold"],
          "subtitle": ["text-muted", "text-xs"],
          "icon": ["text-body"],
          "label": ["text-body", "text-xs", "font-bold"],
          "field": ["bg-black", "border-muted", "rounded-md", "px-md", "py-sm"],
          "fieldText": ["text-body", "text-xs"],
          "placeholderText": ["text-muted", "text-xs"],
          "fieldIcon": ["text-muted"],
        },
        "config": {
          "layout": [
            {
              "type": "container",
              "themeKey": "card",
              "child": {
                "type": "column",
                "crossAxis": "stretch",
                "children": [
                  {
                    "type": "row",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "icon",
                        "key": "icon",
                        "themeKey": "icon",
                        "size": "md",
                      },
                      {
                        "type": "column",
                        "flex": 1,
                        "classes": ["ml-md"],
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
                    ],
                  },
                  {
                    "type": "form_fields",
                    "itemsKey": "fields",
                    "classes": ["mt-md"],
                  },
                ],
              },
            },
          ],
        },
        "props": {
          "titleKey": "title",
          "subtitleKey": "subtitle",
          "iconKey": "icon",
          "fieldsKey": "fields",
          "submitMode": "manual",
        },
      },
      {
        "id": "pre_rental_bring",
        "type": "text_block",
        "bind": "content.bring",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-sm", "font-bold"],
          "card": ["bg-info-soft", "border-info", "rounded-lg", "p-md"],
          "icon": ["text-surface"],
          "iconBox": ['rounded-full', 'bg-info'],

          "itemText": ["text-body", "text-xs", "font-bold"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "text",
                  "key": "title",
                  "themeKey": "title",
                  "classes": ["mb-sm"],
                },
                {
                  "type": "container",
                  "themeKey": "card",
                  "child": {
                    "type": "for_each",
                    "itemsKey": "items",
                    "itemName": "bringItem",
                    "layout": "column",
                    "child": {
                      "type": "row",
                      "crossAxis": "start",
                      "classes": ["mb-sm"],
                      "children": [
                        {
                          "type": "container",
                          "themeKey": "iconBox",
                          "child": {
                            "type": "icon",
                            "icon": "check",
                            "themeKey": "icon",
                            "size": "xs",
                          },
                        },
                        {
                          "type": "text",
                          "key": "bringItem",
                          "themeKey": "itemText",
                          "classes": ["ml-sm"],
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
      },

      {
        "id": "pre_rental_pickup_options",
        "type": "text_block",
        "bind": "content.pickupOptions",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-sm", "font-bold"],
          "selectedCard": [
            "bg-card-soft",
            "border-white",
            "rounded-lg",
            "p-md",
          ],
          "disabledCard": [
            "bg-transparent",
            "border-muted",
            "rounded-lg",
            "p-md",
            "opacity-50",
          ],
          "radioActive": ["text-body"],
          "radioInactive": ["text-muted"],
          "optionTitle": ["text-body", "text-xs", "font-bold"],
          "optionText": ["text-muted", "text-xs"],
          "infoBox": ["bg-page", "rounded-md", "p-sm", "mt-sm"],
          "infoIcon": ["text-muted"],
          "infoTitle": ["text-body", "text-xs", "font-bold"],
          "infoText": ["text-muted", "text-xs"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "text",
                  "key": "title",
                  "themeKey": "title",
                  "classes": ["mb-sm"],
                },
                {
                  "type": "container",
                  "themeKey": "selectedCard",
                  "classes": ["mb-sm"],
                  "child": {
                    "type": "column",
                    "crossAxis": "stretch",
                    "children": [
                      {
                        "type": "row",
                        "crossAxis": "start",
                        "children": [
                          {
                            "type": "icon",
                            "icon": "radio_button_checked",
                            "themeKey": "radioActive",
                            "size": "xs",
                          },
                          {
                            "type": "column",
                            "classes": ["ml-sm"],
                            "flex": 1,
                            "children": [
                              {
                                "type": "text",
                                "key": "collect.title",
                                "themeKey": "optionTitle",
                              },
                              {
                                "type": "text",
                                "key": "collect.description",
                                "themeKey": "optionText",
                                "classes": ["mt-xs"],
                              },
                            ],
                          },
                        ],
                      },
                      {
                        "type": "container",
                        "themeKey": "infoBox",
                        "child": {
                          "type": "row",
                          "crossAxis": "center",
                          "children": [
                            {
                              "type": "icon",
                              "icon": "clock",
                              "themeKey": "infoIcon",
                              "size": "xs",
                            },
                            {
                              "type": "column",
                              "classes": ["ml-sm"],
                              "flex": 1,
                              "children": [
                                {
                                  "type": "text",
                                  "key": "collect.infoLabel",
                                  "themeKey": "infoTitle",
                                },
                                {
                                  "type": "text",
                                  "key": "collect.infoValue",
                                  "themeKey": "infoText",
                                  "classes": ["mt-xs"],
                                },
                              ],
                            },
                          ],
                        },
                      },
                    ],
                  },
                },
                {
                  "type": "container",
                  "themeKey": "disabledCard",
                  "child": {
                    "type": "row",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "icon",
                        "icon": "radio_button_unchecked",
                        "themeKey": "radioInactive",
                        "size": "xs",
                      },
                      {
                        "type": "column",
                        "classes": ["ml-sm"],
                        "flex": 1,
                        "children": [
                          {
                            "type": "text",
                            "key": "delivery.title",
                            "themeKey": "optionTitle",
                          },
                          {
                            "type": "text",
                            "key": "delivery.description",
                            "themeKey": "optionText",
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
      },

      {
        "id": "pre_rental_trip_intelligence",
        "type": "text_block",
        "bind": "content.tripIntelligence",
        "classes": ["mb-lg"],
        "theme": {
          "title": ["text-body", "text-sm", "font-bold"],
          "card": ["bg-info-soft", "border-info", "rounded-lg", "p-md"],
          "iconBox": ["bg-info-dark", "rounded-md", "p-sm"],
          "icon": ["text-info"],
          "cardTitle": ["text-info", "text-xs", "font-bold"],
          "description": ["text-info", "text-xs"],
          "item": ["bg-surface", "rounded-md", "p-md", "mb-xs"],
          "itemLabel": ["text-muted", "text-xs"],
          "itemValue": ["text-body", "text-xs", "font-bold"],
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
                  "classes": ["mb-sm"],
                  "children": [
                    {
                      "type": "icon",
                      "icon": "sparkles",
                      "themeKey": "icon",
                      "size": "xs",
                    },
                    {
                      "type": "text",
                      "key": "title",
                      "themeKey": "title",
                      "classes": ["ml-xs"],
                    },
                  ],
                },
                {
                  "type": "container",
                  "themeKey": "card",
                  "child": {
                    "type": "row",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "iconBox",
                        "child": {
                          "type": "icon",
                          "icon": "navigation",
                          "themeKey": "icon",
                          "size": "sm",
                        },
                      },
                      {
                        "type": "column",
                        "classes": ["ml-md"],
                        "flex": 1,
                        "children": [
                          {
                            "type": "text",
                            "key": "cardTitle",
                            "themeKey": "cardTitle",
                          },
                          {
                            "type": "text",
                            "key": "description",
                            "themeKey": "description",
                            "classes": ["mt-xs", "mb-sm"],
                          },
                          {
                            "type": "for_each",
                            "itemsKey": "items",
                            "itemName": "trip",
                            "layout": "column",
                            "child": {
                              "type": "container",
                              "classes": ["mb-sm"],
                              "themeKey": "item",
                              "child": {
                                "type": "column",
                                "crossAxis": "stretch",
                                "children": [
                                  {
                                    "type": "text",
                                    "key": "trip.label",
                                    "themeKey": "itemLabel",
                                  },
                                  {
                                    "type": "text",
                                    "key": "trip.value",
                                    "themeKey": "itemValue",
                                    "classes": ["mt-xs"],
                                  },
                                ],
                              },
                            },
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
      },

      {
        "id": "pre_rental_support",
        "type": "text_block",
        "bind": "content.support",
        "classes": ["mb-xl"],
        "theme": {
          "title": ["text-body", "text-sm", "font-bold"],
          "button": ["bg-white", "rounded-lg", "py-md"],
          "buttonIcon": ["text-black"],
          "buttonText": ["text-black", "text-xs", "font-bold", "text-center"],
          "notifyCard": ["bg-card-soft", "rounded-lg", "p-md"],
          "notifyIcon": ["text-info"],
          "notifyText": ["text-muted", "text-xs"],
          "pill": ["bg-surface", "rounded-full", "px-sm", "py-xs"],
          "pillText": ["text-body", "text-2xs", "font-bold"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "text",
                  "key": "title",
                  "themeKey": "title",
                  "classes": ["mb-sm"],
                },
                {
                  "type": "container",
                  "themeKey": "button",
                  "action": {"type": "open_chat", "params": {}},
                  "child": {
                    "type": "row",
                    "mainAxis": "center",
                    "crossAxis": "center",
                    "children": [
                      {
                        "type": "icon",
                        "icon": "phone",
                        "themeKey": "buttonIcon",
                        "size": "xs",
                      },
                      {
                        "type": "text",
                        "key": "buttonLabel",
                        "themeKey": "buttonText",
                        "classes": ["ml-sm"],
                        "textAlign": "center",
                      },
                    ],
                  },
                },
                {
                  "type": "container",
                  "themeKey": "notifyCard",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "column",
                    "crossAxis": "stretch",
                    "children": [
                      {
                        "type": "row",
                        "crossAxis": "center",
                        "children": [
                          {
                            "type": "icon",
                            "icon": "phone",
                            "themeKey": "notifyIcon",
                            "size": "xs",
                          },
                          {
                            "type": "text",
                            "key": "notificationsLabel",
                            "themeKey": "notifyText",
                            "classes": ["ml-xs"],
                            "flex": 1,
                          },
                        ],
                      },
                      {
                        "type": "for_each",
                        "itemsKey": "channels",
                        "itemName": "channel",
                        "layout": "row",
                        "classes": ["mt-sm"],
                        "child": {
                          "type": "container",
                          "themeKey": "pill",
                          "classes": ["mr-sm"],
                          "child": {
                            "type": "text",
                            "key": "channel",
                            "themeKey": "pillText",
                          },
                        },
                      },
                    ],
                  },
                },
              ],
            },
          ],
        },
      },

      {
        "id": "bottom_start_rental_bar",
        "type": "bottom_bar",
        "bind": "content.bottomBar",
        "classes": ["bg-app", "border-muted", "p-md"],
        "theme": {
          "container": ["bg-app", "border-muted", "px-md", "py-md"],
          "button": ["bg-white", "rounded-lg", "px-lg", "py-md"],
          "buttonLabel": ["text-black", "text-sm", "font-bold"],
        },
        "props": {
          "mode": "single_button",
          "buttonLabel": "Start Rental (Demo)",
          "button": {
            "labelKey": "buttonLabel",
            "action": {"type": "open_active_rental"},
          },
        },
      },
    ],
  },
};
