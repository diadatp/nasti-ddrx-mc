
# clocks
create_clock -period 5 [get_ports sysclk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sysclk_p]
set_property PACKAGE_PIN AD12 [get_ports sysclk_p]

set_property IOSTANDARD DIFF_SSTL15 [get_ports sysclk_n]
set_property PACKAGE_PIN AD11 [get_ports sysclk_n]

# reset
set_property IOSTANDARD LVCMOS15 [get_ports sysrst]
set_property PACKAGE_PIN AB7 [get_ports sysrst]

# GPIO LEDs
set_property PACKAGE_PIN AB8 [get_ports gpio_led[0]]
set_property IOSTANDARD LVCMOS15 [get_ports gpio_led[0]]

set_property PACKAGE_PIN AA8 [get_ports gpio_led[1]]
set_property IOSTANDARD LVCMOS15 [get_ports gpio_led[1]]

set_property PACKAGE_PIN AC9 [get_ports gpio_led[2]]
set_property IOSTANDARD LVCMOS15 [get_ports gpio_led[2]]

set_property PACKAGE_PIN AB9 [get_ports gpio_led[3]]
set_property IOSTANDARD LVCMOS15 [get_ports gpio_led[3]]

set_property IOSTANDARD LVCMOS25 [get_ports gpio_led[4]]
set_property PACKAGE_PIN AE26 [get_ports gpio_led[4]]

set_property IOSTANDARD LVCMOS25 [get_ports gpio_led[5]]
set_property PACKAGE_PIN G19 [get_ports gpio_led[5]]

set_property IOSTANDARD LVCMOS25 [get_ports gpio_led[6]]
set_property PACKAGE_PIN E18 [get_ports gpio_led[6]]

set_property IOSTANDARD LVCMOS25 [get_ports gpio_led[7]]
set_property PACKAGE_PIN F16 [get_ports gpio_led[7]]

# DCI_CASCADE
set_property DCI_CASCADE {32 34} [get_iobanks 33]

