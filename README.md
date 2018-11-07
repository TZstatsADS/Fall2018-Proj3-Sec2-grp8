# Project: Can you unscramble a blurry image? 
![image](figs/example.png)

### [Full Project Description](doc/project3_desc.md)

Term: Fall 2018

+ **Team Group 8**

+ **Team members**

  + Xiaojing Dong  xd2195@columbia.edu
  + Huiming Xie  hx2238@columbia.edu
  + Lujia Wang  lw2772@columbia.edu
  + Kayla Smith  kys2112@barnard.edu
  + Deepika Namboothiri  dsn2127@columbia.edu

+ **Project summary**

  In this project, we created two predictive models to enhance blurry and low resolution images. Our models can generate high resolution color images with good quality in a short time. Therefore they are good choices for mobile AI programs. The baseline model implements the Boosted Decision Stumps using `gbm` package in R and the improved model implements the Gradient Boosting using `XGBoost` package in R. We trained two models on 1500 images. Codes and reports for both model are under [doc](doc/) folder. Please see [baseline](doc/baseline_report/main_baseline.pdf) and [improved model](doc/improved_report/main_xgboost.pdf) for more details.
* **Contribution statement**: ([contribution statement](doc/a_note_on_contributions.md)) All team members approve our work presented in this GitHub repository including this contributions statement. 

* **References**
  * https://github.com/TZstatsADS/ADS_Teaching#project-cycle-3-predictive-modeling
  * https://github.com/TZstatsADS/ADS_Teaching/tree/master/Projects_StarterCodes/Project3_SuperResolution

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
