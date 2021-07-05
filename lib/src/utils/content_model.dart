class OnboardingContent {
  String image;
  String title;
  String description;

  OnboardingContent({this.image, this.title, this.description});
}

List<OnboardingContent> contents = [
  OnboardingContent(
    title: 'Welcome to DigiNotes!',
    image: 'assets/images/Component 1.png',
    description: "Get your underlined text on a page converted to digital format."
  ),
  OnboardingContent(
    title: 'Image to Text OCR',
    image: 'assets/images/Component 2.png',
    description: "Once converted, note can be edited as per requirement."
  ),
  OnboardingContent(
    title: 'Easy-to-use Interface',
    image: 'assets/images/Component 3.png',
    description: "Save and share the note with others!"
  ),
];

//PlaceholderText
String text1 = "DigiNotes";
String text2 = "Capture what's on your mind!"; 
const String info_title = "About";
const String info_content = 
'''
How to Use?

To add a new note, click the ‘add’ icon  given at the bottom right of the page.

An empty, editable note will open up. Press the ‘edit’ icon on the top right of the screen.

Add a title to the note, and press the camera icon to capture a photo of the page on which some important text is underlined. 

Wait for a few seconds to let AI do its job. Once done, the text will be added to the note.

Not happy with the result? You can edit the text yourself, and then save the note.

Want to share an important note with your friend? Just click the share icon.

''';
const String info_credits = "Made with ❤️ by DSC-VIT";