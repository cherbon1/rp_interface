import os
from abc import ABC, abstractmethod
from typing import Union

from rp_interface import red_pitaya_comms
import logging

log = logging.getLogger(__name__)


class RedPitayaController(ABC):
    '''
    Defines a top-level interface to a red pitaya.
    Has a red pitaya and a bitfile

    This is an abstract base class and therefore can't be directly instantiated.
    Its subclasses must implement:
    - a bitfile `bitfile`
    - a defaults method `defaults`
    '''
    def __init__(self,
                 red_pitaya: Union[red_pitaya_comms.RedPitaya, str],
                 load_bitfile: bool = False,
                 apply_defaults: bool = False):

        if isinstance(red_pitaya, str):
            red_pitaya = red_pitaya_comms.RedPitaya(host=red_pitaya)

        if not isinstance(red_pitaya, red_pitaya_comms.RedPitaya):
            raise ValueError('Invalid red_pitaya parameter {}'.format(red_pitaya))

        self.rp = red_pitaya

        self.bitfiles_directory = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'bitfiles')

        if load_bitfile:
            self.rp.load_bitfile(self.bitfile_path)

        if apply_defaults:
            self.defaults()

    @property
    @abstractmethod
    def bitfile(self):
        ...

    @abstractmethod
    def defaults(self):
        ...

    @property
    def bitfile_path(self):
        bitfiles_directory_path = os.path.join(self.bitfiles_directory, self.bitfile)
        local_path = os.path.join('./', self.bitfile)
        if os.path.isfile(bitfiles_directory_path):
            return bitfiles_directory_path
        log.warning('Bitfile not found in {}'.format(bitfiles_directory_path))

        if os.path.isfile(local_path):
            return bitfiles_directory_path
        log.warning('Bitfile not found in {}'.format(local_path))
        raise RuntimeError("Couldn't find bitfile {}".format(self.bitfile))