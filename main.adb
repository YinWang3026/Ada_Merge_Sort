with text_io;
with msort;

procedure main is
    use text_io;
    package int_io is new Integer_IO(integer);
    use int_io;
    use msort;

    cur_length: Integer:= 0; -- 1 based indexing, should equal LENGTH
    print_width: Integer:= 8; -- Print format
    input_array: myArrayType; -- Array of size LENGTH

    -- Read in LENGTH integers and write them to an array
    task reader is
        entry done_reading;
    end;

    -- Compute the sum of the array
    task sum is
        entry start_summing;
    end sum; 

    -- Print the elements in the array and the sum of the array
    task printer is
        entry print_integer(x:in Integer);
        entry start_printing;
    end printer;

    task body reader is
        currItem: Integer;
    begin
        -- While not end of file, read integers one by one
        while (not End_Of_File) loop
            get(currItem);
            cur_length := cur_length + 1;
            if cur_length > LENGTH then -- LENGTH checking
                exit;
            end if;
            input_array(cur_length) := currItem;
        end loop;
        
        if cur_length /= LENGTH then -- LENGTH checking
            put("input.txt size does not match LENGTH.");
            new_line;
        end if;

        -- Telling main procedure ready
        accept done_reading;
    end reader;

    task body sum is
        s: Integer := 0;
    begin
        -- Waiting for the start signal
        accept start_summing;
        
        -- Sum the array
        for i in 1..LENGTH loop
            s := s + input_array(i);
        end loop;

        -- Telling printer sum is ready
        printer.print_integer(s);
    end sum;
    
    task body printer is
    begin
        -- Waiting for the start signal
        accept start_printing;
        
        -- Print the array
        put("The sorted array is:");
        for i in 1..LENGTH loop
            put(input_array(i),print_width);
        end loop;
        new_line;
        
        -- Print the sum
        accept print_integer(x:in Integer) do
            put("The sum is:");
            put(x,print_width);
            new_line;
        end print_integer;
    end printer;

begin
    reader.done_reading; -- Wait for read to finish
    Sort(input_array); -- merge_sort the input_array
    sum.start_summing; -- Telling sum to start
    printer.start_printing; -- Telling print to start

end main;