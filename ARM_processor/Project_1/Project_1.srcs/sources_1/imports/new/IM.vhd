-- Instruction memory with 2^N words.
-- Words of M bits
--Input is dictated by the PCreg
-- A[N-1:0] = PC[N+1:2]

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IM is
    generic (
        M : positive := 32; -- Word length
        N : positive := 6 -- 2^6 = 64 words
    );
    port (
        A   : in std_logic_vector (N - 1 downto 0); -- N bit address
        RD  : out std_logic_vector (M - 1 downto 0) -- Output data
        );
end IM;

architecture Dataflow of IM is
    
    type ROM_array is array (0 to 2**N-1) of std_logic_vector (M-1 downto 0); -- 64 words
    
    constant ROM : ROM_array := 
    (
        0  => X"E3A00014",
        1  => X"E1A01000",
        2  => X"E1A00000",
        3  => X"E5801002",
        4  => X"E5001002",
        5  => X"E5902002",
        6  => X"E5103002",
        7  => X"E2410013",
        8  => X"E281401E",
        9  => X"E0402001",
        10 => X"E0801003",
        11 => X"E0003001",
        12 => X"E201300F",
        13 => X"E0203001",
        14 => X"E221300F",
        15 => X"E1803001",
        16 => X"E381300F",
        17 => X"E1A03101",
        18 => X"E1A01123",
        19 => X"E1A01142",
        20 => X"E1A01163",
        21 => X"E3E00002",
        22 => X"E1E04003",
        23 => X"E352000F",
        24 => X"0A000010",
        25 => X"1B000000",
        26 => X"EAFFFFE4",
        27 => X"E2510001",
        28 => X"3A00000D",
        29 => X"2AFFFFFF",
        30 => X"E0520001",
        31 => X"5A00000B",
        32 => X"4AFFFFFF",
        33 => X"E2510015",
        34 => X"6A000009",
        35 => X"7AFFFFFF",
        36 => X"8A000008",
        37 => X"9AFFFFFF",
        38 => X"A281401E",
        39 => X"C281401E",
        40 => X"B281401E",
        41 => X"D1A0F00E",
        42 => X"E2510001",
        43 => X"E2510001",
        44 => X"E2510001",
        45 => X"E2510001",
        46 => X"E2510001",
        others => X"00000000"
    );
    begin

        RD <= ROM(to_integer(unsigned(A)));

end Dataflow;