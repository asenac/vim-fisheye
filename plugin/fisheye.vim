if exists('g:loaded_fisheye')
  finish
endif
let g:loaded_fisheye = 1

" TODO default variables

python << EOF
import vim
import os

def isWCRoot(dir):
    for i in ['.svn', '.git']:
        if os.path.exists(os.path.join(dir, i)):
            return True
    return False

def getCurrentWord():
    return vim.eval('expand("<cword>")')

def getCurrentFile():
    return vim.eval('expand("%:p")')

def getFisheyeURL(section):
    return vim.vars['fisheye_url'] + "/" + section + "/" + vim.vars['fisheye_project']

def openBrowser(url):
    browser = vim.vars['browser_command']
    vim.command("silent !%s %s" % (browser, url))
    vim.command("redraw!")

def openFileInBrowser(line = None):
    options = [ "hb=true" ] if line else []
    anchor = "to" + str(line) if line else ""
    url = getFisheyeURL('browse')
    dir = file = getCurrentFile()
    while dir not in ['', '/', os.environ.get('HOME')] and not isWCRoot(dir):
        dir = os.path.dirname(dir)
    if isWCRoot(dir):
        file = file.replace(dir, "")
    url += file
    if options:
        url += "?" + "&".join(options)
    if anchor:
        url += "\#" + anchor
    openBrowser(url)

def openCommitInBrowser():
    url = getFisheyeURL('changelog')
    revision = getCurrentWord()
    openBrowser("%s?cs=%s" % (url, revision))

def openCommitterInBrowser():
    url = getFisheyeURL('commiter')
    committer = getCurrentWord()
    openBrowser("%s/%s" % (url, committer))
EOF

command! -nargs=0 FEOpenCommit python openCommitInBrowser()
command! -nargs=0 FEOpenCommitter python openCommitterInBrowser()
command! -nargs=0 FEOpenFile python openFileInBrowser()
command! -nargs=0 FEOpenFileInCurrentLine python openFileInBrowser(vim.eval('line(".")'))