# ddr3 dq
set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[0]]
set_property PACKAGE_PIN AA15 [get_ports ddr_dq[0]]
set_property SLEW FAST [get_ports ddr_dq[0]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[0]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[1]]
set_property PACKAGE_PIN AA16 [get_ports ddr_dq[1]]
set_property SLEW FAST [get_ports ddr_dq[1]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[1]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[2]]
set_property PACKAGE_PIN AC14 [get_ports ddr_dq[2]]
set_property SLEW FAST [get_ports ddr_dq[2]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[2]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[3]]
set_property PACKAGE_PIN AD14 [get_ports ddr_dq[3]]
set_property SLEW FAST [get_ports ddr_dq[3]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[3]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[4]]
set_property PACKAGE_PIN AA17 [get_ports ddr_dq[4]]
set_property SLEW FAST [get_ports ddr_dq[4]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[4]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[5]]
set_property PACKAGE_PIN AB15 [get_ports ddr_dq[5]]
set_property SLEW FAST [get_ports ddr_dq[5]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[5]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[6]]
set_property PACKAGE_PIN AE15 [get_ports ddr_dq[6]]
set_property SLEW FAST [get_ports ddr_dq[6]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[6]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[7]]
set_property PACKAGE_PIN Y15 [get_ports ddr_dq[7]]
set_property SLEW FAST [get_ports ddr_dq[7]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[7]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[8]]
set_property PACKAGE_PIN AB19 [get_ports ddr_dq[8]]
set_property SLEW FAST [get_ports ddr_dq[8]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[8]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[9]]
set_property PACKAGE_PIN AD16 [get_ports ddr_dq[9]]
set_property SLEW FAST [get_ports ddr_dq[9]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[9]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[10]]
set_property PACKAGE_PIN AC19 [get_ports ddr_dq[10]]
set_property SLEW FAST [get_ports ddr_dq[10]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[10]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[11]]
set_property PACKAGE_PIN AD17 [get_ports ddr_dq[11]]
set_property SLEW FAST [get_ports ddr_dq[11]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[11]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[12]]
set_property PACKAGE_PIN AA18 [get_ports ddr_dq[12]]
set_property SLEW FAST [get_ports ddr_dq[12]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[12]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[13]]
set_property PACKAGE_PIN AB18 [get_ports ddr_dq[13]]
set_property SLEW FAST [get_ports ddr_dq[13]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[13]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[14]]
set_property PACKAGE_PIN AE18 [get_ports ddr_dq[14]]
set_property SLEW FAST [get_ports ddr_dq[14]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[14]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[15]]
set_property PACKAGE_PIN AD18 [get_ports ddr_dq[15]]
set_property SLEW FAST [get_ports ddr_dq[15]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[15]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[16]]
set_property PACKAGE_PIN AG19 [get_ports ddr_dq[16]]
set_property SLEW FAST [get_ports ddr_dq[16]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[16]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[17]]
set_property PACKAGE_PIN AK19 [get_ports ddr_dq[17]]
set_property SLEW FAST [get_ports ddr_dq[17]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[17]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[18]]
set_property PACKAGE_PIN AG18 [get_ports ddr_dq[18]]
set_property SLEW FAST [get_ports ddr_dq[18]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[18]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[19]]
set_property PACKAGE_PIN AF18 [get_ports ddr_dq[19]]
set_property SLEW FAST [get_ports ddr_dq[19]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[19]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[20]]
set_property PACKAGE_PIN AH19 [get_ports ddr_dq[20]]
set_property SLEW FAST [get_ports ddr_dq[20]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[20]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[21]]
set_property PACKAGE_PIN AJ19 [get_ports ddr_dq[21]]
set_property SLEW FAST [get_ports ddr_dq[21]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[21]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[22]]
set_property PACKAGE_PIN AE19 [get_ports ddr_dq[22]]
set_property SLEW FAST [get_ports ddr_dq[22]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[22]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[23]]
set_property PACKAGE_PIN AD19 [get_ports ddr_dq[23]]
set_property SLEW FAST [get_ports ddr_dq[23]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[23]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[24]]
set_property PACKAGE_PIN AK16 [get_ports ddr_dq[24]]
set_property SLEW FAST [get_ports ddr_dq[24]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[24]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[25]]
set_property PACKAGE_PIN AJ17 [get_ports ddr_dq[25]]
set_property SLEW FAST [get_ports ddr_dq[25]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[25]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[26]]
set_property PACKAGE_PIN AG15 [get_ports ddr_dq[26]]
set_property SLEW FAST [get_ports ddr_dq[26]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[26]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[27]]
set_property PACKAGE_PIN AF15 [get_ports ddr_dq[27]]
set_property SLEW FAST [get_ports ddr_dq[27]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[27]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[28]]
set_property PACKAGE_PIN AH17 [get_ports ddr_dq[28]]
set_property SLEW FAST [get_ports ddr_dq[28]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[28]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[29]]
set_property PACKAGE_PIN AG14 [get_ports ddr_dq[29]]
set_property SLEW FAST [get_ports ddr_dq[29]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[29]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[30]]
set_property PACKAGE_PIN AH15 [get_ports ddr_dq[30]]
set_property SLEW FAST [get_ports ddr_dq[30]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[30]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[31]]
set_property PACKAGE_PIN AK15 [get_ports ddr_dq[31]]
set_property SLEW FAST [get_ports ddr_dq[31]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[31]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[32]]
set_property PACKAGE_PIN AK8 [get_ports ddr_dq[32]]
set_property SLEW FAST [get_ports ddr_dq[32]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[32]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[33]]
set_property PACKAGE_PIN AK6 [get_ports ddr_dq[33]]
set_property SLEW FAST [get_ports ddr_dq[33]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[33]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[34]]
set_property PACKAGE_PIN AG7 [get_ports ddr_dq[34]]
set_property SLEW FAST [get_ports ddr_dq[34]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[34]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[35]]
set_property PACKAGE_PIN AF7 [get_ports ddr_dq[35]]
set_property SLEW FAST [get_ports ddr_dq[35]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[35]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[36]]
set_property PACKAGE_PIN AF8 [get_ports ddr_dq[36]]
set_property SLEW FAST [get_ports ddr_dq[36]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[36]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[37]]
set_property PACKAGE_PIN AK4 [get_ports ddr_dq[37]]
set_property SLEW FAST [get_ports ddr_dq[37]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[37]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[38]]
set_property PACKAGE_PIN AJ8 [get_ports ddr_dq[38]]
set_property SLEW FAST [get_ports ddr_dq[38]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[38]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[39]]
set_property PACKAGE_PIN AJ6 [get_ports ddr_dq[39]]
set_property SLEW FAST [get_ports ddr_dq[39]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[39]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[40]]
set_property PACKAGE_PIN AH5 [get_ports ddr_dq[40]]
set_property SLEW FAST [get_ports ddr_dq[40]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[40]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[41]]
set_property PACKAGE_PIN AH6 [get_ports ddr_dq[41]]
set_property SLEW FAST [get_ports ddr_dq[41]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[41]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[42]]
set_property PACKAGE_PIN AJ2 [get_ports ddr_dq[42]]
set_property SLEW FAST [get_ports ddr_dq[42]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[42]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[43]]
set_property PACKAGE_PIN AH2 [get_ports ddr_dq[43]]
set_property SLEW FAST [get_ports ddr_dq[43]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[43]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[44]]
set_property PACKAGE_PIN AH4 [get_ports ddr_dq[44]]
set_property SLEW FAST [get_ports ddr_dq[44]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[44]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[45]]
set_property PACKAGE_PIN AJ4 [get_ports ddr_dq[45]]
set_property SLEW FAST [get_ports ddr_dq[45]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[45]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[46]]
set_property PACKAGE_PIN AK1 [get_ports ddr_dq[46]]
set_property SLEW FAST [get_ports ddr_dq[46]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[46]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[47]]
set_property PACKAGE_PIN AJ1 [get_ports ddr_dq[47]]
set_property SLEW FAST [get_ports ddr_dq[47]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[47]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[48]]
set_property PACKAGE_PIN AF1 [get_ports ddr_dq[48]]
set_property SLEW FAST [get_ports ddr_dq[48]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[48]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[49]]
set_property PACKAGE_PIN AF2 [get_ports ddr_dq[49]]
set_property SLEW FAST [get_ports ddr_dq[49]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[49]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[50]]
set_property PACKAGE_PIN AE4 [get_ports ddr_dq[50]]
set_property SLEW FAST [get_ports ddr_dq[50]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[50]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[51]]
set_property PACKAGE_PIN AE3 [get_ports ddr_dq[51]]
set_property SLEW FAST [get_ports ddr_dq[51]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[51]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[52]]
set_property PACKAGE_PIN AF3 [get_ports ddr_dq[52]]
set_property SLEW FAST [get_ports ddr_dq[52]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[52]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[53]]
set_property PACKAGE_PIN AF5 [get_ports ddr_dq[53]]
set_property SLEW FAST [get_ports ddr_dq[53]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[53]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[54]]
set_property PACKAGE_PIN AE1 [get_ports ddr_dq[54]]
set_property SLEW FAST [get_ports ddr_dq[54]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[54]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[55]]
set_property PACKAGE_PIN AE5 [get_ports ddr_dq[55]]
set_property SLEW FAST [get_ports ddr_dq[55]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[55]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[56]]
set_property PACKAGE_PIN AC1 [get_ports ddr_dq[56]]
set_property SLEW FAST [get_ports ddr_dq[56]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[56]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[57]]
set_property PACKAGE_PIN AD3 [get_ports ddr_dq[57]]
set_property SLEW FAST [get_ports ddr_dq[57]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[57]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[58]]
set_property PACKAGE_PIN AC4 [get_ports ddr_dq[58]]
set_property SLEW FAST [get_ports ddr_dq[58]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[58]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[59]]
set_property PACKAGE_PIN AC5 [get_ports ddr_dq[59]]
set_property SLEW FAST [get_ports ddr_dq[59]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[59]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[60]]
set_property PACKAGE_PIN AE6 [get_ports ddr_dq[60]]
set_property SLEW FAST [get_ports ddr_dq[60]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[60]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[61]]
set_property PACKAGE_PIN AD6 [get_ports ddr_dq[61]]
set_property SLEW FAST [get_ports ddr_dq[61]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[61]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[62]]
set_property PACKAGE_PIN AC2 [get_ports ddr_dq[62]]
set_property SLEW FAST [get_ports ddr_dq[62]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[62]]

