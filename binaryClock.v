module binaryClock  (
    input wire clk,
    output wire [5:0] led
);

    reg [24:0] counter = 0;
    reg [5:0] led_value = 0;

    assign led = ~led_value;

    initial begin
        led_value = 6'b000000;
    end

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter == 27_000_000 - 1) begin
            led_value <= led_value + 1'b1;
            counter <= 0;
        end
    end

endmodule
