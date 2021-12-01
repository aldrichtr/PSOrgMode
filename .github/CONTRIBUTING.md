# Contributing to PSOrgMode

Welcome to the PSOrgMode project, and thank you for your interest in contributing!

## Ways to contribute

- Participate in discussions through comments and discussions
- Test the code and identify features and bugs
- Write/update documentation
- Write code

## Discussions

Issues, pull requests and other repository sections have a comment area.  If you
want to ask a question, answer one, or generally communicate with the community
about a specific topic, just leave a comment in the appropriate item.

The Discussions section contains more general topics and is a good place to
discuss broader topics such as the roadmap, large features, etc.

## If you've found a bug

First, please search the issues to make sure it hasn't been reported already. If
you feel like the bug is not already reported, please open a new issue.

## If you would like to contribute documentation or code

Thank you!  Ideally, I'd like to discuss the contribution with the community first,
and the best way to do that is through an issue and the comments.  To submit code
please issue a pull request by following the below:

```sh
git clone https://github.com/aldrichtr/PSOrgMode.git
cd PSOrgMode
git checkout -b my_new_branch
# 1. make something happen
# 2. write tests
# 3. fix stuff until tests pass
# 4. commit as necessary
# repeat 1..4 until your happy with the result

git rebase -i main
# organize, reword prettify commits and messages

# check for any updates to the project
git checkout main
git pull --rebase

# reapply your patch
git checkout my_new_branch
git rebase main

# now, you're ready to submit a PR!
# fork the project
git remote add fork https://github.com/<you>/PSOrgMode.git
# update your fork
git push fork main
git push fork my_new_branch
```

Now go to your repository, click on "Pull Requests" , "New Pull Request".

- The target is the original repo (https://github.com/aldrichtr/PSOrgMode)
- The head is your repo (https://github.com/<you>/PSOrgMode)
- The branch is whatever you called your new branch.