set_property IOSTANDARD SSTL15_T_DCI [get_ports ddr_dq[63]]
set_property PACKAGE_PIN AD4 [get_ports ddr_dq[63]]
set_property SLEW FAST [get_ports ddr_dq[63]]
set_property VCCAUX_IO HIGH [get_ports ddr_dq[63]]

# ddr3 dqs
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_n[0]]
set_property PACKAGE_PIN AC15 [get_ports ddr_dqs_n[0]]
set_property SLEW FAST [get_ports ddr_dqs_n[0]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_n[0]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_p[0]]
set_property PACKAGE_PIN AC16 [get_ports ddr_dqs_p[0]]
set_property SLEW FAST [get_ports ddr_dqs_p[0]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_p[0]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_n[1]]
set_property PACKAGE_PIN Y18 [get_ports ddr_dqs_n[1]]
set_property SLEW FAST [get_ports ddr_dqs_n[1]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_n[1]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_p[1]]
set_property PACKAGE_PIN Y19 [get_ports ddr_dqs_p[1]]
set_property SLEW FAST [get_ports ddr_dqs_p[1]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_p[1]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_n[2]]
set_property PACKAGE_PIN AK18 [get_ports ddr_dqs_n[2]]
set_property SLEW FAST [get_ports ddr_dqs_n[2]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_n[2]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_p[2]]
set_property PACKAGE_PIN AJ18 [get_ports ddr_dqs_p[2]]
set_property SLEW FAST [get_ports ddr_dqs_p[2]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_p[2]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_n[3]]
set_property PACKAGE_PIN AJ16 [get_ports ddr_dqs_n[3]]
set_property SLEW FAST [get_ports ddr_dqs_n[3]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_n[3]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_p[3]]
set_property PACKAGE_PIN AH16 [get_ports ddr_dqs_p[3]]
set_property SLEW FAST [get_ports ddr_dqs_p[3]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_p[3]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_n[4]]
set_property PACKAGE_PIN AJ7 [get_ports ddr_dqs_n[4]]
set_property SLEW FAST [get_ports ddr_dqs_n[4]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_n[4]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_p[4]]
set_property PACKAGE_PIN AH7 [get_ports ddr_dqs_p[4]]
set_property SLEW FAST [get_ports ddr_dqs_p[4]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_p[4]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_n[5]]
set_property PACKAGE_PIN AH1 [get_ports ddr_dqs_n[5]]
set_property SLEW FAST [get_ports ddr_dqs_n[5]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_n[5]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_p[5]]
set_property PACKAGE_PIN AG2 [get_ports ddr_dqs_p[5]]
set_property SLEW FAST [get_ports ddr_dqs_p[5]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_p[5]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_n[6]]
set_property PACKAGE_PIN AG3 [get_ports ddr_dqs_n[6]]
set_property SLEW FAST [get_ports ddr_dqs_n[6]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_n[6]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_p[6]]
set_property PACKAGE_PIN AG4 [get_ports ddr_dqs_p[6]]
set_property SLEW FAST [get_ports ddr_dqs_p[6]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_p[6]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_n[7]]
set_property PACKAGE_PIN AD1 [get_ports ddr_dqs_n[7]]
set_property SLEW FAST [get_ports ddr_dqs_n[7]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_n[7]]

