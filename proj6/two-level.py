import m5
from m5.objects import *
from my_bp import freePerceptrons
from new_cache import *
from optparse import OptionParser
parser = OptionParser()
parser.add_option('--tmm', action="store_true")
parser.add_option('--bfs', action="store_true")
parser.add_option('--bzip2', action = 'store_true')
parser.add_option('--mcf', action = 'store_true')

# parser.add_option('--hislength', type="int", default=62) # 22 32 42 52 62
# parser.add_option('--pertablesize', type="int", default=2048) # 1024 2048 4096 8192 16384
# parser.add_option('--threshold', type="int", default=0) # -2 -1 0 1 2

# parser.add_option('--o3', action="store_true")
# parser.add_option('--inorder', action="store_true")
# parser.add_option('--cpu_clock', type="string", default="2GHz")
# parser.add_option('--ddr3_1600_8x8', action="store_true")
# parser.add_option('--ddr3_2133_8x8', action="store_true")
# parser.add_option('--ddr4_2400_16x4', action="store_true")
# parser.add_option('--ddr4_2400_8x8', action="store_true")
# parser.add_option('--lpddr2_s4_1066_1x32', action="store_true")
# parser.add_option('--wideio_200_1x128', action="store_true")
# parser.add_option('--lpddr3_1600_1x32', action="store_true")
(options, args) = parser.parse_args()

root = Root()
root.full_system = False
root.system = System()

root.system.clk_domain = SrcClockDomain()
root.system.clk_domain.clock = '2GHz'
root.system.clk_domain.voltage_domain = VoltageDomain()
############### modify cpu clock domain ###########################
# root.system.cpu_clk_domain = SrcClockDomain()
# root.system.cpu_clk_domain.clock = options.cpu_clock
# root.system.cpu_clk_domain.voltage_domain = VoltageDomain()
# root.system.cpu.clk_domain = root.system.cpu_clk_domain
############### modify clock domain ###############################

root.system.mem_mode = 'timing'
root.system.mem_ranges = [AddrRange ('2GB')]
root.system.mem_ctrl = MemCtrl()
root.system.mem_ctrl.dram = DDR4_2400_16x4 ()
############### modify memory controller ###########################
# root.system.mem_ctrl.dram = DDR4_2400_16x4()
# if options.ddr3_1600_8x8:
#     root.system.mem_ctrl.dram = DDR3_1600_8x8()
# elif options.ddr3_2133_8x8:
#     root.system.mem_ctrl.dram = DDR3_2133_8x8()
# elif options.ddr4_2400_16x4:
#     root.system.mem_ctrl.dram = DDR4_2400_16x4()
# elif options.ddr4_2400_8x8:
#     root.system.mem_ctrl.dram = DDR4_2400_8x8()
# elif options.lpddr2_s4_1066_1x32:
#     root.system.mem_ctrl.dram = LPDDR2_S4_1066_1x32()
# elif options.wideio_200_1x128:
#     root.system.mem_ctrl.dram = WideIO_200_1x128()
# elif options.lpddr3_1600_1x32:
#     root.system.mem_ctrl.dram = LPDDR3_1600_1x32()
# else:
#     root.system.mem_ctrl.dram = DDR4_2400_16x4() #default setting
############### modify memory controller ###########################
root.system.mem_ctrl.dram.range = root.system.mem_ranges[0]

#root.system.cpu = TimingSimpleCPU()
root.system.cpu = DerivO3CPU()
root.system.cpu.branchPred = MultiperspectivePerceptron8KB()
# if options.mysimplebp:
#     root.system.cpu.branchPred = MySimpleBP()
# elif options.localbp:
#     root.system.cpu.branchPred = LocalBP()
# elif options.tournamentbp:
#     root.system.cpu.branchPred = TournamentBP()
# elif options.perceptronsbp:
#     root.system.cpu.branchPred = Perceptrons()
#     root.system.cpu.branchPred.threshold = options.threshold*5 + int(options.hislength * 1.93 + 14)
#     root.system.cpu.branchPred.globalHistoryLength = options.hislength
#     root.system.cpu.branchPred.perceptronsTableSize = options.pertablesize
#     # print("hislength: ", options.hislength)
#     # print("pertablesize: ", options.pertablesize)
#     # root.system.cpu.branchPred = freePerceptrons(options.hislength, options.pertablesize)
# elif options.multiper:
#     root.system.cpu.branchPred = MultiperspectivePerceptron8KB()
############### modify cpu type ###########################
# if options.o3:
#     root.system.cpu = DerivO3CPU()
# elif options.inorder:
#     root.system.cpu = MinorCPU()
# else:
#     root.system.cpu = TimingSimpleCPU()
############### modify cpu type ###########################
root.system.cpu.icache = L1ICache()
root.system.cpu.dcache = L1DCache()
root.system.l2cache = L2Cache()


root.system.membus = SystemXBar()

# root.system.cpu.icache_port = root.system.membus.cpu_side_ports
# root.system.cpu.dcache_port = root.system.membus.cpu_side_ports
root.system.cpu.icache.cpu_side = root.system.cpu.icache_port
root.system.cpu.dcache.cpu_side = root.system.cpu.dcache_port

root.system.l2bus = L2XBar()
root.system.cpu.icache.mem_side = root.system.l2bus.cpu_side_ports
root.system.cpu.dcache.mem_side = root.system.l2bus.cpu_side_ports
root.system.l2cache.cpu_side = root.system.l2bus.mem_side_ports
root.system.l2cache.mem_side = root.system.membus.cpu_side_ports

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
# process.cmd = [exe_path]
if options.tmm:
    process.cmd = ['test_bench/2MM/2mm_base']
elif options.bfs:
    process.cmd = ['test_bench/BFS/bfs','-f','test_bench/BFS/USA-road-d.NY.gr']
elif options.bzip2:
    process.cmd = ['test_bench/bzip2/bzip2_base.amd64-m64-gcc42-nn','test_bench/bzip2/input.source','280']
elif options.mcf:
    process.cmd = ['test_bench/mcf/mcf_base.amd64-m64-gcc42-nn','test_bench/mcf/inp.in']
root.system.cpu.workload = process
root.system.cpu.createThreads()

m5.instantiate()
exit_event = m5.simulate()
print('Exiting @ tick {} because {}'.format(m5.curTick(), exit_event.getCause()))