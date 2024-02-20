# System identification

This directory contains:
- The homework from my PhD. course "Identificação de Sistemas", taught by Guilherme de Alencar Barreto at UFC.
- The homework is essentially several system identification algorithms, such as
    - Linear predictive coding (LPC) [3]
    - Yule-Walker for parameter estimation of autoregressive (AR) models [1,2]
    - Estimation techniques of the PSD by using histogram, periodogram [1,5] and spectrogram [4]
    - Ordinary Least Square (OLS) classifier [slides, 9, 10]
    - Box-Cox [6, slides] and z-score [slides] transformations
    - Estimation techniques of the autocorrelation function (ACF) [slides,1?] and partial autocorrelation function (PACF) [7,slides?] for time series analysis
    - AIC, BIC, FPE, and MDL information criteria commonly used in statistical model selection [1]
    - Recursive estimation algorithms:
        - Least Mean Square (LMS)
        - Recursive Least Square (RLS)
        - Least mean modulus (LMM)
        - Regularized Loss Minimization (RLM) [8]
        - Empirical Risk Minimization (ERM) [8]
- The codes were written in `Python`
- The slides can be in the Google drive in the path `Signal Processing and Machine Learning/System Identification/Guilherme's slides`
- I am not sure whether `datasetTC3.dat` belongs to the third computational homework or something else (I am not sure).


---
## Bibliography
1. System Identification: Theory for the User: Ljung, Lennart
1. Introdução à Identificação de Sistemas. Técnicas Lineares e não Lineares Aplicadas a Sistemas.
1. Digital Signal Processing using MATLAB - Proakis
1. [Spectrogram - Wikipedia](https://en.wikipedia.org/wiki/Spectrogram)
1. [Periodogram - Wikipedia](https://en.wikipedia.org/wiki/Periodogram)
1. [Box-cox transformation with Python](https://builtin.com/data-science/box-cox-transformation-target-variable)
1. [Partial autocorrelation function (PACF) - Wikipedia](https://en.wikipedia.org/wiki/Partial_autocorrelation_function)
1. [In-depth analysis of the regularized least-squares algorithm over the empirical risk minimization](https://towardsdatascience.com/in-depth-analysis-of-the-regularized-least-squares-algorithm-over-the-empirical-risk-minimization-729a1433447f)
1. [Derivation of Least Squares Regressor and Classifier](https://towardsdatascience.com/derivation-of-least-squares-regressor-and-classifier-708be1358fe9?gi=e125c07c46de)
1. [Least squares for classification](https://notesonai.com/Least+squares+for+classification)

---
## Further information
- Lennart Ljung is the main author in this field and his book is a must-read for this field.
- [Matlab identification system toolbox](https://www.mathworks.com/videos/lennart-ljung-on-system-identification-toolbox-advice-for-beginners-96988.html) (developed by Lennart Ljung)
- Another System identification [course](http://mocha-java.uccs.edu/ECE5560/index.html), from Colorado University and taught by Gregory Plett. It seems a much more organized course than Guilherme's course.
    - It uses [1] extensively
    - The `Matlab` toolbox is also extensively used in this course.
    - His slides can be found in `Signal Processing and Machine Learning/System Identification/Colorado's slides`