# Project 6 - Translate Me

Submitted by: Jeffrey Berdeal

Translate Me is an app that lets you translate different langauages for better comunication with others.

Time spent: 24 hours spent in total

## Required Features

The following **required** functionality is completed:

- [X] Users open the app to a TranslationMe home page with a place to enter a word, phrase or sentence, a button to translate, and another field that should initially be empty
- [X] When users tap translate, the word written in the upper field translates in the lower field. The requirement is only that you can translate from one language to another.
- [X] A history of translations can be stored (in a scroll view in the same screen, or a new screen)
- [X] The history of translations can be erased
 
The following **optional** features are implemented:

- [X] Add a variety of choices for the languages
- [X] Add UI flair

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

## Video Walkthrough

<div>
    <a href="https://www.loom.com/share/25697865b62749619a0386b10ffd36c9">
    </a>
    <a href="https://www.loom.com/share/25697865b62749619a0386b10ffd36c9">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/25697865b62749619a0386b10ffd36c9-10192963f2e1430c-full-play.gif">
    </a>
  </div>
  
## Notes

- I had trouble installing Firebase since the correct packages (FirebaseCore and FirebaseFirestore) didn’t appear in Xcode.
- I realized Firebase setup was unnecessary for this project and decided to switch to local storage using UserDefaults instead.
- I encountered a SwiftUI preview error because ContentView() was missing the viewModel parameter.
- I fixed the preview build issue by passing a default TranslationViewModel() to the preview.
- My translation results initially showed %20 symbols because I was encoding the query string incorrectly.
- I solved the encoding issue by using URLComponents to safely construct the API request URL.
- I adjusted the UI so that it supported multiple languages through dropdown pickers for “From” and “To” selections.
- I had to add a swap button to make language switching easier and improve user experience.
- I faced layout spacing issues and refined the design to look cleaner and more modern.
- I made sure the translation history saved properly and could be cleared without breaking the app.
  
## License

    Copyright 2025 Jeffrey Berdeal

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
