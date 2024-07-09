# Artificial Ineeelligence

This is an umbrella directory which contains all sort of algorithms related to Artificial Intelligence (AI). Each subdirectory contains:
- Algorithms implemented in a event (courses, workshops, webinars, etc) with their respective theoretical and technical references, these directory's `README.md` file contains:
  - Technical references (software, packages, frameworks, datasets) which might be common to all courses.
  - Extra references about the Data Science career and MLOps tools.
- Some code implementation of books from the AI field.

This `README.md` file contains general information which is common to all topics in AI.

## Technical references

### MLOps tools

Landscape:
- [MLOps Landscape in 2024: Top Tools and Platforms](https://neptune.ai/blog/mlops-tools-platforms-landscape)

Logging:

- [Loguru](https://github.com/Delgan/loguru): Python logging made (stupidly) simple
  - [Data Science Simplified video - Loguru: Simple as Print, Flexible as Logging](https://www.youtube.com/watch?v=XY_OrUoR-HU&ab_channel=DataScienceSimplified)
  - [Data Science Simplified post - Loguru: Simple as Print, Flexible as Logging](https://mathdatasimplified.com/simplify-your-python-logging-with-loguru/)

Configuration Management:

- [Hydra](https://hydra.cc/): allows you to separate configuration from code, enabling greater flexibility and maintainability in your projects
  - [Data Science Simplified video - Stop Hard Coding in a Data Science Project — Use Config Files Instead](https://www.youtube.com/watch?v=jaX9zrC7y4Y&ab_channel=DataScienceSimplified)
  - [Khuyen Tran post - Stop Hard Coding in a Data Science Project — Use Config Files Instead](https://towardsdatascience.com/stop-hard-coding-in-a-data-science-project-use-config-files-instead-479ac8ffc76f)

Local storage:

- [joblib](https://joblib.readthedocs.io/en/stable/): Python library that provides utilities for saving and loading Python objects, particularly those that are computationally intensive to create. It is commonly used for serializing and deserializing machine learning models, NumPy arrays, and other Python objects to and from disk.
- [HDF5](https://www.projectpro.io/article/how-to-save-a-machine-learning-model/776) (see item 7): Hierarchial Data File Format Version 5 is a flexible and efficient format when it comes to storing large amounts of data and works well for saving large models. Use it fo save raw, preprocessed, and postprocess data. For storing ML models, [it might not be always suitable](https://stackoverflow.com/questions/78294583/which-ml-models-can-be-saved-using-hdf5)
- [picke](https://machinelearningmastery.com/save-load-machine-learning-models-python-scikit-learn/) - A standard package way to save generic variables in Python. Although it is also used to save ML models, it is not considered the best practice.
- Other than that, many packages (e.g., tensorflow, keras, etc) may contain the `save()` save method which enables the user to save the model without resorting to extra packages.

Cloud storage:

- [DVC](https://github.com/iterative/dvc) - ML Experiments Management with Git.


Data Science project template:

- [cookiecutter-data-science](https://github.com/drivendata/cookiecutter-data-science) - A logical, reasonably standardized, but flexible project structure for doing and sharing data science work.

Data visualization:

- [ydata-profiling](https://github.com/ydataai/ydata-profiling) - Get summary of pandas dataframes
- [pretty-print-confusion-matrix](https://github.com/wcipriano/pretty-print-confusion-matrix) - Confusion Matrix in Python: plot a pretty confusion matrix (like Matlab) in python using seaborn and matplotlib.
- [searborn](https://github.com/mwaskom/seaborn) - Statistical data visualization in Python.
- [yellowbrick](https://github.com/DistrictDataLabs/yellowbrick) - Visual analysis and diagnostic tools to facilitate machine learning model selection.

### Datasets

- [UCI](https://archive.ics.uci.edu) - UC Irvine Machine Learning Repository.
- [`dataset`](https://www.timeseriesclassification.com/) [`dataset`](http://tseregression.org/) [`dataset`](https://www.cs.ucr.edu/%7Eeamonn/time_series_data_2018/) [`reading`](https://arxiv.org/pdf/2006.10996.pdf) [`reading`](https://arxiv.org/pdf/1810.07758.pdf) [`reading`](https://www.cs.ucr.edu/%7Eeamonn/time_series_data_2018/BriefingDocument2018.pdf) [`reading`](https://arxiv.org/pdf/1811.00075.pdf) **UEA & UCR Time Series Datasets** - Two widely used time series datasets, which are frequently used toghether for Time Series Classification (TSC), Time Series Clustering (TSCL) and Time Series Extrinsic Regression (TSER).
- [kaggle](https://www.kaggle.com/) - A data science competition platform enables users to find and publish open datasets, explore and build models in a web-based data science environment, work with other data scientists and machine learning engineers.

### Packages

Machine Learning & Neural Networks:

- [MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl) - A Julia machine learning framework.
- [pytorch](https://pytorch.org/) - Tensors and Dynamic neural networks in Python with strong GPU acceleration.
- [Tensorflow](https://github.com/tensorflow/tensorflow) - An Python Open Source Machine Learning Framework for Everyone.
- [sktime](https://github.com/sktime/sktime) - A unified framework for machine learning with time series.
  - [PyData Global 2021](https://youtube.com/watch?v=ODspi8-uWgo) and its [code](https://github.com/sktime/sktime-tutorial-pydata-global-2021)
  - [Some examples](https://github.com/sktime/sktime/tree/main/examples)
- [aeon](https://github.com/aeon-toolkit/aeon) - A toolkit for conducting machine learning tasks with time series data.

Natural Language Processing:

- [fastText](https://fasttext.cc/) - Library for efficient text classification and representation learning.

### Amazon AWS

- [Amazon AWS Certification](https://aws.amazon.com/certification/)
  - [AWS certification paths](https://d1.awsstatic.com/training-and-certification/docs/AWS_certification_paths.pdf)

- AI/ML certification paths
  ![image](https://github.com/tapyu/algorithms/assets/22801918/0e53196e-ef36-4e9c-a9a7-eb581dcb6963)

  - [Cloud Practitioner](https://aws.amazon.com/certification/certified-cloud-practitioner/)
    - [AWS Cloud Practitioner Essentials](https://explore.skillbuilder.aws/learn/course/external/view/elearning/134/aws-cloud-practitioner-essentials)
  - [Solutions Architect](https://aws.amazon.com/certification/certified-solutions-architect-associate/)
  - [Developer](https://aws.amazon.com/certification/certified-developer-associate/)
  - [Data Engineer](https://aws.amazon.com/certification/certified-data-engineer-associate/)
  - [Machine Learning - Specialty](https://aws.amazon.com/certification/certified-machine-learning-specialty/)
