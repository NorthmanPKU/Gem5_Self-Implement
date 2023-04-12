import m5
from m5.objects import *
class freePerceptrons(Perceptrons):
    globalHistoryLength = 62
    perceptronsTableSize = 2048
    def __init__(self, _globalHistoryLength = 62, _perceptronsTableSize = 2048):
        super(freePerceptrons, self).__init__()
        self.globalHistoryLength = _globalHistoryLength
        self.perceptronsTableSize = _perceptronsTableSize