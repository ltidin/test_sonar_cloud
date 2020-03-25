*&---------------------------------------------------------------------*
*& Include ZVR_BC412_PICT_CONT_TOP                  - Module Pool      ZVR_BC412_R_PICT_CONT
*&---------------------------------------------------------------------*
PROGRAM zvr_bc412_r_pict_cont.

TYPE-POOLS: icon, cndp.

DATA: ok_code   TYPE sy-ucomm,
      gv_answer TYPE c LENGTH 1,
      p_left    TYPE c LENGTH 1 VALUE 'X',
      p_right   TYPE c LENGTH 1.



DATA: go_container TYPE REF TO cl_gui_docking_container,
      go_picture   TYPE REF TO cl_gui_picture.
