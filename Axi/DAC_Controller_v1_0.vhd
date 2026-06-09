library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DAC_Controller_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4
	);
	port (
		-- Users to add ports here
        D1      : out STD_LOGIC;
        CLK_OUT : out STD_LOGIC;
        nSYNC   : out STD_LOGIC;
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end DAC_Controller_v1_0;

architecture arch_imp of DAC_Controller_v1_0 is

	-- component declaration
	component DAC_Controller_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
		val_reg0 : out std_logic_vector(31 downto 0);
        val_reg1: out std_logic_vector(31 downto 0);
        val_reg2: out std_logic_vector (31 downto 0);
        val_reg3 : out std_logic_vector(31 downto 0);
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component DAC_Controller_v1_0_S00_AXI;
	
		component DAC is
	  generic (
		SHIFT_ANCHO : integer := 4;
		N_BITS_D    : integer := 12;
		N_BITS_SPI  : integer := 16;
		N_BITS_DIV  : integer := 16;
		VAL_DIV     : integer := 4;
		ADDR_WIDTH  : integer := 14
	  );
	  port (
		clk50     : in  std_logic;
		nRST      : in  std_logic;
		wr_en     : in  std_logic;
		addr_wr   : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
		data_in   : in  std_logic_vector(N_BITS_D-1 downto 0);
		START_Reg : in  std_logic;
		D1        : out std_logic;
		CLK_OUT   : out std_logic;
		nSYNC     : out std_logic
	  );
	end component;
	
	component Direcciones is
    Port ( wr_en : out STD_LOGIC;
           data_in : out STD_LOGIC_VECTOR (11 downto 0);
           addr_wr : out STD_LOGIC_VECTOR (13 downto 0);
           START_Reg : out STD_LOGIC;
           val_reg0 : in std_logic_vector (31 downto 0);
           val_reg1: in std_logic_vector(31 downto 0);
           val_reg2: in std_logic_vector (31 downto 0);
           val_reg3 : in std_logic_vector(31 downto 0));
    end component Direcciones;

    signal reg0 : std_logic_vector (31 downto 0);
    signal reg1 : std_logic_vector (31 downto 0);
    signal reg2 : std_logic_vector (31 downto 0);
    signal reg3 : std_logic_vector (31 downto 0);

    signal wr_en1     : std_logic;
    signal data_in1   : std_logic_vector(11 downto 0);
    signal addr_wr1   : std_logic_vector(13 downto 0);
    signal START_Reg1 : std_logic;
begin

-- Instantiation of Axi Bus Interface S00_AXI
DAC_Controller_v1_0_S00_AXI_inst : DAC_Controller_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
	    val_reg0 => reg0, 
	    val_reg1 => reg1,
	    val_reg2 => reg2,
	    val_reg3 => reg3,
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here
Direcciones_out: Direcciones port map ( val_reg0 => reg0, val_reg1 => reg1, val_reg2 => reg2, val_reg3 => reg3
        ,wr_en => wr_en1, data_in=> data_in1, addr_wr=> addr_wr1,START_Reg=> START_Reg1);
       
        DAC_inst : DAC generic map (
        SHIFT_ANCHO => 4,
        N_BITS_D    => 12,
        N_BITS_SPI  => 16,
        N_BITS_DIV  => 16,
        VAL_DIV     => 8,
        ADDR_WIDTH  => 14
    )
    port map (
        clk50     => s00_axi_aclk,
        nRST      => s00_axi_aresetn,
        wr_en     => reg0(0),
        addr_wr   => reg2( 13 downto 0),
        data_in   => reg1( 11 downto 0),
        START_Reg => reg3(0),
        D1        => D1,
        CLK_OUT   => CLK_OUT,
        nSYNC     => nSYNC
    );
	-- User logic ends

end arch_imp;