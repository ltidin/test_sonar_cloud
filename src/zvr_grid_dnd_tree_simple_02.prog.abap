*----------------------------------------------------------------------*
*   INCLUDE BCALV_TREE_EVENT_REC_DRAGDROP                              *
*----------------------------------------------------------------------*
CLASS CL_TREE_EVENT_RECEIVER DEFINITION.

  PUBLIC SECTION.
*   double click item
    METHODS HANDLE_DOUBLE_CLICK
      FOR EVENT NODE_DOUBLE_CLICK OF cl_gui_alv_tree_SIMPLE
      IMPORTING INDEX_OUTTAB
                GROUPLEVEL.
*   Drag
    METHODS HANDLE_ON_DRAG
      FOR EVENT ON_DRAG OF cl_gui_alv_tree_SIMPLE
      IMPORTING DRAG_DROP_OBJECT
                FIELDNAME
                INDEX_OUTTAB
                GROUPLEVEL.
  PRIVATE SECTION.
ENDCLASS.
*---------------------------------------------------------------------*
*       CLASS CL_TREE_EVENT_RECEIVER IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS CL_TREE_EVENT_RECEIVER IMPLEMENTATION.
* handle double_click
  METHOD HANDLE_DOUBLE_CLICK.
    CHECK NOT INDEX_OUTTAB IS INITIAL.
    PERFORM DISPLAY_FLIGHTS USING INDEX_OUTTAB GROUPLEVEL.
  ENDMETHOD.
* Drag & Drop
  METHOD HANDLE_ON_DRAG.
    CHECK NOT INDEX_OUTTAB IS INITIAL.
    PERFORM DISPLAY_FLIGHTS USING INDEX_OUTTAB GROUPLEVEL.
    CALL METHOD CL_GUI_CFW=>SET_NEW_OK_CODE EXPORTING NEW_CODE =
    FCODE_ENTR.
  ENDMETHOD.
ENDCLASS.
*
DATA: TREE_EVENT_RECEIVER TYPE REF TO CL_TREE_EVENT_RECEIVER.
