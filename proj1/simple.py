import m5
from m5.objects import *
from optparse import OptionParser
parser = OptionParser()
parser.add_option('--o3', action="store_true")
parser.add_option('--inorder', action="store_true")
parser.add_option('--cpu_clock', type="string", default="2GHz")
parser.add_option('--ddr3_1600_8x8', action="store_true")
parser.add_option('--ddr3_2133_8x8', action="store_true")
parser.add_option('--ddr4_2400_16x4', action="store_true")
parser.add_option('--ddr4_2400_8x8', action="store_true")
parser.add_option('--lpddr2_s4_1066_1x32', action="store_true")
parser.add_option('--wideio_200_1x128', action="store_true")
parser.add_option('--lpddr3_1600_1x32', action="store_true")
(options, args) = parser.parse_args()

root = Root()
root.full_system = False
root.system = System()

# root.system.clk_domain = SrcClockDomain()
# root.system.clk_domain.clock = '2GHz'
# root.system.clk_domain.voltage_domain = VoltageDomain()
############### modify cpu clock domain ###########################
root.system.cpu_clk_domain = SrcClockDomain()
root.system.cpu_clk_domain.clock = options.cpu_clock
root.system.cpu_clk_domain.voltage_domain = VoltageDomain()
root.system.cpu.clk_domain = root.system.cpu_clk_domain
############### modify clock domain ###############################

root.system.mem_mode = 'timing'
root.system.mem_ranges = [AddrRange ('2GB')]
root.system.mem_ctrl = MemCtrl()
#root.system.mem_ctrl.dram = DDR4_2400_16x4 ()
############### modify memory controller ###########################
root.system.mem_ctrl.dram = DDR4_2400_16x4()
if options.ddr3_1600_8x8:
    root.system.mem_ctrl.dram = DDR3_1600_8x8()
elif options.ddr3_2133_8x8:
    root.system.mem_ctrl.dram = DDR3_2133_8x8()
elif options.ddr4_2400_16x4:
    root.system.mem_ctrl.dram = DDR4_2400_16x4()
elif options.ddr4_2400_8x8:
    root.system.mem_ctrl.dram = DDR4_2400_8x8()
elif options.lpddr2_s4_1066_1x32:
    root.system.mem_ctrl.dram = LPDDR2_S4_1066_1x32()
elif options.wideio_200_1x128:
    root.system.mem_ctrl.dram = WideIO_200_1x128()
elif options.lpddr3_1600_1x32:
    root.system.mem_ctrl.dram = LPDDR3_1600_1x32()
else:
    root.system.mem_ctrl.dram = DDR4_2400_16x4() #default setting
############### modify memory controller ###########################
root.system.mem_ctrl.dram.range = root.system.mem_ranges[0]

#root.system.cpu = TimingSimpleCPU()
############### modify cpu type ###########################
if options.o3:
    root.system.cpu = DerivO3CPU()
elif options.inorder:
    root.system.cpu = MinorCPU()
else:
    root.system.cpu = TimingSimpleCPU()
############### modify cpu type ###########################

root.system.membus = SystemXBar()

root.system.cpu.icache_port = root.system.membus.cpu_side_ports
root.system.cpu.dcache_port = root.system.membus.cpu_side_ports
root.system.mem_ctrl.port = root.system.membus.mem_side_ports
root.system.cpu.createInterruptController()
root.system.system_port = root.system.membus.cpu_side_ports
# root.system.cpu.interrupts[0].pio = system.membus.mem_side_ports
# root.system.cpu.interrupts[0].int_requestor = system.membus.cpu_side_ports
# root.system.cpu.interrupts[0].int_responder = system.membus.mem_side_ports

root.system.cpu.max_insts_any_thread = 10000000 #set maximum instructions as 10000000

exe_path = 'tests/test-progs/hello/bin/arm/linux/hello'
root.system.workload = SEWorkload.init_compatible(exe_path)
process = Process()
process.cmd = [exe_path]
root.system.cpu.workload = process
root.system.cpu.createThreads()

m5.instantiate()
exit_event = m5.simulate()
print('Exiting @ tick {} because {}'.format(m5.curTick(), exit_event.getCause()))