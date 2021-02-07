# +
import glob
import os

class TreatFiles:
    def get_filename(self, v_fileType):

        if v_fileType == 'AFI':
            folderName =    'C:\\Users\\jferrer\\AppData\\Local\\Sage\\Temp\\AFI\\*.AFI'
        elif v_fileType == 'XML':
            folderName =    'V:\\Nomina\\Contratos\\CONTRATA\\*.XML'
        # * means all if need specific format then *.csv
        list_of_files = glob.glob (folderName)
        latest_file = max (list_of_files, key=os.path.getctime)

        return latest_file
