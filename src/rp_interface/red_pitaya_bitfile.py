import os
from dataclasses import dataclass
import logging

log = logging.getLogger(__name__)


@dataclass
class Bitfile:
    '''
    Defines a bitfile string, and a default bitfiles directory.
    full_path will return a bitfile in bitfiles_directory or in the working directory
    '''
    bitfile: str
    bitfiles_directory: str = None

    def __post_init__(self):
        if not self.bitfiles_directory:
            self.bitfiles_directory = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'bitfiles')

    @property
    def full_path(self):
        '''
        First looks for bitfile in self.bitfiles_directory, then looks for it locally (e.g. ./bitfile.bit)
        '''
        bitfiles_directory_path = os.path.join(self.bitfiles_directory, self.bitfile)
        local_path = os.path.join('./', self.bitfile)
        if os.path.isfile(bitfiles_directory_path):
            return bitfiles_directory_path
        log.warning('Bitfile not found in {}'.format(bitfiles_directory_path))

        if os.path.isfile(local_path):
            return bitfiles_directory_path
        log.warning('Bitfile not found in {}'.format(local_path))
        raise RuntimeError("Couldn't find bitfile {}".format(self.bitfile))
