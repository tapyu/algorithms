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
## Theoretical references:

#### Main

1. **System Identification: Theory for the User: Ljung, Lennart** - The System Identification bible.
2. **Ljung, L., 1995. System identification toolbox: User's guide. Natick, MA, USA: MathWorks Incorporated** - The practical implementation aspects for System Identification using Matlab & Simulink.
1. **Aguirre, L.A., 2004. Introdução à identificação de sistemas–Técnicas lineares e não-lineares aplicadas a sistemas reais. Editora UFMG.** - The Luis Antonio Aguirre's Book.

#### Others
1. **Ingle, V.K. and Proakis, J.G., 1999. Digital signal processing using MATLAB. Brooks/Cole Publishing Co..** - Contains a good explanation on Linear predictive coding.
- [Matlab identification system toolbox](https://www.mathworks.com/videos/lennart-ljung-on-system-identification-toolbox-advice-for-beginners-96988.html) (developed by Lennart Ljung)
    - It uses [1] extensively
    - The `Matlab` toolbox is also extensively used in this course.
    - His slides can be found in [`Signal Processing and Machine Learning/System Identification/Colorado's slides`](https://drive.google.com/drive/folders/1CpVOSYmcbwPrMXsJcpOq-4WFjBhq8Tit?usp=drive_link)
1. [Spectrogram - Wikipedia](https://en.wikipedia.org/wiki/Spectrogram)
1. [Periodogram - Wikipedia](https://en.wikipedia.org/wiki/Periodogram)
1. [Box-cox transformation with Python](https://builtin.com/data-science/box-cox-transformation-target-variable)
1. [Partial autocorrelation function (PACF) - Wikipedia](https://en.wikipedia.org/wiki/Partial_autocorrelation_function)
1. [In-depth analysis of the regularized least-squares algorithm over the empirical risk minimization](https://towardsdatascience.com/in-depth-analysis-of-the-regularized-least-squares-algorithm-over-the-empirical-risk-minimization-729a1433447f)
1. [Derivation of Least Squares Regressor and Classifier](https://towardsdatascience.com/derivation-of-least-squares-regressor-and-classifier-708be1358fe9?gi=e125c07c46de)
1. [Least squares for classification](https://notesonai.com/Least+squares+for+classification)

## Extra references

- Another System identification [course](http://mocha-java.uccs.edu/ECE5560/index.html), from Colorado University and taught by Gregory Plett. It seems a much more organized course than Guilherme's course.
- [`course`](https://www.mathworks.com/videos/series/system-identification.html) [`video`](https://www.mathworks.com/videos/introduction-to-system-identification-81796.html) - MathWorks course on System Identification, taught by Lennart Ljung, Linköping University.
