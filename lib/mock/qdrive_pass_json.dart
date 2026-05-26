const Map<dynamic, dynamic> qdrivePassJson = {
  "version": "1.0",
  "screen": "qdrive_pass",

  "meta": {
    "generatedAt": "2026-05-18T10:00:00Z",
    "cacheKey": "qdrive_pass_v3",
    "cacheWholeJson": true,
    "refreshOnLoad": ["dynamicData"],
    "keepCached": ["content", "actions", "ui"],
  },

  "content": {
    "header": {
      "title": "QDrive Pass",
      "subtitle": "Monthly Vehicle Subscription Plans",
    },

    "hero": {
      "badgeIcon": "sparkles",
      "badgeText": "One monthly fee. No deposits. No repeated paperwork.",
      "title": "Drive more, pay less",
      "subtitle":
          "Subscribe to a QDrive Pass and enjoy hassle-free vehicle access without the commitment of ownership.",
    },

    "billingToggle": {
      "selected": "monthly",
      "monthlyLabel": "Monthly",
      "annualLabel": "Annual",
      "annualBadge": "Save 17%",
    },

    "plans": [
      {
        "id": "standard",
        "icon": "car",
        "title": "Standard Pass",
        "subtitle": "Drive more, pay less",

        "price": "£165",
        "period": "/ month",
        "oldPrice": "£199/month",
        "saveText": "Save £398/year",
        "annualNote": "£1990/year billed annually",

        "billing": {
          "monthly": {
            "price": "£199",
            "period": "/ month",
            "oldPrice": "",
            "saveText": "Flexible monthly billing",
            "annualNote": "Billed monthly. Cancel before your next renewal.",
          },
          "annual": {
            "price": "£165",
            "period": "/ month",
            "oldPrice": "£199/month",
            "saveText": "Save £398/year",
            "annualNote": "£1990/year billed annually",
          },
        },

        "badge": null,
        "rentalDays": "3 rental days per month",
        "rollover": "Rolls over for 3 months if unused",
        "features": [
          "3 rental days per month",
          "Access to any QDrive Rent-a-Car vehicle",
          "No deposit required",
          "No re-upload of documents after first verification",
          "Driver Score continues to improve monthly",
        ],
        "bestFor": "Occasional drivers who want flexibility without commitment",
        "buttonLabel": "Start Standard Pass",
        "actionRef": "startStandardPass",
      },
      {
        "id": "performance",
        "icon": "bolt",
        "title": "Performance Pass",
        "subtitle": "Premium vehicles on demand",

        "price": "£415",
        "period": "/ month",
        "oldPrice": "£499/month",
        "saveText": "Save £998/year",
        "annualNote": "£4990/year billed annually",

        "billing": {
          "monthly": {
            "price": "£499",
            "period": "/ month",
            "oldPrice": "",
            "saveText": "Flexible monthly billing",
            "annualNote": "Billed monthly. Cancel before your next renewal.",
          },
          "annual": {
            "price": "£415",
            "period": "/ month",
            "oldPrice": "£499/month",
            "saveText": "Save £998/year",
            "annualNote": "£4990/year billed annually",
          },
        },

        "badge": "MOST POPULAR",
        "rentalDays": "3 rental days per month",
        "rollover": "Rolls over for 3 months if unused",
        "features": [
          "3 rental days per month",
          "Access to all Performance vehicles",
          "Complimentary vehicle delivery",
          "No deposits on bookings",
          "Priority allocation on high-demand vehicles",
        ],
        "bestFor": "Drivers who want premium cars regularly",
        "buttonLabel": "Upgrade to Performance",
        "actionRef": "startPerformancePass",
      },
      {
        "id": "elite",
        "icon": "crown",
        "title": "Elite Pass",
        "subtitle": "Ultimate luxury experience",

        "price": "£1249",
        "period": "/ month",
        "oldPrice": "£1499/month",
        "saveText": "Save £2998/year",
        "annualNote": "£14990/year billed annually",

        "billing": {
          "monthly": {
            "price": "£1499",
            "period": "/ month",
            "oldPrice": "",
            "saveText": "Flexible monthly billing",
            "annualNote": "Billed monthly. Cancel before your next renewal.",
          },
          "annual": {
            "price": "£1249",
            "period": "/ month",
            "oldPrice": "£1499/month",
            "saveText": "Save £2998/year",
            "annualNote": "£14990/year billed annually",
          },
        },

        "badge": "PREMIUM",
        "rentalDays": "5 rental days per month",
        "rollover": "Rolls over for 3 months if unused",
        "features": [
          "5 rental days per month",
          "Access to entire fleet including exotics",
          "Complimentary delivery on every booking",
          "Dedicated named advisor",
          "Priority booking on peak dates",
          "Fast-track vehicle allocation",
        ],
        "bestFor": "High-frequency premium users & executives",
        "buttonLabel": "Go Elite",
        "actionRef": "startElitePass",
      },
    ],
    "benefits": {
      "title": "Why Choose QDrive Pass?",
      "items": [
        {
          "icon": "security",
          "title": "No Deposits, Ever",
          "text":
              "Unlike traditional rentals, Pass members never pay security deposits. Your subscription covers it all.",
        },
        {
          "icon": "trend_up",
          "title": "Build Your Driver Score",
          "text":
              "Every rental improves your score, unlocking better rates and exclusive perks over time.",
        },
        {
          "icon": "users",
          "title": "Paperwork Once, Drive Forever",
          "text":
              "Upload your documents once during signup. Never re-verify for future bookings.",
        },
        {
          "icon": "sparkles",
          "title": "Flexible & Transparent",
          "text":
              "Cancel anytime with no penalties. Unused days roll over for up to 3 months.",
        },
      ],
    },

    "faqs": {
      "title": "Frequently Asked Questions",
      "items": [
        {
          "question": "Can I upgrade or downgrade my plan?",
          "answer":
              "Yes. You can change your QDrive Pass plan before your next billing cycle.",
        },
        {
          "question": "What happens to unused rental days?",
          "answer":
              "Unused rental days roll over for up to 3 months if they are not used.",
        },
        {
          "question": "Are there any hidden fees?",
          "answer":
              "No. Your subscription shows exactly what is included before you join.",
        },
        {
          "question": "Can I cancel my subscription?",
          "answer": "Yes. You can cancel before your next renewal date.",
        },
      ],
    },

    "support": {
      "title": "Still not sure which plan is right?",
      "subtitle":
          "Talk to our team and we'll help you find the perfect subscription for your needs.",
      "button": {"label": "Chat with Us", "actionRef": "openChat"},
    },
  },

  "actions": {
    "goBack": {"type": "go_back", "params": {}},

    "selectMonthlyBilling": {
      "type": "select_qdrive_billing",
      "params": {"billing": "monthly"},
    },

    "selectAnnualBilling": {
      "type": "select_qdrive_billing",
      "params": {"billing": "annual"},
    },

    "startStandardPass": {
      "type": "navigate",
      "params": {
        "route": "/booking-checkout",
        "planId": "standard",
        "billing": "annual",
        "source": "qdrive_pass",
      },
    },

    "startPerformancePass": {
      "type": "navigate",
      "params": {
        "route": "/booking-checkout",
        "planId": "performance",
        "billing": "annual",
        "source": "qdrive_pass",
      },
    },

    "startElitePass": {
      "type": "navigate",
      "params": {
        "route": "/booking-checkout",
        "planId": "elite",
        "billing": "annual",
        "source": "qdrive_pass",
      },
    },

    "openChat": {"type": "open_chat", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": true,

    "layout": [
      {
        "id": "qdrive_pass_back",
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
        "config": {
          "layout": [
            {
              "type": "row",
              "crossAxis": "center",
              "children": [
                {
                  "type": "container",
                  "themeKey": "iconButton",
                  "action": {"type": "go_back"},
                  "child": {
                    "type": "icon",
                    "icon": "arrow_back",
                    "themeKey": "iconButtonIcon",
                    "size": "md",
                  },
                },
              ],
            },
          ],
        },
        "props": {},
      },
      {
        "id": "qdrive_pass_header",
        "type": "text_block",
        "bind": "content.header",
        "classes": ["mb-md"],
        "theme": {
          "title": ["text-body", "text-xl", "font-bold", "text-center"],
          "subtitle": ["text-muted", "text-xs", "text-center"],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "row",
                  "mainAxis": "center",
                  "crossAxis": "center",
                  "children": [
                    {
                      "type": "text",
                      "key": "title",
                      "themeKey": "title",
                      "textAlign": "center",
                    },
                  ],
                },
                {
                  "type": "row",
                  "mainAxis": "center",
                  "crossAxis": "center",
                  "classes": ["mt-xs"],
                  "children": [
                    {
                      "type": "text",
                      "key": "subtitle",
                      "themeKey": "subtitle",
                      "textAlign": "center",
                      "maxLines": 2,
                      "softWrap": true,
                    },
                  ],
                },
              ],
            },
          ],
        },
        "props": {},
      },

      {
        "id": "qdrive_pass_hero",
        "type": "text_block",
        "bind": "content.hero",
        "classes": ["mb-lg"],
        "theme": {
          "badge": [
            "bg-card-soft",
            "border-muted",
            "rounded-full",
            "px-md",
            "py-sm",
          ],
          "badgeIcon": ["text-body"],
          "badgeText": ["text-body", "text-xs", "font-bold"],
          "title": ["text-body", "text-lg", "font-bold", "text-center"],
          "subtitle": ["text-muted", "text-xs", "text-center"],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "stretch",
              "children": [
                {
                  "type": "container",
                  "themeKey": "badge",
                  "child": {
                    "type": "row",
                    "mainAxis": "start",
                    "crossAxis": "center",
                    "children": [
                      {
                        "type": "icon",
                        "key": "badgeIcon",
                        "themeKey": "badgeIcon",
                        "size": "xs",
                      },
                      {
                        "type": "text",
                        "key": "badgeText",
                        "themeKey": "badgeText",
                        "classes": ["ml-sm"],
                        "flex": 1,
                        "maxLines": 2,
                        "softWrap": true,
                        "textAlign": "start",
                      },
                    ],
                  },
                },
                {
                  "type": "row",
                  "mainAxis": "center",
                  "classes": ["mt-lg"],
                  "children": [
                    {
                      "type": "text",
                      "key": "title",
                      "themeKey": "title",
                      "textAlign": "center",
                    },
                  ],
                },
                {
                  "type": "text",
                  "key": "subtitle",
                  "themeKey": "subtitle",
                  "classes": ["mt-sm"],
                  "textAlign": "center",
                  "maxLines": 3,
                  "softWrap": true,
                },
              ],
            },
          ],
        },
        "props": {},
      },
      {
        "id": "qdrive_pass_billing_toggle",
        "type": "qdrive_billing_toggle",
        "classes": ["mb-lg"],
        "theme": {
          "group": ["bg-card-soft", "border-muted", "rounded-xl", "p-xs"],
          "inactiveButton": ["bg-transparent", "rounded-lg", "px-lg", "py-md"],
          "activeButton": ["bg-primary", "rounded-lg", "px-lg", "py-md"],
          "inactiveLabel": ["text-muted", "text-sm", "font-bold"],
          "activeLabel": ["text-inverse-body", "text-sm", "font-bold"],
          "badge": [
            "bg-card-soft",
            "border-muted",
            "rounded-full",
            "px-sm",
            "py-xs",
          ],
          "badgeText": ["text-body", "text-xs", "font-bold"],
        },
        "props": {
          "selected": "monthly",
          "monthlyLabel": "Monthly",
          "annualLabel": "Annual",
          "annualBadge": "Save 17%",
          "monthlyAction": {
            "type": "select_qdrive_billing",
            "params": {"billing": "monthly"},
          },
          "annualAction": {
            "type": "select_qdrive_billing",
            "params": {"billing": "annual"},
          },
        },
      },

      {
        "id": "qdrive_pass_plan_list",
        "type": "text_block",
        "bind": "content",
        "classes": ["mb-2xl"],
        "theme": {
          "card": ["bg-card-soft", "border-muted", "rounded-xl", "p-lg"],

          "badge": ["bg-card-soft", "border-muted", "px-md", "py-sm"],
          "badgeText": ["text-primary", "text-xs", "font-bold"],

          "iconBox": ["bg-muted", "border-muted", "rounded-lg", "p-md"],
          "icon": ["text-body"],

          "title": ["text-body", "text-lg", "font-bold", "text-center"],
          "subtitle": ["text-muted", "text-sm", "text-center"],

          "price": ["text-body", "text-2xl", "font-bold"],
          "period": ["text-muted", "text-sm"],

          "oldPrice": ["text-muted", "text-sm", "line-through", "text-center"],
          "saveText": ["text-body", "text-sm", "font-bold", "text-center"],
          "annualNote": ["text-muted", "text-sm", "text-center"],

          "rentalBox": ["bg-surface", "border-muted", "rounded-xl", "p-md"],
          "rentalIcon": ["text-muted"],
          "rentalDays": ["text-body", "text-sm", "font-bold"],
          "rollover": ["text-muted", "text-sm"],

          "checkIcon": ["text-muted"],
          "featureText": ["text-body", "text-sm"],

          "divider": ["bg-muted"],

          "bestForLabel": ["text-muted", "text-sm", "uppercase"],
          "bestForText": ["text-body", "text-sm", "font-bold"],

          "button": ["bg-primary", "rounded-xl", "px-lg", "py-md"],
          "buttonLabel": [
            "text-surface",
            "text-sm",
            "font-bold",
            "text-center",
          ],
        },

        "config": {
          "layout": [
            {
              "type": "for_each",
              "itemsKey": "plans",
              "itemName": "plan",
              "layout": "column",
              "crossAxis": "stretch",
              "classes": ["mt-lg"],

              "child": {
                "type": "stack",
                "children": [
                  {
                    "type": "container",
                    "themeKey": "card",
                    "fullWidth": true,
                    "classes": ["mb-lg"],
                    "child": {
                      "type": "column",
                      "crossAxis": "stretch",
                      "children": [
                        {
                          "type": "column",
                          "crossAxis": "center",
                          "children": [
                            {
                              "type": "container",
                              "themeKey": "iconBox",
                              "classes": ["mt-lg"],
                              "child": {
                                "type": "icon",
                                "key": "plan.icon",
                                "themeKey": "icon",
                                "size": "md",
                              },
                            },

                            {
                              "type": "text",
                              "key": "plan.title",
                              "themeKey": "title",
                              "classes": ["mt-md"],
                              "textAlign": "center",
                            },

                            {
                              "type": "text",
                              "key": "plan.subtitle",
                              "themeKey": "subtitle",
                              "classes": ["mt-xs"],
                              "textAlign": "center",
                            },

                            {
                              "type": "row",
                              "mainAxis": "center",
                              "crossAxis": "end",
                              "classes": ["mt-lg"],
                              "children": [
                                {
                                  "type": "text",
                                  "key": "plan.price",
                                  "themeKey": "price",
                                },
                                {
                                  "type": "text",
                                  "key": "plan.period",
                                  "themeKey": "period",
                                  "classes": ["ml-xs"],
                                },
                              ],
                            },

                            {
                              "type": "row",
                              "mainAxis": "center",
                              "crossAxis": "center",
                              "classes": ["mt-xs"],
                              "children": [
                                {
                                  "type": "text",
                                  "key": "plan.oldPrice",
                                  "themeKey": "oldPrice",
                                },
                                {
                                  "type": "text",
                                  "key": "plan.saveText",
                                  "themeKey": "saveText",
                                  "classes": ["ml-xs"],
                                },
                              ],
                            },

                            {
                              "type": "text",
                              "key": "plan.annualNote",
                              "themeKey": "annualNote",
                              "classes": ["mt-xs"],
                              "textAlign": "center",
                            },
                          ],
                        },

                        {
                          "type": "container",
                          "themeKey": "rentalBox",
                          "classes": ["mt-xl"],
                          "child": {
                            "type": "row",
                            "crossAxis": "start",
                            "children": [
                              {
                                "type": "icon",
                                "icon": "calendar",
                                "themeKey": "rentalIcon",
                                "size": "sm",
                              },
                              {
                                "type": "column",
                                "classes": ["ml-sm"],
                                "flex": 1,
                                "children": [
                                  {
                                    "type": "text",
                                    "key": "plan.rentalDays",
                                    "themeKey": "rentalDays",
                                    "maxLines": 2,
                                    "softWrap": true,
                                  },
                                  {
                                    "type": "text",
                                    "key": "plan.rollover",
                                    "themeKey": "rollover",
                                    "classes": ["mt-xs"],
                                    "maxLines": 2,
                                    "softWrap": true,
                                  },
                                ],
                              },
                            ],
                          },
                        },

                        {
                          "type": "for_each",
                          "itemsKey": "plan.features",
                          "itemName": "feature",
                          "layout": "column",
                          "classes": ["mt-lg"],
                          "child": {
                            "type": "row",
                            "crossAxis": "start",
                            "classes": ["mb-sm"],
                            "children": [
                              {
                                "type": "icon",
                                "icon": "check",
                                "themeKey": "checkIcon",
                                "size": "sm",
                              },
                              {
                                "type": "text",
                                "key": "feature",
                                "themeKey": "featureText",
                                "classes": ["ml-md"],
                                "flex": 1,
                                "maxLines": 3,
                                "softWrap": true,
                              },
                            ],
                          },
                        },

                        {
                          "type": "container",
                          "themeKey": "divider",
                          "classes": ["mt-md", "mb-md"],
                          "height": 1,
                        },

                        {
                          "type": "text",
                          "value": "BEST FOR",
                          "themeKey": "bestForLabel",
                        },

                        {
                          "type": "text",
                          "key": "plan.bestFor",
                          "themeKey": "bestForText",
                          "classes": ["mt-xs"],
                          "maxLines": 3,
                          "softWrap": true,
                        },

                        {
                          "type": "container",
                          "themeKey": "button",
                          "classes": ["mt-lg"],
                          "fullWidth": true,
                          "alignment": "center",
                          "action": {'type': "open_checkout"},
                          "child": {
                            "type": "row",
                            "mainAxis": "center",
                            "crossAxis": "center",
                            "children": [
                              {
                                "type": "text",
                                "key": "plan.buttonLabel",
                                "themeKey": "buttonLabel",
                                "textAlign": "center",
                              },
                            ],
                          },
                        },
                      ],
                    },
                  },

                  {
                    "type": "positioned",
                    "alignment": "topRight",
                    "visibleWhen": "plan.badge != null",
                    "child": {
                      "type": "container",
                      "themeKey": "badge",
                      "borderSides": ["left", "bottom"],
                      "child": {
                        "type": "text",
                        "key": "plan.badge",
                        "themeKey": "badgeText",
                        "maxLines": 1,
                      },
                    },
                  },
                ],
              },
            },
          ],
        },

        "props": {},
      },

      {
        "id": "qdrive_pass_benefits",
        "type": "text_block",
        "bind": "content.benefits",
        "classes": ["mb-2xl"],
        "theme": {
          "title": ["text-body", "text-base", "font-bold", "text-center"],
          "itemIconBox": ["bg-card-soft", "border-muted", "rounded-lg", "p-sm"],
          "itemIcon": ["text-body"],
          "itemTitle": ["text-body", "text-xs", "font-bold"],
          "itemText": ["text-muted", "text-xs"],
        },
        "config": {
          "layout": [
            {
              "type": "column",
              "crossAxis": "center",
              "children": [
                {"type": "text", "key": "title", "themeKey": "title"},
                {
                  "type": "for_each",
                  "itemsKey": "items",
                  "itemName": "item",
                  "layout": "column",
                  "classes": ["mt-lg"],
                  "child": {
                    "type": "row",
                    "crossAxis": "start",
                    "classes": ["mb-md"],
                    "children": [
                      {
                        "type": "container",
                        "themeKey": "itemIconBox",
                        "child": {
                          "type": "icon",
                          "key": "item.icon",
                          "themeKey": "itemIcon",
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
                            "key": "item.title",
                            "themeKey": "itemTitle",
                          },
                          {
                            "type": "text",
                            "key": "item.text",
                            "themeKey": "itemText",
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
        "props": {},
      },

      {
        "id": "qdrive_pass_faqs",
        "type": "accordion_section",
        "bind": "content.faqs",
        "classes": ["mb-2xl"],
        "theme": {
          "title": ["text-body", "text-base", "font-bold", "text-center"],
          "item": [
            "bg-card-soft",
            "border-muted",
            "rounded-lg",
            "px-md",
            "py-md",
          ],
          "question": ["text-body", "text-xs", "font-bold"],
          "answer": ["text-muted", "text-xs"],
          "icon": ["text-body"],
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
                  "itemName": "faq",
                  "layout": "column",
                  "classes": ["mt-lg"],
                  "child": {
                    "type": "container",
                    "themeKey": "item",
                    "classes": ["mb-sm"],
                    "child": {
                      "type": "column",
                      "children": [
                        {
                          "type": "row",
                          "crossAxis": "center",
                          "children": [
                            {
                              "type": "icon",
                              "icon": "chevron_right",
                              "themeKey": "icon",
                              "size": "xs",
                            },
                            {
                              "type": "text",
                              "key": "faq.question",
                              "themeKey": "question",
                              "classes": ["ml-sm"],
                              "flex": 1,
                            },
                          ],
                        },
                        {
                          "type": "text",
                          "key": "faq.answer",
                          "themeKey": "answer",
                          "classes": ["mt-sm"],
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
          "questionKey": "question",
          "answerKey": "answer",
          "initialOpenIndex": null,
        },
      },

      {
        "id": "qdrive_pass_support",
        "type": "info_card",
        "bind": "content.support",
        "classes": ["mb-xl"],
        "theme": {
          "card": ["bg-card-soft", "border-muted", "rounded-xl", "p-xl"],
          "title": ["text-body", "text-base", "font-bold", "text-center"],
          "text": ["text-muted", "text-xs", "text-center"],
          "button": [
            "bg-transparent",
            "border-muted",
            "rounded-lg",
            "px-lg",
            "py-md",
          ],
          "buttonLabel": ["text-body", "text-xs", "font-bold"],
        },
        "config": {
          "layout": [
            {
              "type": "container",
              "themeKey": "card",
              "child": {
                "type": "column",
                "crossAxis": "center",
                "children": [
                  {"type": "text", "key": "title", "themeKey": "title"},
                  {
                    "type": "text",
                    "key": "subtitle",
                    "themeKey": "text",
                    "classes": ["mt-sm"],
                  },
                  {
                    "type": "container",
                    "themeKey": "button",
                    "classes": ["mt-lg"],
                    "actionRef": "openChat",
                    "child": {
                      "type": "text",
                      "key": "button.label",
                      "themeKey": "buttonLabel",
                      "textAlign": "center",
                    },
                  },
                ],
              },
            },
          ],
        },
        "props": {},
      },
    ],
  },
};
