import glob
import threading

from zipfile import ZipFile

def zip_file(file):
    file_name = file.split('/')[-1].split('.')[:-1]
    dest_path = 'output/%s.zip' % ".".join(file_name)

    with ZipFile(dest_path, 'w') as myzip:
        myzip.write(file)

def do_zip(list_files):
    for file in list_files:
        t = threading.Thread(target=zip_file, args=(file,))
        t.start()

files = glob.glob("input/*")

do_zip(files)

