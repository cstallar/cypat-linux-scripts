#!/bin/python3
import subprocess

newPasswd = "Kachow69!!Kachow69!!"

userstrings = subprocess.check_output("cut -d: -f1,3,7 /etc/passwd", shell=True).decode('utf-8').split("\n") 
passwordstrings = subprocess.check_output("sudo cut -d: -f1,2 /etc/shadow", shell=True).decode('utf-8').split("\n")
passwdDict = dict()
pwpairs = [p.split(":") for p in passwordstrings][:-1]
for (uname,pwhash) in pwpairs:
    passwdDict[uname] = pwhash

userList = []
newUser = ""
while newUser != "end":
    userList.append(newUser.strip(" "))
    newUser =  input("Enter User (type end to continue): ")
userList = userList[1:] + ["nobody"]

adminList = []
newUser = ""
while newUser != "end":
    adminList.append(newUser.strip(" "))
    newUser =  input("Enter Admin (type end to continue): ")
adminList = adminList[1:]
usersOnSystem = []
removedUsers = []

for u in userstrings:
    if ":" in u:
        uname, uid, shell = u.split(":")
        uid = int(uid)
        groups = subprocess.check_output("groups " + uname, shell=True).decode('utf-8').strip().split(" ")[2:]
        if uid >= 1000:
            if uname not in userList:
                print("removing user "+uname)
                removedUsers.append(uname)
                print("sudo userdel -r " + uname)
            else:
                usersOnSystem.append(uname)
                if ("admin" in groups or "sudo" in groups) and uname not in adminList:
                    print("Unauth admin " + uname)
                    try:
                        print("sudo gpasswd -d " + uname + " admin")
                    except subprocess.CalledProcessError:
                        pass
                    print("sudo gpasswd -d " + uname + " sudo")
                elif uname in adminList and not ("admin" in groups or "sudo" in groups):
                    print("promoting admin " + uname)
                    print("sudo gpasswd -a " + uname + " sudo")
            if (len(passwdDict[uname]) < 3 or passwdDict[uname][:3] != "$6$") and uname != "nobody" and uname not in removedUsers:
                print("Creating new password for " + uname)
                print('echo '+uname+":"+newPasswd+"| sudo chpasswd")
        else:
            if shell != "/usr/sbin/nologin" and uname != "root":
                print("unauth shell for system user "+uname)
                print("sudo chsh -s /usr/sbin/nologin "+ uname)

for uname in set(userList) - set(usersOnSystem):
    if uname in adminList:
        print("adding admin "+uname)
        print("sudo useradd -G sudo " + uname )
    else:
        print("adding user "+uname)
        print("sudo useradd " + uname )
    print('echo '+uname+":"+newPasswd+"| sudo chpasswd" )




