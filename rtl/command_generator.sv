/**
 *
 */

module command_generator;

	// JESD79-3F pg. 33
	localparam CMD_MRS   = 4'b0000; // Mode Register Set
	localparam CMD_REF   = 4'b0001; // Refresh
	localparam CMD_SRE   = 4'b0001; // Self Refresh Entry
	localparam CMD_SRX   = 4'b0000; // Self Refresh Exit
	localparam CMD_PRE   = 4'b0010; // Single Bank Precharge
	localparam CMD_PREA  = 4'b0000; // Precharge all Banks
	localparam CMD_ACT   = 4'b0000; // Bank Activate
	localparam CMD_WR    = 4'b0000; // Write (Fixed BL8 or BC4)
	localparam CMD_WRS4  = 4'b0000; // Write (BC4, on the Fly)
	localparam CMD_WRS8  = 4'b0000; // Write (BL8, on the Fly)
	localparam CMD_WRA   = 4'b0000; // Write with Auto Precharge (Fixed BL8 or BC4)
	localparam CMD_WRAS4 = 4'b0000; // Write with Auto Precharge (BC4, on the Fly)
	localparam CMD_WRAS8 = 4'b0000; // Write with Auto Precharge (BL8, on the Fly)
	localparam CMD_RD    = 4'b0000; // Read (Fixed BL8 or BC4)
	localparam CMD_RDS4  = 4'b0000; // Read (BC4, on the Fly)
	localparam CMD_RDS8  = 4'b0000; // Read (BL8, on the Fly)
	localparam CMD_RDA   = 4'b0000; // Read with Auto Precharge (Fixed BL8 or BC4)
	localparam CMD_RDAS4 = 4'b0000; // Read with Auto Precharge (BC4, on the Fly)
	localparam CMD_RDAS8 = 4'b0000; // Read with Auto Precharge (BL8, on the Fly)
	localparam CMD_NOP   = 4'b0000; // No Operation
	localparam CMD_DES   = 4'b0000; // Device Deselected
	localparam CMD_PDE   = 4'b0000; // Power Down Entry
	localparam CMD_PDX   = 4'b0000; // Power Down Exit
	localparam CMD_ZQCL  = 4'b0000; // ZQ Calibration Long
	localparam CMD_ZQCS  = 4'b0000; // ZQ Calibration Short

endmodule // command_generator
