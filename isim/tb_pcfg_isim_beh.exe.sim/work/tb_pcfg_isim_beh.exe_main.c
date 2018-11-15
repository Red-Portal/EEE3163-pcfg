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

char *IEEE_P_2592010699;
char *STD_STANDARD;
char *STD_TEXTIO;
char *IEEE_P_3620187407;
char *IEEE_P_3499444699;
char *UNISIM_P_0947159679;
char *IEEE_P_1242562249;
char *IEEE_P_3564397177;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    unisim_p_0947159679_init();
    ieee_p_1242562249_init();
    unisim_a_0780662263_2014779070_init();
    work_a_2624752158_3212880686_init();
    work_a_1380139569_3212880686_init();
    std_textio_init();
    ieee_p_3564397177_init();
    xilinxcorelib_a_3189398483_2959432447_init();
    xilinxcorelib_a_1717820610_1709443946_init();
    xilinxcorelib_a_4216127487_0543512595_init();
    xilinxcorelib_a_1774992342_3212880686_init();
    work_a_0201413723_2800817134_init();
    work_a_1531662726_2372691052_init();
    work_a_1278232005_2372691052_init();
    work_a_4235732096_2372691052_init();
    work_a_0963963531_3212880686_init();
    work_a_2731648740_3212880686_init();
    work_a_1412406658_3212880686_init();
    work_a_1341324395_3212880686_init();
    work_a_3810578882_2372691052_init();


    xsi_register_tops("work_a_3810578882_2372691052");

    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    STD_TEXTIO = xsi_get_engine_memory("std_textio");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");
    UNISIM_P_0947159679 = xsi_get_engine_memory("unisim_p_0947159679");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
    IEEE_P_3564397177 = xsi_get_engine_memory("ieee_p_3564397177");

    return xsi_run_simulation(argc, argv);

}
