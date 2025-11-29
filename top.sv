module top (
    input  wire CLK100MHZ,   // 100 MHz board clock
    input  wire uart_rx,     // from Raspberry Pi TX → JA1
    output wire [4:0] LED    // use LED[0..4] for buttons
);

    // UART signals
    wire [7:0] rx_byte;
    wire       rx_done;

    // UART receiver at 115200 baud, 100 MHz clock
    uart_rx #(
        .CLKS_PER_BIT(868)   // 100_000_000 / 115200 ≈ 868
    ) uart_rx_inst (
        .clk   (CLK100MHZ),
        .rx    (uart_rx),
        .rx_dv (rx_done),
        .rx_byte(rx_byte)
    );

    // Latch last received byte
    logic [7:0] buttons = 8'd0;

    always_ff @(posedge CLK100MHZ) begin
        if (rx_done) begin
            buttons <= rx_byte;
        end
    end

    // Map bits to LEDs: UP, DOWN, LEFT, RIGHT, ACTION
    assign LED[0] = buttons[0];   // UP
    assign LED[1] = buttons[1];   // DOWN
    assign LED[2] = buttons[2];   // LEFT
    assign LED[3] = buttons[3];   // RIGHT
    assign LED[4] = buttons[4];   // ACTION (B button)

endmodule