set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports ddr_dqs_p[7]]
set_property PACKAGE_PIN AD2 [get_ports ddr_dqs_p[7]]
set_property SLEW FAST [get_ports ddr_dqs_p[7]]
set_property VCCAUX_IO HIGH [get_ports ddr_dqs_p[7]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[0]]
set_property PACKAGE_PIN AH12 [get_ports ddr_addr[0]]
set_property SLEW FAST [get_ports ddr_addr[0]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[0]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[1]]
set_property PACKAGE_PIN AG13 [get_ports ddr_addr[1]]
set_property SLEW FAST [get_ports ddr_addr[1]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[1]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[2]]
set_property PACKAGE_PIN AG12 [get_ports ddr_addr[2]]
set_property SLEW FAST [get_ports ddr_addr[2]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[2]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[3]]
set_property PACKAGE_PIN AF12 [get_ports ddr_addr[3]]
set_property SLEW FAST [get_ports ddr_addr[3]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[3]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[4]]
set_property PACKAGE_PIN AJ12 [get_ports ddr_addr[4]]
set_property SLEW FAST [get_ports ddr_addr[4]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[4]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[5]]
set_property PACKAGE_PIN AJ13 [get_ports ddr_addr[5]]
set_property SLEW FAST [get_ports ddr_addr[5]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[5]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[6]]
set_property PACKAGE_PIN AJ14 [get_ports ddr_addr[6]]
set_property SLEW FAST [get_ports ddr_addr[6]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[6]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[7]]
set_property PACKAGE_PIN AH14 [get_ports ddr_addr[7]]
set_property SLEW FAST [get_ports ddr_addr[7]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[7]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[8]]
set_property PACKAGE_PIN AK13 [get_ports ddr_addr[8]]
set_property SLEW FAST [get_ports ddr_addr[8]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[8]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[9]]
set_property PACKAGE_PIN AK14 [get_ports ddr_addr[9]]
set_property SLEW FAST [get_ports ddr_addr[9]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[9]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[10]]
set_property PACKAGE_PIN AF13 [get_ports ddr_addr[10]]
set_property SLEW FAST [get_ports ddr_addr[10]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[10]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[11]]
set_property PACKAGE_PIN AE13 [get_ports ddr_addr[11]]
set_property SLEW FAST [get_ports ddr_addr[11]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[11]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[12]]
set_property PACKAGE_PIN AJ11 [get_ports ddr_addr[12]]
set_property SLEW FAST [get_ports ddr_addr[12]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[12]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[13]]
set_property PACKAGE_PIN AH11 [get_ports ddr_addr[13]]
set_property SLEW FAST [get_ports ddr_addr[13]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[13]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[14]]
set_property PACKAGE_PIN AK10 [get_ports ddr_addr[14]]
set_property SLEW FAST [get_ports ddr_addr[14]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[14]]

