const Map<dynamic, dynamic> vehicleVirtualTourJson = {
  "version": "1.0",
  "screen": "vehicle_virtual_tour",

  "content": {
    "tour": {
      "title": "360° Virtual Tour",
      "vehicleName": "BMW 2 Gran Coupe",
      "viewHint": "Interactive 360° panoramic view",
    },
  },

  "actions": {
    "closeTour": {"type": "go_back", "params": {}},

    "previousView": {"type": "tour_previous", "params": {}},
    "nextView": {"type": "tour_next", "params": {}},

    "zoomOut": {"type": "tour_zoom_out", "params": {}},
    "zoomIn": {"type": "tour_zoom_in", "params": {}},
    "resetView": {"type": "tour_reset", "params": {}},
    "fullscreen": {"type": "tour_fullscreen", "params": {}},

    "selectExterior": {"type": "tour_exterior", "params": {}},
    "selectInterior": {"type": "tour_interior", "params": {}},

    "selectFront": {"type": "tour_front", "params": {}},
    "selectRightSide": {"type": "tour_right", "params": {}},
    "selectRear": {"type": "tour_rear", "params": {}},
    "selectLeftSide": {"type": "tour_left", "params": {}},

    "selectDashboard": {"type": "tour_dashboard", "params": {}},
    "selectFrontSeats": {"type": "tour_front_seats", "params": {}},
    "selectBackSeats": {"type": "tour_back_seats", "params": {}},
    "selectTrunk": {"type": "tour_trunk", "params": {}},
  },

  "ui": {
    "showAppBar": false,
    "showFloatingActionButton": false,

    "layout": [
      {
        "id": "virtual_tour",
        "type": "text_block",
        "bind": "content.tour",
        "classes": ["bg-black", "p-md"],

        "theme": {
          "title": ["text-white", "text-lg", "font-extrabold"],
          "vehicleName": ["text-muted", "text-sm"],

          "closeButton": ["bg-card-soft", "rounded-full", "p-md"],
          "closeIcon": ["text-white"],

          "segmentWrap": ["bg-card-soft", "rounded-full", "p-xs"],
          "segmentActive": ["bg-black", "rounded-full", "px-lg", "py-sm"],
          "segmentInactive": [
            "bg-transparent",
            "rounded-full",
            "px-lg",
            "py-sm",
          ],
          "segmentTextActive": ["text-white", "text-sm", "font-bold"],
          "segmentTextInactive": ["text-white", "text-sm", "font-bold"],

          "viewer": ["bg-navy", "rounded-xl"],

          "navButton": ["bg-white-opacity", "rounded-full", "p-md"],
          "navIcon": ["text-white"],

          "centerIconBox": ["bg-white-opacity", "rounded-full"],
          "centerIcon": ["text-primary"],

          "viewTitle": ["text-white", "text-base", "font-bold"],
          "viewSubtitle": ["text-white", "text-sm"],
          "viewHint": ["text-muted", "text-xs"],

          "toolButton": ["bg-card-soft", "rounded-full", "p-md"],
          "toolButtonWide": ["bg-card-soft", "rounded-full", "px-md", "py-sm"],
          "toolIcon": ["text-white"],
          "toolText": ["text-white", "text-sm", "font-bold"],

          "angleActive": ["bg-card-soft", "rounded-md", "px-md", "py-sm"],
          "angleInactive": ["bg-card-soft", "rounded-md", "px-md", "py-sm"],
          "angleTextActive": ["text-white", "text-xs", "font-bold"],
          "angleTextInactive": ["text-white", "text-xs", "font-bold"],
        },

        "config": {
          "layout": [
            {
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
                      "children": [
                        {"type": "text", "key": "title", "themeKey": "title"},
                        {
                          "type": "text",
                          "key": "vehicleName",
                          "themeKey": "vehicleName",
                          "classes": ["mt-xs"],
                        },
                      ],
                    },
                    {
                      "type": "container",
                      "themeKey": "closeButton",
                      "action": {"type": "go_back"},
                      "child": {
                        "type": "icon",
                        "icon": "close",
                        "themeKey": "closeIcon",
                        "size": "lg",
                      },
                    },
                  ],
                },

                {
                  "type": "align",
                  "alignment": "center",
                  "classes": ["mt-8xl", "mb-4xl"],
                  "child": {"type": "virtual_tour_mode_tabs"},
                },

                {
                  "type": "container",
                  "height": 360,
                  "classes": ["mt-xl"],
                  "child": {
                    "type": "stack",
                    "children": [
                      {
                        "type": "align",
                        "alignment": "center",
                        "child": {
                          "type": "virtual_tour_view",
                          "child": {
                            "type": "container",
                            "themeKey": "viewer",
                            "height": 260,
                            "child": {
                              "type": "align",
                              "alignment": "center",
                              "child": {
                                "type": "column",
                                "crossAxis": "center",
                                "mainAxisSize": "min",
                                "children": [
                                  {
                                    "type": "container",
                                    "themeKey": "centerIconBox",
                                    "width": 86,
                                    "height": 86,
                                    "alignment": "center",
                                    "child": {
                                      "type": "icon",
                                      "icon": "refresh",
                                      "themeKey": "centerIcon",
                                      "size": "xl",
                                    },
                                  },
                                  {
                                    "type": "virtual_tour_label",
                                    "labelType": "title",
                                    "themeKey": "viewTitle",
                                    "classes": ["mt-md"],
                                  },
                                  {
                                    "type": "virtual_tour_label",
                                    "labelType": "subtitle",
                                    "themeKey": "viewSubtitle",
                                    "classes": ["mt-xs"],
                                  },
                                  {
                                    "type": "text",
                                    "key": "viewHint",
                                    "themeKey": "viewHint",
                                    "classes": ["mt-sm"],
                                    "textAlign": "center",
                                  },
                                ],
                              },
                            },
                          },
                        },
                      },

                      {
                        "type": "positioned",
                        "alignment": "centerLeft",
                        "classes": ["p-md"],
                        "child": {
                          "type": "container",
                          "themeKey": "navButton",
                          "action": {"type": "tour_previous"},
                          "child": {
                            "type": "icon",
                            "icon": "chevron_left",
                            "themeKey": "navIcon",
                            "size": "xl",
                          },
                        },
                      },

                      {
                        "type": "positioned",
                        "alignment": "centerRight",
                        "classes": ["p-md"],
                        "child": {
                          "type": "container",
                          "themeKey": "navButton",
                          "action": {"type": "tour_next"},
                          "child": {
                            "type": "icon",
                            "icon": "chevron_right",
                            "themeKey": "navIcon",
                            "size": "xl",
                          },
                        },
                      },
                    ],
                  },
                },

                {
                  "type": "row",
                  "mainAxis": "center",
                  "crossAxis": "center",
                  "children": [
                    {
                      "type": "container",
                      "themeKey": "toolButton",
                      "action": {"type": "tour_zoom_out"},
                      "child": {
                        "type": "icon",
                        "icon": "zoom_out",
                        "themeKey": "toolIcon",
                        "size": "md",
                      },
                    },
                    {
                      "type": "container",
                      "themeKey": "toolButton",
                      "classes": ["ml-md"],
                      "action": {"type": "tour_zoom_in"},
                      "child": {
                        "type": "icon",
                        "icon": "zoom_in",
                        "themeKey": "toolIcon",
                        "size": "md",
                      },
                    },
                    {
                      "type": "container",
                      "themeKey": "toolButtonWide",
                      "classes": ["ml-md"],
                      "action": {"type": "tour_reset"},
                      "child": {
                        "type": "row",
                        "crossAxis": "center",
                        "children": [
                          {
                            "type": "icon",
                            "icon": "refresh",
                            "themeKey": "toolIcon",
                            "size": "md",
                          },
                          {
                            "type": "text",
                            "value": "Reset View",
                            "themeKey": "toolText",
                            "classes": ["ml-xs"],
                          },
                        ],
                      },
                    },
                    {
                      "type": "container",
                      "themeKey": "toolButton",
                      "classes": ["ml-md"],
                      "action": {"type": "tour_fullscreen"},
                      "child": {
                        "type": "icon",
                        "icon": "fullscreen",
                        "themeKey": "toolIcon",
                        "size": "md",
                      },
                    },
                  ],
                },

                {
                  "type": "virtual_tour_angle_buttons",
                  "classes": ["mt-md"],
                },
              ],
            },
          ],
        },

        "props": {
          "titleKey": "title",
          "vehicleNameKey": "vehicleName",
          "viewHintKey": "viewHint",
        },
      },
    ],
  },
};
