const Map<dynamic, dynamic> checkoutJson = {
  "version": "1.0",
  "screen": "booking_checkout",

  "meta": {
    "generatedAt": "2026-05-17T10:00:00Z",
    "cacheKey": "booking_checkout_v3_six_steps_full_merged",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "checkout": {
      "steps": [
        {
          "step": 1,
          "label": "DATES",
          "stepText": "Step 1 of 6",
          "title": "Booking option",
        },
        {
          "step": 2,
          "label": "PICKUP / DROP-OFF",
          "stepText": "Step 2 of 6",
          "title": "Booking option",
        },
        {
          "step": 3,
          "label": "MILEAGE",
          "stepText": "Step 3 of 6",
          "title": "Booking option",
        },
        {
          "step": 4,
          "label": "PROTECTION PACKAGE",
          "stepText": "Step 4 of 6",
          "title": "Booking option",
        },
        {
          "step": 5,
          "label": "EXTRAS",
          "stepText": "Step 5 of 6",
          "title": "Booking option",
        },
        {
          "step": 6,
          "label": "QDRIVE PASS",
          "stepText": "Step 6 of 6",
          "title": "Booking option",
        },
      ],
    },
  },

  "dynamicData": {
    "checkout": {
      "source": "api",
      "endpoint": "/bookings/checkout",
      "cache": false,
      "params": {"bookingId": "BK-2026-4521"},
      "value": null,

      "fallback": {
        "bookingId": "BK-2026-4521",
        "currentStep": 1,
        "totalSteps": 6,

        "currency": "GBP",
        "totalPrice": "£865.45",

        "selectedDeliveryOption": "pickup_at_location",
        "selectedCollectionOption": "drop_off_at_location",
        "selectedDeliveryTime": "evening",
        "selectedCollectionTime": "evening",
        "selectedMileage": "600_miles",
        "selectedProtection": "no_extra_protection",
        "selectedQdrivePass": "standard_pass",

        "rentalPeriod": {
          "title": "Rental Period",
          "duration": "Duration: 5 days",
          "items": [
            {
              "label": "Pickup Date & Time",
              "value": "04/20/2026 10:00 AM",
              "icon": "calendar",
            },
            {
              "label": "Return Date & Time",
              "value": "04/25/2026 10:00 AM",
              "icon": "calendar",
            },
          ],
        },

        "flightDetails": {
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
              "width": "half",
            },
            {
              "id": "flightNumber",
              "label": "Flight number",
              "placeholder": "AA 123",
              "value": "",
              "type": "text",
              "width": "half",
            },
          ],
        },

        "deliveryPreference": {
          "title": "Delivery Preference",
          "options": [
            {
              "id": "pickup_at_location",
              "title": "Pickup at location",
              "description": "123 Main Street, City Center",
              "price": "Free",
            },
            {
              "id": "deliver_to_address",
              "title": "Deliver to address",
              "description": "We'll deliver the car to your location",
              "price": "+ £25",
              "calculation": {
                "addressIcon": "location",
                "address": "45 Oxford Street, London W1D 2DZ",
                "buttonLabel": "Calculate Distance",
                "successMessage": "Delivery distance calculated successfully.",
                "breakdownIcon": "truck",
                "breakdownTitle": "Delivery Cost Breakdown",
                "baseFeeLabel": "Base delivery fee",
                "baseFee": 30,
                "distanceLabel": "Distance",
                "distanceMiles": 13,
                "pricePerMile": 2,
                "totalLabel": "Total delivery",

                "addressBoxClasses": [
                  "bg-card-soft",
                  "border-muted",
                  "rounded-lg",
                  "p-md",
                ],
                "addressIconClasses": ["text-muted"],
                "addressTextClasses": ["text-body", "text-xs"],

                "calculateButtonClasses": [
                  "bg-inverse-card",
                  "rounded-md",
                  "px-md",
                  "py-sm",
                ],
                "calculateButtonLabelClasses": [
                  "text-inverse-body",
                  "text-xs",
                  "font-bold",
                ],

                "accentText": ["text-success", "text-xs", "font-bold"],
                "boxClasses": [
                  "bg-success-soft",
                  "border-success",
                  "rounded-lg",
                  "p-md",
                ],

                "breakdownIconClasses": ["text-success"],
                "breakdownTitleClasses": ["text-body", "text-sm", "font-bold"],
                "breakdownLabelClasses": ["text-muted", "text-xs"],
                "breakdownValueClasses": ["text-body", "text-xs", "font-bold"],
                "breakdownTotalLabelClasses": [
                  "text-success",
                  "text-xs",
                  "font-bold",
                ],
                "breakdownTotalValueClasses": [
                  "text-success",
                  "text-sm",
                  "font-bold",
                ],

                "timeTitle": "Select Delivery Time",
                "timeTitleClasses": ["text-body", "text-sm", "font-bold"],
                "timeSlotClasses": [
                  "bg-card-soft",
                  "border-success",
                  "rounded-md",
                  "p-sm",
                ],
                "selectedTimeSlotClasses": ["bg-success", "rounded-md", "p-sm"],
                "timeText": ["text-success", "text-xs", "font-bold"],
                "selectedTimeText": ["text-black", "text-xs", "font-bold"],

                "timeSlots": [
                  {"id": "morning", "label": "Morning", "time": "8am-12pm"},
                  {"id": "afternoon", "label": "Afternoon", "time": "12pm-4pm"},
                  {"id": "evening", "label": "Evening", "time": "4pm-8pm"},
                ],
              },
            },
          ],
        },

        "collectionPreference": {
          "title": "Collection Preference",
          "options": [
            {
              "id": "drop_off_at_location",
              "title": "Drop-off at location",
              "description": "Return vehicle to 123 Main Street, City Center",
              "price": "Free",
            },
            {
              "id": "collection_from_address",
              "title": "Collection from address",
              "description": "We'll collect the vehicle from your location",
              "price": "+ £25",
              "calculation": {
                "addressIcon": "location",
                "address": "45 Oxford Street, London W1D 2DZ",
                "buttonLabel": "Calculate Distance",
                "successMessage":
                    "Collection distance calculated successfully.",
                "breakdownIcon": "truck",
                "breakdownTitle": "Collection Cost Breakdown",
                "baseFeeLabel": "Base collection fee",
                "baseFee": 25,
                "distanceLabel": "Distance",
                "distanceMiles": 26,
                "pricePerMile": 1.5,
                "totalLabel": "Total collection",

                "addressBoxClasses": [
                  "bg-card-soft",
                  "border-muted",
                  "rounded-lg",
                  "p-md",
                ],
                "addressIconClasses": ["text-muted"],
                "addressTextClasses": ["text-body", "text-xs"],

                "calculateButtonClasses": [
                  "bg-inverse-card",
                  "rounded-md",
                  "px-md",
                  "py-sm",
                ],
                "calculateButtonLabelClasses": [
                  "text-inverse-body",
                  "text-xs",
                  "font-bold",
                ],

                "accentText": ["text-info", "text-xs", "font-bold"],
                "boxClasses": [
                  "bg-info-soft",
                  "border-info",
                  "rounded-lg",
                  "p-md",
                ],

                "breakdownIconClasses": ["text-info"],
                "breakdownTitleClasses": ["text-body", "text-sm", "font-bold"],
                "breakdownLabelClasses": ["text-muted", "text-xs"],
                "breakdownValueClasses": ["text-body", "text-xs", "font-bold"],
                "breakdownTotalLabelClasses": [
                  "text-info",
                  "text-xs",
                  "font-bold",
                ],
                "breakdownTotalValueClasses": [
                  "text-info",
                  "text-sm",
                  "font-bold",
                ],

                "timeTitle": "Select Collection Time",
                "timeTitleClasses": ["text-body", "text-sm", "font-bold"],
                "timeSlotClasses": [
                  "bg-card-soft",
                  "border-info",
                  "rounded-md",
                  "p-sm",
                ],
                "selectedTimeSlotClasses": ["bg-info", "rounded-md", "p-sm"],
                "timeText": ["text-info", "text-xs", "font-bold"],
                "selectedTimeText": ["text-white", "text-xs", "font-bold"],

                "timeSlots": [
                  {"id": "morning", "label": "Morning", "time": "8am-12pm"},
                  {"id": "afternoon", "label": "Afternoon", "time": "12pm-4pm"},
                  {"id": "evening", "label": "Evening", "time": "4pm-8pm"},
                ],
              },
            },
          ],
        },

        "mileage": {
          "title": "Mileage",
          "subtitle": "Choose how many miles you need for this rental.",
          "options": [
            {
              "id": "600_miles",
              "title": "600 miles",
              "badge": "Included",
              "badgeIcon": "check",
              "description": "+£0.38 / for every additional mile",
              "price": "600 miles included",
            },
            {
              "id": "1000_miles",
              "title": "1000 miles",
              "description": "+£0.38 / for every additional mile",
              "price": "+£2.10 / day",
            },
            {
              "id": "unlimited_miles",
              "title": "Unlimited miles",
              "description": "All miles are included in the price",
              "price": "+£18.2 / day",
            },
          ],
        },

        "protectionPackage": {
          "title": "Protection Package",
          "subtitle": "Which protection package do you need?",
          "description":
              "Without protection, up to the full vehicle value will be charged in case of damage or theft.",
          "options": [
            {
              "id": "no_extra_protection",
              "title": "No extra protection",
              "badge": "Included",
              "badgeIcon": "check",
              "description": "Deductible: up to full vehicle value",
              "linkLabel": "View coverage",
              "coverageText":
                  "You remain responsible for repair or replacement costs up to the full value of the vehicle for damage, loss, or theft.",
            },
            {
              "id": "cover_the_car",
              "title": "Cover The Car",
              "description": "No deductible",
              "price": "£10.02 / day",
              "linkLabel": "View coverage",
              "coverageItems": [
                "100% coverage for car damage and theft",
                "£300k liability protection for injury or property damage to others",
                "24/7 roadside assistance",
                "Medical coverage for you and your passengers",
                "Protection for the belongings of you, family, and other drivers",
              ],
            },
          ],
        },

        "extras": {
          "title": "Add Extras",
          "items": [
            {
              "id": "child_seat",
              "title": "Child Seat",
              "price": "£10/day",
              "quantity": 1,
            },
            {
              "id": "gps_device",
              "title": "GPS Device",
              "price": "£8/day",
              "quantity": 2,
            },
            {
              "id": "additional_driver",
              "title": "Additional Driver",
              "price": "£15/day",
              "quantity": 1,
            },
            {
              "id": "wifi_hotspot",
              "title": "WiFi Hotspot",
              "price": "£12/day",
              "quantity": 1,
            },
          ],
        },

        "securityDeposit": {
          "title": "Security Deposit Required",
          "description":
              "A refundable security deposit of £250 is required for this booking. The deposit will be returned within 7 days after the rental period.",
          "icon": "security",
        },

        "qdrivePass": {
          "title": "Qdrive Pass",
          "selectedState": {
            "icon": "crown",
            "titleSuffix": "Added",
            "description":
                "Security deposit waived. Your membership has been added to this booking.",
            "removeLabel": "Remove membership",
          },
          "options": [
            {
              "id": "skip_deposit_with_qdrive_pass",
              "title": "Skip the Deposit with QDrive Pass",
              "description":
                  "Purchase any QDrive Pass membership and avoid paying the security deposit. Plus, get included rental days and exclusive benefits!",
              "icon": "crown",
              "plans": [
                {
                  "id": "standard_pass",
                  "title": "Standard Pass",
                  "description": "Drive more, pay less",
                  "price": "£199",
                  "billing": "per month",
                  "coverage": {
                    "viewLabel": "View coverage",
                    "hideLabel": "Hide coverage",
                    "billingNote": "Billed monthly • Cancel anytime",
                    "includedIcon": "calendar",
                    "includedTitle": "3 rental days per month",
                    "includedSubtitle": "Rolls over for 3 months if unused",
                    "features": [
                      "3 rental days per month",
                      "Access to any QDrive Rent-a-Car vehicle",
                      "No deposit required",
                      "No re-upload of documents after first verification",
                      "Driver Score continues to improve monthly",
                    ],
                    "bestForLabel": "Best for:",
                    "bestFor":
                        "Occasional drivers who want flexibility without commitment",
                  },
                },
                {
                  "id": "performance_pass",
                  "title": "Performance Pass",
                  "description": "Premium vehicles on demand",
                  "price": "£499",
                  "billing": "per month",
                  "badge": "Most Popular",
                  "coverage": {
                    "viewLabel": "View coverage",
                    "hideLabel": "Hide coverage",
                    "billingNote": "Billed monthly • Cancel anytime",
                    "includedIcon": "calendar",
                    "includedTitle": "3 rental days per month",
                    "includedSubtitle": "Rolls over for 3 months if unused",
                    "features": [
                      "3 rental days per month",
                      "Access to all Performance vehicles",
                      "Complimentary vehicle delivery",
                      "No deposits on bookings",
                      "Priority allocation on high-demand vehicles",
                    ],
                    "bestForLabel": "Best for:",
                    "bestFor": "Drivers who want premium cars regularly",
                  },
                },
                {
                  "id": "elite_pass",
                  "title": "Elite Pass",
                  "description": "Ultimate luxury experience",
                  "price": "£1499",
                  "billing": "per month",
                  "badge": "Premium",
                  "coverage": {
                    "viewLabel": "View coverage",
                    "hideLabel": "Hide coverage",
                    "billingNote": "Billed monthly • Cancel anytime",
                    "includedIcon": "calendar",
                    "includedTitle": "5 rental days per month",
                    "includedSubtitle": "Rolls over for 3 months if unused",
                    "features": [
                      "5 rental days per month",
                      "Access to entire fleet, including exotics",
                      "Complimentary delivery on every booking",
                      "Dedicated named advisor",
                      "Priority booking on peak dates",
                      "Fast-track vehicle allocation",
                    ],
                    "bestForLabel": "Best for:",
                    "bestFor": "High-frequency premium users & executives",
                  },
                },
              ],
            },
          ],
        },

        "priceDetails": {
          "title": "Price details",
          "subtitle":
              "Summary by step and line-item amounts. Total includes tax.",

          "summary": [
            {"title": "Dates", "value": "2026-04-20 → 2026-04-25 • 5 days"},
            {
              "title": "Pickup / Drop-off",
              "value":
                  "Pickup at supplier location\nReturn at supplier location",
            },
            {"title": "Mileage", "value": "600 miles"},
            {"title": "Protection package", "value": "No add-on cover"},
            {
              "title": "Extras",
              "value":
                  "Child seat ×1 · GPS ×2 · Additional driver ×1 · WiFi ×1",
            },
            {"title": "Qdrive Pass", "value": "Standard Pass"},
          ],

          "amountsTitle": "Amounts",

          "amounts": [
            {"label": "Base rental (5 days)", "value": 445.00},
            {"label": "Extras", "value": 265.00},
            {"label": "Delivery fee", "value": 64.00},
            {"label": "Collection fee", "value": 50.50},
            {"label": "Mileage (600 miles)", "value": 0.00},
            {"label": "Tax (10%)", "value": 102.35},
            {"label": "Standard Pass", "value": 199.00, "highlight": true},
          ],

          "totalLabel": "Total",
          "total": 1125.85,
          "currency": "GBP",
        },
      },
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},

    "checkoutBack": {
      "type": "checkout_previous_step",
      "params": {"bind": "dynamicData.checkout"},
    },

    "checkoutContinue": {
      "type": "checkout_next_step",
      "params": {
        "bind": "dynamicData.checkout",
        "totalSteps": 6,
        "finalRoute": "payment",
      },
    },

    "selectCheckoutOption": {"type": "select_checkout_option", "params": {}},

    "increaseExtra": {"type": "increase_extra", "params": {}},

    "decreaseExtra": {"type": "decrease_extra", "params": {}},

    "openPriceDetails": {
      "type": "open_checkout_price_details",
      "params": {"bind": "dynamicData.checkout.priceDetails"},
    },

    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "checkout_flow",
        "type": "checkout_flow",
        "bind": "dynamicData.checkout",
        "contentBind": "content.checkout",
        "classes": ["bg-app", "min-h-screen"],

        "config": {
          "header": {
            "id": "checkout_header",
            "type": "checkout_header",
            "classes": ["mb-lg"],
            "showBack": true,
            "backIcon": "arrow_back",
            "backActionRef": "goBack",
            "priceActionRef": "openPriceDetails",
          },

          "headerTheme": {
            "backButton": ["bg-card-soft", "rounded-full"],
            "backIcon": ["text-primary"],
            "title": ["text-body", "text-lg", "font-bold"],
            "stepLabel": ["text-muted", "text-xs", "font-bold"],
            "stepText": ["text-body", "text-xs"],
            "counter": ["bg-card-soft", "border-muted", "rounded-full"],
            "counterText": ["text-body", "text-xs", "font-bold"],
            "progressTrack": ["bg-muted"],
            "progressActive": ["bg-secondary"],
            "priceTotal": ["text-body", "text-sm", "font-bold"],
            "priceDetails": ["text-body", "text-xs", "font-bold", "underline"],
          },
        },

        "props": {
          "stepsKey": "steps",
          "currentStepKey": "currentStep",
          "totalStepsKey": "totalSteps",
          "totalPriceKey": "totalPrice",
          "priceActionRef": "openPriceDetails",

          "sections": [
            {
              "step": 1,
              "id": "rental_period",
              "type": "rental_period_section",
              "bind": "rentalPeriod",
              "classes": ["mb-lg"],
              "theme": {
                "title": ["text-body", "text-base", "font-bold"],
                "field": [
                  "bg-transparent",
                  "border-muted",
                  "rounded-lg",
                  "p-md",
                ],
                "fieldLabel": ["text-muted", "text-xs"],
                "fieldValue": ["text-body", "text-sm", "font-bold"],
                "icon": ["text-muted"],
                "duration": ["text-muted", "text-xs"],
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
                        "itemName": "item",
                        "layout": "column",
                        "classes": ["mt-md"],
                        "child": {
                          "type": "container",
                          "themeKey": "field",
                          "classes": ["mb-sm"],
                          "child": {
                            "type": "row",
                            "crossAxis": "center",
                            "children": [
                              {
                                "type": "icon",
                                "key": "item.icon",
                                "themeKey": "icon",
                                "size": "lg",
                              },
                              {
                                "type": "column",
                                "flex": 1,
                                "classes": ["ml-md"],
                                "children": [
                                  {
                                    "type": "text",
                                    "key": "item.label",
                                    "themeKey": "fieldLabel",
                                  },
                                  {
                                    "type": "text",
                                    "key": "item.value",
                                    "themeKey": "fieldValue",
                                    "classes": ["mt-xs"],
                                  },
                                ],
                              },
                              {
                                "type": "icon",
                                "icon": "calendar",
                                "themeKey": "icon",
                                "size": "md",
                              },
                            ],
                          },
                        },
                      },
                      {
                        "type": "text",
                        "key": "duration",
                        "themeKey": "duration",
                        "classes": ["mt-xs"],
                      },
                    ],
                  },
                ],
              },
              "props": {
                "titleKey": "title",
                "itemsKey": "items",
                "durationKey": "duration",
              },
            },

            {
              "step": 1,
              "id": "flight_details",
              "type": "form_section",
              "bind": "flightDetails",
              "classes": ["mb-lg"],
              "theme": {
                "card": ["bg-card-soft", "border-muted", "rounded-lg", "p-md"],
                "title": ["text-body", "text-sm", "font-bold"],
                "subtitle": ["text-muted", "text-xs"],
                "icon": ["text-body"],
                "label": ["text-body", "text-xs", "font-bold"],
                "field": [
                  "bg-black",
                  "border-muted",
                  "rounded-md",
                  "px-md",
                  "py-sm",
                ],
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
                                {
                                  "type": "text",
                                  "key": "title",
                                  "themeKey": "title",
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
              },
            },

            {
              "step": 2,
              "id": "delivery_preference",
              "type": "option_section",
              "bind": "deliveryPreference",
              "selectionKey": "selectedDeliveryOption",
              "classes": ["mb-lg"],
              "theme": {
                "title": ["text-body", "text-base", "font-bold"],
                "option": [
                  "bg-transparent",
                  "border-muted",
                  "rounded-lg",
                  "p-md",
                ],
                "selectedOption": [
                  "bg-card-soft",
                  "border-white",
                  "rounded-lg",
                  "p-md",
                ],
                "addressBox": [
                  "bg-transparent",
                  "border-muted",
                  "rounded-lg",
                  "p-md",
                ],
                "calculateButton": ["bg-card-soft", "rounded-md", "p-sm"],
                "calculateButtonLabel": ["text-body", "text-xs", "font-bold"],
                "calculationBox": [
                  "bg-success-dark",
                  "border-success",
                  "rounded-lg",
                  "p-md",
                ],
                "radio": ["border-white"],
                "selectedRadio": ["border-white"],
                "optionTitle": ["text-body", "text-sm", "font-bold"],
                "description": ["text-muted", "text-xs"],
                "price": ["text-success", "text-xs", "font-bold"],
                "calculationAccent": ["text-success", "text-xs", "font-bold"],
                "calculationTitle": ["text-success", "text-md", "font-bold"],
                "calculationTimeLabel": [
                  "text-success",
                  "text-md",
                  "font-bold",
                ],

                "divider": ["border-success"],
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
                        "itemsKey": "options",
                        "itemName": "option",
                        "layout": "column",
                        "classes": ["mt-md"],
                        "child": {
                          "type": "option_tile",
                          "key": "option",
                          "sectionIdKey": "sectionId",
                          "themeKey": "option",
                          "selectedThemeKey": "selectedOption",
                          "classes": ["mb-sm"],
                          "child": {
                            "type": "row",
                            "crossAxis": "start",
                            "children": [
                              {
                                "type": "option_radio",
                                "key": "option",
                                "themeKey": "radio",
                                "selectedThemeKey": "selectedRadio",
                              },
                              {
                                "type": "column",
                                "flex": 1,
                                "classes": ["ml-md"],
                                "children": [
                                  {
                                    "type": "text",
                                    "key": "option.title",
                                    "themeKey": "optionTitle",
                                  },
                                  {
                                    "type": "text",
                                    "key": "option.description",
                                    "themeKey": "description",
                                    "classes": ["mt-xs"],
                                    "visibleWhen": "option.description != null",
                                  },
                                  {
                                    "type": "text",
                                    "key": "option.price",
                                    "themeKey": "price",
                                    "classes": ["mt-xs"],
                                    "visibleWhen": "option.price != null",
                                  },
                                ],
                              },
                            ],
                          },
                        },
                      },

                      {
                        "type": "container",
                        "themeKey": "addressBox",
                        "classes": ["mt-xs"],
                        "visibleWhen": "showCalculationPanel == true",
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
                                  "key": "calculation.addressIcon",
                                  "themeKey": "description",
                                  "size": "md",
                                },
                                {
                                  "type": "text",
                                  "key": "calculation.address",
                                  "themeKey": "optionTitle",
                                  "classes": ["ml-sm"],
                                  "flex": 1,
                                },
                              ],
                            },
                            {
                              "type": "calculate_distance_button",
                              "sectionIdKey": "sectionId",
                              "optionKey": "selectedOption",
                              "themeKey": "calculateButton",
                              "classes": ["mt-sm"],
                              "child": {
                                "type": "text",
                                "key": "calculation.buttonLabel",
                                "themeKey": "calculateButtonLabel",
                                "textAlign": "center",
                              },
                            },
                          ],
                        },
                      },

                      {
                        "type": "container",
                        "themeKey": "calculationBox",
                        "classes": ["mt-sm"],
                        "visibleWhen": "calculation.calculated == true",
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
                                  "key": "calculation.breakdownIcon",
                                  "themeKey": "calculationAccent",
                                  "size": "lg",
                                },
                                {
                                  "type": "text",
                                  "key": "calculation.breakdownTitle",
                                  "themeKey": "calculationTitle",
                                  "classes": ["ml-sm"],
                                },
                              ],
                            },
                            {
                              "type": "text",
                              "key": "calculation.baseFeeText",
                              "themeKey": "calculationAccent",
                              "classes": ["mt-sm"],
                            },
                            {
                              "type": "text",
                              "key": "calculation.distanceText",
                              "themeKey": "calculationAccent",
                              "classes": ["mt-xs"],
                            },
                            {
                              "type": "divider",
                              "themeKey": "divider",
                              "classes": ["my-sm"],
                            },
                            {
                              "type": "text",
                              "key": "calculation.totalText",
                              "themeKey": "calculationAccent",
                            },
                            {
                              "type": "divider",
                              "themeKey": "divider",
                              "classes": ["my-sm"],
                            },
                            {
                              "type": "text",
                              "key": "calculation.timeTitle",
                              "themeKey": "calculationTimeLabel",
                              "classes": ["mt-md"],
                              "visibleWhen": "calculation.timeTitle != null",
                            },
                            {
                              "type": "for_each",
                              "itemsKey": "calculation.timeSlots",
                              "itemName": "slot",
                              "layout": "row",
                              "expanded": true,
                              "classes": ["mt-sm"],
                              "child": {
                                "type": "time_slot",
                                "key": "slot",
                                "height": 46,
                                "sectionIdKey": "sectionId",
                                "classes": ["mr-sm"],
                                "child": {
                                  "type": "column",
                                  "crossAxis": "center",
                                  "mainAxis": "center",
                                  "children": [
                                    {
                                      "type": "text",
                                      "key": "slot.label",
                                      "themeKey": "calculationAccent",
                                      "classListKey": "slot.textClasses",
                                      "textAlign": "center",
                                    },
                                    {
                                      "type": "text",
                                      "key": "slot.time",
                                      "themeKey": "calculationAccent",
                                      "classListKey": "slot.textClasses",
                                      "textAlign": "center",
                                    },
                                  ],
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
              "props": {
                "titleKey": "title",
                "optionsKey": "options",
                "optionActionRef": "selectCheckoutOption",
                "selectionKey": "selectedDeliveryOption",
              },
            },

            {
              "step": 2,
              "id": "collection_preference",
              "type": "option_section",
              "bind": "collectionPreference",
              "selectionKey": "selectedCollectionOption",
              "classes": ["mb-lg"],
              "theme": {
                "title": ["text-body", "text-base", "font-bold"],
                "option": [
                  "bg-transparent",
                  "border-muted",
                  "rounded-lg",
                  "p-md",
                ],
                "selectedOption": [
                  "bg-card-soft",
                  "border-white",
                  "rounded-lg",
                  "p-md",
                ],
                "addressBox": [
                  "bg-transparent",
                  "border-muted",
                  "rounded-lg",
                  "p-md",
                ],
                "calculateButton": ["bg-card-soft", "rounded-md", "p-sm"],
                "calculateButtonLabel": ["text-body", "text-xs", "font-bold"],
                "calculationBox": [
                  "bg-info-soft",
                  "border-info",
                  "rounded-lg",
                  "p-md",
                ],
                "radio": ["border-white"],
                "selectedRadio": ["border-white"],
                "optionTitle": ["text-body", "text-sm", "font-bold"],
                "description": ["text-muted", "text-xs"],
                "price": ["text-success", "text-xs", "font-bold"],
                "calculationAccent": ["text-info", "text-xs", "font-bold"],
                "calculationTitle": ["text-info", "text-md", "font-bold"],
                "calculationTimeLabel": [
                  "text-success",
                  "text-md",
                  "font-bold",
                ],

                "divider": ["border-info"],
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
                        "itemsKey": "options",
                        "itemName": "option",
                        "layout": "column",
                        "classes": ["mt-md"],
                        "child": {
                          "type": "option_tile",
                          "key": "option",
                          "sectionIdKey": "sectionId",
                          "themeKey": "option",
                          "selectedThemeKey": "selectedOption",
                          "classes": ["mb-sm"],
                          "child": {
                            "type": "row",
                            "crossAxis": "start",
                            "children": [
                              {
                                "type": "option_radio",
                                "key": "option",
                                "themeKey": "radio",
                                "selectedThemeKey": "selectedRadio",
                              },
                              {
                                "type": "column",
                                "flex": 1,
                                "classes": ["ml-md"],
                                "children": [
                                  {
                                    "type": "text",
                                    "key": "option.title",
                                    "themeKey": "optionTitle",
                                  },
                                  {
                                    "type": "text",
                                    "key": "option.description",
                                    "themeKey": "description",
                                    "classes": ["mt-xs"],
                                    "visibleWhen": "option.description != null",
                                  },
                                  {
                                    "type": "text",
                                    "key": "option.price",
                                    "themeKey": "price",
                                    "classes": ["mt-xs"],
                                    "visibleWhen": "option.price != null",
                                  },
                                ],
                              },
                            ],
                          },
                        },
                      },

                      {
                        "type": "container",
                        "themeKey": "addressBox",
                        "classes": ["mt-xs"],
                        "visibleWhen": "showCalculationPanel == true",
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
                                  "key": "calculation.addressIcon",
                                  "themeKey": "description",
                                  "size": "md",
                                },
                                {
                                  "type": "text",
                                  "key": "calculation.address",
                                  "themeKey": "optionTitle",
                                  "classes": ["ml-sm"],
                                  "flex": 1,
                                },
                              ],
                            },
                            {
                              "type": "calculate_distance_button",
                              "sectionIdKey": "sectionId",
                              "optionKey": "selectedOption",
                              "themeKey": "calculateButton",
                              "classes": ["mt-sm"],
                              "child": {
                                "type": "text",
                                "key": "calculation.buttonLabel",
                                "themeKey": "calculateButtonLabel",
                                "textAlign": "center",
                              },
                            },
                          ],
                        },
                      },

                      {
                        "type": "container",
                        "themeKey": "calculationBox",
                        "classes": ["mt-sm"],
                        "visibleWhen": "calculation.calculated == true",
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
                                  "key": "calculation.breakdownIcon",
                                  "themeKey": "calculationAccent",
                                  "size": "lg",
                                },
                                {
                                  "type": "text",
                                  "key": "calculation.breakdownTitle",
                                  "themeKey": "calculationTitle",
                                  "classes": ["ml-sm"],
                                },
                              ],
                            },
                            {
                              "type": "text",
                              "key": "calculation.baseFeeText",
                              "themeKey": "calculationAccent",
                              "classes": ["mt-sm"],
                            },
                            {
                              "type": "text",
                              "key": "calculation.distanceText",
                              "themeKey": "calculationAccent",
                              "classes": ["mt-xs"],
                            },
                            {
                              "type": "divider",
                              "themeKey": "divider",
                              "classes": ["my-sm"],
                            },
                            {
                              "type": "text",
                              "key": "calculation.totalText",
                              "themeKey": "calculationAccent",
                            },
                            {
                              "type": "divider",
                              "themeKey": "divider",
                              "classes": ["my-sm"],
                            },
                            {
                              "type": "text",
                              "key": "calculation.timeTitle",
                              "themeKey": "calculationLabel",
                              "classes": ["mt-md"],
                              "visibleWhen": "calculation.timeTitle != null",
                            },
                            {
                              "type": "for_each",
                              "itemsKey": "calculation.timeSlots",
                              "itemName": "slot",
                              "layout": "row",
                              "expanded": true,
                              "classes": ["mt-sm"],
                              "child": {
                                "type": "time_slot",
                                "key": "slot",
                                "sectionIdKey": "sectionId",
                                "height": 46,
                                "classes": ["mr-sm"],
                                "child": {
                                  "type": "column",
                                  "crossAxis": "center",
                                  "mainAxis": "center",
                                  "children": [
                                    {
                                      "type": "text",
                                      "key": "slot.label",
                                      "themeKey": "calculationAccent",
                                      "classListKey": "slot.textClasses",
                                      "textAlign": "center",
                                    },
                                    {
                                      "type": "text",
                                      "key": "slot.time",
                                      "themeKey": "calculationAccent",
                                      "classListKey": "slot.textClasses",
                                      "textAlign": "center",
                                    },
                                  ],
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
              "props": {
                "titleKey": "title",
                "optionsKey": "options",
                "optionActionRef": "selectCheckoutOption",
                "selectionKey": "selectedCollectionOption",
              },
            },

            {
              "step": 3,
              "id": "mileage",
              "type": "option_section",
              "bind": "mileage",
              "selectionKey": "selectedMileage",
              "classes": ["mb-lg"],
              "theme": {
                "title": ["text-body", "text-base", "font-bold"],
                "subtitle": ["text-muted", "text-xs"],
                "option": [
                  "bg-transparent",
                  "border-muted",
                  "rounded-lg",
                  "p-md",
                ],
                "selectedOption": [
                  "bg-card-soft",
                  "border-white",
                  "rounded-lg",
                  "p-md",
                ],
                "radio": ["border-white"],
                "selectedRadio": ["border-white"],
                "optionTitle": ["text-body", "text-sm", "font-bold"],
                "description": ["text-muted", "text-xs"],
                "price": ["text-body", "text-xs", "font-bold"],
                "badge": [
                  "bg-muted",
                  "rounded-full",
                  "px-sm",
                  "py-xs",
                  "text-xs",
                  "font-bold",
                ],
              },
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
                        "type": "for_each",
                        "itemsKey": "options",
                        "itemName": "option",
                        "layout": "column",
                        "classes": ["mt-md"],
                        "child": {
                          "type": "option_tile",
                          "key": "option",
                          "sectionIdKey": "sectionId",
                          "themeKey": "option",
                          "selectedThemeKey": "selectedOption",
                          "classes": ["mb-sm"],
                          "child": {
                            "type": "row",
                            "crossAxis": "start",
                            "children": [
                              {
                                "type": "option_radio",
                                "key": "option",
                                "themeKey": "radio",
                                "selectedThemeKey": "selectedRadio",
                              },
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
                                        "icon": "speed",
                                        "themeKey": "description",
                                        "size": "md",
                                      },
                                      {
                                        "type": "text",
                                        "key": "option.title",
                                        "themeKey": "optionTitle",
                                        "classes": ["ml-xs"],
                                      },
                                      {
                                        "type": "container",
                                        "themeKey": "badge",
                                        "classes": ["ml-sm"],
                                        "visibleWhen": "option.badge != null",
                                        "child": {
                                          "type": "row",
                                          "mainAxisSize": "min",
                                          "crossAxis": "center",
                                          "children": [
                                            {
                                              "type": "icon",
                                              "key": "option.badgeIcon",
                                              "themeKey": "badge",
                                              "size": "sm",
                                              "visibleWhen":
                                                  "option.badgeIcon != null",
                                            },
                                            {
                                              "type": "text",
                                              "key": "option.badge",
                                              "themeKey": "badge",
                                              "classes": ["ml-xs"],
                                            },
                                          ],
                                        },
                                      },
                                    ],
                                  },
                                  {
                                    "type": "text",
                                    "key": "option.description",
                                    "themeKey": "description",
                                    "classes": ["mt-xs"],
                                  },
                                  {
                                    "type": "text",
                                    "key": "option.price",
                                    "themeKey": "price",
                                    "classes": ["mt-sm"],
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
                "subtitleKey": "subtitle",
                "optionsKey": "options",
                "optionActionRef": "selectCheckoutOption",
                "selectionKey": "selectedMileage",
              },
            },

            {
              "step": 4,
              "id": "protection_package",
              "type": "protection_package_section",
              "bind": "protectionPackage",
              "selectionKey": "selectedProtection",
              "classes": ["mb-lg"],
              "theme": {
                "title": ["text-body", "text-base", "font-bold"],
                "description": ["text-muted", "text-xs"],
                "option": [
                  "bg-transparent",
                  "border-muted",
                  "rounded-lg",
                  "p-md",
                ],
                "selectedOption": [
                  "bg-card-soft",
                  "border-white",
                  "rounded-lg",
                  "p-md",
                ],
                "optionTitle": ["text-body", "text-sm", "font-bold"],
                "badge": [
                  "bg-muted",
                  "rounded-sm",
                  "px-sm",
                  "py-xs",
                  "text-xs",
                ],
                "radio": ["border-white"],
                "selectedRadio": ["border-white"],
                "divider": true,
                "dividerLine": ["border-muted"],
                "optionText": ["text-muted", "text-xs"],
                "price": ["text-body", "text-xs", "font-bold"],
                "link": ["text-body", "text-xs", "font-bold"],
              },
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
                        "themeKey": "description",
                        "classes": ["mt-xs"],
                        "visibleWhen": "subtitle != null",
                      },
                      {
                        "type": "text",
                        "key": "description",
                        "themeKey": "description",
                        "classes": ["mt-sm"],
                        "visibleWhen": "description != null",
                      },
                      {
                        "type": "for_each",
                        "itemsKey": "options",
                        "itemName": "option",
                        "layout": "column",
                        "classes": ["mt-md"],
                        "child": {
                          "type": "protection_tile",
                          "key": "option",
                          "themeKey": "option",
                          "selectedThemeKey": "selectedOption",
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
                                    "type": "protection_radio",
                                    "key": "option",
                                    "themeKey": "radio",
                                    "selectedThemeKey": "selectedRadio",
                                  },
                                  {
                                    "type": "column",
                                    "flex": 1,
                                    "classes": ["ml-md"],
                                    "children": [
                                      {
                                        "type": "row",
                                        "crossAxis": "start",
                                        "children": [
                                          {
                                            "type": "wrap",
                                            "flex": 1,
                                            "spacing": 8,
                                            "runSpacing": 6,
                                            "children": [
                                              {
                                                "type": "text",
                                                "key": "option.title",
                                                "themeKey": "optionTitle",
                                              },
                                              {
                                                "type": "container",
                                                "themeKey": "badge",
                                                "visibleWhen":
                                                    "option.badge != null",
                                                "child": {
                                                  "type": "row",
                                                  "mainAxisSize": "min",
                                                  "crossAxis": "center",
                                                  "children": [
                                                    {
                                                      "type": "icon",
                                                      "key": "option.badgeIcon",
                                                      "themeKey": "badge",
                                                      "size": "sm",
                                                      "visibleWhen":
                                                          "option.badgeIcon != null",
                                                    },
                                                    {
                                                      "type": "text",
                                                      "key": "option.badge",
                                                      "themeKey": "badge",
                                                      "classes": ["ml-xs"],
                                                    },
                                                  ],
                                                },
                                              },
                                            ],
                                          },
                                          {
                                            "type": "text",
                                            "key": "option.price",
                                            "themeKey": "price",
                                            "classes": ["ml-md"],
                                            "visibleWhen":
                                                "option.price != null",
                                          },
                                        ],
                                      },
                                      {
                                        "type": "text",
                                        "key": "option.description",
                                        "themeKey": "optionText",
                                        "classes": ["mt-xs"],
                                        "visibleWhen":
                                            "option.description != null",
                                      },
                                      {
                                        "type": "divider",
                                        "themeKey": "dividerLine",
                                        "classes": ["mt-md"],
                                        "visibleWhen":
                                            "option.linkLabel != null",
                                      },
                                      {
                                        "type": "protection_toggle_coverage",
                                        "key": "option",
                                        "classes": ["mt-sm"],
                                        "visibleWhen":
                                            "option.linkLabel != null",
                                        "child": {
                                          "type": "row",
                                          "mainAxisSize": "min",
                                          "crossAxis": "center",
                                          "children": [
                                            {
                                              "type": "text",
                                              "key": "option.linkLabel",
                                              "themeKey": "link",
                                            },
                                            {
                                              "type": "protection_expand_icon",
                                              "key": "option",
                                              "themeKey": "link",
                                              "size": "md",
                                              "classes": ["ml-xs"],
                                            },
                                          ],
                                        },
                                      },
                                      {
                                        "type": "column",
                                        "crossAxis": "stretch",
                                        "classes": ["mt-sm"],
                                        "visibleWhen":
                                            "option.expanded == true",
                                        "children": [
                                          {
                                            "type": "text",
                                            "key": "option.coverageText",
                                            "themeKey": "optionText",
                                            "visibleWhen":
                                                "option.coverageText != null",
                                          },
                                          {
                                            "type": "for_each",
                                            "itemsKey":
                                                "option.coverageItemsBulleted",
                                            "itemName": "coverage",
                                            "layout": "column",
                                            "classes": ["mt-sm"],
                                            "visibleWhen":
                                                "option.coverageItemsBulleted != null",
                                            "child": {
                                              "type": "text",
                                              "key": "coverage",
                                              "themeKey": "optionText",
                                              "classes": ["mb-xs"],
                                            },
                                          },
                                        ],
                                      },
                                    ],
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
                "subtitleKey": "subtitle",
                "descriptionKey": "description",
                "optionsKey": "options",
                "optionActionRef": "selectCheckoutOption",
                "selectionKey": "selectedProtection",
              },
            },

            {
              "step": 5,
              "id": "add_extras",
              "type": "extras_selector_section",
              "bind": "extras",
              "classes": ["mb-lg"],
              "theme": {
                "title": ["text-body", "text-base", "font-bold"],
                "item": [
                  "bg-transparent",
                  "border-muted",
                  "rounded-lg",
                  "p-md",
                ],
                "itemTitle": ["text-body", "text-sm", "font-bold"],
                "price": ["text-muted", "text-xs"],
                "quantity": ["text-body", "text-sm", "font-bold"],
                "button": ["bg-card-soft", "border-muted", "rounded-full"],
                "buttonIcon": ["text-body"],
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
                          "child": {
                            "type": "row",
                            "crossAxis": "center",
                            "children": [
                              {
                                "type": "column",
                                "flex": 1,
                                "children": [
                                  {
                                    "type": "text",
                                    "key": "extra.title",
                                    "themeKey": "itemTitle",
                                  },
                                  {
                                    "type": "text",
                                    "key": "extra.price",
                                    "themeKey": "price",
                                    "classes": ["mt-xs"],
                                  },
                                ],
                              },
                              {
                                "type": "extra_quantity_button",
                                "key": "extra",
                                "action": "decrease",
                                "themeKey": "button",
                                "iconThemeKey": "buttonIcon",
                                "width": 32,
                                "height": 32,
                                "child": {
                                  "type": "icon",
                                  "icon": "minus",
                                  "themeKey": "buttonIcon",
                                  "size": "md",
                                },
                              },
                              {
                                "type": "text",
                                "key": "extra.quantity",
                                "themeKey": "quantity",
                                "classes": ["mx-md"],
                              },
                              {
                                "type": "extra_quantity_button",
                                "key": "extra",
                                "action": "increase",
                                "themeKey": "button",
                                "iconThemeKey": "buttonIcon",
                                "width": 32,
                                "height": 32,
                                "child": {
                                  "type": "icon",
                                  "icon": "plus",
                                  "themeKey": "buttonIcon",
                                  "size": "md",
                                },
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
                "itemsKey": "items",
                "increaseActionRef": "increaseExtra",
                "decreaseActionRef": "decreaseExtra",
              },
            },

            {
              "step": 6,
              "id": "security_deposit_required",
              "type": "info_card",
              "bind": "securityDeposit",
              "classes": ["mb-md"],
              "theme": {
                "card": ["bg-card-soft", "border-muted", "rounded-lg", "p-md"],
                "title": ["text-body", "text-sm", "font-bold"],
                "text": ["text-muted", "text-xs"],
                "icon": ["text-muted"],
              },
              "props": {
                "titleKey": "title",
                "textKey": "description",
                "iconKey": "icon",
              },
            },

            {
              "step": 6,
              "id": "qdrive_pass",
              "type": "qdrive_pass_section",
              "bind": "qdrivePass",
              "selectionKey": "selectedQdrivePass",
              "classes": ["mb-lg"],

              "theme": {
                "title": ["text-body", "text-base", "font-bold"],

                "option": ["bg-info-soft", "border-info", "rounded-lg", "p-md"],

                "selectedOption": [
                  "bg-info-soft",
                  "border-info",
                  "rounded-lg",
                  "p-md",
                ],

                "optionTitle": ["text-body", "text-sm", "font-bold"],
                "description": ["text-muted", "text-xs"],

                "iconBox": ["bg-white", "rounded-md", "p-sm"],
                "icon": ["text-black"],

                "plan": ["bg-app", "border-muted", "rounded-md", "p-md"],

                "planTitle": ["text-body", "text-sm", "font-bold"],
                "planDescription": ["text-muted", "text-xs"],
                "planPrice": ["text-body", "text-lg", "font-extrabold"],
                "billing": ["text-muted", "text-xs"],

                "link": ["text-info", "text-xs", "font-bold"],

                "badge": [
                  "bg-info",
                  "text-white",
                  "text-xs",
                  "font-bold",
                  "rounded-full",
                  "px-sm",
                  "py-xs",
                ],

                "coverageBox": [
                  "bg-info-soft",
                  "border-info",
                  "rounded-md",
                  "p-sm",
                ],

                "featureText": ["text-body", "text-xs"],
                "mutedFeatureText": ["text-muted", "text-xs"],
                "divider": ["border-muted"],
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
                        "itemsKey": "options",
                        "itemName": "option",
                        "layout": "column",
                        "classes": ["mt-md"],
                        "child": {
                          "type": "container",
                          "themeKey": "option",
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
                                    "type": "container",
                                    "themeKey": "iconBox",
                                    "child": {
                                      "type": "icon",
                                      "key": "option.icon",
                                      "themeKey": "icon",
                                      "size": "md",
                                    },
                                  },

                                  {
                                    "type": "column",
                                    "flex": 1,
                                    "classes": ["ml-md"],
                                    "children": [
                                      {
                                        "type": "text",
                                        "key": "option.title",
                                        "themeKey": "optionTitle",
                                      },
                                      {
                                        "type": "text",
                                        "key": "option.description",
                                        "themeKey": "description",
                                        "classes": ["mt-xs"],
                                      },
                                    ],
                                  },
                                ],
                              },

                              {
                                "type": "for_each",
                                "itemsKey": "option.plans",
                                "itemName": "plan",
                                "layout": "column",
                                "classes": ["mt-md"],
                                "child": {
                                  "type": "qdrive_pass_plan_tile",
                                  "key": "plan",
                                  "themeKey": "plan",
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
                                            "type": "column",
                                            "flex": 1,
                                            "crossAxis": "start",
                                            "children": [
                                              {
                                                "type": "row",
                                                "crossAxis": "center",
                                                "children": [
                                                  {
                                                    "type": "text",
                                                    "key": "plan.title",
                                                    "themeKey": "planTitle",
                                                    "flex": 1,
                                                  },
                                                  {
                                                    "type": "container",
                                                    "themeKey": "badge",
                                                    "visibleWhen":
                                                        "plan.badge != null",
                                                    "child": {
                                                      "type": "text",
                                                      "key": "plan.badge",
                                                      "themeKey": "badge",
                                                    },
                                                  },
                                                ],
                                              },

                                              {
                                                "type": "text",
                                                "key": "plan.description",
                                                "themeKey": "planDescription",
                                                "classes": ["mt-xs"],
                                              },
                                            ],
                                          },

                                          {
                                            "type": "column",
                                            "crossAxis": "end",
                                            "classes": ["ml-md"],
                                            "children": [
                                              {
                                                "type": "text",
                                                "key": "plan.price",
                                                "themeKey": "planPrice",
                                              },
                                              {
                                                "type": "text",
                                                "key": "plan.billing",
                                                "themeKey": "billing",
                                                "classes": ["mt-xs"],
                                              },
                                            ],
                                          },
                                        ],
                                      },

                                      {
                                        "type": "qdrive_pass_coverage_toggle",
                                        "key": "plan",
                                        "classes": ["mt-sm"],
                                        "child": {
                                          "type": "row",
                                          "crossAxis": "center",
                                          "children": [
                                            {
                                              "type": "text",
                                              "key": "plan.coverage.viewLabel",
                                              "themeKey": "link",
                                            },
                                            {
                                              "type": "qdrive_pass_expand_icon",
                                              "key": "plan",
                                              "themeKey": "link",
                                              "size": "sm",
                                              "classes": ["ml-xs"],
                                            },
                                          ],
                                        },
                                      },

                                      {
                                        "type": "qdrive_pass_coverage_panel",
                                        "key": "plan",
                                        "classes": ["mt-sm"],
                                        "child": {
                                          "type": "container",
                                          "themeKey": "coverageBox",
                                          "child": {
                                            "type": "column",
                                            "crossAxis": "stretch",
                                            "children": [
                                              {
                                                "type": "text",
                                                "key":
                                                    "plan.coverage.billingNote",
                                                "themeKey": "mutedFeatureText",
                                              },

                                              {
                                                "type": "row",
                                                "crossAxis": "start",
                                                "classes": ["mt-sm"],
                                                "children": [
                                                  {
                                                    "type": "icon",
                                                    "key":
                                                        "plan.coverage.includedIcon",
                                                    "themeKey": "link",
                                                    "size": "sm",
                                                  },

                                                  {
                                                    "type": "column",
                                                    "flex": 1,
                                                    "classes": ["ml-sm"],
                                                    "children": [
                                                      {
                                                        "type": "text",
                                                        "key":
                                                            "plan.coverage.includedTitle",
                                                        "themeKey": "planTitle",
                                                      },
                                                      {
                                                        "type": "text",
                                                        "key":
                                                            "plan.coverage.includedSubtitle",
                                                        "themeKey":
                                                            "featureText",
                                                        "classes": ["mt-xs"],
                                                      },
                                                    ],
                                                  },
                                                ],
                                              },

                                              {
                                                "type": "for_each",
                                                "itemsKey":
                                                    "plan.coverage.features",
                                                "itemName": "feature",
                                                "layout": "column",
                                                "classes": ["mt-sm"],
                                                "child": {
                                                  "type": "row",
                                                  "crossAxis": "start",
                                                  "classes": ["mb-xs"],
                                                  "children": [
                                                    {
                                                      "type": "icon",
                                                      "icon": "check_circle",
                                                      "themeKey": "link",
                                                      "size": "xs",
                                                    },
                                                    {
                                                      "type": "text",
                                                      "key": "feature",
                                                      "themeKey": "featureText",
                                                      "classes": ["ml-sm"],
                                                      "flex": 1,
                                                    },
                                                  ],
                                                },
                                              },

                                              {
                                                "type": "divider",
                                                "themeKey": "divider",
                                                "classes": ["mt-sm"],
                                              },

                                              {
                                                "type": "text",
                                                "key":
                                                    "plan.coverage.bestForLabel",
                                                "themeKey": "mutedFeatureText",
                                                "classes": ["mt-sm"],
                                              },

                                              {
                                                "type": "text",
                                                "key": "plan.coverage.bestFor",
                                                "themeKey": "planTitle",
                                                "classes": ["mt-xs"],
                                              },
                                            ],
                                          },
                                        },
                                      },
                                    ],
                                  },
                                },
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
                "selectedStateKey": "selectedState",
                "optionsKey": "options",
                "optionActionRef": "selectCheckoutOption",
                "selectionKey": "selectedQdrivePass",
              },
            },
          ],
        },
      },

      {
        "id": "checkout_bottom_bar",
        "type": "bottom_bar",
        "bind": "dynamicData.checkout",
        "classes": ["bg-app", "border-muted", "p-md"],
        "theme": {
          "backButton": [
            "bg-transparent",
            "border-muted",
            "rounded-lg",
            "px-md",
            "py-md",
          ],
          "backButtonLabel": ["text-body", "text-base", "font-bold"],
          "button": ["bg-white", "rounded-lg", "px-lg", "py-md"],
          "buttonLabel": ["text-black", "text-base", "font-bold"],
        },
        "props": {
          "currentStepKey": "currentStep",
          "totalStepsKey": "totalSteps",
          "backLabel": "Back",
          "backActionRef": "checkoutBack",
          "button": {
            "label": "Continue",
            "finalLabel": "Continue to Payment",
            "actionRef": "checkoutContinue",
          },
        },
      },
    ],
  },
};
