const Map<dynamic, dynamic> carTravelPolicySheetJson = {
  "version": "1.0",
  "screen": "car_travel_policy_sheet",

  "meta": {
    "generatedAt": "2026-05-17T10:00:00Z",
    "cacheKey": "car_travel_policy_sheet_v1",
    "cacheWholeJson": true,
    "refreshOnLoad": [],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "sheet": {
      "title": "Car travel Policy",

      "inPolicy": {
        "label": "IN POLICY",
        "items": [
          {
            "title": "Book in advance",
            "subtitle": "7 days or more",
            "linkLabel": "More details",
            "action": {
              "type": "show_policy_detail_snackbar",
              "params": {
                "message": "Lead-time rules are set in your company policy.",
              },
            },
          },
          {
            "title": "Price",
            "subtitle": "Dynamic maximum price",
            "linkLabel": "More details",
            "action": {
              "type": "show_policy_detail_snackbar",
              "params": {
                "message":
                    "Price limits are controlled by your company policy.",
              },
            },
          },
        ],
      },

      "outOfPolicy": {
        "label": "OUT OF POLICY",
        "text":
            "You can still complete this booking outside your company’s travel policy, but you must provide a reason for your approver. Your booking may be reviewed, amended, or cancelled if it does not meet company requirements.",
      },

      "policySetupMessage": {
        "label": "POLICY SETUP MESSAGE",
        "text":
            "Optimise your company’s QDrive travel and vehicle hire budget with configurable booking lead times, approval flows, vehicle class rules, price limits, deposit controls, and more.",
        "strongText":
            "Visit the QDrive corporate portal on desktop to build and manage your company policy.",
      },
    },
  },

  "actions": {
    "closeSheet": {"type": "close", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "car_travel_policy_sheet",
        "type": "car_travel_policy_sheet",
        "bind": "content.sheet",
        "classes": ["bg-black"],
        "theme": {
          "sheet": ["bg-black"],
          "title": ["text-white", "text-md", "font-bold"],
        },
        "props": {"closeActionRef": "closeSheet"},
      },
    ],
  },
};
