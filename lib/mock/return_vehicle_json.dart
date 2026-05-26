const Map<dynamic, dynamic> returnVehicleJson = {
  "version": "1.0",
  "screen": "return_vehicle",

  "meta": {
    "generatedAt": "2026-05-18T10:00:00Z",
    "cacheKey": "return_vehicle_v6",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {"title": "Return Vehicle", "subtitle": "Complete your rental"},
  },

  "dynamicData": {
    "returnVehicle": {
      "source": "api",
      "endpoint": "/bookings/return",
      "cache": false,
      "params": {"bookingId": "BK-2026-4521"},
      "value": null,
      "fallback": {
        "bookingId": "BK-2026-4521",

        "photosUploaded": false,
        "inspectionComplete": false,

        "status": {
          "label": "Return Status",
          "title": "Ready to Return",
          "text": "Please return the vehicle to the designated location",
          "icon": "check_circle",
        },

        "details": {
          "returnDate": {
            "icon": "calendar",
            "label": "Return Date & Time",
            "value": "April 25, 2026",
            "subtitle": "Before 10:00 AM",
          },
          "returnLocation": {
            "icon": "location",
            "label": "Return Location",
            "value": "Downtown Location",
            "subtitle": "123 Main Street, City Center",
            "link": "Get Directions →",
          },
        },

        "checklist": {
          "fuel": {
            "title": "Fuel Tank Full",
            "text": "Vehicle must be returned with a full tank",
          },
          "interior": {
            "title": "Clean Interior",
            "text": "Remove all personal belongings",
          },
          "photos": {
            "title": "Upload Photos",
            "text": "Take photos of the vehicle condition",
            "buttonLabel": "Take Photos",
          },
        },

        "inspection": {
          "waitingTitle": "Awaiting Inspection",
          "waitingText":
              "Supplier will inspect the vehicle within 24 hours of return",
          "buttonLabel": "Mark as Inspected (Demo)",
          "completeTitle": "Inspection Complete",
          "completeText":
              "No damages found. Your deposit will be released within 7 days.",
        },

        "depositPending": {
          "amountLabel": "Deposit Amount",
          "amount": "£250.00",
          "progress": 0.72,
          "note": "Pending final inspection",
        },

        "depositComplete": {
          "amountLabel": "Deposit Amount",
          "amount": "£250.00",
          "progress": 1.0,
          "note": "Deposit will be released in 7 days",
        },

        "support": {
          "icon": "chat",
          "title": "Need help with your return?",
          "buttonLabel": "Contact Support",
        },

        "review": {
          "title": "Rate Your Experience",
          "question": "How was your rental experience?",
          "label": "Share your experience (optional)",
          "placeholder": "Tell us about your experience...",
          "buttonLabel": "Submit Review",
        },
      },
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},

    "takeReturnPhotos": {
      "type": "take_return_photos",
      "params": {"bookingId": "BK-2026-4521"},
    },

    "markReturnInspectedDemo": {
      "type": "mark_return_inspected_demo",
      "params": {"bookingId": "BK-2026-4521"},
    },

    "contactSupport": {"type": "open_chat", "params": {}},

    "submitReview": {
      "type": "submit_return_review",
      "params": {"bookingId": "BK-2026-4521"},
    },

    "completeReturnLater": {
      "type": "complete_return_later",
      "params": {"bookingId": "BK-2026-4521"},
    },
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "return_vehicle_back",
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
              "type": "row",
              "children": [
                {
                  "type": "container",
                  "themeKey": "iconButton",
                  "action": {"type": "go_back"},
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
        "id": "return_vehicle_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-xl"],
        "theme": {
          "title": ["text-body", "text-lg", "font-bold"],
          "subtitle": ["text-muted", "text-xs"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "column",
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
          ],
        },
      },

      {
        "id": "return_status_card",
        "type": "text_block",
        "bind": "dynamicData.returnVehicle",
        "classes": ["mb-xl"],
        "theme": {
          "card": ["bg-info", "rounded-xl", "p-lg"],
          "iconBox": ["bg-white-opacity-soft", "rounded-full", "p-sm"],
          "icon": ["text-white"],
          "label": ["text-white", "text-xs"],
          "title": ["text-white", "text-base", "font-bold"],
          "text": ["text-white", "text-xs", "font-medium"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "container",
              "themeKey": "card",
              "fullWidth": true,
              "child": {
                "type": "column",
                "crossAxis": "start",
                "children": [
                  {
                    "type": "row",
                    "crossAxis": "center",
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "iconBox",
                        "width": 42,
                        "height": 42,
                        "alignment": "center",
                        "child": {
                          "type": "icon",
                          "key": "status.icon",
                          "themeKey": "icon",
                          "size": "md",
                        },
                      },
                      {
                        "type": "column",
                        "classes": ["ml-md"],
                        "children": [
                          {
                            "type": "text",
                            "key": "status.label",
                            "themeKey": "label",
                          },
                          {
                            "type": "text",
                            "key": "status.title",
                            "themeKey": "title",
                            "classes": ["mt-xs"],
                          },
                        ],
                      },
                    ],
                  },
                  {
                    "type": "text",
                    "key": "status.text",
                    "themeKey": "text",
                    "classes": ["mt-lg"],
                  },
                ],
              },
            },
          ],
        },
      },

      {
        "id": "return_details",
        "type": "text_block",
        "bind": "dynamicData.returnVehicle",
        "classes": ["mb-xl"],
        "theme": {
          "sectionTitle": ["text-body", "text-base", "font-bold"],
          "card": ["bg-card-soft", "rounded-xl", "p-md"],
          "icon": ["text-muted"],
          "label": ["text-muted", "text-xs"],
          "value": ["text-body", "text-sm", "font-bold"],
          "subtitle": ["text-muted", "text-xs"],
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
                  "value": "Return Details",
                  "themeKey": "sectionTitle",
                },
                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "row",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "icon",
                        "key": "details.returnDate.icon",
                        "themeKey": "icon",
                        "size": "sm",
                      },
                      {
                        "type": "column",
                        "classes": ["ml-md"],
                        "flex": 1,
                        "children": [
                          {
                            "type": "text",
                            "key": "details.returnDate.label",
                            "themeKey": "label",
                          },
                          {
                            "type": "text",
                            "key": "details.returnDate.value",
                            "themeKey": "value",
                            "classes": ["mt-xs"],
                          },
                          {
                            "type": "text",
                            "key": "details.returnDate.subtitle",
                            "themeKey": "subtitle",
                            "classes": ["mt-xs"],
                          },
                        ],
                      },
                    ],
                  },
                },
                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-sm"],
                  "child": {
                    "type": "row",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "icon",
                        "key": "details.returnLocation.icon",
                        "themeKey": "icon",
                        "size": "sm",
                      },
                      {
                        "type": "column",
                        "classes": ["ml-md"],
                        "flex": 1,
                        "children": [
                          {
                            "type": "text",
                            "key": "details.returnLocation.label",
                            "themeKey": "label",
                          },
                          {
                            "type": "text",
                            "key": "details.returnLocation.value",
                            "themeKey": "value",
                            "classes": ["mt-xs"],
                          },
                          {
                            "type": "text",
                            "key": "details.returnLocation.subtitle",
                            "themeKey": "subtitle",
                            "classes": ["mt-xs"],
                          },
                          {
                            "type": "container",
                            "classes": ["mt-md"],
                            "action": {"type": "open_return_directions"},
                            "child": {
                              "type": "text",
                              "key": "details.returnLocation.link",
                              "themeKey": "link",
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
        "id": "return_checklist",
        "type": "text_block",
        "bind": "dynamicData.returnVehicle",
        "classes": ["mb-xl"],
        "theme": {
          "sectionTitle": ["text-body", "text-base", "font-bold"],
          "card": ["bg-transparent", "border-muted", "rounded-xl", "p-md"],
          "checkCircle": ["bg-success", "rounded-full"],
          "emptyCircle": ["bg-muted", "rounded-full"],
          "checkIcon": ["text-white"],
          "title": ["text-body", "text-sm", "font-bold"],
          "text": ["text-muted", "text-xs"],
          "button": ["bg-white", "rounded-md", "px-md", "py-sm"],
          "buttonIcon": ["text-black"],
          "buttonLabel": ["text-black", "text-xs", "font-bold"],
          "photoBox": ["bg-card-soft", "rounded-md", "p-md"],
          "photoIcon": ["text-muted"],
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
                  "value": "Return Checklist",
                  "themeKey": "sectionTitle",
                },

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
                        "themeKey": "checkCircle",
                        "width": 20,
                        "height": 20,
                        "alignment": "center",
                        "child": {
                          "type": "icon",
                          "icon": "check_circle",
                          "themeKey": "checkIcon",
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
                            "key": "checklist.fuel.title",
                            "themeKey": "title",
                          },
                          {
                            "type": "text",
                            "key": "checklist.fuel.text",
                            "themeKey": "text",
                            "classes": ["mt-xs"],
                          },
                        ],
                      },
                    ],
                  },
                },

                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-sm"],
                  "child": {
                    "type": "row",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "checkCircle",
                        "width": 20,
                        "height": 20,
                        "alignment": "center",
                        "child": {
                          "type": "icon",
                          "icon": "check_circle",
                          "themeKey": "checkIcon",
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
                            "key": "checklist.interior.title",
                            "themeKey": "title",
                          },
                          {
                            "type": "text",
                            "key": "checklist.interior.text",
                            "themeKey": "text",
                            "classes": ["mt-xs"],
                          },
                        ],
                      },
                    ],
                  },
                },

                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-sm"],
                  "visibleWhen": "returnUi.photosUploaded == false",
                  "child": {
                    "type": "row",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "emptyCircle",
                        "width": 20,
                        "height": 20,
                      },
                      {
                        "type": "column",
                        "classes": ["ml-md"],
                        "flex": 1,
                        "children": [
                          {
                            "type": "text",
                            "key": "checklist.photos.title",
                            "themeKey": "title",
                          },
                          {
                            "type": "text",
                            "key": "checklist.photos.text",
                            "themeKey": "text",
                            "classes": ["mt-xs"],
                          },
                          {
                            "type": "container",
                            "themeKey": "button",
                            "classes": ["mt-md"],
                            "action": {"type": "take_return_photos"},
                            "child": {
                              "type": "row",
                              "mainAxisSize": "min",
                              "crossAxis": "center",
                              "children": [
                                {
                                  "type": "icon",
                                  "icon": "camera",
                                  "themeKey": "buttonIcon",
                                  "size": "sm",
                                },
                                {
                                  "type": "text",
                                  "key": "checklist.photos.buttonLabel",
                                  "themeKey": "buttonLabel",
                                  "classes": ["ml-sm"],
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
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-sm"],
                  "visibleWhen": "returnUi.photosUploaded == true",
                  "child": {
                    "type": "row",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "checkCircle",
                        "width": 20,
                        "height": 20,
                        "alignment": "center",
                        "child": {
                          "type": "icon",
                          "icon": "check_circle",
                          "themeKey": "checkIcon",
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
                            "key": "checklist.photos.title",
                            "themeKey": "title",
                          },
                          {
                            "type": "text",
                            "key": "checklist.photos.text",
                            "themeKey": "text",
                            "classes": ["mt-xs"],
                          },
                          {
                            "type": "row",
                            "classes": ["mt-md"],
                            "children": [
                              {
                                "type": "container",
                                "themeKey": "photoBox",
                                "width": 52,
                                "height": 52,
                                "alignment": "center",
                                "child": {
                                  "type": "icon",
                                  "icon": "camera",
                                  "themeKey": "photoIcon",
                                  "size": "sm",
                                },
                              },
                              {
                                "type": "container",
                                "themeKey": "photoBox",
                                "classes": ["ml-sm"],
                                "width": 52,
                                "height": 52,
                                "alignment": "center",
                                "child": {
                                  "type": "icon",
                                  "icon": "camera",
                                  "themeKey": "photoIcon",
                                  "size": "sm",
                                },
                              },
                              {
                                "type": "container",
                                "themeKey": "photoBox",
                                "classes": ["ml-sm"],
                                "width": 52,
                                "height": 52,
                                "alignment": "center",
                                "child": {
                                  "type": "icon",
                                  "icon": "camera",
                                  "themeKey": "photoIcon",
                                  "size": "sm",
                                },
                              },
                              {
                                "type": "container",
                                "themeKey": "photoBox",
                                "classes": ["ml-sm"],
                                "width": 52,
                                "height": 52,
                                "alignment": "center",
                                "child": {
                                  "type": "icon",
                                  "icon": "camera",
                                  "themeKey": "photoIcon",
                                  "size": "sm",
                                },
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
          ],
        },
      },

      {
        "id": "inspection_status",
        "type": "text_block",
        "bind": "dynamicData.returnVehicle",
        "classes": ["mb-xl"],
        "theme": {
          "sectionTitle": ["text-body", "text-base", "font-bold"],

          "pendingCard": [
            "bg-warning-soft",
            "border-warning",
            "rounded-xl",
            "p-lg",
          ],
          "pendingIcon": ["text-warning"],
          "pendingTitle": ["text-warning", "text-sm", "font-bold"],
          "pendingText": ["text-warning", "text-xs", "font-bold"],
          "pendingButton": ["bg-warning", "rounded-md", "px-md", "py-sm"],
          "pendingButtonLabel": ["text-black", "text-xs", "font-bold"],

          "completeCard": [
            "bg-success-dark",
            "border-success",
            "rounded-xl",
            "p-lg",
          ],
          "completeIcon": ["text-success-soft"],
          "completeTitle": ["text-success-soft", "text-sm", "font-bold"],
          "completeText": ["text-success", "text-xs", "font-bold"],
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
                  "value": "Inspection",
                  "themeKey": "sectionTitle",
                },

                {
                  "type": "container",
                  "themeKey": "pendingCard",
                  "classes": ["mt-md"],
                  "visibleWhen": "returnUi.inspectionComplete == false",
                  "child": {
                    "type": "row",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "icon",
                        "icon": "warning",
                        "themeKey": "pendingIcon",
                        "size": "md",
                      },
                      {
                        "type": "column",
                        "classes": ["ml-md"],
                        "flex": 1,
                        "children": [
                          {
                            "type": "text",
                            "key": "inspection.waitingTitle",
                            "themeKey": "pendingTitle",
                          },
                          {
                            "type": "text",
                            "key": "inspection.waitingText",
                            "themeKey": "pendingText",
                            "classes": ["mt-xs"],
                          },
                          {
                            "type": "container",
                            "themeKey": "pendingButton",
                            "classes": ["mt-md"],
                            "action": {"type": "mark_return_inspected_demo"},
                            "child": {
                              "type": "text",
                              "key": "inspection.buttonLabel",
                              "themeKey": "pendingButtonLabel",
                            },
                          },
                        ],
                      },
                    ],
                  },
                },

                {
                  "type": "container",
                  "themeKey": "completeCard",
                  "classes": ["mt-md"],
                  "visibleWhen": "returnUi.inspectionComplete == true",
                  "child": {
                    "type": "row",
                    "crossAxis": "start",
                    "children": [
                      {
                        "type": "icon",
                        "icon": "check_circle",
                        "themeKey": "completeIcon",
                        "size": "md",
                      },
                      {
                        "type": "column",
                        "classes": ["ml-md"],
                        "flex": 1,
                        "children": [
                          {
                            "type": "text",
                            "key": "inspection.completeTitle",
                            "themeKey": "completeTitle",
                          },
                          {
                            "type": "text",
                            "key": "inspection.completeText",
                            "themeKey": "completeText",
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
        "id": "deposit_status",
        "type": "progress_section",
        "bind": "dynamicData.returnVehicle",
        "classes": ["mb-xl"],
        "theme": {
          "sectionTitle": ["text-body", "text-base", "font-bold"],
          "card": ["bg-card-soft", "rounded-xl", "p-md"],
          "label": ["text-muted", "text-xs"],
          "value": ["text-body", "text-sm", "font-bold"],
          "track": ["bg-muted", "rounded-full"],
          "fill": ["bg-white", "rounded-full"],
          "note": ["text-muted", "text-xs"],
        },
        "props": {
          "title": "Deposit Status",

          "pendingLabelKey": "depositPending.amountLabel",
          "pendingValueKey": "depositPending.amount",
          "pendingProgressKey": "depositPending.progress",
          "pendingNoteKey": "depositPending.note",

          "completeLabelKey": "depositComplete.amountLabel",
          "completeValueKey": "depositComplete.amount",
          "completeProgressKey": "depositComplete.progress",
          "completeNoteKey": "depositComplete.note",
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {"type": "text", "key": "title", "themeKey": "sectionTitle"},

                {
                  "type": "container",
                  "themeKey": "card",
                  "classes": ["mt-md"],
                  "child": {
                    "type": "column",
                    "crossAxis": "stretch",
                    "children": [
                      {
                        "type": "row",
                        "visibleWhen": "returnUi.inspectionComplete == false",
                        "children": [
                          {
                            "type": "text",
                            "key": "depositPending.amountLabel",
                            "themeKey": "label",
                            "flex": 1,
                          },
                          {
                            "type": "text",
                            "key": "depositPending.amount",
                            "themeKey": "value",
                          },
                        ],
                      },

                      {
                        "type": "row",
                        "visibleWhen": "returnUi.inspectionComplete == true",
                        "children": [
                          {
                            "type": "text",
                            "key": "depositComplete.amountLabel",
                            "themeKey": "label",
                            "flex": 1,
                          },
                          {
                            "type": "text",
                            "key": "depositComplete.amount",
                            "themeKey": "value",
                          },
                        ],
                      },

                      {
                        "type": "container",
                        "themeKey": "track",
                        "classes": ["mt-sm"],
                        "height": 6,
                        "fullWidth": true,
                        "visibleWhen": "returnUi.inspectionComplete == false",
                        "child": {
                          "type": "container",
                          "themeKey": "fill",
                          "height": 6,
                          "progressKey": "depositPending.progress",
                        },
                      },

                      {
                        "type": "container",
                        "themeKey": "track",
                        "classes": ["mt-sm"],
                        "height": 6,
                        "fullWidth": true,
                        "visibleWhen": "returnUi.inspectionComplete == true",
                        "child": {
                          "type": "container",
                          "themeKey": "fill",
                          "height": 6,
                          "progressKey": "depositComplete.progress",
                        },
                      },

                      {
                        "type": "text",
                        "key": "depositPending.note",
                        "themeKey": "note",
                        "classes": ["mt-sm"],
                        "visibleWhen": "returnUi.inspectionComplete == false",
                      },

                      {
                        "type": "text",
                        "key": "depositComplete.note",
                        "themeKey": "note",
                        "classes": ["mt-sm"],
                        "visibleWhen": "returnUi.inspectionComplete == true",
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
        "id": "rate_experience",
        "type": "return_review_section",
        "classes": ["mb-xl"],
        "props": {
          "title": "Rate Your Experience",
          "question": "How was your rental experience?",
          "label": "Share your experience (optional)",
          "placeholder": "Tell us about your experience...",
          "buttonLabel": "Submit Review",
        },
      },

      {
        "id": "return_support",
        "type": "text_block",
        "bind": "dynamicData.returnVehicle",
        "classes": ["mb-xl"],
        "visibleWhen": "returnUi.inspectionComplete == false",
        "theme": {
          "card": ["bg-card-soft", "rounded-xl", "p-xl"],
          "icon": ["text-muted"],
          "title": ["text-muted", "text-xs", "text-center"],
          "buttonLabel": ["text-info", "text-xs", "font-bold", "text-center"],
        },
        "props": {},
        "config": {
          "layout": [
            {
              "type": "container",
              "themeKey": "card",
              "fullWidth": true,
              "child": {
                "type": "column",
                "crossAxis": "center",
                "children": [
                  {
                    "type": "icon",
                    "key": "support.icon",
                    "themeKey": "icon",
                    "size": "lg",
                  },
                  {
                    "type": "text",
                    "key": "support.title",
                    "themeKey": "title",
                    "classes": ["mt-md"],
                    "textAlign": "center",
                  },
                  {
                    "type": "container",
                    "classes": ["mt-md"],
                    "action": {"type": "open_chat"},
                    "child": {
                      "type": "text",
                      "key": "support.buttonLabel",
                      "themeKey": "buttonLabel",
                      "textAlign": "center",
                    },
                  },
                ],
              },
            },
          ],
        },
      },

      {
        "id": "return_vehicle_bottom_bar",
        "type": "bottom_bar",
        "visibleWhen": "returnUi.showReturnLaterBar == true",

        "classes": ["bg-app", "border-muted", "p-md"],
        "theme": {
          "button": ["bg-card-soft", "rounded-xl", "px-lg", "py-md"],
          "buttonLabel": ["text-body", "text-sm", "font-bold"],
        },
        "props": {
          "mode": "single_button",
          "buttonLabel": "Complete Return Later",
          "button": {
            "label": "Complete Return Later",
            "action": {"type": "go_home"},
          },
        },
      },
    ],
  },
};
