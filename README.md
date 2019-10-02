# IoT Classter

IoT Classter is an unsupervised IoT device fingerprinting framework based on variational autoencoder and K-means algorithms at the network level, which can effectively cluster IoT devices without labeled samples.

**This work is being reviewed by NOMS 2020.**

# How to start?

In order to build the system, there are two things need to be prepared, one is essential, the other is optional.

* **[ESSENTIAL]** The **pcap files** that may contain network traffic generated by IoT devices;

* **[OPTIONAL]** A **csv file** contains information of IoT devices in the traffic (device name and MAC address). It only use to validate the performance of the system.

**Notice:** cpp programs in our system are implemented on Ubuntu18.04 with gcc version 7.4.0. Transformation to other platforms are not considered.

## Step1. Prepare the pcap files

You can detect a single pcap file or several pcap files and put them into */data*. Then you need to obtain the pre-observation data with */preprocess/pcap_preobservation*, here is a simple example to use the tool:

```shell
# change directory to /pcap_preobservation

# build the tool, default path: ./bin/dataPreProcess
make
# usage: <program> <mode> <data path> <output path>
./bin/dataPreProcess iot ../../data ../../data
# remove or clean the built program
make clean
```

We have prepared the pre-observation files of the dataset in */data*, you can skip this step if you only need to reproduce our experiment.

## Step2. Create raw instances

To create raw instances, use tool in */traffic_extractor*:

```shell
# change directory to /traffic_extractor

# build the extractor, default path: ./bin/ext_tool
make
# usage: <program> <data path> <output path>
./bin/ext_tool ../data ../result
# remove or clean the built program
make clean
```

We have prepared the raw instances of the dataset in */result*, you can skip this step if you only need to reproduce our experiment.

## Step3. Preprocess of instances

To do the preprocess of our system, simply run the script in */preprocess/auto_preprocess.sh*:

```shell
# change directory to /preprocess
chmod +x ./auto_preprocess.sh
./auto_preprocess.sh
```

If you want to custom the path of data, edit the script according to the comment in it. This will create a **instance.csv** in */result*, which is the input of the system.

## Step4. Train and validate the system

When the **instance.csv** is prepared, you can start to build the IoT Classter.

Our system is implemented in */IoT_Classter.ipynb*, which is a jupyter notebook file. Following the notebook you are able to train and validate the system. We highly recommend you to use jupyter notebook to employ our system to observe plots and results, however we also provide a normal python file in */IoT_Classter.py* which outputs pictures and accuracy:

```shell
# check and install requirements
# you can skip if you have: pandas, matplotlib, Keras, numpy and scikit_learn
pip3 install -r requirements.txt
# if you use python 2, change the command to "python"
python3 ./IoT_Classter.py
```

There is a pretrained VAE model weights file provided in */vae.h5* and the *IoT_Classter.py* we provide uses the pretrained weights. You can edit the python file according to Advanced Usage.

# Advanced Usage

## Pre-observation tool

There are two modes to use our pre-observation tool:

* **"iot"**: tool will obtain frequency according to given device list, need to provide an **iotList.csv** in */data* with two columns, one is the device name, the other is corresponding MAC address. You should not list Non-IoT device in this list. An example list is provided in */data*;

* **"all"**: tool will obtain frequency by observing all packets. Implement this mode when using your own pcap files. In this mode, a blank iotList.csv is generated in order to be compatible with other tools.

This tool will generate three sorted csv files: ports.csv, domain.csv and cipher_suite.csv, which should be passed to traffic_extractor as the reference of two-tuple features.

## Configuration of encoding method

You can custom the configuration file (name should specify to "dataAnalysis.conf") to control the data analysis tool, here is an example:

```
0,Data Type: 0 for IoT dataset, 1 for Tunet Background Flow
0,Mode:0 for Feature Vectors Statistic analysis, 1 for Raw Reconstruct
16,[STA]Top M of Ports
8,[STA]Top N of Domain
2,[STA]Top P of Cipher Suite
5,[RAW]Pck Number Filter
5,[RAW]DNS Pck Number Filter
0,[RAW]NTP Pck Number Filter
1,[RAW]IP filter for DNS(1 or 0)
1,[STO]1 for STA store with head, 0 for STA store without head
```

Feel free to try other [STA] parameters to change the dimensions of two-tuple features.

## Modify system parameters

At the top of */IoT_Classter.ipynb* or */IoT_Classter.py*, you can change system parameters, here is an example:

```python
# Ststem Parametres
np_seed = 1998         # random seed to control the result

# Control Flag, set to True or False
# NOTICE: If the structure of the network is changed, the pretrained weight can't be employed 
use_pretrain = True   # load pretrained model, need to have vae.h5
save_model = True     # save model
plt_model = False     # plot model description picture
save_predict = True   # save latent space output (with label)
use_callback = False  # employ Earlystopping and Checkpoint during training

l1_dim = 50           # VAE encoder hidden layer dimension
l2_dim = 50           # VAE decoder hidden layer dimension
vae_mean = 0.0        # VAE sampling normal distribution mean
vae_std = 0.3         # VAE sampling normal distribution std deviation
latent_dim = 3        # latent space dimension

hp_epoch = 10000      # train epoch
hp_batch_size = 512   # train batch size

# directory path that contains instance.csv
iot_data_dir = "./result/"
```

# Dataset

Our implementation is based on the pcap files provided by an open dataset, you can download the full dataset [here](https://iotanalytics.unsw.edu.au/iottraces).

# License

This project is licensed under the GPLv3 License.