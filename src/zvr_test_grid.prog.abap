report zvr_test_grid.
* global data, tables, Constants, types
INCLUDE ZVR_GRID_DND_TREE_SIMPLE_TOP.
*include grid_dnd_tree_simple_top.
* icons
INCLUDE ZVR_<ICON>.
*include <icon>.
* event receiver ALV grid
INCLUDE ZVR_GRID_DND_TREE_SIMPLE_01.
*include grid_dnd_tree_simple_01.
* event receiver ALV tree simple
INCLUDE ZVR_GRID_DND_TREE_SIMPLE_02.
*include grid_dnd_tree_simple_02.
* forms for BCALV_GRID_DND_TREE_SIMPLE
INCLUDE ZVR_GRID_DND_TREE_SIMPLE_F01.
*include grid_dnd_tree_simple_f01.
*----------------------------------------------------------------------*
start-of-selection.
  perform init_dragdrop.
* table SPFLI
  refresh gt_spfli.
  select * from spfli into table gt_spfli.
* table SCARR
  refresh gt_scarr.
  select * from scarr into table gt_scarr.              "#EC CI_NOWHERE
*
end-of-selection.
  g_repid = sy-repid.
  call screen 100.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
module status_0100 output.
  set pf-status '100'.
  set titlebar '100'.
endmodule.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
module status_0200 output.
  set pf-status '200'.
  set titlebar '200'.
endmodule.                             " STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  TREE_AND_DOCKING  OUTPUT
*&---------------------------------------------------------------------*
module tree_and_docking output.
  if controls_created is initial.
*   docking control
    perform createdockingcontrol.
*   tree control
    perform createtreecontrol.
    controls_created = selected.
  endif.
endmodule.                             " TREE_AND_DOCKING  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  ALV_DISPLAY  OUTPUT
*&---------------------------------------------------------------------*
module alv_display output.
  if g_custom_container is initial.
*   create container for ALV grid
    create object g_custom_container
       exporting
         container_name = 'CUSTOM_CONTROL'.
  endif.
  if grid is initial.
*   create Event Receiver
    create object event_receiver.
*   build sort_tab_grid
    perform build_sort_tab_grid.
*   create ALV grid
    create object grid
       exporting
         i_appl_events = selected      "application event
         i_parent = g_custom_container.
*   Dummy entry for D'n'D
    clear gt_sflight.
    append gt_sflight.
*   opt. col. width
    gs_layout_alv-cwidth_opt = selected.
*   handle for D'n'D
    gs_layout_alv-s_dragdrop-row_ddid = g_handle_alv.
*   handler for ALV grid
    set handler event_receiver->handle_toolbar_set  for grid.
    set handler event_receiver->handle_user_command for grid.
    set handler event_receiver->handle_double_click for grid.
    set handler event_receiver->handle_context_menu for grid.
    set handler event_receiver->handle_ondrop for grid.
*   first call with dummy entry
    call method grid->set_table_for_first_display
      exporting
        i_structure_name = 'SFLIGHT'
        is_layout        = gs_layout_alv
      changing
        it_sort          = gt_sort_grid[]
        it_outtab        = gt_sflight[].
*   flush
    call method cl_gui_control=>set_focus
      exporting
        control = grid.
    call method cl_gui_cfw=>flush.
  endif.
  if flg_new = selected.
    clear flg_new.
*   first call with data
    gs_layout_alv-grid_title = scarr-carrname.
    call method grid->set_table_for_first_display
      exporting
        i_structure_name = 'SFLIGHT'
        is_layout        = gs_layout_alv
      changing
        it_sort          = gt_sort_grid[]
        it_outtab        = gt_sflight[].
*   reset fields on screen 100
    clear saplane.
*   flush
    call method cl_gui_control=>set_focus
      exporting
        control = grid.
    call method cl_gui_cfw=>flush.
  endif.
endmodule.                             " ALV_DISPLAY  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  OK_CODE  INPUT
*&---------------------------------------------------------------------*
module ok_code input.
  save_ok_code = ok_code.
  clear ok_code.
  case save_ok_code.
*   Exit program
    when fcode_back or
         fcode_end  or
         fcode_esc.
      call method grid->free.
      call method tree1->free.
      call method g_custom_container->free.
      leave program.
    when others.
      call method cl_gui_cfw=>dispatch.
  endcase.
endmodule.                             " OK_CODE  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
module user_command_0200 input.
  save_ok_code = ok_code.
  clear ok_code.
* leave screen 200
  if save_ok_code = fcode_entr or
     save_ok_code = fcode_esc.
    set screen 0. leave screen.
  endif.
endmodule.                             " USER_COMMAND_0200  INPUT

*&---------------------------------------------------------------------*
*&      Module  HIDE_SAPLANE  OUTPUT
*&---------------------------------------------------------------------*
module hide_saplane output.
  loop at screen.
    if screen-group1 = 'F01' and saplane is initial.
      screen-active = '0'.
      modify screen.
    endif.
  endloop.
endmodule.                             " HIDE_SAPLANE  OUTPUT
