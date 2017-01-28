
`timescale 1ns/100ps
module fifotb();


reg[31:0] datain;
reg wrreq, rdclk, wrclk;

wire [31:0] dataout;
wire empty, rdreq;

fifo #(.FIFO_DEPTH (4096))
fifo_inst(
.wrclk(wrclk),
.wrreq(wrreq),
.rdclk(rdclk),
.rdreq(rdreq),
.datain(datain),
.clr(0),

//output
.dataout(dataout),
.empty(empty)
);


reg [15:0] wrreq_cnt, rdreq_cnt;


initial
begin

wrclk = 0;
rdclk = 0;
wrreq_cnt = 0;
rdreq_cnt = 0;
datain = 0;
wrreq = 0;
//rdreq = 0;

end

initial forever #5 wrclk=~wrclk;
initial forever #12.5 rdclk=~rdclk;

always @(negedge wrclk)
begin
wrreq_cnt <= wrreq_cnt + 1;

if (wrreq_cnt == 4)
    wrreq = 1;
else if (wrreq_cnt == 4099)
    wrreq <= 0;
else if (wrreq_cnt == 11000)
    wrreq_cnt <= 0;


if (wrreq)
    datain <= datain + 1;
end


/*
always @(negedge rdclk)
begin
rdreq_cnt <= rdreq_cnt + 1;

if (rdreq_cnt == 10 & ~empty)
    rdreq <= 1;
else if (rdreq_cnt == 20)
    begin
    rdreq <= 0;
    rdreq_cnt <= 0;
    end
end
*/

assign rdreq = ~empty;


endmodule