import glob
from zipfile import ZipFile

def do_zip(list_files):
    for file in list_files:
        file_name = file.split('/')[-1].split('.')[:-1]
        dest_path = 'output/%s.zip' % ".".join(file_name)

        with ZipFile(dest_path, 'w') as myzip:
            myzip.write(file)

files = glob.glob("input/*")

do_zip(files)