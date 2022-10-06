import os
import json
import csv
from tqdm import tqdm
from joblib import Parallel, delayed
import re
import subprocess

PIPE = subprocess.PIPE
# assign directory
directory = 'output'

ext = ('.dart')

arrayOfText = []
arrayOfComments = []
repo = ""
# iterate over files in
# that directory

class Parser():
    def __init__(self,comment,code,commentSize,codeSize,repo):
        self.comment = comment
        self.code = code
        self.commentSize = commentSize
        self.codeSize = codeSize
        self.repo = repo

absolute_path = os.path.dirname(os.path.abspath(__file__))

def extractdata():
    i=0
    for root, dirs, files in tqdm(os.walk(directory)):
        if root.count(os.path.sep) == 1:
            gitRes = subprocess.Popen('git -C '+root +' remote show origin -n"', shell=True, stdout=subprocess.PIPE).communicate()[0].decode('utf-8').strip()
            repo = re.findall('Fetch URL: https:\/\/github\.com\/(.*?)\\n', gitRes)[0]
        for filename in files:
            if filename.endswith(ext):
                path = os.path.join(root, filename)
                parseFileComments(path)
                if len(arrayOfText) > 0:
                    saveComments(repo)


def saveComments(repo):
    global arrayOfComments
    global arrayOfText
    f = open("export.txt", "a", encoding='utf-8')
    for i, item in enumerate(arrayOfText):
        commentSize = len(arrayOfComments[i])
        codeSize = len(arrayOfText[i])
        if commentSize < 17000 and codeSize < 17000:
            p = Parser(arrayOfComments[i],arrayOfText[i],commentSize,codeSize,repo)
            f.write(json.dumps(p.__dict__))
            f.write("\n")
    f.close()
    arrayOfText = []
    arrayOfComments = []

def parseFileComments(path):
    textfile = open(absolute_path + '\\' +
                                path, 'r', encoding='utf-8')
    try:
        filetext = textfile.read()
        textfile.seek(0)
        filelines = textfile.readlines()
        textfile.close()
    except:
        filelines = []
        filetext = ""
        textfile.close()
    matches = re.findall("(\/\/.{15,})", filetext)
    functionBraces = 0
    comment = ""
    text = ""

    startComment = False
    if len(matches) > 1:
        for line in filelines:
            if line.startswith("//") and line.find("nodoc") == -1:
                startComment = True
                comment += line.replace('\n',"\\n")
            elif startComment == True or functionBraces > 0:
                startComment = False
                text += line.replace('\n', "\\n")
                if not "{" in line and functionBraces == 0:
                    if len(text.replace(")","").replace("]","").replace(";","").strip()) > 5:
                        arrayOfComments.append(comment)
                        arrayOfText.append(text)
                    text = ""
                    comment = ""
                    continue
                if "{" in line:
                    functionBraces += 1
                if "}" in line:
                    functionBraces -= 1
                    if functionBraces < 0:
                        print('error')
                    if functionBraces == 0:
                        arrayOfComments.append(comment)
                        arrayOfText.append(text)
                        text = ""
                        comment = ""

extractdata()