module main(
    input wire clk, 
    input wire right_toggle, 
    input wire up_toggle, 
    input wire down_toggle,
    output reg [6:0] hex5, 
    output reg [6:0] hex4, 
    output reg [6:0] hex3, 
    output reg [6:0] hex2, 
    output reg [6:0] hex1, 
    output reg [6:0] hex0, 
    output reg [1:0] test_leds
); 



wire [6:0] zero = 7'b1000000; 
wire [6:0] one = 7'b1111001; 
wire [6:0] two = 7'b0100100; 
wire [6:0] three = 7'b0110000; 
wire [6:0] four = 7'b0011001; 
wire [6:0] five = 7'b0010010; 
wire [6:0] six = 7'b0000010; 
wire [6:0] seven = 7'b1111000; 
wire [6:0] eight = 7'b0000000; 
wire [6:0] nine = 7'b0010000;
wire [6:0] equal = 7'b0110111; 
wire [6:0] off = 7'b1111111; 
wire [6:0] error = 7'b0000110;

reg [26:0] accum = 0;
reg blink_trigger = 0; 

reg [1:0] left_right_setting = 2'b0; 

wire [6:0] minus = 7'b0111111; 
wire [6:0] plus = 7'b0001100; 


// Side scroll code 
always @ (negedge right_toggle) begin
    if (!right_toggle) begin // if key0 gets pushed 
        left_right_setting <= left_right_setting + 1; 
    end 
end 

// blinking code 
always @ (posedge clk) begin 
    accum <= accum + 1; 
    if (accum > 25000000) begin 
        blink_trigger <= 1; // turns on 
    end 
    else if (accum < 25000000) begin // turns off 
        blink_trigger <= 0; 
    end 
end 

reg [7:0] incr_val1_hex5; 
reg [7:0] incr_val1_hex4; 
reg [7:0] incr_val1_hex3; 

reg [7:0] decr_val2_hex5;
reg [7:0] decr_val2_hex4;
reg [7:0] decr_val2_hex3;

// increment value 1
always @ (negedge up_toggle) begin 
    case (left_right_setting) 
        1: incr_val1_hex5 <= incr_val1_hex5 + 1; 
        2: incr_val1_hex4 <= incr_val1_hex4 + 1; 
        3: incr_val1_hex3 <= incr_val1_hex3 + 1; 
    endcase   
end 

// decrement value 2
always @ (negedge down_toggle) begin 
    case (left_right_setting)
        1: decr_val2_hex5 <= decr_val2_hex5 + 1; 
        2: decr_val2_hex4 <= decr_val2_hex4 + 1; 
        3: decr_val2_hex3 <= decr_val2_hex3 + 1; 
    endcase 
end 

reg [3:0] output_hex5; 
reg output_hex4; 
reg [3:0] output_hex3; 

