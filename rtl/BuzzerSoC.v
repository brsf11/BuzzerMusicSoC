module BuzzerSoC(input  wire clk,
                 input  wire RSTn,
                 inout  wire SWDIO,  
                 input  wire SWCLK,
                 output wire PWM);
 
//------------------------------------------------------------------------------
// DEBUG IOBUF 
//------------------------------------------------------------------------------

    wire SWDO;
    wire SWDOEN;
    wire SWDI;

    assign SWDI = SWDIO;
    assign SWDIO = (SWDOEN) ?  SWDO : 1'bz;

//------------------------------------------------------------------------------
// Interrupt
//------------------------------------------------------------------------------

    wire [31:0] IRQ;
    assign IRQ = 32'b0;

    wire RXEV;
    assign RXEV = 1'b0;

//------------------------------------------------------------------------------
// AHB
//------------------------------------------------------------------------------

    wire [31:0] HADDR;
    wire [ 2:0] HBURST;
    wire        HMASTLOCK;
    wire [ 3:0] HPROT;
    wire [ 2:0] HSIZE;
    wire [ 1:0] HTRANS;
    wire [31:0] HWDATA;
    wire        HWRITE;
    wire [31:0] HRDATA;
    wire        HRESP;
    wire        HMASTER;
    wire        HREADY;

//------------------------------------------------------------------------------
// RESET AND DEBUG
//------------------------------------------------------------------------------

    wire SYSRESETREQ;
    reg cpuresetn;

    always @(posedge clk or negedge RSTn)begin
            if (~RSTn) cpuresetn <= 1'b0;
            else if (SYSRESETREQ) cpuresetn <= 1'b0;
            else cpuresetn <= 1'b1;
    end

    wire CDBGPWRUPREQ;
    reg CDBGPWRUPACK;

    always @(posedge clk or negedge RSTn)begin
            if (~RSTn) CDBGPWRUPACK <= 1'b0;
            else CDBGPWRUPACK <= CDBGPWRUPREQ;
    end


