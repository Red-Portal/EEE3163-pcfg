/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;

<<<<<<< HEAD:isim/tb181111_01forTOP_8254_isim_beh.exe.sim/work/tb181111_01forTOP_8254_isim_beh.exe_main.c
char *IEEE_P_3499444699;
<<<<<<< HEAD:isim/memory_block_test_isim_beh.exe.sim/work/memory_block_test_isim_beh.exe_main.c
char *STD_TEXTIO;
char *IEEE_P_3564397177;
char *STD_STANDARD;
char *IEEE_P_3620187407;
char *IEEE_P_2592010699;
=======
char *IEEE_P_2592010699;
char *STD_STANDARD;
char *IEEE_P_3620187407;
>>>>>>> dfa3576e34fde7fbf602852b7ac6f12b5acb792c:isim/tb181111_01forTOP_8254_isim_beh.exe.sim/work/tb181111_01forTOP_8254_isim_beh.exe_main.c
=======
char *IEEE_P_2592010699;
char *STD_STANDARD;
char *IEEE_P_1242562249;
>>>>>>> parent of dfa3576... finished top module - no simulation performed yet.:isim/address_decoder_test_isim_beh.exe.sim/work/address_decoder_test_isim_beh.exe_main.c


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_1242562249_init();
    work_a_1412406658_3212880686_init();
    work_a_3991588173_2372691052_init();


    xsi_register_tops("work_a_3991588173_2372691052");

<<<<<<< HEAD:isim/tb181111_01forTOP_8254_isim_beh.exe.sim/work/tb181111_01forTOP_8254_isim_beh.exe_main.c
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");
<<<<<<< HEAD:isim/memory_block_test_isim_beh.exe.sim/work/memory_block_test_isim_beh.exe_main.c
    STD_TEXTIO = xsi_get_engine_memory("std_textio");
    IEEE_P_3564397177 = xsi_get_engine_memory("ieee_p_3564397177");
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
=======
    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
>>>>>>> dfa3576e34fde7fbf602852b7ac6f12b5acb792c:isim/tb181111_01forTOP_8254_isim_beh.exe.sim/work/tb181111_01forTOP_8254_isim_beh.exe_main.c
=======
    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
>>>>>>> parent of dfa3576... finished top module - no simulation performed yet.:isim/address_decoder_test_isim_beh.exe.sim/work/address_decoder_test_isim_beh.exe_main.c

    return xsi_run_simulation(argc, argv);

}
