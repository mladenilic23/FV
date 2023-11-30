library ieee;use 
ieee.std_logic_1164.all;

entity zad2 is    
	port(        	
		clk   : in  std_logic;    -- Clock   
		rst   : in  std_logic;    -- Synchronous reset
		a     : in  std_logic;        
		b     : in  std_logic;        
		c     : in  std_logic;        
		d     : in  std_logic;        
		e     : in  std_logic;        
		f     : in  std_logic;
		g     : in  std_logic;        
		h     : in  std_logic;
		o1    : out std_logic;       
		o2    : out std_logic);
end entity zad2;

architecture Behavioral of zad2 is  

	signal sel             : std_logic_vector(3 downto 0);    
	signal o1_reg, o1_next : std_logic;
	signal o2_reg, o2_next : std_logic;    
	signal dec1_s, dec2_s  : std_logic_vector(3 downto 0);

begin 

	sel <= d & c & b & a;

	reg_p : process(clk, rst) is   
	begin        
		if (rst = '1') then            
			o1_reg <= '0';
			o2_reg <= '0';             
		elsif rising_edge(clk) then            
			o1_reg <= o1_next;
			o2_reg <= o2_next;                 
		end if;    
	end process reg_p;    
	
	o1 <= o1_reg;
	o2 <= o2_reg;

	o2_next <= ((((not a) and (not b) and (not c) and (not e) and (not f)) or
		     	 ((a)     and (not b) and (not c) and (e)     and (not f)) or
		     	 ((not a) and (b)     and (not c) and (not e) and (f))     or
		     	 ((a)     and (b)     and (not c) and (e)     and (f))     or
				 ((not a) and (not b) and (c)     and (not g) and (not h)) or
		     	 ((a)     and (not b) and (c)     and (g)     and (not h)) or
		     	 ((not a) and (b)     and (c)     and (not g) and (h))     or
		     	 ((a)     and (b)     and (c)     and (g)     and (h))) and (not d)) or d;

	o1_next_p : process (sel, dec1_s, dec2_s) is
	begin
		case sel is
			when "0000" => o1_next <= dec1_s(0);
			when "0001" => o1_next <= dec1_s(1);
			when "0010" => o1_next <= dec1_s(2);
			when "0011" => o1_next <= dec1_s(3);

			when "0100" => o1_next <= dec2_s(0);
			when "0101" => o1_next <= dec2_s(1);
			when "0110" => o1_next <= dec2_s(2);
			when "0111" => o1_next <= dec2_s(3);

			when others => o1_next <= '1';
		end case;
	end process o1_next_p;

	dec1 : process (e, f, dec1_s) is
		variable dec1_in : std_logic_vector(1 downto 0);
	begin

		dec1_in := f & e;
		
		case dec1_in is
			when "00" => dec1_s <= "0001";
			when "01" => dec1_s <= "0010";
			when "10" => dec1_s <= "0100";
			when "11" => dec1_s <= "1000";

			when others => dec1_s <= "0000";
		end case;
	end process dec1;

	dec2 : process (g, h, dec2_s) is
		variable dec2_in : std_logic_vector(1 downto 0);
	begin

		dec2_in := h & g;
		
		case dec2_in is
			when "00" => dec2_s <= "0001";
			when "01" => dec2_s <= "0010";
			when "10" => dec2_s <= "0100";
			when "11" => dec2_s <= "1000";	

			when others => dec2_s <= "0000";
		end case;
	end process dec2;

end architecture Behavioral;
