/**
 *
 */

function ns_to_clk();
    input real data;
    ns_to_clk = $ceil(data/`C_CORE_CLK_PERIOD);
endfunction : ns_to_clk
