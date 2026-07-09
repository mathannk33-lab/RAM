Single Port RAM Verification
SystemVerilog functional verification project for a single-port, synchronous RAM (32 x 8) design, using a layered, mailbox-connected testbench (generator, driver, monitor, reference model, scoreboard, environment, test).
Author: Mathan G (Employee ID: 6909)
Simulator: Questa 10.6c
Status: 1 known open bug — see Known Issues
DUV Overview
Item	Detail
Type	Single port RAM
Frequency	50 MHz
Depth x Width	32 locations x 8 bits
Reset	Active low (`reset`)
Concurrent read/write	Not supported

Pin	Direction	Width	Description
`clk`	Input	1	Clock
`reset`	Input	1	Active low reset
`write_enb`	Input	1	Active high write enable
`read_enb`	Input	1	Active high read enable
`data_in`	Input	8	Write data
`address`	Input	5	Memory address (0–31)
`data_out`	Output	8	Read data
Testbench Architecture
Layered SystemVerilog UVM-style (non-UVM class based) environment:
```
Generator -> mbx_gd -> Driver -> DUV
                         |
                         v (mbx_dr)
                    Reference Model -> mbx_rs -> Scoreboard <- mbx_ms <- Monitor <- DUV
```
Transaction (`ram_trans`): randomizable `write_data`, `write_en`, `read_en`, `add`, constrained so `{write_en, read_en}` never illegally overlaps in a way the generator intends to send.
Generator (`ram_gen`): produces directed + constrained-random transactions.
Driver (`ram_drv`): drives transactions onto the DUV via a virtual interface clocking block; forwards each transaction to the reference model; samples a functional covergroup (`cg`) on `write_en`, `read_en`, `write_data`, `add`, with a `WRXRD` cross that ignores the illegal `write_en=1, read_en=1` case.
Monitor (`ram_mon`): passively samples `data_out` and forwards it to the scoreboard.
Reference Model: golden behavioral model of the RAM; predicts expected `data_out`.
Scoreboard: compares reference-model output against monitor output and tallies matches/mismatches.
Environment / Test: builds and connects all components and drives the run.
Running the Simulation
```bash
vsim -c -do "run -all" top_tb
vcover report -html cover.ucdb -htmldir covReport -details
```
(Adjust the compile/simulate commands to match your local Questa project setup — file lists, `+incdir`, and `-cover` flags are project-specific.)
Coverage Results
Latest regression (Questa 10.6c):
Coverage Type	Bins	Hits	Misses	% Hit	Coverage
Covergroups	41	41	0	100.00%	100.00%
Statements	29	28	1	96.55%	96.55%
Branches	6	6	0	100.00%	100.00%
FEC Conditions	4	4	0	100.00%	100.00%
Toggles	104	104	0	100.00%	100.00%
Assertions	1	1	0	100.00%	100.00%
Total				99.45%	99.42%
The single missed statement corresponds to the unimplemented `data_out` holding-state branch — see below.
Known Issues
BUG-001: `data_out` incorrectly goes to high-impedance instead of holding its previous value
Expected: Outside of reset, `data_out` should only update on a qualified read (`write_enb=1... wait, write_enb=0, read_enb=1`). In all other cycles — idle (`write_enb=0, read_enb=0`) and write (`write_enb=1, read_enb=0`) — `data_out` should hold the last value it read.
Actual: The DUV drives `data_out` to `Z` (high-impedance) during idle and write cycles instead of holding the previous value. High-impedance is only expected while `reset=0`.
Impact: Any logic sampling `data_out` outside an active read window observes `Z` instead of the last valid read data. This is also the source of the one missed statement in the statement coverage report above, since the "hold" path is never reached by the current RTL.
How it was found: Manual waveform review. The scoreboard did not flag this automatically because the reference model's checking logic was not written to check the hold case — this is called out below as a follow-up.
Suggested fix / follow-up:
Update the DUV RTL to latch `data_out` only on a qualified read, and hold it otherwise (except during reset, where it should still go to `Z`).
Update the RAM design specification to explicitly document the holding behavior (currently silent on this case).
Extend the reference model / scoreboard to actively check the hold behavior so this class of bug is caught automatically in future regressions instead of relying on manual waveform inspection.
Status: Open
Repository Contents
File	Description
`RAM_Verification_Report_MathanG.docx`	Full verification report (architecture, environment, coverage, results, bug write-up)
`RAM_Design_Specification_latest.pdf`	RAM design specification used as the verification reference
`coverage_report.jpg`	Questa coverage summary screenshot
`ram_drv.sv` (driver source, see report Section 4.3)	Driver class with functional covergroup
Verification Goals Checklist
[x] Correct write of data into memory at the specified address
[x] Correct read of data from memory at the specified address
[x] Reset drives all outputs / internal signals to a known idle/high-impedance state
[ ] `data_out` holds its previous value outside of reset and active read cycles — failing, see BUG-001
[x] Invalid address on write is silently ignored; invalid address on read returns `Z`
[x] Illegal `write_en=1, read_en=1` combination excluded from functional coverage goals
[x] 100% functional (covergroup), branch, FEC condition, toggle, and assertion coverage
[ ] 100% statement coverage — 96.55%, blocked by BUG-001