//------------------------------------------------------------------------------
// Instantiate Cortex-M0 processor logic level
//------------------------------------------------------------------------------

    cortexm0ds_logic u_logic (

        // System inputs
        .FCLK           (clk),           //FREE running clock 
        .SCLK           (clk),           //system clock
        .HCLK           (clk),           //AHB clock
        .DCLK           (clk),           //Debug clock
        .PORESETn       (RSTn),          //Power on reset
        .HRESETn        (cpuresetn),     //AHB and System reset
        .DBGRESETn      (RSTn),          //Debug Reset
        .RSTBYPASS      (1'b0),          //Reset bypass
        .SE             (1'b0),          // dummy scan enable port for synthesis

        // Power management inputs
        .SLEEPHOLDREQn  (1'b1),          // Sleep extension request from PMU
        .WICENREQ       (1'b0),          // WIC enable request from PMU
        .CDBGPWRUPACK   (CDBGPWRUPACK),  // Debug Power Up ACK from PMU

        // Power management outputs
        .CDBGPWRUPREQ   (CDBGPWRUPREQ),
        .SYSRESETREQ    (SYSRESETREQ),

        // System bus
        .HADDR          (HADDR[31:0]),
        .HTRANS         (HTRANS[1:0]),
        .HSIZE          (HSIZE[2:0]),
        .HBURST         (HBURST[2:0]),
        .HPROT          (HPROT[3:0]),
        .HMASTER        (HMASTER),
        .HMASTLOCK      (HMASTLOCK),
        .HWRITE         (HWRITE),
        .HWDATA         (HWDATA[31:0]),
        .HRDATA         (HRDATA[31:0]),
        .HREADY         (HREADY),
        .HRESP          (HRESP),

        // Interrupts
        .IRQ            (IRQ),          //Interrupt
        .NMI            (1'b0),         //Watch dog interrupt
        .IRQLATENCY     (8'h0),
        .ECOREVNUM      (28'h0),

        // Systick
        .STCLKEN        (1'b0),
        .STCALIB        (26'h0),

        // Debug - JTAG or Serial wire
        // Inputs
        .nTRST          (1'b1),
        .SWDITMS        (SWDI),
        .SWCLKTCK       (SWCLK),
        .TDI            (1'b0),
        // Outputs
        .SWDO           (SWDO),
        .SWDOEN         (SWDOEN),

        .DBGRESTART     (1'b0),

        // Event communication
        .RXEV           (RXEV),         // Generate event when a DMA operation completed.
        .EDBGRQ         (1'b0)          // multi-core synchronous halt request
    );

//------------------------------------------------------------------------------
// Instantiate BuzzerSoC AHB Bus Matrix
//------------------------------------------------------------------------------

    //BDMAC port
    wire[31:0] BDMAC_HRDATA;
    wire       BDMAC_HREADYOUT;
    wire[1:0]  BDMAC_HRESP;
    wire       BDMAC_HSEL;
    wire       BDMAC_HREADY;
    wire[31:0] BDMAC_HADDR;
    wire[1:0]  BDMAC_HTRANS;
    wire       BDMAC_HWRITE;
    wire[31:0] BDMAC_HWDATA;       

    //SBDMA Port
    wire[31:0] SBDMA_HADDR;
    wire[1:0]  SBDMA_HTRANS;
    wire       SBDMA_HWRITE;
    wire[31:0] SBDMA_HRDATA;
    wire       SBDMA_HREADY;

    //BBDMA Port
    wire[31:0] BBDMA_HADDR;
    wire[1:0]  BBDMA_HTRANS;
    wire       BBDMA_HWRITE;
    wire[31:0] BBDMA_HRDATA;
    wire       BBDMA_HREADY;

    //RAMCODE Port
    wire       RAMCODE_HSEL;
    wire[31:0] RAMCODE_HADDR;
    wire[1:0]  RAMCODE_HTRANS;
    wire[2:0]  RAMCODE_HSIZE;
    wire[3:0]  RAMCODE_HPROT;
    wire       RAMCODE_HWRITE;
    wire[31:0] RAMCODE_HWDATA;
    wire       RAMCODE_HREADY;
    wire       RAMCODE_HREADYOUT;
    wire[31:0] RAMCODE_HRDATA;
    wire[1:0]  RAMCODE_HRESP;

    //RAMDATA Port
    wire       RAMDATA_HSEL;
    wire[31:0] RAMDATA_HADDR;
    wire[1:0]  RAMDATA_HTRANS;
    wire[2:0]  RAMDATA_HSIZE;
    wire[3:0]  RAMDATA_HPROT;
    wire       RAMDATA_HWRITE;
    wire[31:0] RAMDATA_HWDATA;
    wire       RAMDATA_HREADY;
    wire       RAMDATA_HREADYOUT;
    wire[31:0] RAMDATA_HRDATA;
    wire[1:0]  RAMDATA_HRESP;

    BuzzerSoCBusMtx BuzzerSoCBusMtx(
        //General Signals
        .HCLK           (clk),
        .HRESETn        (cpuresetn),
        .REMAP          (4'b0),

        //Master0 Signals Cortex-M0
        .HSELS0                             (1'b1),
        .HADDRS0                            (HADDR),
        .HTRANSS0                           (HTRANS),
        .HWRITES0                           (HWRITE),
        .HSIZES0                            (HSIZE),
        .HBURSTS0                           (HBURST),
        .HPROTS0                            (HPROT),
        .HMASTERS0                          (4'b0000),
        .HWDATAS0                           (HWDATA),
        .HMASTLOCKS0                        (HMASTLOCK),
        .HREADYS0                           (HREADY),
        .HAUSERS0                           (32'b0),
        .HWUSERS0                           (32'b0),
        .HRDATAS0                           (HRDATA),
        .HREADYOUTS0                        (HREADY),
        .HRESPS0                            (HRESP),
        .HRUSERS0                           (),

        //Master1 Signals SBDMA
        .HSELS1                             (1'b1),
        .HADDRS1                            (SBDMA_HADDR),
        .HTRANSS1                           (SBDMA_HTRANS),
        .HWRITES1                           (1'b0),
        .HSIZES1                            (3'b001),
        .HBURSTS1                           (3'b000),
        .HPROTS1                            (4'b0000),
        .HMASTERS1                          (4'b0000),
        .HWDATAS1                           (32'b0),
        .HMASTLOCKS1                        (1'b0),
        .HREADYS1                           (SBDMA_HREADY),
        .HAUSERS1                           (32'b0),
        .HWUSERS1                           (32'b0),
        .HREADYOUTS1                        (SBDMA_HREADY),
        .HRESPS1                            (),
        .HRUSERS1                           (),
        .HRDATAS1                           (SBDMA_HRDATA),

        //Master2 Signals BBDMA
        .HSELS2                             (1'b1),
        .HADDRS2                            (BBDMA_HADDR),
        .HTRANSS2                           (BBDMA_HTRANS),
        .HWRITES2                           (1'b0),
        .HSIZES2                            (3'b001),
        .HBURSTS2                           (3'b000),
        .HPROTS2                            (4'b0000),
        .HMASTERS2                          (4'b0000),
        .HWDATAS2                           (32'b0),
        .HMASTLOCKS2                        (1'b0),
        .HREADYS2                           (BBDMA_HREADY),
        .HAUSERS2                           (32'b0),
        .HWUSERS2                           (32'b0),
        .HREADYOUTS2                        (BBDMA_HREADY),
        .HRESPS2                            (),
        .HRUSERS2                           (),
        .HRDATAS2                           (BBDMA_HRDATA),

        //Slave0 Signals RAMCODE
        .HSELM0                             (RAMCODE_HSEL),
        .HADDRM0                            (RAMCODE_HADDR),
        .HTRANSM0                           (RAMCODE_HTRANS),
        .HWRITEM0                           (RAMCODE_HWRITE),
        .HSIZEM0                            (RAMCODE_HSIZE),
        .HBURSTM0                           (),
        .HPROTM0                            (RAMCODE_HPROT),
        .HMASTERM0                          (),
        .HWDATAM0                           (RAMCODE_HWDATA),
        .HMASTLOCKM0                        (),
        .HREADYMUXM0                        (RAMCODE_HREADY),
        .HAUSERM0                           (),
        .HWUSERM0                           (),
        .HRDATAM0                           (RAMCODE_HRDATA),
        .HREADYOUTM0                        (RAMCODE_HREADYOUT),
        .HRESPM0                            (RAMCODE_HRESP),
        .HRUSERM0                           (32'b0),

        //Slave1 Signals RAMDATA
        .HSELM1                             (RAMDATA_HSEL),
        .HADDRM1                            (RAMDATA_HADDR),
        .HTRANSM1                           (RAMDATA_HTRANS),
        .HWRITEM1                           (RAMDATA_HWRITE),
        .HSIZEM1                            (RAMDATA_HSIZE),
        .HBURSTM1                           (),
        .HPROTM1                            (RAMDATA_HPROT),
        .HMASTERM1                          (),
        .HWDATAM1                           (RAMDATA_HWDATA),
        .HMASTLOCKM1                        (),
        .HREADYMUXM1                        (RAMDATA_HREADY),
        .HAUSERM1                           (),
        .HWUSERM1                           (),
        .HRDATAM1                           (RAMDATA_HRDATA),
        .HREADYOUTM1                        (RAMDATA_HREADYOUT),
        .HRESPM1                            (RAMDATA_HRESP),
        .HRUSERM1                           (32'b0),

        //Slave2 Signals BDMAC
        .HSELM2                             (BDMAC_HSEL),
        .HADDRM2                            (BDMAC_HADDR),
        .HTRANSM2                           (BDMAC_HTRANS),
        .HWRITEM2                           (BDMAC_HWRITE),
        .HSIZEM2                            (),
        .HBURSTM2                           (),
        .HPROTM2                            (),
        .HMASTERM2                          (),
        .HWDATAM2                           (BDMAC_HWDATA),
        .HMASTLOCKM2                        (),
        .HREADYMUXM2                        (BDMAC_HREADY),
        .HAUSERM2                           (),
        .HWUSERM2                           (),
        .HRDATAM2                           (BDMAC_HRDATA),
        .HREADYOUTM2                        (BDMAC_HREADYOUT),
        .HRESPM2                            (BDMAC_HRESP),
        .HRUSERM2                           (32'b0),

        //Scan chain
        .SCANENABLE                         (1'b0),
        .SCANINHCLK                         (1'b0),
        .SCANOUTHCLK                        ()
    );

//------------------------------------------------------------------------------
// Instantiate Buzzer
//------------------------------------------------------------------------------

    Buzzer #(.isSim(0)) Buzzer(
        //General Signals
        .clk             (clk),
        .rst_n           (cpuresetn),
        
        //BDMAC Master Port
        .BDMAC_RDATA    (BDMAC_HRDATA),
        .BDMAC_READYOUT (BDMAC_HREADYOUT),
        .BDMAC_RESP     (BDMAC_HRESP),
        .BDMAC_SEL      (BDMAC_HSEL),
        .BDMAC_READY    (BDMAC_HREADY),
        .BDMAC_ADDR     (BDMAC_HADDR),
        .BDMAC_TRANS    (BDMAC_HTRANS),
        .BDMAC_WRITE    (BDMAC_HWRITE),
        .BDMAC_WDATA    (BDMAC_HWDATA),

        //SBDMA Slave Port
        .SBDMA_HADDR     (SBDMA_HADDR),
        .SBDMA_HTRANS    (SBDMA_HTRANS),
        .SBDMA_HWRITE    (SBDMA_HWRITE),
        .SBDMA_HRDATA    (SBDMA_HRDATA),
        .SBDMA_HREADY    (SBDMA_HREADY),

        //BBDMA Slave Port
        .BBDMA_HADDR     (BBDMA_HADDR),
        .BBDMA_HTRANS    (BBDMA_HTRANS),
        .BBDMA_HWRITE    (BBDMA_HWRITE),
        .BBDMA_HRDATA    (BBDMA_HRDATA),
        .BBDMA_HREADY    (BBDMA_HREADY),

        //PWM
        .PWM(PWM)
    );

//------------------------------------------------------------------------------
// AHB RAMCODE
//------------------------------------------------------------------------------

wire [31:0] RAMCODE_RDATA,RAMCODE_WDATA;
wire [13:0] RAMCODE_WADDR;
wire [13:0] RAMCODE_RADDR;
wire [3:0]  RAMCODE_WRITE;

AHBlite_Block_RAM RAMCODE_Interface(
        /* Connect to Interconnect Port 0 */
        .HCLK           (clk),
        .HRESETn        (cpuresetn),
        .HSEL           (RAMCODE_HSEL),
        .HADDR          (RAMCODE_HADDR),
        .HPROT          (RAMCODE_HPROT),
        .HSIZE          (RAMCODE_HSIZE),
        .HTRANS         (RAMCODE_HTRANS),
        .HWDATA         (RAMCODE_HWDATA),
        .HWRITE         (RAMCODE_HWRITE),
        .HRDATA         (RAMCODE_HRDATA),
        .HREADY         (RAMCODE_HREADY),
        .HREADYOUT      (RAMCODE_HREADYOUT),
        .HRESP          (RAMCODE_HRESP),
        .BRAM_WRADDR    (RAMCODE_WADDR),
        .BRAM_RDADDR    (RAMCODE_RADDR),
        .BRAM_RDATA     (RAMCODE_RDATA),
        .BRAM_WDATA     (RAMCODE_WDATA),
        .BRAM_WRITE     (RAMCODE_WRITE)
        /**********************************/
);

//------------------------------------------------------------------------------
// AHB RAMDATA
//------------------------------------------------------------------------------

wire [31:0] RAMDATA_RDATA;
wire [31:0] RAMDATA_WDATA;
wire [13:0] RAMDATA_WADDR;
wire [13:0] RAMDATA_RADDR;
wire [3:0]  RAMDATA_WRITE;

AHBlite_Block_RAM RAMDATA_Interface(
        /* Connect to Interconnect Port 1 */
        .HCLK           (clk),
        .HRESETn        (cpuresetn),
        .HSEL           (RAMDATA_HSEL),
        .HADDR          (RAMDATA_HADDR),
        .HPROT          (RAMDATA_HPROT),
        .HSIZE          (RAMDATA_HSIZE),
        .HTRANS         (RAMDATA_HTRANS),
        .HWDATA         (RAMDATA_HWDATA),
        .HWRITE         (RAMDATA_HWRITE),
        .HRDATA         (RAMDATA_HRDATA),
        .HREADY         (RAMDATA_HREADY),
        .HREADYOUT      (RAMDATA_HREADYOUT),
        .HRESP          (RAMDATA_HRESP),
        .BRAM_WRADDR    (RAMDATA_WADDR),
        .BRAM_RDADDR    (RAMDATA_RADDR),
        .BRAM_WDATA     (RAMDATA_WDATA),
        .BRAM_RDATA     (RAMDATA_RDATA),
        .BRAM_WRITE     (RAMDATA_WRITE)
        /**********************************/
);

//------------------------------------------------------------------------------
// RAM
//------------------------------------------------------------------------------

Block_RAM RAM_CODE(
        .clka           (clk),
        .addra          (RAMCODE_WADDR),
        .addrb          (RAMCODE_RADDR),
        .dina           (RAMCODE_WDATA),
        .doutb          (RAMCODE_RDATA),
        .wea            (RAMCODE_WRITE)
);

Block_RAM RAM_DATA(
        .clka           (clk),
        .addra          (RAMDATA_WADDR),
        .addrb          (RAMDATA_RADDR),
        .dina           (RAMDATA_WDATA),
        .doutb          (RAMDATA_RDATA),
        .wea            (RAMDATA_WRITE)
);



endmodule