library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity zad3 is
	port(
		clk 		: in std_logic;
		rst 		: in std_logic;

		--zad1
		RT1 		: out std_logic;
		RDY1 		: out std_logic;
		START1 		: out std_logic;
		ENDD1		: out std_logic;

		--zad2
		ER2			: out std_logic;

		--zad3
		ER3			: out std_logic;
		RDY3 		: out std_logic;

		--zad4
		RDY4 		: out std_logic;
		START4 		: out std_logic;

		--zad5
		ENDD5 		: out std_logic;
		STOP5 		: out std_logic;
		ER5 		: out std_logic;
		RDY5		: out std_logic;
		START5 		: out std_logic;

		--zad6
		ENDD6 		: out std_logic;
		STOP6 		: out std_logic;
		ER6 		: out std_logic;
		RDY6		: out std_logic;

		--zad7
		ENDD7 			: out std_logic;
		START7 			: out std_logic;
		STATUS_VALID7 	: out std_logic;
		INSTARTSV7		: out std_logic;

		--zad8
		RT8			: out std_logic;
		ENABLE8 	: out std_logic;

		--zad9
		RDY9		: out std_logic;
		START9 		: out std_logic;
		INTERUPT9	: out std_logic;

		--zad10
		ACK10 		: out std_logic;
		REQ10 		: out std_logic
	    );
end entity zad3;

architecture rtl of zad3 is

	signal cnt : unsigned(7 downto 0);

begin

	process(clk, rst)
	begin
		if (rst = '1') then
			cnt <= X"00";
		elsif rising_edge(clk) then
			cnt <= cnt + X"01";
		end if;
	end process;

	--zad1
	with cnt select
		RT1 <= '1' when X"00"|X"01"|X"02"|X"03"|X"08",
		'0' when others;

	with cnt select
		RDY1 <= '1' when X"05",
		'0' when others;

	with cnt select
		START1 <= '1' when X"08",
		'0' when others;

	with cnt select
		ENDD1 <= '1' when X"06",
		'0' when others;

	--zad2
	with cnt select
		ER2 <= '1' when X"01"|X"02"|X"06"|X"07"|X"08"|X"09", --???
		'0' when others;

	--zad3
	with cnt select
		ER3 <= '1' when X"01"|X"05"|X"06"|X"09",
		'0' when others;

	with cnt select
		RDY3 <= '1' when X"01"|X"02"|X"05"|X"09",
		'0' when others;

	--zad4
	with cnt select
		RDY4 <= '1' when X"06",
		'0' when others;

	with cnt select
		START4 <= '1' when X"02",
		'0' when others;

	--zad5
	with cnt select
		ENDD5 <= '1' when X"02",
		'0' when others;

	STOP5 <= '0';

	with cnt select
		ER5 <= '1' when X"0A",
		'0' when others;

	with cnt select
		RDY5 <= '1' when X"01"|X"02"|X"08"|X"09"|X"0A",
		'0' when others;

	with cnt select
		START5 <= '1' when X"08",
		'0' when others;

	--zad6
	with cnt select
		ENDD6 <= '1' when X"02",
		'0' when others;

	with cnt select
		STOP6 <= '1' when X"05",
		'0' when others;

	with cnt select
		ER6 <= '1' when X"0A",
		'0' when others;

	with cnt select
		RDY6 <= '1' when X"01"|X"02"|X"04"|X"05"|X"06"|X"09"|X"0A",
		'0' when others;

	--zad7
	with cnt select
		ENDD7 <= '1' when X"03",
		'0' when others;

	with cnt select
		START7 <= '1' when X"05",
		'0' when others;

	with cnt select
		STATUS_VALID7 <= '1' when X"0A",
		'0' when others;

	with cnt select
		INSTARTSV7 <= '1' when X"03"|X"04"|X"05"|X"06"|X"07",
		'0' when others;

	--zad8
	with cnt select
		RT8 <= '1' when X"00"|X"01"|X"02",
		'0' when others;

	with cnt select
		ENABLE8 <= '1' when X"07",
		'0' when others;	

	--zad9
	with cnt select
		RDY9 <= '1' when X"02"|X"03"|X"04"|X"05"|X"06"|X"07",
		'0' when others;

	with cnt select
		START9 <= '1' when X"05"|X"06"|X"07",
		'0' when others;

	with cnt select
		INTERUPT9 <= '1' when X"07",
		'0' when others;

	--zad10
	with cnt select
		ACK10 <= '1' when X"06",
		'0' when others;

	with cnt select
		REQ10 <= '1' when X"01",
		'0' when others;
	
end architecture rtl;
