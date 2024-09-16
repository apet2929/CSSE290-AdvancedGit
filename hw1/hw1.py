import argparse
import os
import subprocess

def query(sha):
    output = subprocess.check_output(f'git cat-file -p {sha}', shell=True)
    return output.decode("utf-8")

def search_file(file_sha, string):
    try:
        output = subprocess.check_output(f'git cat-file -p {file_sha} | grep \"{string}\"', shell=True)
        return output.decode("utf-8")
    except subprocess.CalledProcessError as e:
        return ""

def run(tree_sha, string):
    folders = [tree_sha]

    while len(folders) != 0:
        base = folders.pop()

        result = query(base).split("\n")

        for row in result:
            row = row.replace("\t", " ").split(" ")
            if len(row) > 1 and row[1] == "tree":
                folders.append(row[2])
            elif len(row) > 1 and row[1] == "blob":
                result = search_file(row[2], string)
                if result:
                    result = result.replace("\\n", "\n")
                    print(result.rstrip())

if __name__ == "__main__":
    # Get initial hash with `git cat-file -p HEAD` while in js-parsons directory
    parser = argparse.ArgumentParser(
                    prog='ProgramName',
                    description='What the program does',
                    epilog='Text at the bottom of help')

    parser.add_argument('-t', '--tree')      # option that takes a value
    parser.add_argument('-s', '--string')
    args = parser.parse_args()
    run(args.tree, args.string)