set_property IOSTANDARD SSTL15 [get_ports ddr_addr[15]]
set_property PACKAGE_PIN AK11 [get_ports ddr_addr[15]]
set_property SLEW FAST [get_ports ddr_addr[15]]
set_property VCCAUX_IO HIGH [get_ports ddr_addr[15]]

# ddr3 ba
set_property IOSTANDARD SSTL15 [get_ports ddr_ba[0]]
set_property PACKAGE_PIN AH9 [get_ports ddr_ba[0]]
set_property SLEW FAST [get_ports ddr_ba[0]]
set_property VCCAUX_IO HIGH [get_ports ddr_ba[0]]

set_property IOSTANDARD SSTL15 [get_ports ddr_ba[1]]
set_property PACKAGE_PIN AG9 [get_ports ddr_ba[1]]
set_property SLEW FAST [get_ports ddr_ba[1]]
set_property VCCAUX_IO HIGH [get_ports ddr_ba[1]]

set_property IOSTANDARD SSTL15 [get_ports ddr_ba[2]]
set_property PACKAGE_PIN AK9 [get_ports ddr_ba[2]]
set_property SLEW FAST [get_ports ddr_ba[2]]
set_property VCCAUX_IO HIGH [get_ports ddr_ba[2]]

# ddr3 ras
set_property IOSTANDARD SSTL15 [get_ports ddr_ras_n]
set_property PACKAGE_PIN AD9 [get_ports ddr_ras_n]
set_property SLEW FAST [get_ports ddr_ras_n]
set_property VCCAUX_IO HIGH [get_ports ddr_ras_n]

