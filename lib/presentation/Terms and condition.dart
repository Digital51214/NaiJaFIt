import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  late final Animation<Offset> _introSlide;
  late final Animation<double> _introFade;

  late final Animation<Offset> _bodySlide;
  late final Animation<double> _bodyFade;

  late final Animation<Offset> _moreSlide;
  late final Animation<double> _moreFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.20, curve: Curves.easeOutCubic),
      ),
    );
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.20, curve: Curves.easeOut),
      ),
    );

    _introSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.45, curve: Curves.easeOutCubic),
      ),
    );
    _introFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.45, curve: Curves.easeOut),
      ),
    );

    _bodySlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.75, curve: Curves.easeOutCubic),
      ),
    );
    _bodyFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
      ),
    );

    _moreSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.00, curve: Curves.easeOutCubic),
      ),
    );
    _moreFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.00, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Title widget ──────────────────────────────────────────────────────────
  Widget _buildTitle(String title, double screenWidth) {
    return Text(
      title,
      style: TextStyle(
        fontSize: screenWidth * 0.06,
        fontFamily: "semibold",
        fontWeight: FontWeight.w700,
        color: Colors.black,
        height: 1.3,
      ),
    );
  }

  // ── Body paragraph widget ─────────────────────────────────────────────────
  Widget _buildParagraph(String text, double screenWidth) {
    return Text(
      text,
      style: TextStyle(
        fontSize: screenWidth * 0.043,
        fontFamily: "medium",
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF2B2B2B),
      ),
    );
  }

  // ── Section = title + gap + body ──────────────────────────────────────────
  Widget _buildSection({
    required String title,
    required String body,
    required double screenWidth,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(title, screenWidth),
        SizedBox(height: screenWidth * 0.02),
        _buildParagraph(body, screenWidth),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.045),

              // ── Header ──────────────────────────────────────────────────
              SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 13.5.w,
                          height: 13.5.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDDE5DB),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Color(0xFF0A8A2A),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      const Expanded(
                        child: Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            fontFamily: "semibold",
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Container(
                        height: screenHeight * 0.08,
                        width: screenWidth * 0.18,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage("assets/images/LOGO.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // ── Scrollable content ──────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Updated date (no title needed)
                      SlideTransition(
                        position: _introSlide,
                        child: FadeTransition(
                          opacity: _introFade,
                          child: _buildParagraph(
                            "Updated at February 5th, 2026",
                            screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // General Terms
                      SlideTransition(
                        position: _introSlide,
                        child: FadeTransition(
                          opacity: _introFade,
                          child: _buildSection(
                            title: "General Terms",
                            body:
                            "By accessing and placing an order with NaijaFit, you confirm that you are in agreement with and bound by the terms of service contained in the Terms & Conditions outlined below. These terms apply to the entire website and any email or other type of communication between you and NaijaFit.\n\n"
                                "Under no circumstances shall NaijaFit team be liable for any direct, indirect, special, incidental or consequential damages, including, but not limited to, loss of data or profit, arising out of the use, or the inability to use, the materials on this site, even if NaijaFit team or an authorized representative has been advised of the possibility of such damages. If your use of materials from this site results in the need for servicing, repair or correction of equipment or data, you assume any costs thereof.\n\n"
                                "NaijaFit will not be responsible for any outcome that may occur during the course of usage of our resources. We reserve the rights to change prices and revise the resources usage policy in any moment.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // License
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "License",
                            body:
                            "NaijaFit grants you a revocable, non-exclusive, non-transferable, limited license to download, install and use the app strictly in accordance with the terms of this Agreement.\n\n"
                                "These Terms & Conditions are a contract between you and NaijaFit (referred to in these Terms & Conditions as \"NaijaFit\", \"us\", \"we\" or \"our\"), the provider of the NaijaFit website and the services accessible from the NaijaFit website (which are collectively referred to in these Terms & Conditions as the \"NaijaFit Service\").\n\n"
                                "You are agreeing to be bound by these Terms & Conditions. If you do not agree to these Terms & Conditions, please do not use the NaijaFit Service. In these Terms & Conditions, \"you\" refers both to you as an individual and to the entity you represent. If you violate any of these Terms & Conditions, we reserve the right to cancel your account or block access to your account without notice.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Definitions
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Definitions and Key Terms",
                            body:
                            "To help explain things as clearly as possible in this Terms & Conditions, every time any of these terms are referenced, are strictly defined as:\n\n"
                                "Cookie: small amount of data generated by a website and saved by your web browser. It is used to identify your browser, provide analytics, remember information about you such as your language preference or login information.\n\n"
                                "Company: when this terms mention \"Company\", \"we\", \"us\", or \"our\", it refers to Latom Suites Inc, (10508 107 Ave NW, Edmonton AB T5H 2X9), that is responsible for your information under this Terms & Conditions.\n\n"
                                "Country: where NaijaFit or the owners/founders of NaijaFit are based, in this case is Canada.\n\n"
                                "Device: any internet connected device such as a phone, tablet, computer or any other device that can be used to visit NaijaFit and use the services.\n\n"
                                "Service: refers to the service provided by NaijaFit as described in the relative terms (if available) and on this platform.\n\n"
                                "Third-party service: refers to advertisers, contest sponsors, promotional and marketing partners, and others who provide our content or whose products or services we think may interest you.\n\n"
                                "App/Application: NaijaFit app, refers to the SOFTWARE PRODUCT identified above.\n\n"
                                "You: a person or entity that is registered with NaijaFit to use the Services.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Restrictions
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Restrictions",
                            body:
                            "You agree not to, and you will not permit others to:\n\n"
                                "• License, sell, rent, lease, assign, distribute, transmit, host, outsource, disclose or otherwise commercially exploit the app or make the platform available to any third party.\n\n"
                                "• Modify, make derivative works of, disassemble, decrypt, reverse compile or reverse engineer any part of the app.\n\n"
                                "• Remove, alter or obscure any proprietary notice (including any notice of copyright or trademark) of NaijaFit or its affiliates, partners, suppliers or the licensors of the app.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Payment
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Payment",
                            body:
                            "If you register to any of our recurring payment plans, you agree to pay all fees or charges to your account for the Service in accordance with the fees, charges and billing terms in effect at the time that each fee or charge is due and payable. Unless otherwise indicated in an order form, you must provide NaijaFit with a valid credit card (Visa, MasterCard, or any other issuer accepted by us) as a condition to signing up for the Premium plan.\n\n"
                                "By providing NaijaFit with your credit card number and associated payment information, you agree that NaijaFit is authorized to verify information immediately, and subsequently invoice your account for all fees and charges due and payable to NaijaFit hereunder and that no additional notice or consent is required. You agree to immediately notify NaijaFit of any change in your billing address or the credit card used for payment hereunder.\n\n"
                                "Any attorney fees, court costs, or other costs incurred in collection of delinquent undisputed amounts shall be the responsibility of and paid for by you.\n\n"
                                "No contract will exist between you and NaijaFit for the Service until NaijaFit accepts your order by a confirmatory e-mail, SMS/MMS message, or other appropriate means of communication.\n\n"
                                "You are responsible for any third-party fees that you may incur when using the Service.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Return and Refund
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Return and Refund Policy",
                            body:
                            "Thanks for shopping at NaijaFit. We appreciate the fact that you like to buy the stuff we build. We also want to make sure you have a rewarding experience while you're exploring, evaluating, and purchasing our products.\n\n"
                                "If, for any reason, you are not completely satisfied with any good or service that we provide, don't hesitate to contact us and we will discuss any of the issues you are going through with our product.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Your Suggestions
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Your Suggestions",
                            body:
                            "Any feedback, comments, ideas, improvements or suggestions (collectively, \"Suggestions\") provided by you to NaijaFit with respect to the app shall remain the sole and exclusive property of NaijaFit.\n\n"
                                "NaijaFit shall be free to use, copy, modify, publish, or redistribute the Suggestions for any purpose and in any way without any credit or any compensation to you.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Your Consent
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Your Consent",
                            body:
                            "We've updated our Terms & Conditions to provide you with complete transparency into what is being set when you visit our site and how it's being used. By using our app, registering an account, or making a purchase, you hereby consent to our Terms & Conditions.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Links to Other Websites
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Links to Other Websites",
                            body:
                            "This Terms & Conditions applies only to the Services. The Services may contain links to other websites not operated or controlled by NaijaFit. We are not responsible for the content, accuracy or opinions expressed in such websites, and such websites are not investigated, monitored or checked for accuracy or completeness by us.\n\n"
                                "Please remember that when you use a link to go from the Services to another website, our Terms & Conditions are no longer in effect. Your browsing and interaction on any other website, including those that have a link on our platform, is subject to that website's own rules and policies.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Cookies
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Cookies",
                            body:
                            "NaijaFit uses \"Cookies\" to identify the areas of our app that you have visited. A Cookie is a small piece of data stored on your computer or mobile device by your web browser. We use Cookies to enhance the performance and functionality of our app but are non-essential to their use. However, without these cookies, certain functionality like videos may become unavailable or you would be required to enter your login details every time you visit the app.\n\n"
                                "Most web browsers can be set to disable the use of Cookies. However, if you disable Cookies, you may not be able to access functionality on our app correctly or at all. We never place Personally Identifiable Information in Cookies.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Changes to Terms
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Changes To Our Terms & Conditions",
                            body:
                            "You acknowledge and agree that NaijaFit may stop (permanently or temporarily) providing the Service (or any features within the Service) to you or to users generally at NaijaFit's sole discretion, without prior notice to you. You may stop using the Service at any time. You do not need to specifically inform NaijaFit when you stop using the Service.\n\n"
                                "If we decide to change our Terms & Conditions, we will post those changes on this page, and/or update the Terms & Conditions modification date below.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Modifications to App
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Modifications to Our App",
                            body:
                            "NaijaFit reserves the right to modify, suspend or discontinue, temporarily or permanently, the app or any service to which it connects, with or without notice and without liability to you.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Updates to App
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Updates to Our App",
                            body:
                            "NaijaFit may from time to time provide enhancements or improvements to the features/functionality of the app, which may include patches, bug fixes, updates, upgrades and other modifications (\"Updates\").\n\n"
                                "Updates may modify or delete certain features and/or functionalities of the app. You agree that NaijaFit has no obligation to (i) provide any Updates, or (ii) continue to provide or enable any particular features and/or functionalities of the app to you.\n\n"
                                "You further agree that all Updates will be (i) deemed to constitute an integral part of the app, and (ii) subject to the terms and conditions of this Agreement.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Third-Party Services
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Third-Party Services",
                            body:
                            "We may display, include or make available third-party content (including data, information, applications and other products services) or provide links to third-party websites or services (\"Third-Party Services\").\n\n"
                                "You acknowledge and agree that NaijaFit shall not be responsible for any Third-Party Services, including their accuracy, completeness, timeliness, validity, copyright compliance, legality, decency, quality or any other aspect thereof. NaijaFit does not assume and shall not have any liability or responsibility to you or any other person or entity for any Third-Party Services.\n\n"
                                "Third-Party Services and links thereto are provided solely as a convenience to you and you access and use them entirely at your own risk and subject to such third parties' terms and conditions.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Term and Termination
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Term and Termination",
                            body:
                            "This Agreement shall remain in effect until terminated by you or NaijaFit.\n\n"
                                "NaijaFit may, in its sole discretion, at any time and for any or no reason, suspend or terminate this Agreement with or without prior notice.\n\n"
                                "This Agreement will terminate immediately, without prior notice from NaijaFit, in the event that you fail to comply with any provision of this Agreement. You may also terminate this Agreement by deleting the app and all copies thereof from your computer.\n\n"
                                "Upon termination of this Agreement, you shall cease all use of the app and delete all copies of the app from your computer.\n\n"
                                "Termination of this Agreement will not limit any of NaijaFit's rights or remedies at law or in equity in case of breach by you (during the term of this Agreement) of any of your obligations under the present Agreement.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Copyright Infringement
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Copyright Infringement Notice",
                            body:
                            "If you are a copyright owner or such owner's agent and believe any material on our app constitutes an infringement on your copyright, please contact us setting forth the following information: (a) a physical or electronic signature of the copyright owner or a person authorized to act on his behalf; (b) identification of the material that is claimed to be infringing; (c) your contact information, including your address, telephone number, and an email; (d) a statement by you that you have a good faith belief that use of the material is not authorized by the copyright owners; and (e) a statement that the information in the notification is accurate, and, under penalty of perjury you are authorized to act on behalf of the owner.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Indemnification
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Indemnification",
                            body:
                            "You agree to indemnify and hold NaijaFit and its parents, subsidiaries, affiliates, officers, employees, agents, partners and licensors (if any) harmless from any claim or demand, including reasonable attorneys' fees, due to or arising out of your: (a) use of the app; (b) violation of this Agreement or any law or regulation; or (c) violation of any right of a third party.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // No Warranties
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "No Warranties",
                            body:
                            "The app is provided to you \"AS IS\" and \"AS AVAILABLE\" and with all faults and defects without warranty of any kind. To the maximum extent permitted under applicable law, NaijaFit expressly disclaims all warranties, whether express, implied, statutory or otherwise, with respect to the app, including all implied warranties of merchantability, fitness for a particular purpose, title and non-infringement.\n\n"
                                "Without limiting the foregoing, neither NaijaFit nor any NaijaFit's provider makes any representation or warranty of any kind, express or implied: (i) as to the operation or availability of the app; (ii) that the app will be uninterrupted or error-free; (iii) as to the accuracy, reliability, or currency of any information or content provided through the app; or (iv) that the app, its servers, the content, or e-mails sent from or on behalf of NaijaFit are free of viruses, scripts, trojan horses, worms, malware, timebombs or other harmful components.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Limitation of Liability
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Limitation of Liability",
                            body:
                            "Notwithstanding any damages that you might incur, the entire liability of NaijaFit and any of its suppliers under any provision of this Agreement and your exclusive remedy for all of the foregoing shall be limited to the amount actually paid by you for the app.\n\n"
                                "To the maximum extent permitted by applicable law, in no event shall NaijaFit or its suppliers be liable for any special, incidental, indirect, or consequential damages whatsoever (including, but not limited to, damages for loss of profits, for loss of data or other information, for business interruption, for personal injury, for loss of privacy arising out of or in any way related to the use of or inability to use the app), even if NaijaFit or any supplier has been advised of the possibility of such damages.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Severability
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Severability",
                            body:
                            "If any provision of this Agreement is held to be unenforceable or invalid, such provision will be changed and interpreted to accomplish the objectives of such provision to the greatest extent possible under applicable law and the remaining provisions will continue in full force and effect.\n\n"
                                "YOU AND NaijaFit AGREE THAT ANY CAUSE OF ACTION ARISING OUT OF OR RELATED TO THE SERVICES MUST COMMENCE WITHIN ONE (1) YEAR AFTER THE CAUSE OF ACTION ACCRUES. OTHERWISE, SUCH CAUSE OF ACTION IS PERMANENTLY BARRED.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Waiver
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Waiver",
                            body:
                            "Except as provided herein, the failure to exercise a right or to require performance of an obligation under this Agreement shall not effect a party's ability to exercise such right or require such performance at any time thereafter nor shall be the waiver of a breach constitute waiver of any subsequent breach.\n\n"
                                "No failure to exercise, and no delay in exercising, on the part of either party, any right or any power under this Agreement shall operate as a waiver of that right or power. In the event of a conflict between this Agreement and any applicable purchase or other terms, the terms of this Agreement shall govern.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Amendments
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Amendments to this Agreement",
                            body:
                            "NaijaFit reserves the right, at its sole discretion, to modify or replace this Agreement at any time. If a revision is material we will provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.\n\n"
                                "By continuing to access or use our app after any revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, you are no longer authorized to use NaijaFit.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Intellectual Property
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Intellectual Property",
                            body:
                            "The app and its entire contents, features and functionality (including but not limited to all information, software, text, displays, images, video and audio, and the design, selection and arrangement thereof), are owned by NaijaFit, its licensors or other providers of such material and are protected by Canada and international copyright, trademark, patent, trade secret and other intellectual property or proprietary rights laws.\n\n"
                                "The material may not be copied, modified, reproduced, downloaded or distributed in any way, in whole or in part, without the express prior written permission of NaijaFit, unless and except as is expressly provided in these Terms & Conditions. Any unauthorized use of the material is prohibited.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Agreement to Arbitrate
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Agreement to Arbitrate",
                            body:
                            "This section applies to any dispute except it does not include a dispute relating to claims for injunctive or equitable relief regarding the enforcement or validity of your or NaijaFit's intellectual property rights. The term \"dispute\" means any dispute, action, or other controversy between you and NaijaFit concerning the Services or this agreement, whether in contract, warranty, tort, statute, regulation, ordinance, or any other legal or equitable basis.\n\n"
                                "Notice of Dispute\n"
                                "In the event of a dispute, you or NaijaFit must give the other a Notice of Dispute, which is a written statement that sets forth the name, address, and contact information of the party giving it, the facts giving rise to the dispute, and the relief requested. You must send any Notice of Dispute via email to: hello@naijafit.com. You and NaijaFit will attempt to resolve any dispute through informal negotiation within sixty (60) days from the date the Notice of Dispute is sent. After sixty (60) days, you or NaijaFit may commence arbitration.\n\n"
                                "Binding Arbitration\n"
                                "If you and NaijaFit don't resolve any dispute by informal negotiation, any other effort to resolve the dispute will be conducted exclusively by binding arbitration as described in this section. You are giving up the right to litigate (or participate in as a party or class member) all disputes in court before a judge or jury. The dispute shall be settled by binding arbitration in accordance with the commercial arbitration rules of the American Arbitration Association.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Promotions
                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildSection(
                            title: "Promotions",
                            body:
                            "NaijaFit may, from time to time, include contests, promotions, sweepstakes, or other activities (\"Promotions\") that require you to submit material or information concerning yourself. Please note that all Promotions may be governed by separate rules that may contain certain eligibility requirements, such as restrictions as to age and geographic location. You are responsible to read all Promotions rules to determine whether or not you are eligible to participate.\n\n"
                                "Typographical Errors\n"
                                "In the event a product and/or service is listed at an incorrect price or with incorrect information due to typographical error, we shall have the right to refuse or cancel any orders placed for the product and/or service listed at the incorrect price. If your credit card has already been charged for the purchase and your order is canceled, we shall immediately issue a credit to your credit card account or other payment account in the amount of the charge.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Disclaimer
                      SlideTransition(
                        position: _moreSlide,
                        child: FadeTransition(
                          opacity: _moreFade,
                          child: _buildSection(
                            title: "Disclaimer",
                            body:
                            "NaijaFit is not responsible for any content, code or any other imprecision.\n\n"
                                "NaijaFit does not provide warranties or guarantees.\n\n"
                                "In no event shall NaijaFit be liable for any special, direct, indirect, consequential, or incidental damages or any damages whatsoever, whether in an action of contract, negligence or other tort, arising out of or in connection with the use of the Service or the contents of the Service. The Company reserves the right to make additions, deletions, or modifications to the contents on the Service at any time without prior notice.\n\n"
                                "The NaijaFit Service and its contents are provided \"as is\" and \"as available\" without any warranty or representations of any kind, whether express or implied. Without limiting the foregoing, NaijaFit does not warrant that the NaijaFit Service will be uninterrupted, uncorrupted, timely, or error-free.",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      // Contact Us
                      SlideTransition(
                        position: _moreSlide,
                        child: FadeTransition(
                          opacity: _moreFade,
                          child: _buildSection(
                            title: "Contact Us",
                            body:
                            "Don't hesitate to contact us if you have any questions.\n\n"
                                "Via Email: hello@naijafit.com",
                            screenWidth: screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}