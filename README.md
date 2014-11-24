# 5werk/darkcoin
![We love darkcoin!](https://www.darkcoin.io/wp-content/uploads/2014/09/i_heart_drk_s.png)

A simple [docker](http://docker.io/) container for [darkcoin](http://darkcoin.io/)  masternodes.

The suite includes the ready-made docker container, a script to install or upgrade the container and this basic step-by-step tutorial on how to set-up your masternode.

## 0. Prerequisites
You need to have root access to a **64bit linux server with Kernel 3.8+** (requirement to run docker) which ideally has a static public ip address in order to be a reliable darkcoin masternode.

Additionally you need to have at least **1000 DRK** coins for operating a masternode. Since darkcoin masternodes allow a hot/cold wallet setup, you don't need to put the wallet.dat, which holds the 1000 DRKs on the server.

You need to install **curl**, if its not installed already (like on ubuntu). On debian for example use the following command:
```bash
sudo apt-get install curl
```

## 1. Client: Prepare a wallet
You need to install the latest version of darkcoin-qt on your local computer. Download the executable file from [darkcoin](http://darkcoin.io/).

### Always encrypt and backup your wallet
Make sure your wallet is encrypted with `Settings > Encrypt Wallet`.
Save the password. Now export your wallet with `File > Backup Wallet` to
a save location.

### Generate a masterprivkey and transfer 1000 DRK
When your block-chain is syncronised you can create a masternode private key. Open the debug console at `Help > Debug Window > Console` and type following command:

```bash
masternode genkey
```

Save the output (long string of numbers and letters) in a textfile. You will need the key during **step 3**.

Now create a new account address with the following command:
```bash
getaccountaddress "My Masternode"
```

Now transfer exact 1000 DRK to this newly generate address using the `Send > Pay To:` Field. Make sure the field below reads `Label: My Masternode`.

## 2. Server: Install docker
Check out the [docker website](http://docker.io) in order to understand how to install docker on the specific linux distribution you are running.

The install command for ubuntu is as follows:

```bash
curl -sSL https://get.docker.com/ubuntu/ | sudo sh
```

## 3. Server: Create the darkcoin.conf
Choose a folder where you want to house the darkcoin blockchain and the server config file. In this setup we use `/var/darkcoin`. 

*Careful: this command overwrites the file /var/darkcoin/darkcoin.conf*

```bash
sudo sh -c 'mkdir -p /var/darkcoin && curl -sSL https://raw.github.com/5werk/docker-darkcoin/master/darkcoin.conf > /var/darkcoin/darkcoin.conf && chmod 0400 /var/darkcoin/darkcoin.conf'
```

You can now edit the `darkcoin.conf` file (still with root permissions) using your favourite editor vim:
```bash
sudo vim /var/darkcoin/darkcoin.conf
```

Make sure the `darkcoin.conf` is filled out with the masternodeprivkey you obtained during the first step of this tutorial. Change at least the following 3 entries of the template config file:

```config
masternode=1
masternodeprivkey=[FILL IN FROM ABOVE]
rpcpassword=[super secure random password with 30 or more characters. You probably never need to use it]
```

Since we set the permissions of the config file to owner read-only you have to save with
`<ESC>:wq!` in vim (the root user always has write permissions).

You can easily generate a random password using the following
command or a multitude of [other methods](http://www.howtogeek.com/howto/30184/10-ways-to-generate-a-random-password-from-the-command-line/):
```bash
date | md5sum
```

## 4. Client: Install and run 5werk/darkcoin
You can use the provided `darkcoin-server.sh` to download and run the **5werk/darkcoin** docker image. We recommend you install the script in `/usr/local/bin/` as follows:

```bash
sudo sh -c 'curl -sSL https://raw.github.com/5werk/docker-darkcoin/master/darkcoin-server.sh > /usr/local/bin/darkcoin-server.sh && chmod +x /usr/local/bin/darkcoin-server.sh'
```

Change the default paths in the script, if you want to. You can edit the script with vim:
```bash
sudo vim /usr/local/bin/darkcoin-server.sh
```

If the script is configured to your likings install and run the **5werk/darkcoin** docker image like this:
```bash
sudo darkcoin-server.sh install
```
This command creates a running docker instance named **drk-server**. Check out the status of the service with:

```bash
sudo docker ps -a
```

## 5. Client: Unlock the wallet

Stop your **local** client. Open your **local** `darkcoin.conf` file. Typicall paths you can look for
it are the following:

Operating System  |Path                                          |
------------------|----------------------------------------------|
Windows 7         |C:\Users\YourUserName\Appdata\Roaming\Darkcoin|
Mac OSX           |~/Library/Application Support/Darkcoin/       |
Linux             |~/.darkcoin/                                  |

Add the following config options:
```config
server=1
addnode=23.23.186.131
masternodeprivkey=[FILL IN FROM ABOVE]
masternodeaddr=[ip address of your server]:9999
```

Now start the client and open the console at `Help > Debug Window > Console`. To authentificate your remote server type the following into the console:
```bash
masternode start [your wallet password]
```
If successful, you will see a message like *"successfully started masternode"*.

<br/>
***Congratulations! You successfully setup your darkcoin masternode!***
<br/><br/>

## 6. Server: Upgrade the darkcoin server periodically
Check periodically if the darkcoin developers upgraded the darkcoin runtime. We will try to keep the `5werk/darkcoin` docker image up-to-date. The upgrade process for you is relatively simple. Just run:

```bash
sudo darkcoin-server.sh upgrade
```

If you have problems with the latest image you can always downgrade to a prior darkcoin version (if it is still supported) using the following command:
```bash
sudo darkcoin-server.sh install-version 0.10.16.15
```
<br><br><br><br/>
* * *
Feel free to open Github issues for comments.

Donations are welcome at [Xk9nfmMJuGRpAcABjxDVVNwGjBiSRmHVYe](https://chainz.cryptoid.info/drk/search.dws?q=Xk9nfmMJuGRpAcABjxDVVNwGjBiSRmHVYe). All DRKs will be used to operate a liquidity provider! Thanks