# ddr3 cas
set_property IOSTANDARD SSTL15 [get_ports ddr_cas_n]
set_property PACKAGE_PIN AC11 [get_ports ddr_cas_n]
set_property SLEW FAST [get_ports ddr_cas_n]
set_property VCCAUX_IO HIGH [get_ports ddr_cas_n]

# ddr3 we
set_property IOSTANDARD SSTL15 [get_ports ddr_we_n]
set_property PACKAGE_PIN AE9 [get_ports ddr_we_n]
set_property SLEW FAST [get_ports ddr_we_n]
set_property VCCAUX_IO HIGH [get_ports ddr_we_n]

# ddr3 reset
set_property IOSTANDARD LVCMOS15 [get_ports ddr_reset_n]
set_property PACKAGE_PIN AK3 [get_ports ddr_reset_n]
set_property SLEW FAST [get_ports ddr_reset_n]
set_property VCCAUX_IO HIGH [get_ports ddr_reset_n]

# ddr3 ck
set_property IOSTANDARD DIFF_SSTL15 [get_ports ddr_ck_n[0]]
set_property PACKAGE_PIN AH10 [get_ports ddr_ck_n[0]]
set_property SLEW FAST [get_ports ddr_ck_n[0]]
set_property VCCAUX_IO HIGH [get_ports ddr_ck_n[0]]

set_property IOSTANDARD DIFF_SSTL15 [get_ports ddr_ck_p[0]]
set_property PACKAGE_PIN AG10 [get_ports ddr_ck_p[0]]
set_property SLEW FAST [get_ports ddr_ck_p[0]]
set_property VCCAUX_IO HIGH [get_ports ddr_ck_p[0]]

set_property IOSTANDARD DIFF_SSTL15 [get_ports ddr_ck_n[1]]
set_property PACKAGE_PIN AF11 [get_ports ddr_ck_n[1]]
set_property SLEW FAST [get_ports ddr_ck_n[1]]
set_property VCCAUX_IO HIGH [get_ports ddr_ck_n[1]]

set_property IOSTANDARD DIFF_SSTL15 [get_ports ddr_ck_p[1]]
set_property PACKAGE_PIN AE11 [get_ports ddr_ck_p[1]]
set_property SLEW FAST [get_ports ddr_ck_p[1]]
set_property VCCAUX_IO HIGH [get_ports ddr_ck_p[1]]

# ddr3 cke
set_property IOSTANDARD SSTL15 [get_ports ddr_cke[0]]
set_property PACKAGE_PIN AF10 [get_ports ddr_cke[0]]
set_property SLEW FAST [get_ports ddr_cke[0]]
set_property VCCAUX_IO HIGH [get_ports ddr_cke[0]]

set_property IOSTANDARD SSTL15 [get_ports ddr_cke[1]]
set_property PACKAGE_PIN AE10 [get_ports ddr_cke[1]]
set_property SLEW FAST [get_ports ddr_cke[1]]
set_property VCCAUX_IO HIGH [get_ports ddr_cke[1]]

# ddr3 cs
set_property IOSTANDARD SSTL15 [get_ports ddr_cs_n[0]]
set_property PACKAGE_PIN AC12 [get_ports ddr_cs_n[0]]
set_property SLEW FAST [get_ports ddr_cs_n[0]]
set_property VCCAUX_IO HIGH [get_ports ddr_cs_n[0]]

