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

char *XILINXCORELIB_P_3381355550;
char *IEEE_P_2592010699;
char *STD_STANDARD;
char *STD_TEXTIO;
char *IEEE_P_3499444699;
char *XILINXCORELIB_P_2147798235;
char *XILINXCORELIB_P_1837083571;
char *IEEE_P_3620187407;
char *XILINXCORELIB_P_0914797037;
char *XILINXCORELIB_P_0558180590;
char *IEEE_P_1242562249;
char *XILINXCORELIB_P_1433929353;
char *XILINXCORELIB_P_0661866964;
char *XILINXCORELIB_P_3106367597;
char *XILINXCORELIB_P_0624651749;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    std_textio_init();
    xilinxcorelib_p_1837083571_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    xilinxcorelib_p_2147798235_init();
    xilinxcorelib_p_0914797037_init();
    xilinxcorelib_p_0558180590_init();
    ieee_p_1242562249_init();
    xilinxcorelib_p_3381355550_init();
    xilinxcorelib_p_1433929353_init();
    xilinxcorelib_p_0661866964_init();
    xilinxcorelib_p_3106367597_init();
    xilinxcorelib_p_0624651749_init();
    xilinxcorelib_a_1871456832_3212880686_init();
    xilinxcorelib_a_1887370777_3212880686_init();
    xilinxcorelib_a_0603225182_3212880686_init();
    xilinxcorelib_a_1797578820_3212880686_init();
    work_a_4000226436_0476169694_init();
    work_a_3912051845_2372691052_init();


    xsi_register_tops("work_a_3912051845_2372691052");

    XILINXCORELIB_P_3381355550 = xsi_get_engine_memory("xilinxcorelib_p_3381355550");
    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    STD_TEXTIO = xsi_get_engine_memory("std_textio");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");
    XILINXCORELIB_P_2147798235 = xsi_get_engine_memory("xilinxcorelib_p_2147798235");
    XILINXCORELIB_P_1837083571 = xsi_get_engine_memory("xilinxcorelib_p_1837083571");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    XILINXCORELIB_P_0914797037 = xsi_get_engine_memory("xilinxcorelib_p_0914797037");
    XILINXCORELIB_P_0558180590 = xsi_get_engine_memory("xilinxcorelib_p_0558180590");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
    XILINXCORELIB_P_1433929353 = xsi_get_engine_memory("xilinxcorelib_p_1433929353");
    XILINXCORELIB_P_0661866964 = xsi_get_engine_memory("xilinxcorelib_p_0661866964");
    XILINXCORELIB_P_3106367597 = xsi_get_engine_memory("xilinxcorelib_p_3106367597");
    XILINXCORELIB_P_0624651749 = xsi_get_engine_memory("xilinxcorelib_p_0624651749");

    return xsi_run_simulation(argc, argv);

}
