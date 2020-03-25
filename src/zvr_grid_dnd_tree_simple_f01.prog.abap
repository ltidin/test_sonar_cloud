*----------------------------------------------------------------------*
*   INCLUDE GRID_DND_TREE_SIMPLE_F01                                   *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  CREATEDOCKINGCONTROL
*&---------------------------------------------------------------------*
FORM CREATEDOCKINGCONTROL.
* create container for alv-tree
  CREATE OBJECT G_CONTAINER_OBJECT
      EXPORTING SIDE = CL_GUI_DOCKING_CONTAINER=>DOCK_AT_LEFT
                EXTENSION = 270
                REPID     = G_REPID
                DYNNR     = '0100'.
ENDFORM.                               " CREATEDOCKINGCONTROL

*&---------------------------------------------------------------------*
*&      Form  CREATETREECONTROL
*&---------------------------------------------------------------------*
FORM CREATETREECONTROL.
* create Event Receiver
  CREATE OBJECT TREE_EVENT_RECEIVER.
* create tree control
  CREATE OBJECT TREE1
    EXPORTING
        I_PARENT              = G_CONTAINER_OBJECT
        I_NODE_SELECTION_MODE = CL_GUI_COLUMN_TREE=>NODE_SEL_MODE_SINGLE
        I_ITEM_SELECTION      = ''
        I_NO_HTML_HEADER      = ''
        I_NO_TOOLBAR          = ''
    EXCEPTIONS
        CNTL_ERROR                   = 1
        CNTL_SYSTEM_ERROR            = 2
        CREATE_ERROR                 = 3
        LIFETIME_ERROR               = 4
        ILLEGAL_NODE_SELECTION_MODE  = 5
        FAILED                       = 6
        ILLEGAL_COLUMN_NAME          = 7.
  IF SY-SUBRC <> 0.
*
  ENDIF.
* fields for tree
  PERFORM CREATE_FIELDCAT.
* header for tree
  PERFORM CREATE_HEADER.
* Sorttable for tree
  PERFORM BUILT_SORT_TABLE.
* handle for D'n'D
  GS_LAYOUT_TREE-S_DRAGDROP-ROW_DDID = G_HANDLE_TREE.
* fill tree with data
  CALL METHOD TREE1->SET_TABLE_FOR_FIRST_DISPLAY
          EXPORTING
               IT_LIST_COMMENTARY   = GT_HEADER[]
               I_BACKGROUND_ID      = 'ALV_BACKGROUND'
               IS_LAYOUT            = GS_LAYOUT_TREE
          CHANGING
               IT_SORT              = GT_SORT[]
               IT_OUTTAB            = GT_SPFLI[]
               IT_FIELDCATALOG      = GT_FIELDCAT_LVC[].
* register events
  PERFORM REGISTER_EVENTS.
* set handler for tree1
  SET HANDLER TREE_EVENT_RECEIVER->HANDLE_DOUBLE_CLICK FOR TREE1.
  SET HANDLER TREE_EVENT_RECEIVER->HANDLE_ON_DRAG FOR TREE1.
ENDFORM.                               " CREATETREECONTROL

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_FLIGHTS
*&---------------------------------------------------------------------*
FORM DISPLAY_FLIGHTS USING P_INDEX TYPE LVC_INDEX
                           P_GROUPLEVEL TYPE LVC_FNAME.
  REFRESH GT_SFLIGHT.
  IF NOT P_GROUPLEVEL IS INITIAL.
    READ TABLE GT_SPFLI INDEX P_INDEX.
    IF SY-SUBRC = 0.
      SELECT * FROM SFLIGHT INTO TABLE GT_SFLIGHT
                            WHERE CARRID = GT_SPFLI-CARRID.
      READ TABLE GT_SCARR WITH KEY CARRID = GT_SPFLI-CARRID.
      SCARR = GT_SCARR.
    ENDIF.
  ELSE.
    READ TABLE GT_SPFLI INDEX P_INDEX.
    IF SY-SUBRC = 0.
      SELECT * FROM SFLIGHT INTO TABLE GT_SFLIGHT
                            WHERE CARRID = GT_SPFLI-CARRID
                            AND   CONNID = GT_SPFLI-CONNID.
      READ TABLE GT_SCARR WITH KEY CARRID = GT_SPFLI-CARRID.
      SCARR = GT_SCARR.
    ENDIF.
  ENDIF.
  IF GT_SFLIGHT[] IS INITIAL AND NOT GRID IS INITIAL.
    MESSAGE I000(0K) WITH TEXT-115 SPACE SPACE SPACE.
    CLEAR SCARR.
    CLEAR SPFLI.
  ELSE.
    FLG_NEW = SELECTED.
  ENDIF.
