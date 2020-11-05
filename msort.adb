with text_io;

package body msort is
    use text_io;
    package int_io is new Integer_IO(integer);
    use int_io;

    procedure merge_Sort(A: in out myArrayType; L: in Integer) is
        -- Variables
        curr_length : Integer := L; -- Array A size
        upper_array : myArrayType;
        lower_array : myArrayType;
        upper_size: Integer := curr_length / 2;  -- Upper array size, 5/2=2.5=2 rounds down
        lower_size: Integer := curr_length - upper_size; -- Lower array size

        -- Index for merging
        ptU : Integer := 1; -- Upper array index
        ptL : Integer := 1; -- Lower array index
        ptA : Integer := 1; -- A array index

        -- Specification
        task sort_upper is
            entry done_sorting;
        end sort_upper;

        task sort_lower is  
            entry done_sorting;
        end sort_lower;
        
        -- Body
        task body sort_upper is
        begin
            -- Copy upper half A to array
            for i in 1..upper_size loop
                upper_array(i) := A(i);
            end loop;

            -- Only recurse on array size > 1
            if upper_size > 1 then
                merge_Sort(upper_array, upper_size);
            end if;

            -- Allowing main to proceed merge
            accept done_sorting;
        end sort_upper;

        task body sort_lower is
        begin
            -- Copy lower half A to array
            for i in 1..lower_size loop
                lower_array(i) := A(upper_size+i); -- mid_index offset
            end loop;

            -- Only recurse on array size > 1
            if lower_size > 1 then
                merge_Sort(lower_array, lower_size);
            end if;

            -- Allowing main to proceed merge
            accept done_sorting;
        end sort_lower;
    begin
        -- Wait for upper/lower arrays to be sorted
        sort_lower.done_sorting;
        sort_upper.done_sorting;
        
        -- 2 Pointer merge
        while ptU <= upper_size and ptL <= lower_size loop
            if upper_array(ptU) <= lower_array(ptL) then
                A(ptA) := upper_array(ptU);
                ptA := ptA + 1;
                ptU := ptU + 1;
            elsif upper_array(ptU) > lower_array(ptL) then
                A(ptA) := lower_array(ptL);
                ptA := ptA + 1;
                ptL := ptL + 1;
            end if;
        end loop;

        for i in ptU..upper_size loop
            A(ptA) := upper_array(i);
            ptA := ptA + 1;
        end loop;

        for i in ptL..lower_size loop
            A(ptA) := lower_array(i);
            ptA := ptA + 1;
        end loop;
    end merge_Sort;

    -- Driver for merge_sort
    procedure Sort(A: in out myArrayType) is 
    begin
        merge_Sort(A, LENGTH);
    end Sort;

end msort;