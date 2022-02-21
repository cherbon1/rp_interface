from abc import ABC, abstractmethod

from rp_interface import red_pitaya_comms
import logging

log = logging.getLogger(__name__)


class RedPitayaModule(ABC):
    '''
    Uses a redpitaya instance to define bitfile specific interactions with a redpitaya
    This is an abstract base class and therefore can't be directly instantiated.
    Its subclasses must implement:
    - a defaults method `defaults`
    '''
    def __init__(self,
                 red_pitaya: red_pitaya_comms.RedPitaya,
                 apply_defaults: bool = False
                ):
        if not isinstance(red_pitaya, red_pitaya_comms.RedPitaya):
            raise ValueError('Invalid red_pitaya parameter {}'.format(red_pitaya))
        self.rp = red_pitaya

        if apply_defaults:
            self.defaults()

    @abstractmethod
    def defaults(self):
        ...

