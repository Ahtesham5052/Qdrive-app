const Map<dynamic, dynamic> previousBookingDetailDialogJson = {
  "title": "Booking Details",
  "bookingId": "BK-2026-0509",

  "body": {
    "type": "text_block",
    "props": {
      "booking": {
        "id": "BK-2026-0509",
        "statusTitle": "Booked",
        "statusText": "Payment paid",

        "vehicleLabel": "Booked Vehicle",
        "vehicleName": "Hybrid Estate",
        "vehicleType": "One-way",
        "vehicleImage":
            "https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=300",

        "tripTitle": "Trip Details",

        "pickupLabel": "Pickup Location",
        "pickupValue": "Bristol Temple Meads Station",

        "dropoffLabel": "Drop-off Location",
        "dropoffValue": "Bristol Airport",

        "dateLabel": "Pickup Date & Time",
        "dateValue": "2026-05-12 at 10:00",

        "paymentTitle": "Payment Details",
        "fareLabel": "Fare Amount",
        "fareValue": "£189",
        "paymentStatusLabel": "Payment Status",
        "paymentStatusValue": "Paid",

        "additionalTitle": "Additional Information",
        "dateBookedLabel": "Date Booked",
        "dateBookedValue": "2026-05-08",
        "specialRequestsLabel": "Special Requests",
        "specialRequestsValue": "GPS add-on",

        "preRentalButton": "Open pre-rental checklist",
        "receiptButton": "Download Receipt",
      },
    },
    "theme": {
      "sectionTitle": ["text-body", "text-sm", "font-bold"],

      "statusCard": ["bg-info-soft", "border-info", "rounded-lg", "p-md"],
      "statusIcon": ["text-info"],
      "statusTitle": ["text-info", "text-xs", "font-bold"],
      "statusText": ["text-body", "text-xs", "font-bold"],

      "vehicleCard": ["bg-card-soft", "rounded-lg", "p-md"],
      "vehicleImage": ["rounded-md"],
      "vehicleLabel": ["text-muted", "text-xs"],
      "vehicleName": ["text-body", "text-sm", "font-bold"],
      "vehicleType": ["text-muted", "text-xs"],

      "tripIconBoxSuccess": ["bg-success-dark", "rounded-md", "p-sm"],
      "tripIconBoxDanger": ["bg-danger-soft", "rounded-md", "p-sm"],
      "tripIconBoxInfo": ["bg-info-soft", "rounded-md", "p-sm"],
      "successIcon": ["text-success"],
      "dangerIcon": ["text-danger"],
      "infoIcon": ["text-info"],
      "tripLabel": ["text-muted", "text-xs"],
      "tripValue": ["text-body", "text-xs", "font-bold"],

      "paymentCard": ["bg-card-soft", "rounded-lg", "p-md"],
      "paymentLabel": ["text-muted", "text-xs"],
      "paymentValue": ["text-body", "text-sm", "font-bold"],
      "paidValue": ["text-success", "text-xs", "font-bold"],

      "divider": ["bg-muted"],

      "additionalLabel": ["text-muted", "text-xs"],
      "additionalValue": ["text-body", "text-xs", "font-bold"],

      "primaryButton": ["bg-white", "rounded-lg", "px-lg", "py-md"],
      "primaryButtonIcon": ["text-black"],
      "primaryButtonLabel": ["text-black", "text-xs", "font-bold"],

      "secondaryButton": ["bg-card-soft", "rounded-lg", "px-lg", "py-md"],
      "secondaryButtonIcon": ["text-body"],
      "secondaryButtonLabel": ["text-body", "text-xs", "font-bold"],
    },
    "config": {
      "layout": [
        {
          "type": "column",
          "crossAxis": "stretch",
          "children": [
            {
              "type": "container",
              "themeKey": "statusCard",
              "classes": ["mb-md"],
              "child": {
                "type": "row",
                "crossAxis": "center",
                "children": [
                  {
                    "type": "icon",
                    "icon": "calendar",
                    "themeKey": "statusIcon",
                    "size": "md",
                  },
                  {
                    "type": "column",
                    "classes": ["ml-sm"],
                    "children": [
                      {
                        "type": "text",
                        "key": "booking.statusTitle",
                        "themeKey": "statusTitle",
                      },
                      {
                        "type": "text",
                        "key": "booking.statusText",
                        "themeKey": "statusText",
                        "classes": ["mt-xs"],
                      },
                    ],
                  },
                ],
              },
            },

            {
              "type": "container",
              "themeKey": "vehicleCard",
              "classes": ["mb-lg"],
              "child": {
                "type": "row",
                "crossAxis": "center",
                "children": [
                  {
                    "type": "image",
                    "key": "booking.vehicleImage",
                    "themeKey": "vehicleImage",
                    "width": 72,
                    "height": 54,
                    "fit": "cover",
                  },
                  {
                    "type": "column",
                    "classes": ["ml-md"],
                    "flex": 1,
                    "children": [
                      {
                        "type": "text",
                        "key": "booking.vehicleLabel",
                        "themeKey": "vehicleLabel",
                      },
                      {
                        "type": "text",
                        "key": "booking.vehicleName",
                        "themeKey": "vehicleName",
                        "classes": ["mt-xs"],
                      },
                      {
                        "type": "text",
                        "key": "booking.vehicleType",
                        "themeKey": "vehicleType",
                        "classes": ["mt-xs"],
                      },
                    ],
                  },
                ],
              },
            },

            {
              "type": "text",
              "key": "booking.tripTitle",
              "themeKey": "sectionTitle",
              "classes": ["mb-md"],
            },

            {
              "type": "row",
              "crossAxis": "start",
              "classes": ["mb-sm"],
              "children": [
                {
                  "type": "container",
                  "themeKey": "tripIconBoxSuccess",
                  "child": {
                    "type": "icon",
                    "icon": "location",
                    "themeKey": "successIcon",
                    "size": "sm",
                  },
                },
                {
                  "type": "column",
                  "classes": ["ml-sm"],
                  "flex": 1,
                  "children": [
                    {
                      "type": "text",
                      "key": "booking.pickupLabel",
                      "themeKey": "tripLabel",
                    },
                    {
                      "type": "text",
                      "key": "booking.pickupValue",
                      "themeKey": "tripValue",
                      "classes": ["mt-xs"],
                    },
                  ],
                },
              ],
            },

            {
              "type": "row",
              "crossAxis": "start",
              "classes": ["mb-sm"],
              "children": [
                {
                  "type": "container",
                  "themeKey": "tripIconBoxDanger",
                  "child": {
                    "type": "icon",
                    "icon": "location",
                    "themeKey": "dangerIcon",
                    "size": "sm",
                  },
                },
                {
                  "type": "column",
                  "classes": ["ml-sm"],
                  "flex": 1,
                  "children": [
                    {
                      "type": "text",
                      "key": "booking.dropoffLabel",
                      "themeKey": "tripLabel",
                    },
                    {
                      "type": "text",
                      "key": "booking.dropoffValue",
                      "themeKey": "tripValue",
                      "classes": ["mt-xs"],
                    },
                  ],
                },
              ],
            },

            {
              "type": "row",
              "crossAxis": "start",
              "classes": ["mb-lg"],
              "children": [
                {
                  "type": "container",
                  "themeKey": "tripIconBoxInfo",
                  "child": {
                    "type": "icon",
                    "icon": "calendar",
                    "themeKey": "infoIcon",
                    "size": "sm",
                  },
                },
                {
                  "type": "column",
                  "classes": ["ml-sm"],
                  "flex": 1,
                  "children": [
                    {
                      "type": "text",
                      "key": "booking.dateLabel",
                      "themeKey": "tripLabel",
                    },
                    {
                      "type": "text",
                      "key": "booking.dateValue",
                      "themeKey": "tripValue",
                      "classes": ["mt-xs"],
                    },
                  ],
                },
              ],
            },

            {
              "type": "text",
              "key": "booking.paymentTitle",
              "themeKey": "sectionTitle",
              "classes": ["mb-md"],
            },

            {
              "type": "container",
              "themeKey": "paymentCard",
              "classes": ["mb-lg"],
              "child": {
                "type": "column",
                "crossAxis": "stretch",
                "children": [
                  {
                    "type": "row",
                    "children": [
                      {
                        "type": "text",
                        "key": "booking.fareLabel",
                        "themeKey": "paymentLabel",
                        "flex": 1,
                      },
                      {
                        "type": "text",
                        "key": "booking.fareValue",
                        "themeKey": "paymentValue",
                      },
                    ],
                  },
                  {
                    "type": "container",
                    "themeKey": "divider",
                    "height": 1,
                    "classes": ["mt-sm", "mb-sm"],
                  },
                  {
                    "type": "row",
                    "children": [
                      {
                        "type": "text",
                        "key": "booking.paymentStatusLabel",
                        "themeKey": "paymentLabel",
                        "flex": 1,
                      },
                      {
                        "type": "text",
                        "key": "booking.paymentStatusValue",
                        "themeKey": "paidValue",
                      },
                    ],
                  },
                ],
              },
            },

            {
              "type": "text",
              "key": "booking.additionalTitle",
              "themeKey": "sectionTitle",
              "classes": ["mb-md"],
            },

            {
              "type": "row",
              "classes": ["mb-sm"],
              "children": [
                {
                  "type": "text",
                  "key": "booking.dateBookedLabel",
                  "themeKey": "additionalLabel",
                  "flex": 1,
                },
                {
                  "type": "text",
                  "key": "booking.dateBookedValue",
                  "themeKey": "additionalValue",
                },
              ],
            },
            {
              "type": "container",
              "themeKey": "divider",
              "height": 1,
              "classes": ["mb-sm"],
            },
            {
              "type": "row",
              "classes": ["mb-lg"],
              "children": [
                {
                  "type": "text",
                  "key": "booking.specialRequestsLabel",
                  "themeKey": "additionalLabel",
                  "flex": 1,
                },
                {
                  "type": "text",
                  "key": "booking.specialRequestsValue",
                  "themeKey": "additionalValue",
                },
              ],
            },

            {
              "type": "container",
              "themeKey": "primaryButton",
              "fullWidth": true,
              "alignment": "center",
              "classes": ["mb-sm"],
              "action": {
                "type": "open_pre_rental",
                "params": {"closeDialog": true},
              },
              "child": {
                "type": "row",
                "mainAxis": "center",
                "crossAxis": "center",
                "children": [
                  {
                    "type": "icon",
                    "icon": "chevron_right",
                    "themeKey": "primaryButtonIcon",
                    "size": "sm",
                  },
                  {
                    "type": "text",
                    "key": "booking.preRentalButton",
                    "themeKey": "primaryButtonLabel",
                    "classes": ["ml-sm"],
                  },
                ],
              },
            },

            {
              "type": "container",
              "themeKey": "secondaryButton",
              "fullWidth": true,
              "alignment": "center",
              "action": {"type": "download_receipt"},
              "child": {
                "type": "row",
                "mainAxis": "center",
                "crossAxis": "center",
                "children": [
                  {
                    "type": "icon",
                    "icon": "upload",
                    "themeKey": "secondaryButtonIcon",
                    "size": "sm",
                  },
                  {
                    "type": "text",
                    "key": "booking.receiptButton",
                    "themeKey": "secondaryButtonLabel",
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
};
