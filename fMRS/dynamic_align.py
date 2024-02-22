import argparse
from pathlib import Path

from fsl_mrs.utils import mrs_io
from fsl_mrs.utils.misc import parse_metab_groups
from fsl_mrs.utils.preproc import dyn_based_proc as dproc

parser = argparse.ArgumentParser(description='Run dynamic alignment on an fMRS file.')
parser.add_argument('input', type=Path,
                    help='Location of NIfTI file')
parser.add_argument('basis', type=Path,
                    help='Location of basis')
parser.add_argument('output', type=Path,
                    help='Location to output the results')
args = parser.parse_args()

args.output.mkdir(exist_ok=True, parents=True)

data = mrs_io.read_FID(args.input)
basis = mrs_io.read_basis(args.basis)

for metab in ['Ala', 'Asp', 'GABA', 'Gly', 'PE', 'NAAG', 'Lac']:
    basis.remove_fid_from_basis(metab)

Fitargs = {'baseline_order': 1,
           'ppmlim': (.2, 4.2),
           'metab_groups': parse_metab_groups(data.mrs(basis=basis)[0], 'MM_CMR')}

daligned = dproc.align_by_dynamic_fit(data, basis, fitargs=Fitargs)
daligned[0].save(args.output / (args.input.name + '_aligned.nii.gz'))
