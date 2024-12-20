`timescale 1ns / 1ps

module Elevator2(
    input logic clk, reset,
    input logic [4:0] floor_request,
    output logic [4:0] current_floor,
    output logic moving, direction
);

    logic [2:0] fr, cf;
    logic valid_request;
    
    logic clkbit;
    logic [27:0]count;
    always_ff@(posedge clk)
    begin
        count <= count + 1;
        clkbit = count[27];
    end
    
    priority_encoder pre(.ipe(floor_request), .ope(fr), .valid(valid_request));

    decoder dec(.ipd(cf), .opd(current_floor));

    always_ff @(posedge count[27] or posedge reset) begin
        if (reset) begin
            cf <= 3'd0;
            moving <= 0;
            direction <= 1;
        end 
        else if (valid_request) begin  
            if (cf == fr) begin
                moving <= 0;     
            end 
            else begin
                moving <= 1;     
                if (cf < fr) begin
                    direction <= 1;  
                    cf <= cf + 1;
                end 
                else begin
                    direction <= 0;  
                    cf <= cf - 1;
                end
            end
        end 
        else 
            moving <= 0;
    end
endmodule

module priority_encoder(
    input logic [4:0] ipe,
    output logic [2:0] ope,
    output logic valid
);
    always_comb begin
        casex (ipe)
            5'b00001 : begin ope = 3'b000; valid = 1; end
            5'b0001x : begin ope = 3'b001; valid = 1; end
            5'b001xx : begin ope = 3'b010; valid = 1; end
            5'b01xxx : begin ope = 3'b011; valid = 1; end
            5'b1xxxx : begin ope = 3'b100; valid = 1; end
            default  : begin ope = 3'b000; valid = 0; end 
        endcase
    end
endmodule

module decoder(
    input logic [2:0] ipd,
    output logic [4:0] opd
);
    always_comb begin
        case (ipd)
            3'b000 : opd = 5'b00001;
            3'b001 : opd = 5'b00010;
            3'b010 : opd = 5'b00100;
            3'b011 : opd = 5'b01000;
            3'b100 : opd = 5'b10000;
            default: opd = 5'b00000;
        endcase
    end
endmodule
