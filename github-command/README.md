# GitHub related Note and Command

## Setup Environment

### Topology

working directory --- staging --- local repository ----- remote respository

<img title="" src="img/gitflow.PNG" alt="title" width="441">

### Tool download

| Name        | url                               |
| ----------- | --------------------------------- |
| github bash | https://www.git-scm.com/downloads |
| sourcetree  | https://www.sourcetreeapp.com/    |

### Setup config File (`.gitconfig`)

After install git it will generate `.gitconfig`  file, which store git configure setting . Store location:

> Windows：C:\Users\username\
> MacOs：~/.gitconfig

- **Show your configure setting**: use command: `git config` and add `--list` parameter like this: 
  
  - `git config --list` will show all configure setting

- **edit your config** add username, and email address
  In order to publish any code we need to have username and email.

   You can edit configure as below:    

```
$ git config --global user.name "username"
$ git config --global user.email <email-address>
$ git config --global color.ui auto

#add specific editor
#git config --global core.editor emacs
#git config --global core.editor "nano -w"
```

- Alias Git command 
  
  ```
  $git config --global alias.co checkout
  $ git config --global alias.br branch
  $ git config --global alias.st status
  $ git config --global alias.ci commit
  ```

## Basic git command

Basic Step and common step are as below:

```
＃Step1: git init 
＃Step 2: touch file and edit file
#Step3: git add .
#Step4: git commit -m "message to commit"
#Step5: git push 
```

### git Init

This initializes a git repository, and creates the initial .git directory in a new or already existing project

> Create `.git init` in local and push to remote repository 

- Run command in local: `git init`,to generate `.git` file. Step as below: 

```
  #create project example: tutorial
  $ mkdir <directoryName>
  $ cd <directoryName>
  #inital git will generate .git
  $ git init
```

### git status

**Syntax**: `git status` , show status of new file is added or modify. If new file is been modify will occur `Untracked files`

> git status

### git add: Staging your file

This will add file changes that are in your working directory to your index

**Syntax**: `git add <filename>` ,  you can use below command: 

> git add  <filename>
> git add .  #current directory. Stage new/modify/delete files or directory  
> git add -A #Stage new/modify files or directory

    Example Step:    

```
    #create a file 
    $ touch test.txt
    # will show git status will occur unstage
    $ git status
    # adding file into staging 
    $ git add . 
    $ git status will occur stage
```

### git commit: save in local repository

This Git command takes all of the changes written in the index, creates a new commit object pointing to it, and sets the branch to point to that new commit. You can use these command: 

- commit your file using -m for message 
  `$ git commit -m "first commit"`

- or skip staging
  `$ git commit -am "first commit"`

### git log : show commit history detail

This command will show a list of commits on a branch, and include the corresponding details. You can use below command: 

- check log to see commit history  detail
  
  > `git --log` 

- show in one line
  
  > `git --log oneline`  

### git push: push into remote repository

This Git command will push all the modified local objects to the remote repository(github). 

- push new repository to remote(first time)
  
  ```
  $git remote add origin https://github.com/<username>/test.git   
  git branch -M main
  git push -u origin main 
  ```
  
  To understand `git remote`, please refer below `git remote` for more information. 

- push your repository remotely 
  
  > $git push -u origin master
  
     or
  
  > $git push 

 `-u` : will use default master or main branch. It will use the last push default branch. So if you push next time, your can just use this command: `git push` without adding branch name. 

`origin` : github use default branch `orgiin`, you can change also change to other name if you like. 

### git clone : download  repository from remote

 You can use git clone to download repository from remote to local. This command creates a Git repository copy from a remote source.

 Syntax:　`git clone https://github.com/<username>/repository.git`

### git remote

We need to link our local repoistory to remote repoistory, we need to register by using this comamnd: `$git remote add origin　<remote repoistory url>`

You can check `.git\config` to see link success or not, if success will occur as below: 

```
[remote "origin"]
url = https://github.com/<username>/test.git 
```

We can use the same local repository with multiply  remote repository in github.  

For example I have `test` in <u>remote repository(github)</u>, let create another <u>new remote repository</u> as `test2` and use the same <u>local repository</u>. 

<img title="" src="img/remote_repository.PNG" alt="title" width="614">

**Example:**

1. Go to github create new repository name `test1`

2. run  **remote add origin** will have error 
   
   - `git remote add origin https://github.com/chenchih/test1.git` It will occur error: `error: remote origin already exists.` 
   
   - Since we have already create `origin` already, so we need to change different remote repository name. 

3. change **remote add origin** into **remote add git2**
   
   `git remote add git2 https://github.com/chenchih/test1.git`

4. push to server again
   
   > git branch -M main
   > git push -u *git2* main

Why yould I want to do like this, a local repository link to two different remote repoistory? You can think one is `code release server` another one is `testing code server.

### Other command

- git diff
  
  - `git diff`: diff of what is changed but not staged
  
  - `git diff --staged`: diff of what is staged but not yet commited

- git rm 
  
  This will remove files from your index and your working directory so they will not be tracked:

## Advance  Setting

### Branch

- show listing your branch: ` $git branch`

- Create branch: `$git branch <branch name>`

- Switch branch: 

- create and switch branch: `$git checkout -b <branch>`

- create branch only: `$git checkout <branch>`

- delete branch: ` $git branch -d <branch>`

- Merge branch: `$git merge <branch name>`

**Example:**
After Creating master need to push like this:

```
$git add -A 
#create draft branch
$git checkout draft
$git commit -m "adding github comamnd"
#push origin draft
$git push origin draft
```

### Conflict Branch

### Reset/ checkout/Fetch recover commit

### rebase:

- git -rebase:
  
  apply any commits of current branch ahead of specified one

# Reference:

- https://code.yidas.com/git-commands/
- https://www.maxlist.xyz/2020/05/03/git-reset-checkout/
- https://w3c.hexschool.com/git/fd426d5a
- https://june.monster/git-github-checkout-reset-revert/
