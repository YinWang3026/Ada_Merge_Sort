package msort is 
    LENGTH: constant Integer := 40; -- Integer constant
    type myArrayType is Array (1..LENGTH) of Integer;  -- My type
    procedure Sort(A:in out myArrayType); -- Sort procedure
end msort;