always @ (posedge clk) begin 
    hex2 <= 7'b0110111; // equal sign 
    if (left_right_setting == 2'b01) begin 
        output_hex5 = incr_val1_hex5 - decr_val2_hex5; 
        if (blink_trigger == 1) begin 
            case (output_hex5)
                0: hex5 <= zero; 
                1: hex5 <= one; 
                2: hex5 <= two; 
                3: hex5 <= three; 
                4: hex5 <= four; 
                5: hex5 <= five; 
                6: hex5 <= six; 
                7: hex5 <= seven; 
                8: hex5 <= eight; 
                9: hex5 <= nine;
                default: hex5 <= error; 
            endcase 
        end 

        else if (blink_trigger == 0) begin 
            hex5 <= off; 
        end 
    end 

    if (left_right_setting == 2'b10) begin 
        output_hex4 = incr_val1_hex4 - decr_val2_hex4; 
        if (blink_trigger == 1) begin 
            case (output_hex4)
                0: hex4 <= plus; 
                1: hex4 <= minus; 
            endcase 
        end 
        else if (blink_trigger == 0) begin 
            hex4 <= off; 
        end 
    end 

    if (left_right_setting == 2'b11) begin 
        output_hex3 = incr_val1_hex3 - decr_val2_hex3; 
        if (blink_trigger == 1) begin 
            case (output_hex3)
                0: hex3 <= zero; 
                1: hex3 <= one; 
                2: hex3 <= two; 
                3: hex3 <= three; 
                4: hex3 <= four; 
                5: hex3 <= five; 
                6: hex3 <= six; 
                7: hex3 <= seven; 
                8: hex3 <= eight; 
                9: hex3 <= nine; 
                default: hex3 <= error; 
            endcase 
        end 
        else if (blink_trigger == 0) begin 
            hex3 <= off; 
        end 
    end 
end 

reg [6:0] output_calc_plus; 
reg [6:0] output_calc_minus; 
reg [6:0] output_calc_neg; 

always @ (posedge clk) begin 
    // Plus calculation 
    if (output_hex4 == 0) begin 
        output_calc_plus <= output_hex5 + output_hex3; 
        case (output_calc_plus)
            0: begin  
                hex0 <= zero;
                hex1 <= off; 
            end  
            1: begin  
                hex0 <= one;
                hex1 <= off; 
            end  
            2: begin 
                hex0 <= two; 
                hex1 <= off; 
            end 
            3: begin 
                hex0 <= three; 
                hex1 <= off; 
            end 
            4: begin 
                hex0 <= four; 
                hex1 <= off; 
            end 
            5: begin 
                hex0 <= five; 
                hex1 <= off; 
            end 
            6: begin 
                hex0 <= six; 
                hex1 <= off; 
            end 
            7: begin 
                hex0 <= seven; 
                hex1 <= off; 
            end 
            8: begin 
                hex0 <= eight; 
                hex1 <= off; 
            end 
            9: begin 
                hex0 <= nine;
                hex1 <= off; 
            end 
            10: begin 
                hex1 <= one; 
                hex0 <= zero; 
            end 
            11: begin 
                hex1 <= one; 
                hex0 <= one; 
            end
            12: begin 
                hex1 <= one; 
                hex0 <= two; 
            end                 
            13: begin 
                hex1 <= one; 
                hex0 <= three; 
            end
            14: begin 
                hex1 <= one; 
                hex0 <= four; 
            end
            15: begin 
                hex1 <= one; 
                hex0 <= five; 
            end
            16: begin 
                hex1 <= one; 
                hex0 <= six; 
            end
            17: begin 
                hex1 <= one; 
                hex0 <= seven; 
            end                                                                                
            18: begin 
                hex1 <= one; 
                hex0 <= eight; 
            end                
        endcase 
    end 

    // minus calculation
    if (output_hex4 == 1) begin 
        output_calc_minus <= output_hex5 - output_hex3; 
        case (output_calc_minus)
            0: begin  
                hex0 <= zero;
                hex1 <= off; 
            end  
            1: begin  
                hex0 <= one;
                hex1 <= off; 
            end  
            2: begin 
                hex0 <= two; 
                hex1 <= off; 
            end 
            3: begin 
                hex0 <= three; 
                hex1 <= off; 
            end 
            4: begin 
                hex0 <= four; 
                hex1 <= off; 
            end 
            5: begin 
                hex0 <= five; 
                hex1 <= off; 
            end 
            6: begin 
                hex0 <= six; 
                hex1 <= off; 
            end 
            7: begin 
                hex0 <= seven; 
                hex1 <= off; 
            end 
            8: begin 
                hex0 <= eight; 
                hex1 <= off; 
            end 
            9: begin 
                hex0 <= nine;
                hex1 <= off; 
            end  
        endcase  

        // if output is negative 
        if (output_hex5 < output_hex3) begin 
            output_calc_neg <= output_hex3 - output_hex5; 
            case (output_calc_neg) 
                1: begin  
                    hex0 <= one;
                    hex1 <= minus; 
                end  
                2: begin 
                    hex0 <= two; 
                    hex1 <= minus; 
                end 
                3: begin 
                    hex0 <= three; 
                    hex1 <= minus; 
                end 
                4: begin 
                    hex0 <= four; 
                    hex1 <= minus; 
                end 
                5: begin 
                    hex0 <= five; 
                    hex1 <= minus; 
                end 
                6: begin 
                    hex0 <= six; 
                    hex1 <= minus; 
                end 
                7: begin 
                    hex0 <= seven; 
                    hex1 <= minus; 
                end 
                8: begin 
                    hex0 <= eight; 
                    hex1 <= minus; 
                end 
                9: begin 
                    hex0 <= nine;
                    hex1 <= minus; 
                end                 
            endcase 
        end              
    end     
end 




endmodule 
