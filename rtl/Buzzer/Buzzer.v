module Buzzer #(parameter isSim = 0) (input wire clk,rst_n,
              //BDMAC Master Port
              output wire[31:0] BDMAC_HRDATA,
              output wire       BDMAC_HREADYOUT,
              output wire[1:0]  BDMAC_HRESP,
              input wire        BDMAC_HSEL,
			  input wire        BDMAC_HREADY,
              input wire[31:0]  BDMAC_HADDR,
              input wire[1:0]   BDMAC_HTRANS,
              input wire        BDMAC_HWRITE,
              input wire[31:0]  BDMAC_HWDATA,
              //SBDMA Slave Port
              output wire[31:0] SBDMA_HADDR,
              output wire[1:0]  SBDMA_HTRANS,
              output wire       SBDMA_HWRITE,
              input wire[31:0]  SBDMA_HRDATA,
              input wire        SBDMA_HREADY,
              //BBDMA Slave Port
              output wire[31:0] BBDMA_HADDR,
              output wire[1:0]  BBDMA_HTRANS,
              output wire       BBDMA_HWRITE,
              input wire[31:0]  BBDMA_HRDATA,
              input wire        BBDMA_HREADY,
              //PWM
              output wire PWM);
			  
	wire[31:0] BRstAddr,SRstAddr;
	wire[1:0] SPri;
	wire isCyl,BisPlaying,Bstop,SisPlaying;
	wire ref_BGM,ref_Sound;
	
	BDMAC BDMAC_BGM(
		.clk              (clk),
		.rst_n            (rst_n),
		.HWRITE           (BDMAC_HWRITE),
		.HREADY           (BDMAC_HREADY),
		.HSEL             (BDMAC_HSEL),
		.Bref             (ref_BGM),
		.Sref             (ref_Sound),
		.HTRANS           (BDMAC_HTRANS),
		.HWRDATA          (BDMAC_HWDATA),
		.HADDR            (BDMAC_HADDR),
		.HRDDATA          (BDMAC_HRDATA),
		.BRstAddr         (BRstAddr),
		.SRstAddr         (SRstAddr),
		.SPri             (SPri),
		.isCyl            (isCyl),
		.BisPlaying       (BisPlaying),
		.Bstop            (Bstop),
		.SisPlaying       (SisPlaying)
    );
	
	assign BDMAC_HREADYOUT = 1'b1;
	assign BDMAC_HRESP     = 2'b00;

    //BGM
	wire BeatFinish_BGM,BReady_BGM;
	wire AddrCntRstn_BGM,AddrCntEn_BGM;
	wire BeatCntRstn_BGM,BeatCntEn_BGM;
	wire TunePWMRstn_BGM,TunePWMEn_BGM;
	wire BDMAstart_BGM,BDMARstn_BGM,BDMAAddrSel_BGM,fetch_BGM;
	wire PWM_BGM;
	wire[15:0] Buf_BGM;
	wire[31:0] BDMAAddr_BGM,Addr_BGM,NextAddr_BGM;
	wire[27:0] BeatCntParameter_BGM;
	wire[19:0] TunePWMParameter_BGM;

	reg[15:0] SoundReg_BGM;

	
	
    BuzzerCtr BuzzerCtr_BGM(
		.clk              (clk),
		.rst_n            (rst_n),
		.isPlaying        (BisPlaying),
		.BeatFinish       (BeatFinish_BGM),
		.BReady           (BReady_BGM),
		.stop             (Bstop),
		.Buf              (Buf_BGM),
		.AddrCntRstn      (AddrCntRstn_BGM),
		.AddrCntEn        (AddrCntEn_BGM),
		.BeatCntRstn      (BeatCntRstn_BGM),
		.BeatCntEn        (BeatCntEn_BGM),
		.TunePWMRstn      (TunePWMRstn_BGM),
		.TunePWMEn        (TunePWMEn_BGM),
		.BDMAstart        (BDMAstart_BGM),
		.BDMARstn         (BDMARstn_BGM),
		.BDMAAddrSel      (BDMAAddrSel_BGM),
		.fetch            (fetch_BGM),
		.ref              (ref_BGM)
    );

    BDMA BDMA_BGM(
		.clk              (clk),
		.rst_n            (BDMARstn_BGM&rst_n),
		.start            (BDMAstart_BGM),
		.fetch            (fetch_BGM),
		.Addr             (BDMAAddr_BGM),
		.HREADY           (BBDMA_HREADY),
		.HRDATA           (BBDMA_HRDATA),
		.BReady           (BReady_BGM),
		.HTRANS           (BBDMA_HTRANS),
		.Buf              (Buf_BGM),
		.HADDR            (BBDMA_HADDR)
    );

    AddrCnt AddrCnt_BGM(
		.clk              (clk),
		.rst_n            (AddrCntRstn_BGM&rst_n),
		.en               (AddrCntEn_BGM),
		.rstAddr          (BRstAddr),
		.Addr             (Addr_BGM),
		.NextAddr         (NextAddr_BGM)
    );

    BeatCnt BeatCnt_BGM(
		.clk              (clk),
		.rst_n            (BeatCntRstn_BGM&rst_n),
		.en               (BeatCntEn_BGM),
		.BeatCntParameter (BeatCntParameter_BGM),
		.BeatFinish       (BeatFinish_BGM)
    );

    BeatDecoder #(isSim) BeatDecoder_BGM(
		.beat             (SoundReg_BGM[11:8]),
		.bpm              (1'b1),
		.BeatCntParameter (BeatCntParameter_BGM)
    );

    TuneDecoder TuneDecoder_BGM(
		.tune             (SoundReg_BGM[7:0]),
		.TunePWMParameter (TunePWMParameter_BGM)
    );

    TunePWM TunePWM_BGM(
        .clk              (clk),
		.rst_n            (TunePWMRstn_BGM&rst_n),
		.en               (TunePWMEn_BGM),
		.PWMParameter     (TunePWMParameter_BGM),
		.loudness         (2'b11),
		.PWM              (PWM_BGM)
    );
	
	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			SoundReg_BGM <= 16'b0;
		end
		else if(fetch_BGM)begin
			SoundReg_BGM <= Buf_BGM;
		end
	end
	
	assign BDMAAddr_BGM = BDMAAddrSel_BGM?NextAddr_BGM:Addr_BGM;
	
	//Sound

	wire BeatFinish_Sound,BReady_Sound;
	wire AddrCntRstn_Sound,AddrCntEn_Sound;
	wire BeatCntRstn_Sound,BeatCntEn_Sound;
	wire TunePWMRstn_Sound,TunePWMEn_Sound;
	wire BDMAstart_Sound,BDMARstn_Sound,BDMAAddrSel_Sound,fetch_Sound;
	wire PWM_Sound;
	wire[15:0] Buf_Sound;
	wire[31:0] BDMAAddr_Sound,Addr_Sound,NextAddr_Sound;
	wire[27:0] BeatCntParameter_Sound;
	wire[19:0] TunePWMParameter_Sound;

	reg[15:0] SoundReg_Sound;

	
	
    BuzzerCtr BuzzerCtr_Sound(
		.clk              (clk),
		.rst_n            (rst_n),
		.isPlaying        (SisPlaying),
		.BeatFinish       (BeatFinish_Sound),
		.BReady           (BReady_Sound),
		.stop             (1'b0),
		.Buf              (Buf_Sound),
		.AddrCntRstn      (AddrCntRstn_Sound),
		.AddrCntEn        (AddrCntEn_Sound),
		.BeatCntRstn      (BeatCntRstn_Sound),
		.BeatCntEn        (BeatCntEn_Sound),
		.TunePWMRstn      (TunePWMRstn_Sound),
		.TunePWMEn        (TunePWMEn_Sound),
		.BDMAstart        (BDMAstart_Sound),
		.BDMARstn         (BDMARstn_Sound),
		.BDMAAddrSel      (BDMAAddrSel_Sound),
		.fetch            (fetch_Sound),
		.ref              (ref_Sound)
    );

    BDMA BDMA_Sound(
		.clk              (clk),
		.rst_n            (BDMARstn_Sound&rst_n),
		.start            (BDMAstart_Sound),
		.fetch            (fetch_Sound),
		.Addr             (BDMAAddr_Sound),
		.HREADY           (SBDMA_HREADY),
		.HRDATA           (SBDMA_HRDATA),
		.BReady           (BReady_Sound),
		.HTRANS           (SBDMA_HTRANS),
		.Buf              (Buf_Sound),
		.HADDR            (SBDMA_HADDR)
    );

    AddrCnt AddrCnt_Sound(
		.clk              (clk),
		.rst_n            (AddrCntRstn_Sound&rst_n),
		.en               (AddrCntEn_Sound),
		.rstAddr          (SRstAddr),
		.Addr             (Addr_Sound),
		.NextAddr         (NextAddr_Sound)
    );

    BeatCnt BeatCnt_Sound(
		.clk              (clk),
		.rst_n            (BeatCntRstn_Sound&rst_n),
		.en               (BeatCntEn_Sound),
		.BeatCntParameter (BeatCntParameter_Sound),
		.BeatFinish       (BeatFinish_Sound)
    );

    BeatDecoder #(isSim) BeatDecoder_Sound(
		.beat             (SoundReg_Sound[11:8]),
		.bpm              (1'b0),
		.BeatCntParameter (BeatCntParameter_Sound)
    );

    TuneDecoder TuneDecoder_Sound(
		.tune             (SoundReg_Sound[7:0]),
		.TunePWMParameter (TunePWMParameter_Sound)
    );

    TunePWM TunePWM_Sound(
        .clk              (clk),
		.rst_n            (TunePWMRstn_Sound&rst_n),
		.en               (TunePWMEn_Sound),
		.PWMParameter     (TunePWMParameter_Sound),
		.loudness         (2'b11),
		.PWM              (PWM_Sound)
    );
	
	
	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			SoundReg_Sound <= 16'b0;
		end
		else if(fetch_Sound)begin
			SoundReg_Sound <= Buf_Sound;
		end
	end
	
	assign BDMAAddr_Sound = BDMAAddrSel_Sound?NextAddr_Sound:Addr_Sound;
	assign PWM = SisPlaying?PWM_Sound:PWM_BGM;

endmodule