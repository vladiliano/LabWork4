library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity kxx_rom is
port (
CLK : in STD_LOGIC;RST : in STD_LOGIC;
OE  : in STD_LOGIC;R : in STD_LOGIC;
X : in STD_LOGIC_VECTOR(3 downto 0);
Y : out STD_LOGIC_VECTOR(3 downto 0);
OV : out STD_LOGIC 
);
end kxx_rom;

architecture kxx_rom_arc of kxx_rom is
signal inp_data : STD_LOGIC_VECTOR(4 downto 0);
signal Y_buf : STD_LOGIC_VECTOR(3 downto 0);
type sbox is array (0 to 31) of STD_LOGIC_VECTOR(3 downto 0);
constant kxx : sbox := (x"4", x"b", x"2", x"e", x"f", x"0", x"8", x"d", --R=0;X:0-7
						x"3",x"c", x"9", x"7", x"5", x"a", x"6", x"1",--R=0;X:8-15
						x"5", x"f",x"2", x"8", x"0", x"c", x"e", x"b",--R=1;X:0-7
						x"6", x"a", x"d",x"1", x"9", x"7", x"3", x"4"--R=1;X:8-15
					);
begin
--implementation #1
--output signal Y acts like register to hold output value
inp_data<= R& X; --forming address to look upcell in ROM array
--buffer signal contains value found through ROM array by formed address
Y_buf<= kxx(conv_integer(inp_data)); 
outp_reg: process(CLK, RST)
begin
if CLK'event and CLK='1' then --specifies rising edge of CLK
OV<= '0';
if RST='1' then--if reset signal is active
Y<= (others=> '0');--reset register Yvalue to default
OV<= '0';
elsif OE='1' then--reset is not active and output enable signal is active
Y<= Y_buf;--register update withvalue from buffer
OV<= '1';
else--this part is executed most of time
null;--do nothing(register just holds its last value)
end if;
end if;
end process;

----ALTERNATIVE implementation
----to use it replace previous contents of architecture with code below
--Y<= Y_buf; 
--in this implementation signalY_bufacts like register
--inp_data <= R & X;--update_reg: process(CLK, RST)
--begin
--if CLK'event and CLK='1' then 
--only at rising edge of CLK
--OV<= '0';
--ifRST='1' then
--Y_buf<= (others=> '0'); 
--reset register value to default
--OV<= '0';
--elsifOE='1' then
--Y_buf<= kxx(conv_integer(inp_data)); 
--update register value from buffer
--OV<= '1';
--else
--null;
--do nothing (register just holds its last value)
--end if;
--end if;
--end process;

end kxx_rom_arc;