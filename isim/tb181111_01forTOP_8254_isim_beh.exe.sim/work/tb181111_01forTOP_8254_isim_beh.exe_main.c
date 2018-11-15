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


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    work_a_2624752158_3212880686_init();
    work_a_1380139569_3212880686_init();
    work_a_2321235089_2372691052_init();


    xsi_register_tops("work_a_2321235089_2372691052");

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

    return xsi_run_simulation(argc, argv);

}
