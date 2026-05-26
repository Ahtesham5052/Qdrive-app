const Map<dynamic, dynamic> preRentalConfirmationDialogJson = {
  "id": "booking_confirmation_dialog",
  "title": "Booking confirmation",
  "scrollable": false,
  "maxHeightFactor": 0.82,
  "body": {
    "type": "text_block",
    "classes": [],
    "props": {
      "eyebrow": "OFFICIAL BOOKING VOUCHER",
      "brand": "Qdrive",
      "bookingLabel": "Booking reference",
      "bookingRef": "QD-7X9K2M",
      "pickupLabel": "Pickup",
      "pickupValue": "April 20, 2026 · 10:00 AM",
      "pickupLocation": "Downtown Location",
      "vehicleLabel": "Vehicle",
      "vehicleValue": "Premium Sedan",
      "amountLabel": "Amount paid",
      "amountValue": "£267.00",
      "amountMeta": "(incl. taxes where shown)",
      "note":
          "Present this voucher with your driving licence at pickup. Supplier: Qdrive Partner Network.",
      "printLabel": "Print",
      "downloadLabel": "Download PDF",
    },
    "theme": {
      "card": ["bg-card-soft", "border-muted", "rounded-lg", "p-lg"],
      "eyebrow": ["text-muted", "text-xs", "font-bold", "uppercase"],
      "brand": ["text-body", "text-xl", "font-bold"],
      "label": ["text-muted", "text-xs"],
      "value": ["text-body", "text-xs", "font-bold"],
      "divider": ["border-muted"],
      "note": ["text-muted", "text-xs"],
      "primaryButton": ["bg-white", "rounded-lg", "py-md"],
      "primaryButtonText": [
        "text-black",
        "text-xs",
        "font-bold",
        "text-center",
      ],
      "secondaryButton": [
        "bg-transparent",
        "border-muted",
        "rounded-lg",
        "py-md",
      ],
      "secondaryButtonText": [
        "text-body",
        "text-xs",
        "font-bold",
        "text-center",
      ],
      "buttonIcon": ["text-black"],
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
              {"type": "text", "key": "eyebrow", "themeKey": "eyebrow"},
              {
                "type": "text",
                "key": "brand",
                "themeKey": "brand",
                "classes": ["mt-xs"],
              },

              {
                "type": "text",
                "key": "bookingLabel",
                "themeKey": "label",
                "classes": ["mt-lg"],
              },
              {
                "type": "text",
                "key": "bookingRef",
                "themeKey": "value",
                "classes": ["mt-xs"],
              },

              {
                "type": "divider",
                "themeKey": "divider",
                "classes": ["mt-lg", "mb-md"],
              },

              {"type": "text", "key": "pickupLabel", "themeKey": "label"},
              {
                "type": "text",
                "key": "pickupValue",
                "themeKey": "value",
                "classes": ["mt-xs"],
              },
              {
                "type": "text",
                "key": "pickupLocation",
                "themeKey": "value",
                "classes": ["mt-xs"],
              },

              {
                "type": "text",
                "key": "vehicleLabel",
                "themeKey": "label",
                "classes": ["mt-md"],
              },
              {
                "type": "text",
                "key": "vehicleValue",
                "themeKey": "value",
                "classes": ["mt-xs"],
              },

              {
                "type": "text",
                "key": "amountLabel",
                "themeKey": "label",
                "classes": ["mt-md"],
              },
              {
                "type": "row",
                "crossAxis": "center",
                "children": [
                  {"type": "text", "key": "amountValue", "themeKey": "value"},
                  {
                    "type": "text",
                    "key": "amountMeta",
                    "themeKey": "label",
                    "classes": ["ml-xs"],
                  },
                ],
              },

              {
                "type": "text",
                "key": "note",
                "themeKey": "note",
                "classes": ["mt-lg"],
              },

              {
                "type": "container",
                "themeKey": "primaryButton",
                "classes": ["mt-lg"],
                "action": {"type": "print_booking_confirmation"},
                "child": {
                  "type": "row",
                  "mainAxis": "center",
                  "crossAxis": "center",
                  "children": [
                    {
                      "type": "icon",
                      "icon": "receipt",
                      "themeKey": "buttonIcon",
                      "size": "xs",
                    },
                    {
                      "type": "text",
                      "key": "printLabel",
                      "themeKey": "primaryButtonText",
                      "classes": ["ml-sm"],
                    },
                  ],
                },
              },

              {
                "type": "container",
                "themeKey": "secondaryButton",
                "classes": ["mt-sm"],
                "action": {"type": "download_booking_confirmation_pdf"},
                "child": {
                  "type": "text",
                  "key": "downloadLabel",
                  "themeKey": "secondaryButtonText",
                  "textAlign": "center",
                },
              },
            ],
          },
        },
      ],
    },
  },
};

