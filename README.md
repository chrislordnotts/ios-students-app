# ios-students-app
A prototype data entry application using Swift

# Decisions
My technology stack:

	- Swift 3 and Xcode 8
	- CoreData for storage	
	- JSON for HTTP Requests

# Assumptions
I have made the following assumptions:

	- That connectivity *will* be poor. I find this the best approach.
	- That I didn't need to do automatic syncing.
	- That pending users could be as extreme as 1000+ by end of day.
	- The prototype does not need any kind of mock authentication.
	- The application should be universal and support both iPhone & iPad.

I have made the following decisions:

	Main Screen:
		- The images are photoshoped versions of online resources.
		- Both the image and the label can be tapped to move to the adjacent screens.
		- If there are no students to upload, "Upload Students" will appear disabled.

	Add New Student Screen:
		- First Name and Last Name must not be empty.
		- Email must be a valid non-empty email address.
		- The male and female buttons are custom radio buttons.
		- Users can select university from a scrolling picklist.
		- All fields have the keyboard key "Next" to jump to next field.
		- Fields are set with correct casing, spell checking and auto-replacement settings.
		- Tapping 'Male' / 'Female' buttons will dismiss the keyboard as it is no longer required to complete the form
		- Tapping 'Save' will validate the form and highlight problem fields in red with a label indicating the cause
		- When a field is highlighted red it is automatically focused (to save the user a tap)
		- The list of universities is loaded from a bundled static file
		- Every student gets given a unique record UUID for local indexing
		- A successful save will take the user back to the home menu

	Upload Students Screen:
		- Student data is persistently stored in Core Data.
		- Uploads are broken into batches of 200 to improve success rate & reliability.
		- If an upload fails, data is kept for the next sync.
		- If an upload succeeds, the portion of data it represented is deleted.
		- The user can cancel the upload at any time and it wont effect data.
		- I decided not to use a networking framework for this project. I used iOS APIs instead.

# Caveats
	- There is no automatic migration / upgrade of Core Data.
	- Does not support horizontal orientations (couldn't get it perfect in time!).
	- All images used are rasterized PNG's and not vector formats.