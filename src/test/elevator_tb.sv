
`timescale 1ns / 1ps

module Elevator2_TB();
    logic clk, reset;
    logic [4:0] floor_request;
    logic [4:0] current_floor;
    logic moving, direction;
    
    Elevator2 dut(.clk(clk), .reset(reset), .floor_request(floor_request), .current_floor(current_floor), .moving(moving), .direction(direction));
    
    initial 
    begin
        forever #5 clk = ~clk;
    end
    
    initial 
    begin
    clk = 0;
        reset = 1;
        floor_request = 5'b10000;
        #20 reset = 0;
        floor_request = 5'b00010;
        #100;
        floor_request = 5'b10000;
        #100;
        floor_request = 5'b00010;
        #100;
        floor_request = 5'b00001;
        #100;
        $finish;
    end
endmodule