const Map<dynamic, dynamic> preRentalConditionsDialogJson = {
  "id": "rental_conditions_dialog",
  "title": "Rental conditions",
  "scrollable": true,
  "maxHeightFactor": 0.82,
  "body": {
    "type": "text_block",
    "props": {
      "intro":
          "Summary of supplier terms for this booking. Full legal wording is available in your confirmation email.",
      "sections": [
        {
          "title": "Mileage",
          "text":
              "Included mileage: 900 miles for the rental period. Additional miles charged at £0.25/mile unless a mileage package was purchased.",
        },
        {
          "title": "Fuel policy",
          "text":
              "Full to full — return with the same fuel level as at pickup. Refuelling service fees apply if not complied with.",
        },
        {
          "title": "Security deposit",
          "text":
              "A hold of £250–£500 may be placed on your card at pickup depending on vehicle category and supplier. Released after return inspection if no damage or traffic charges apply.",
        },
        {
          "title": "Insurance",
          "text":
              "Collision damage waiver is included as selected at booking. Theft protection included. Tyres, glass, and underside may be excluded unless premium cover was added.",
        },
        {
          "title": "Cancellation",
          "text":
              "Free cancellation up to 48 hours before scheduled pickup. Within 48 hours, a fee of up to 50% of rental may apply. No-show is charged in full unless covered by a flexible fare.",
        },
        {
          "title": "Driver requirements",
          "text":
              "Main driver must hold a valid licence for at least 2 years, meet the minimum age for the category, and present the payment card used to book.",
        },
      ],
    },
    "theme": {
      "intro": ["text-muted", "text-xs"],
      "sectionTitle": ["text-body", "text-sm", "font-bold"],
      "sectionText": ["text-muted", "text-xs"],
    },
    "config": {
      "layout": [
        {
          "type": "column",
          "crossAxis": "stretch",
          "children": [
            {"type": "text", "key": "intro", "themeKey": "intro"},
            {
              "type": "for_each",
              "itemsKey": "sections",
              "itemName": "section",
              "layout": "column",
              "classes": ["mt-lg"],
              "child": {
                "type": "column",
                "crossAxis": "stretch",
                "children": [
                  {
                    "type": "text",
                    "key": "section.title",
                    "themeKey": "sectionTitle",
                  },
                  {
                    "type": "text",
                    "key": "section.text",
                    "themeKey": "sectionText",
                    "classes": ["mt-sm", "mb-md"],
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

const Map<dynamic, dynamic> preRentalReceiptDialogJson = {
  "id": "receipt_dialog",
  "title": "Receipt",
  "scrollable": false,
  "maxHeightFactor": 0.72,
  "body": {
    "type": "text_block",
    "props": {
      "bookingLabel": "Booking reference",
      "bookingRef": "QD-7X9K2M",
      "statusLabel": "Status",
      "statusValue": "Paid",
      "items": [
        {"label": "Vehicle rental", "value": "£220.00"},
        {"label": "Insurance upgrade", "value": "£32.00"},
        {"label": "Taxes & fees", "value": "£15.00"},
      ],
      "totalLabel": "Total paid",
      "totalValue": "£267.00",
      "note":
          "VAT shown where applicable. Card ending •••• 4242 · April 20, 2026",
    },
    "theme": {
      "summaryCard": ["bg-card-soft", "border-muted", "rounded-lg", "p-md"],
      "label": ["text-muted", "text-xs"],
      "value": ["text-body", "text-xs", "font-bold"],
      "paid": ["text-success", "text-xs", "font-bold"],
      "divider": ["border-muted"],
      "totalLabel": ["text-body", "text-sm", "font-bold"],
      "totalValue": ["text-body", "text-sm", "font-bold"],
      "note": ["text-muted", "text-xs"],
    },
    "config": {
      "layout": [
        {
          "type": "column",
          "crossAxis": "stretch",
          "children": [
            {
              "type": "container",
              "themeKey": "summaryCard",
              "child": {
                "type": "column",
                "crossAxis": "stretch",
                "children": [
                  {"type": "text", "key": "bookingLabel", "themeKey": "label"},
                  {
                    "type": "text",
                    "key": "bookingRef",
                    "themeKey": "value",
                    "classes": ["mt-xs"],
                  },
                  {
                    "type": "text",
                    "key": "statusLabel",
                    "themeKey": "label",
                    "classes": ["mt-md"],
                  },
                  {
                    "type": "text",
                    "key": "statusValue",
                    "themeKey": "paid",
                    "classes": ["mt-xs"],
                  },
                ],
              },
            },

            {
              "type": "for_each",
              "itemsKey": "items",
              "itemName": "receiptItem",
              "layout": "column",
              "classes": ["mt-lg"],
              "child": {
                "type": "row",
                "crossAxis": "center",
                "classes": ["mb-sm"],
                "children": [
                  {
                    "type": "text",
                    "key": "receiptItem.label",
                    "themeKey": "label",
                    "flex": 1,
                  },
                  {
                    "type": "text",
                    "key": "receiptItem.value",
                    "themeKey": "value",
                  },
                ],
              },
            },

            {
              "type": "divider",
              "themeKey": "divider",
              "classes": ["mt-md", "mb-md"],
            },

            {
              "type": "row",
              "crossAxis": "center",
              "children": [
                {
                  "type": "text",
                  "key": "totalLabel",
                  "themeKey": "totalLabel",
                  "flex": 1,
                },
                {"type": "text", "key": "totalValue", "themeKey": "totalValue"},
              ],
            },

            {
              "type": "text",
              "key": "note",
              "themeKey": "note",
              "classes": ["mt-lg"],
            },
          ],
        },
      ],
    },
  },
};

const Map<dynamic, dynamic> preRentalCancellationDialogJson = {
  "id": "cancellation_dialog",
  "title": "Cancel booking",
  "scrollable": false,
  "maxHeightFactor": 0.82,
  "body": {
    "type": "text_block",
    "props": {
      "warning":
          "You are about to request cancellation for QD-7X9K2M. Charges below are estimates based on supplier rules and your pickup time.",
      "refundTitle": "Refund estimate",
      "originalLabel": "Original payment",
      "originalValue": "£267.00",
      "feeLabel": "Cancellation fee (within policy window)",
      "feeValue": "−£45.00",
      "refundLabel": "Estimated refund",
      "refundValue": "£222.00",
      "refundNote":
          "Final amounts may vary if extras or insurance are non-refundable. Refunds typically post within 5–10 business days.",
      "confirmText":
          "By confirming, you accept the cancellation charges shown and understand this action cannot be undone in the app (demo).",
      "confirmLabel": "Confirm cancellation",
      "keepLabel": "Keep booking",
    },
    "theme": {
      "warningBox": ["bg-warning-soft", "border-warning", "rounded-lg", "p-md"],
      "warningText": ["text-warning", "text-xs", "font-bold"],
      "refundBox": ["bg-card-soft", "border-muted", "rounded-lg", "p-md"],
      "refundTitle": ["text-body", "text-sm", "font-bold"],
      "label": ["text-muted", "text-xs"],
      "value": ["text-body", "text-xs", "font-bold"],
      "feeLabel": ["text-danger", "text-xs", "font-bold"],
      "feeValue": ["text-danger", "text-xs", "font-bold"],
      "divider": ["border-muted"],
      "refundLabel": ["text-body", "text-xs", "font-bold"],
      "refundValue": ["text-body", "text-xs", "font-bold"],
      "note": ["text-muted", "text-xs"],
      "confirmText": ["text-muted", "text-xs"],
      "dangerButton": ["bg-danger", "rounded-lg", "py-md"],
      "dangerButtonText": ["text-white", "text-xs", "font-bold", "text-center"],
      "secondaryButton": [
        "bg-transparent",
        "border-muted",
        "rounded-lg",
        "py-md",
      ],
      "secondaryButtonText": [
        "text-body",
        "text-xs",
        "font-bold",
        "text-center",
      ],
    },
    "config": {
      "layout": [
        {
          "type": "column",
          "crossAxis": "stretch",
          "children": [
            {
              "type": "container",
              "themeKey": "warningBox",
              "child": {
                "type": "text",
                "key": "warning",
                "themeKey": "warningText",
              },
            },

            {
              "type": "container",
              "themeKey": "refundBox",
              "classes": ["mt-md"],
              "child": {
                "type": "column",
                "crossAxis": "stretch",
                "children": [
                  {
                    "type": "text",
                    "key": "refundTitle",
                    "themeKey": "refundTitle",
                  },
                  {
                    "type": "row",
                    "classes": ["mt-md"],
                    "children": [
                      {
                        "type": "text",
                        "key": "originalLabel",
                        "themeKey": "label",
                        "flex": 1,
                      },
                      {
                        "type": "text",
                        "key": "originalValue",
                        "themeKey": "value",
                      },
                    ],
                  },
                  {
                    "type": "row",
                    "classes": ["mt-sm"],
                    "children": [
                      {
                        "type": "text",
                        "key": "feeLabel",
                        "themeKey": "feeLabel",
                        "flex": 1,
                      },
                      {
                        "type": "text",
                        "key": "feeValue",
                        "themeKey": "feeValue",
                      },
                    ],
                  },
                  {
                    "type": "divider",
                    "themeKey": "divider",
                    "classes": ["mt-md", "mb-md"],
                  },
                  {
                    "type": "row",
                    "children": [
                      {
                        "type": "text",
                        "key": "refundLabel",
                        "themeKey": "refundLabel",
                        "flex": 1,
                      },
                      {
                        "type": "text",
                        "key": "refundValue",
                        "themeKey": "refundValue",
                      },
                    ],
                  },
                  {
                    "type": "text",
                    "key": "refundNote",
                    "themeKey": "note",
                    "classes": ["mt-sm"],
                  },
                ],
              },
            },

            {
              "type": "text",
              "key": "confirmText",
              "themeKey": "confirmText",
              "classes": ["mt-lg"],
            },

            {
              "type": "container",
              "themeKey": "dangerButton",
              "classes": ["mt-lg"],
              "action": {"type": "confirm_pre_rental_cancellation"},
              "child": {
                "type": "text",
                "key": "confirmLabel",
                "themeKey": "dangerButtonText",
                "textAlign": "center",
              },
            },

            {
              "type": "container",
              "themeKey": "secondaryButton",
              "classes": ["mt-sm"],
              "action": {"type": "keep_pre_rental_booking"},
              "child": {
                "type": "text",
                "key": "keepLabel",
                "themeKey": "secondaryButtonText",
                "textAlign": "center",
              },
            },
          ],
        },
      ],
    },
  },
};
