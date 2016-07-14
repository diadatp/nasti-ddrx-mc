/**
 *
 */

function integer ns_to_clk(real data);
    ns_to_clk = $ceil(data/`C_CORE_CLK_PERIOD);
endfunction : ns_to_clk