ENDFORM.                               " DISPLAY_FLIGHTS
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DETAIL
*&---------------------------------------------------------------------*
FORM DISPLAY_DETAIL.
  CLEAR SFLIGHT.
  CALL METHOD GRID->GET_SELECTED_ROWS IMPORTING ET_INDEX_ROWS =
                                                GT_ROW_TABLE[].
* only one selected row!
  READ TABLE GT_ROW_TABLE INDEX 1.
  IF SY-SUBRC = 0.
    READ TABLE GT_SFLIGHT INDEX GT_ROW_TABLE-INDEX.
    IF SY-SUBRC = 0.
      MOVE-CORRESPONDING GT_SFLIGHT TO SFLIGHT.
*     Detail screen 200
      CALL SCREEN 200 STARTING AT 10 10.
    ENDIF.
  ELSE.
    MESSAGE I000(0K) WITH TEXT-054 SPACE SPACE SPACE.
  ENDIF.
ENDFORM.                               " DISPLAY_DETAIL
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_SAPLANE
*&---------------------------------------------------------------------*
FORM DISPLAY_SAPLANE.
  CLEAR SAPLANE.
  CLEAR GT_ROW_TABLE[].
  CALL METHOD GRID->GET_SELECTED_ROWS IMPORTING ET_INDEX_ROWS =
                                                GT_ROW_TABLE[].
  CALL METHOD CL_GUI_CFW=>FLUSH.
* only one selected row!
  READ TABLE GT_ROW_TABLE INDEX 1.
  IF SY-SUBRC = 0.
    READ TABLE GT_SFLIGHT INDEX GT_ROW_TABLE-INDEX.
    IF SY-SUBRC = 0.
      READ TABLE GT_SAPLANE WITH KEY PLANETYPE = GT_SFLIGHT-PLANETYPE.
      IF SY-SUBRC = 0.
        SAPLANE = GT_SAPLANE.
      ELSE.
        SELECT SINGLE * FROM SAPLANE WHERE PLANETYPE =
                                           GT_SFLIGHT-PLANETYPE.
        IF SY-SUBRC = 0.
          GT_SAPLANE = SAPLANE.
          APPEND GT_SAPLANE.
        ELSE.
        ENDIF.
      ENDIF.
    ENDIF.
  ELSE.
    MESSAGE I000(0K) WITH TEXT-054 SPACE SPACE SPACE.
  ENDIF.
ENDFORM.                               " DISPLAY_SAPLANE
*&---------------------------------------------------------------------*
*&      Form  CREATE_FIELDCAT
*&---------------------------------------------------------------------*
FORM CREATE_FIELDCAT.
* get fieldcatalog
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
       EXPORTING
            I_STRUCTURE_NAME = 'SPFLI'
       CHANGING
            CT_FIELDCAT      = GT_FIELDCAT_LVC[].
* change fieldcatalog
  DATA: LS_FIELDCATALOG TYPE LVC_S_FCAT.
  LOOP AT GT_FIELDCAT_LVC INTO LS_FIELDCATALOG.
    CASE LS_FIELDCATALOG-FIELDNAME.
      WHEN 'CARRID' OR 'CONNID'.
        LS_FIELDCATALOG-NO_OUT = SELECTED.
        LS_FIELDCATALOG-KEY    = ''.
    ENDCASE.
    MODIFY GT_FIELDCAT_LVC FROM LS_FIELDCATALOG.
  ENDLOOP.
ENDFORM.                               " CREATE_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  CREATE_HEADER
*&---------------------------------------------------------------------*
FORM CREATE_HEADER.
  CLEAR GT_HEADER.
  GT_HEADER-TYP = 'H'.
  GT_HEADER-INFO = TEXT-007.
  APPEND GT_HEADER.
  CLEAR GT_HEADER.
  GT_HEADER-TYP = 'S'.
  GT_HEADER-KEY = TEXT-008.
  GT_HEADER-INFO = TEXT-009.
  APPEND GT_HEADER.
ENDFORM.                               " CREATE_HEADER
*&---------------------------------------------------------------------*
*&      Form  REGISTER_EVENTS
*&---------------------------------------------------------------------*
FORM REGISTER_EVENTS.
  DATA: LT_EVENTS TYPE CNTL_SIMPLE_EVENTS,
        L_EVENT TYPE CNTL_SIMPLE_EVENT.
