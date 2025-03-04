# Scanimals
**About the Scanimals** <br/>
The Scanimals app is an interactive and educational mobile application designed for children. Using your device's camera, the app allows users to scan animals and provide them with information about the animal.

# Motivation
**The Problem** <br/>
Currently, there are similar apps out there on the App Store or Google Play Store that performs the same functionality as our app. However, there were multiple glaring issues within the majority of the sample apps we tested. Firstly, many of these apps have implemented a paywall, limiting access users to the full functionality of their app. This occurs in limiting the usage of the app to the user in the form of limited scans per day or limited time usage (i.e. a week) before prompting users to pay for a subscription for continued usage. 

In regards to the details that are displayed upon a scan, we also found an issue where the text was far too dense. The density of the descriptions are an issue since the text can be far too advanced for our target demographic to comprehend. 

Lastly, other apps have no filtering system for animals or a way to create personalized folders of the user's scanned animals. Outside of our core functionality of providing users with information about a scanned animal, we plan to incorporate a wikipedia section of other various animals. Other apps have no filtering system making it hard for users to navigate a specific animal they are hoping to see. Furthermore, without the ability to create personalized folders, users are unable to organize their collection of photos which undermines the core objective of the project.

# The Solution
Scanimals aims to foster learning in children about animals around the world and their environment through a quickly accessible and easy-to-use app on their device. Through this app users will be able to expand their knowledge, possibly nurture their love for animals and develop a deeper understanding of the planet's biodiversity.

# Technical Stack
**Platforms** <br/>
The Scanimals App will be available for free to download on the Apple App Store for iOS and iPadOS devices with full free access to all of the app's features.

**Frameworks and Technologies** <br/>
Creating Scanimals will require the following frameworks/technologies:

| Technology/Framework                     | Reason                                           |
|-------------------------|------------------------------------------------|
| Swift/SwiftUI    | For iOS and iPad development                                        |
| Apple Vision   | Capture and Process Images |
| CreateML   | For training pre-existing ML models (MobileNet) |
| CoreML   | For deploying trained model to Scanimals |
| MobileNet   | A lightweight model for real-time animal recognition |
| DistillBart   | A lightweight LLM used for text summaries |
| PyTorch   | For fine-tuning DistilBart to generate kid-friendly summaries before passing it on to CoreML |
# Figma Design Goes Here
<img width="546" alt="Screenshot 2025-03-03 at 2 51 25 AM" src="https://github.com/user-attachments/assets/ed4d2b89-a1aa-4554-94c0-43c027c47c03" /> <br/>
[Figma Prototype Link](https://www.figma.com/proto/OGS4zwWZQ2sKZuKfFR3UzZ/Scanimal?node-id=1-3&p=f&t=Dhormxor4JGluUcQ-1&scaling=scale-down&content-scaling=fixed&page-id=0%3A1&starting-point-node-id=1%3A3)
