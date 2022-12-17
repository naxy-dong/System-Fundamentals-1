## Assignment 0: Test Git Workflow

We will use this assignment to test the git workflow that we will use to submit assignments in this course. This assignment will not be graded. Use this opportunity to make sure that you have everything setup before working with the assignments. Do not hesitate to contact the teaching staff if you are stuck.

## Required Software
- [Git](https://git-scm.com/downloads)\
Mac OSX and Linux systems have git pre-installed. Check by running the command `git --version` in a terminal. On Windows, you will use git bash to run git commands.
- [Java 1.8 or higher](https://java.com/en/download/help/download_options.html)\
Make sure that java is set in your classpath so it can be run from any directory in your system. If you do not know how to do it see [here](https://docs.oracle.com/javase/tutorial/essential/environment/paths.html).

- MARS. Download the SBU Version from Brightspace under the Software modules. Make sure to extract the Mars.jar file in your local system.

## Setting up SSH

You will need to use the SSH protocol to securely connect to the assignment repository hosted on GitHub. Follow the listed steps below to setup ssh with GitHub:

- You will first need to create a GitHub account. If you do not already have an account create one [here](https://github.com). Use your Stonybrook email to create the account.

- If you already have an account, add the Stonybrook email to your existing GitHub account. See [here](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-github-user-account/managing-email-preferences/adding-an-email-address-to-your-github-account) for reference.

- Once you have a GitHub account, you will need to setup SSH public and private keys. These keys will be used by GitHub to authenticate your system. If you already have an existing public/private key pair in your system, you can simply use those keys. How do you know your system has these keys? See [here](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/checking-for-existing-ssh-keys). Skip next step, if the keys exist in your system.

- If your system does not have any public/private key pairs, do not panic. We can easily generate a new key pair. See [here](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) on how to generate new keys.

- The next step is add the public/private key pair in your system to your GitHub account. This is how GitHub knows which keys to use for authenticating your system. See [here](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) for how to add keys to GitHub.

- The final step is to test the SSH connection. See [here](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/testing-your-ssh-connection) for testing your setup.

For a general understanding of SSH and how it works see [here](https://www.techtarget.com/searchsecurity/definition/Secure-Shell).

## Downloading The Repository

Once you have setup SSH to work with GitHub, we can now seamlessly download the assignment repository from GitHub and push or upload code to the repository. You should be able to see a **Code** button in the repository. Click on the button and select the **SSH** option. Copy the corresponding link under this option and run the following command in your local terminal or git bash:

`git clone <paste-ssh-link>`

You will see a directory or folder named *./cse220-hw0* created in your current directory or folder. Inside this folder, you will find the following files:
- *hw0.asm* a file that prints a message. This is the file in which you will write your code. For this assignment all you have to do is fill in your name, NetID, and SBU ID.

- *Hw0Test.java* This file contains test code to verify the behavior of *hw0.asm*. In this assignment it contains code to verify if the expected message is being printed in *hw0.asm*. In future assignments, this file will have numerous test cases which you will need to pass. You will get credit for every test case you pass. You must not change this file.

- *Hw0Test.class* This is the compiled version of *Hw0Test.java*. It is in machine code understood only by the JVM. Ignore this file. You must not edit or remove this file. If you do, you will receive no credit for future assignments.

- *munit.jar* is a jar file used to run the test cases. You should ignore this file as well. Do not edit or remove this file.

## Submitting to GitHub
As described in the previous section, you will write all your code in the *.asm* file. For this assignment, fill in your full name, NetID, and SBU ID in the parts marked for you in *hw0.asm*. Submit your code using the following commands:

- Add your file to git:\
`git add hw0.asm`

- Save your file with a comment:\
`git commit -m "first draft" hw0.asm`

- Submit file:\
`git push`

To know more about using git, start [here](https://git-scm.com/docs/gittutorial)

## After submission/pushing
After you submit or push code to your repository, open the assignment repository on GitHub in a browser. Look for a **green tick** or a **red cross**. A green tick indicates that all tests have passed. A red cross indicates some or all tests may have failed. When you click on the red cross and then *details*, you will see a report indicating which test methods in *Hw0Test.java* passed and which methods failed. In this assignment, there is only one test method. Since you won't be changing any code, the test will pass. Hence, you will see a green tick indicating that the test has passed. For future assignments, you can click on the report to view the test report. You can keep changing your code till all tests pass or you see the green tick. However, submissions/pushes will only be allowed till a deadline, after which you will not be allowed to submit/push. This assignment has no deadline.

## Testing Your code locally

You can also verify if the test cases pass locally in your system before pushing to the remote repository. Use the following command in a terminal to run the tests:

`java -jar munit.jar Hw0Test.class hw0.asm`

After the running the command you should see a message *All tests passed* or a bunch of *Failure* messages stating which tests failed. Expect to see a green tick in GitHub after you push code that passed all tests locally, in which case you are done!
