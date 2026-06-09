library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADC_Controller_v1_0 is
    generic (
        -- Parameters of Axi Slave Bus Interface S00_AXI
        C_S00_AXI_DATA_WIDTH : integer := 32;
        C_S00_AXI_ADDR_WIDTH : integer := 4
    );
    port (
        -- User ports
    D1_in   : in  std_logic;
    rst_adc : in  std_logic;
    clk_in  : in  std_logic;
    clk_out : out std_logic;
    CS      : out std_logic;

DRDY_out    : out std_logic;
D1_out_ext  : out std_logic_vector(11 downto 0);
        -- Ports of Axi Slave Bus Interface S00_AXI
        s00_axi_aclk    : in  std_logic;
        s00_axi_aresetn : in  std_logic;
        s00_axi_awaddr  : in  std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        s00_axi_awprot  : in  std_logic_vector(2 downto 0);
        s00_axi_awvalid : in  std_logic;
        s00_axi_awready : out std_logic;
        s00_axi_wdata   : in  std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        s00_axi_wstrb   : in  std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
        s00_axi_wvalid  : in  std_logic;
        s00_axi_wready  : out std_logic;
        s00_axi_bresp   : out std_logic_vector(1 downto 0);
        s00_axi_bvalid  : out std_logic;
        s00_axi_bready  : in  std_logic;
        s00_axi_araddr  : in  std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        s00_axi_arprot  : in  std_logic_vector(2 downto 0);
        s00_axi_arvalid : in  std_logic;
        s00_axi_arready : out std_logic;
        s00_axi_rdata   : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        s00_axi_rresp   : out std_logic_vector(1 downto 0);
        s00_axi_rvalid  : out std_logic;
        s00_axi_rready  : in  std_logic
    );
end ADC_Controller_v1_0;

architecture arch_imp of ADC_Controller_v1_0 is

    component ADC_Controller_v1_0_S00_AXI is
        generic (
            C_S_AXI_DATA_WIDTH : integer := 32;
            C_S_AXI_ADDR_WIDTH : integer := 4
        );
        port (
            val_reg0 : in  std_logic_vector(11 downto 0);
            val_reg1 : in  std_logic;
            ctrl_start : out std_logic;
            S_AXI_ACLK    : in  std_logic;
            S_AXI_ARESETN : in  std_logic;
            S_AXI_AWADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            S_AXI_AWPROT  : in  std_logic_vector(2 downto 0);
            S_AXI_AWVALID : in  std_logic;
            S_AXI_AWREADY : out std_logic;
            S_AXI_WDATA   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S_AXI_WSTRB   : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
            S_AXI_WVALID  : in  std_logic;
            S_AXI_WREADY  : out std_logic;
            S_AXI_BRESP   : out std_logic_vector(1 downto 0);
            S_AXI_BVALID  : out std_logic;
            S_AXI_BREADY  : in  std_logic;
            S_AXI_ARADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            S_AXI_ARPROT  : in  std_logic_vector(2 downto 0);
            S_AXI_ARVALID : in  std_logic;
            S_AXI_ARREADY : out std_logic;
            S_AXI_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S_AXI_RRESP   : out std_logic_vector(1 downto 0);
            S_AXI_RVALID  : out std_logic;
            S_AXI_RREADY  : in  std_logic
        );
    end component;

component ADC is
    Port (
        D1_in     : in  STD_LOGIC;
        START     : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        clk_in    : in  STD_LOGIC;
        DRDY      : out STD_LOGIC;
        D1_out    : out STD_LOGIC_VECTOR (11 downto 0);
        clk_out   : out STD_LOGIC;
        CS        : out STD_LOGIC
    );
end component;

signal data_adc_int : std_logic_vector(11 downto 0);
signal drdy_adc_int : std_logic;
signal start_adc_int : std_logic;

begin

    -- Instantiation of Axi Bus Interface S00_AXI
    ADC_Controller_v1_0_S00_AXI_inst : ADC_Controller_v1_0_S00_AXI
        generic map (
            C_S_AXI_DATA_WIDTH => C_S00_AXI_DATA_WIDTH,
            C_S_AXI_ADDR_WIDTH => C_S00_AXI_ADDR_WIDTH
        )
        port map (
            val_reg0 => data_adc_int,
            val_reg1 => drdy_adc_int,
            ctrl_start => start_adc_int,
            S_AXI_ACLK    => s00_axi_aclk,
            S_AXI_ARESETN => s00_axi_aresetn,
            S_AXI_AWADDR  => s00_axi_awaddr,
            S_AXI_AWPROT  => s00_axi_awprot,
            S_AXI_AWVALID => s00_axi_awvalid,
            S_AXI_AWREADY => s00_axi_awready,
            S_AXI_WDATA   => s00_axi_wdata,
            S_AXI_WSTRB   => s00_axi_wstrb,
            S_AXI_WVALID  => s00_axi_wvalid,
            S_AXI_WREADY  => s00_axi_wready,
            S_AXI_BRESP   => s00_axi_bresp,
            S_AXI_BVALID  => s00_axi_bvalid,
            S_AXI_BREADY  => s00_axi_bready,
            S_AXI_ARADDR  => s00_axi_araddr,
            S_AXI_ARPROT  => s00_axi_arprot,
            S_AXI_ARVALID => s00_axi_arvalid,
            S_AXI_ARREADY => s00_axi_arready,
            S_AXI_RDATA   => s00_axi_rdata,
            S_AXI_RRESP   => s00_axi_rresp,
            S_AXI_RVALID  => s00_axi_rvalid,
            S_AXI_RREADY  => s00_axi_rready
        );
ADC_inst : ADC
    port map (
        D1_in   => D1_in,
        START   => start_adc_int,
        rst     => rst_adc,
        clk_in  => clk_in,
        DRDY    => drdy_adc_int,
        D1_out  => data_adc_int,
        clk_out => clk_out,
        CS      => CS
    );
    
    DRDY_out   <= drdy_adc_int;
    D1_out_ext <= data_adc_int;
end arch_imp;