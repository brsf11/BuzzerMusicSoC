##clk
set_property PACKAGE_PIN D4 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

##RSTn
set_property PACKAGE_PIN T9 [get_ports RSTn]
set_property IOSTANDARD LVCMOS33 [get_ports RSTn]

##DEBUGGER
set_property PACKAGE_PIN H14 [get_ports SWDIO]
set_property IOSTANDARD LVCMOS33 [get_ports SWDIO]
set_property PACKAGE_PIN H12 [get_ports SWCLK]
set_property IOSTANDARD LVCMOS33 [get_ports SWCLK]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets SWCLK]

##PWM
set_property PACKAGE_PIN L2 [get_ports PWM]
set_property IOSTANDARD LVCMOS33 [get_ports PWM]

##Keyboard Mtx
set_property IOSTANDARD LVCMOS33 [get_ports {col[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {col[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {col[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {col[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[0]}]

set_property PACKAGE_PIN T10 [get_ports {col[3]}]
set_property PACKAGE_PIN R11 [get_ports {col[2]}]
set_property PACKAGE_PIN T12 [get_ports {col[1]}]
set_property PACKAGE_PIN R10 [get_ports {row[3]}]
set_property PACKAGE_PIN P10 [get_ports {row[2]}]
set_property PACKAGE_PIN R12 [get_ports {col[0]}]
set_property PACKAGE_PIN M6 [get_ports {row[1]}]
set_property PACKAGE_PIN K3 [get_ports {row[0]}]


