import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kiroku_notes_app/screens/login_screen.dart';
import '../../screens/profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 16),
                Text(
                  "Application Settings",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  "Update your settings like Account & Privacy, Application Preferences, Data & Notes, notifications, etc.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ProfileMenuCard(
                  svgSrc: editProfileIcon,
                  title: "Profile Information",
                  subTitle: "Change your account information & Privacy",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
                ProfileMenuCard(
                  svgSrc: changePasswordIcon,
                  title: "Change Password",
                  subTitle: "Change your password",
                  press: () {},
                ),
                ProfileMenuCard(
                  svgSrc: appPreferencesIcon,
                  title: "Application Preferences",
                  subTitle: "Change themes, Language, Text Size, etc.",
                  press: () {},
                ),
                ProfileMenuCard(
                  svgSrc: dataNotesIcon,
                  title: "Data & Notes",
                  subTitle:
                      "Backup & Restore Data, Auto sync, Manage Storage, etc.",
                  press: () {},
                ),
                ProfileMenuCard(
                  svgSrc: notificationsIcon,
                  title: "notifications",
                  subTitle:
                      "Daily Activity Reminder, Medical Schedule Notification, Urgent Alerts",
                  press: () {},
                ),
                ProfileMenuCard(
                  svgSrc: aboutIcon,
                  title: "Help & About App",
                  subTitle:
                      "Help Center / FAQ, Report Issues / Suggestions, etc.",
                  press: () {},
                ),
                ProfileMenuCard(
                  svgSrc: logoutIcon,
                  title: "Log Out",
                  subTitle: "Log out from this app",
                  press: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.bottomSlide,
                      title: 'Log Out',
                      desc: 'Are you sure you want to log out?',
                      dialogBorderRadius: BorderRadius.circular(20),
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      width:
                          MediaQuery.of(context).size.width > 600 ? 400 : null,
                    ).show();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({
    super.key,
    this.title,
    this.subTitle,
    this.svgSrc,
    this.press,
  });

  final String? title, subTitle, svgSrc;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: press,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              SvgPicture.string(
                svgSrc!,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  const Color(0xFF010F07).withOpacity(0.64),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subTitle!,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF010F07).withOpacity(0.54),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_outlined, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

const editProfileIcon =
    '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M12 12c2.7 0 5-2.3 5-5s-2.3-5-5-5-5 2.3-5 5 2.3 5 5 5Zm0 2c-3.3 0-10 1.7-10 5v3h20v-3c0-3.3-6.7-5-10-5Z" fill="#757575"/>
</svg>
''';

const changePasswordIcon = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M12 17a2 2 0 1 0 0-4 2 2 0 0 0 0 4Zm6-10h-1V5a3 3 0 0 0-6 0v2H6a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2Zm-6-2a1 1 0 0 1 2 0v2h-2V5Z" fill="#757575"/>
</svg>
''';

const appPreferencesIcon = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill="#757575" d="M19.43 12.98c.04-.32.07-.66.07-1s-.03-.68-.07-1l2.11-1.65a.5.5 0 0 0 .11-.64l-2-3.46a.5.5 0 0 0-.6-.22l-2.49 1a7.025 7.025 0 0 0-1.73-1l-.38-2.65A.5.5 0 0 0 14 2h-4a.5.5 0 0 0-.5.42l-.38 2.65a7.02 7.02 0 0 0-1.73 1l-2.49-1a.5.5 0 0 0-.6.22l-2 3.46a.5.5 0 0 0 .11.64L4.57 11c-.04.32-.07.66-.07 1s.03.68.07 1l-2.11 1.65a.5.5 0 0 0-.11.64l2 3.46c.14.24.43.34.69.22l2.49-1c.53.42 1.11.76 1.73 1l.38 2.65c.05.26.26.45.5.45h4c.24 0 .45-.19.5-.45l.38-2.65c.62-.24 1.2-.58 1.73-1l2.49 1c.26.12.55.02.69-.22l2-3.46a.5.5 0 0 0-.11-.64l-2.11-1.65ZM12 15.5a3.5 3.5 0 1 1 0-7 3.5 3.5 0 0 1 0 7Z"/>
</svg>
''';

const dataNotesIcon = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill="#757575" d="M17 2H7a2 2 0 0 0-2 2v16c0 .55.45 1 1 1h12a1 1 0 0 0 1-1V4a2 2 0 0 0-2-2Zm0 18H7V4h10v16Zm-2-7H9v-2h6v2Zm0-4H9V7h6v2Zm0 8H9v-2h6v2Z"/>
</svg>
''';

const notificationsIcon = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M12 2a7 7 0 0 0-7 7v4.1L4 15v1h16v-1l-1-1.9V9a7 7 0 0 0-7-7Zm0 20a2 2 0 0 0 2-2h-4a2 2 0 0 0 2 2Z" fill="#757575"/>
</svg>
''';

const aboutIcon = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M11 7h2v2h-2V7Zm1-5a10 10 0 1 0 0 20 10 10 0 0 0 0-20Zm1 16h-2v-6h2v6Z" fill="#757575"/>
</svg>
''';

const logoutIcon = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M15.536 8.464a1 1 0 0 0-1.414 1.414L16.172 12l-2.05 2.122a1 1 0 1 0 1.414 1.414l3.243-3.243a1 1 0 0 0 0-1.414l-3.243-3.243ZM12 4a1 1 0 0 1 1 1v3h-2V6H6v12h5v-2h2v3a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1h7Z" fill="#757575"/>
</svg>
''';