set_property IOSTANDARD SSTL15 [get_ports ddr_cs_n[1]]
set_property PACKAGE_PIN AE8 [get_ports ddr_cs_n[1]]
set_property SLEW FAST [get_ports ddr_cs_n[1]]
set_property VCCAUX_IO HIGH [get_ports ddr_cs_n[1]]

# ddr3 dm
set_property IOSTANDARD SSTL15 [get_ports ddr_dm[0]]
set_property PACKAGE_PIN Y16 [get_ports ddr_dm[0]]
set_property SLEW FAST [get_ports ddr_dm[0]]
set_property VCCAUX_IO HIGH [get_ports ddr_dm[0]]

set_property IOSTANDARD SSTL15 [get_ports ddr_dm[1]]
set_property PACKAGE_PIN AB17 [get_ports ddr_dm[1]]
set_property SLEW FAST [get_ports ddr_dm[1]]
set_property VCCAUX_IO HIGH [get_ports ddr_dm[1]]

set_property IOSTANDARD SSTL15 [get_ports ddr_dm[2]]
set_property PACKAGE_PIN AF17 [get_ports ddr_dm[2]]
set_property SLEW FAST [get_ports ddr_dm[2]]
set_property VCCAUX_IO HIGH [get_ports ddr_dm[2]]

set_property IOSTANDARD SSTL15 [get_ports ddr_dm[3]]
set_property PACKAGE_PIN AE16 [get_ports ddr_dm[3]]
set_property SLEW FAST [get_ports ddr_dm[3]]
set_property VCCAUX_IO HIGH [get_ports ddr_dm[3]]

set_property IOSTANDARD SSTL15 [get_ports ddr_dm[4]]
set_property PACKAGE_PIN AK5 [get_ports ddr_dm[4]]
set_property SLEW FAST [get_ports ddr_dm[4]]
set_property VCCAUX_IO HIGH [get_ports ddr_dm[4]]

set_property IOSTANDARD SSTL15 [get_ports ddr_dm[5]]
set_property PACKAGE_PIN AJ3 [get_ports ddr_dm[5]]
set_property SLEW FAST [get_ports ddr_dm[5]]
set_property VCCAUX_IO HIGH [get_ports ddr_dm[5]]

set_property IOSTANDARD SSTL15 [get_ports ddr_dm[6]]
set_property PACKAGE_PIN AF6 [get_ports ddr_dm[6]]
set_property SLEW FAST [get_ports ddr_dm[6]]
set_property VCCAUX_IO HIGH [get_ports ddr_dm[6]]

set_property IOSTANDARD SSTL15 [get_ports ddr_dm[7]]
set_property PACKAGE_PIN AC7 [get_ports ddr_dm[7]]
set_property SLEW FAST [get_ports ddr_dm[7]]
set_property VCCAUX_IO HIGH [get_ports ddr_dm[7]]

# ddr3 odt
set_property IOSTANDARD SSTL15 [get_ports ddr_odt[0]]
set_property PACKAGE_PIN AD8 [get_ports ddr_odt[0]]
set_property SLEW FAST [get_ports ddr_odt[0]]
set_property VCCAUX_IO HIGH [get_ports ddr_odt[0]]

set_property IOSTANDARD SSTL15 [get_ports ddr_odt[1]]
set_property PACKAGE_PIN AC10 [get_ports ddr_odt[1]]
set_property SLEW FAST [get_ports ddr_odt[1]]
set_property VCCAUX_IO HIGH [get_ports ddr_odt[1]]

# set_property LOC BUFIO_X1Y0 [get_cells i_phy_top/gen_dqs_32[0].BUFIO_inst_n]
# set_property LOC BUFIO_X1Y1 [get_cells i_phy_top/gen_dqs_32[1].BUFIO_inst_n]
# set_property LOC BUFIO_X1Y2 [get_cells i_phy_top/gen_dqs_32[2].BUFIO_inst_n]
# set_property LOC BUFIO_X1Y3 [get_cells i_phy_top/gen_dqs_32[3].BUFIO_inst_n]