* define the events which will be passed to the backend
  CLEAR L_EVENT.
  L_EVENT-EVENTID = CL_GUI_COLUMN_TREE=>EVENTID_NODE_DOUBLE_CLICK.
  L_EVENT-APPL_EVENT = SELECTED.
  APPEND L_EVENT TO LT_EVENTS.
  CLEAR L_EVENT.
  L_EVENT-EVENTID = CL_GUI_COLUMN_TREE=>EVENTID_EXPAND_NO_CHILDREN.
  APPEND L_EVENT TO LT_EVENTS.
  CLEAR L_EVENT.
  L_EVENT-EVENTID = CL_GUI_COLUMN_TREE=>EVENTID_HEADER_CLICK.
  APPEND L_EVENT TO LT_EVENTS.
  CLEAR L_EVENT.
* register events
  CALL METHOD TREE1->SET_REGISTERED_EVENTS
    EXPORTING
      EVENTS = LT_EVENTS
    EXCEPTIONS
      CNTL_ERROR                = 1
      CNTL_SYSTEM_ERROR         = 2
      ILLEGAL_EVENT_COMBINATION = 3.
  IF SY-SUBRC <> 0.
    MESSAGE X534(0K).
  ENDIF.
ENDFORM.                               " REGISTER_EVENTS
*&---------------------------------------------------------------------*
*&      Form  init_dragdrop
*&---------------------------------------------------------------------*
FORM INIT_DRAGDROP.
* set allowed drop effect
  G_DROPEFFECT = CL_DRAGDROP=>MOVE.
* Initialize drag & drop descriptions
* -> tree
  CREATE OBJECT DRAGDROP_TREE.
  CALL METHOD DRAGDROP_TREE->ADD EXPORTING
                                 FLAVOR = 'LINE'
                                 DRAGSRC = SELECTED
                                 DROPTARGET = ''
                                 EFFECT = G_DROPEFFECT.
  CALL METHOD DRAGDROP_TREE->GET_HANDLE IMPORTING
                                          HANDLE = G_HANDLE_TREE.
* -> ALV grid
  CREATE OBJECT DRAGDROP_ALV.
  CALL METHOD DRAGDROP_ALV->ADD EXPORTING
                            FLAVOR = 'LINE'
                            DRAGSRC = ''
                            DROPTARGET = SELECTED
                            EFFECT = G_DROPEFFECT.
  CALL METHOD DRAGDROP_ALV->GET_HANDLE IMPORTING
                                          HANDLE = G_HANDLE_ALV.
ENDFORM.                               " init_dragdrop
*&---------------------------------------------------------------------*
*&      Form  BUILT_SORT_TABLE
*&---------------------------------------------------------------------*
FORM BUILT_SORT_TABLE.
  DATA LS_SORT_WA TYPE LVC_S_SORT.
* CARRID
  LS_SORT_WA-SPOS = 1.
  LS_SORT_WA-FIELDNAME = 'CARRID'.
  LS_SORT_WA-UP = SELECTED.
  LS_SORT_WA-SUBTOT = ''.
  APPEND LS_SORT_WA TO GT_SORT.
* CONNID
  LS_SORT_WA-SPOS = 2.
  LS_SORT_WA-FIELDNAME = 'CONNID'.
  LS_SORT_WA-UP = SELECTED.
  LS_SORT_WA-SUBTOT = ''.
  APPEND LS_SORT_WA TO GT_SORT.

ENDFORM.                               " BUILT_SORT_TABLE
*&---------------------------------------------------------------------*
*&      Form  build_sort_tab_grid
*&---------------------------------------------------------------------*
FORM BUILD_SORT_TAB_GRID.

* create sort-table
  GT_SORT_GRID-SPOS = 1.
  GT_SORT_GRID-FIELDNAME = 'CARRID'.
  GT_SORT_GRID-UP = SELECTED.
  GT_SORT_GRID-SUBTOT = SELECTED.
  APPEND GT_SORT_GRID.

  GT_SORT_GRID-SPOS = 2.
  GT_SORT_GRID-FIELDNAME = 'CONNID'.
  GT_SORT_GRID-UP = SELECTED.
  GT_SORT_GRID-SUBTOT = SELECTED.
  APPEND GT_SORT_GRID.

  GT_SORT_GRID-SPOS = 3.
  GT_SORT_GRID-FIELDNAME = 'FLDATE'.
  GT_SORT_GRID-UP = SELECTED.
  APPEND GT_SORT_GRID.

ENDFORM.                               " build_sort_tab_grid
