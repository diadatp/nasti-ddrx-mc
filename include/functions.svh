/**
 *
 */

function integer ns_to_clk(input real data);
	ns_to_clk = $ceil(data/`C_CORE_CLK_PERIOD);
endfunction : ns_to_clk

function integer ceild(input integer number, input integer div);
    if ((number % div) > 0)
        ceild = (number/div) + 1;
    else
        ceild = (number/div);
endfunction : ceild
