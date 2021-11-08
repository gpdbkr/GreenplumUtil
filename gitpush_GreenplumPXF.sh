#git init
git add *
git commit -m "first commit"
git remote add origin https://github.com/gpdbkr/GreenplumPXF.git
git push -u origin master
# …or push an existing repository from the command line
# git remote add origin https://github.com/gpdbkr/GreenplumPXF.git
# git push -u origin master


exit
#create a new repository on the command line
echo "# GreenplumPXF" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/gpdbkr/GreenplumPXF.git
git push -u origin main

#push an existing repository from the command line
git remote add origin https://github.com/gpdbkr/GreenplumPXF.git
git branch -M main
git push -u origin main
