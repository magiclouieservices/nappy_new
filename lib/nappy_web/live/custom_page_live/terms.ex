defmodule NappyWeb.CustomPageLive.Terms do
  use NappyWeb, :live_view

  alias NappyWeb.Components.CustomPageComponent

  def render(assigns) do
    ~H"""
    <div class="container mx-auto py-24">
      <h1 class="text-center font-tiempos-bold text-5xl">
        Terms & Conditions
      </h1>
      <article class="grid grid-cols-12 place-items-start gap-2 mt-24">
        <div class="cols-span-2 invisible"></div>
        <CustomPageComponent.sidebar socket={@socket} action={assigns.live_action} />
        <div class="col-span-6 leading-loose text-lg font-light">
          <p>
            These Terms of Use hereinafter referred to as “TOU” constitute a legally binding agreement made between you, whether personally or on behalf of an entity (“you or user or visitor”) and (“Nappy, we,” “us” or “our”), concerning your access to and use of
            <a href={Routes.home_index_path(@socket, :index)} class="underline">www.nappy.co</a> <span class="text-indigo-600 underline">(the “Website”)</span>. You agree that by accessing the Site, you have read, understood, and agree to be bound by the TOU.
          </p>
          <p class="mt-4">
            IF YOU DO NOT AGREE WITH THE TOU, THEN YOU ARE EXPRESSLY PROHIBITED FROM USING THE WEBSITE AND YOU MUST DISCONTINUE USE IMMEDIATELY.
          </p>
          <p class="mt-4">
            Supplemental TOU or documents that may be posted on the Site from time to time are hereby expressly incorporated herein by reference. We reserve the right, in our sole discretion, to make changes or modifications to these TOU at any time and for any reason.  We will alert you about any changes by updating the “Last updated” date of these TOU and you waive any right to receive specific notice of each such change.  It is your responsibility to periodically review these TOU to stay informed of updates.  You will be subject to, and will be deemed to have been made aware of and to have accepted, the changes in any revised TOU by your continued use of the Site after the date such revised Terms are posted.
          </p>
          <p class="mt-4">
            1. <span class="ml-4">YOUR CONSENT TO OTHER AGREEMENTS</span>
          </p>
          <p>
            When you intend to use a special feature of this Site, you may be asked to agree to special terms governing your use of the special feature. In such cases, you may be asked to expressly consent to the special terms, for example, by checking a box or clicking on a button marked “I agree.” This type of agreement is known as a “click-through” agreement. If any of the terms of the click-through agreement are different than the TOU, the terms of the click-through agreement will supplement or amend the TOU, but only with respect to the matters governed by the “click-through agreement.”
          </p>
          <p class="mt-4">
            2. <span class="ml-4">APPLICABILITY</span>
          </p>
          <p>
            "These general terms and conditions (the "Conditions") apply to:
            <ul>
              <li>
                (a)
                <span class="ml-4">
                  The use of any information, pictures, documents and/or other services offered by our website;
                </span>
              </li>
              <li>
                (b)
                <span class="ml-4">
                  The submission, downloading and donations to any photographs posted on the site.
                </span>
              </li>
            </ul>
          </p>
          <p class="mt-4">
            3. <span class="ml-4">ACCOUNT.</span>
            <p class="mt-4">
              You have the option of creating a user account on our Website so that you can use the additional functions of the Website, in particular for uploading photos, creating lists, following other users, and more. The opening of a user account can only take place with the agreement to the TOU.
            </p>

            <p class="mt-4">
              Upon registration, NAPPY and you enter into a contract for the use of the Website and the Services. There is no claim to the conclusion of this contract. NAPPY is entitled to refuse your registration without providing reasons.
            </p>

            <p class="mt-4">
              You may only register with NAPPY if you are 18 years of age or if you act with the consent of your parents or guardian to register under these Terms. NAPPY reserves the right to verify the consent of your parents or guardian. Therefore, you must provide an e-mail address of your parents or guardian when you register, so that we can obtain a declaration of consent from your parents or guardian.
            </p>

            <p class="mt-4">
              When you create an account with us, you must provide us with the information and data requested by NAPPY that is accurate, complete, and current at all times. If your data changes after registration, you are obliged to correct the information in your account immediately.
            </p>

            <p class="mt-4">
              You may not use as a username the name of another person or entity or that is not lawfully available for use, a name or trademark that is subject to any rights of another person or entity other than you without authorization, or a name that is otherwise offensive, vulgar or obscene.
            </p>

            <p class="mt-4">
              You are responsible for safeguarding the password that you use to access the Service and for any activities or actions under your password, whether your password is with our Service or a third-party service. If you are not responsible for the misuse of your member account, you are not liable. You agree not to disclose your password to any third party. You must notify us immediately at
              <a href="mailto:hi@nappy.co" class="underline text-indigo-600">hi@nappy.co</a>
              upon becoming aware of any breach of security or unauthorized use of your account.
            </p>
          </p>
          <p class="mt-4">
            4. <span class="ml-4">USER CONTENT</span>
            <p class="mt-4">
              When you upload any Content (photographs, videos or other resource materials) to the Website, you grant us a worldwide, non-exclusive, permanently, irrevocable, royalty-free license (with the right to sublicense) to reproduce, adapt and modify (incl. translation), distribute, publicly perform, publicly display, broadcast, make available, store and archive and otherwise use such Content (in whole or in part) on and through the Service.
            </p>
            <p class="mt-4">
              You acknowledge and confirm that your Content will be made available to the public on and through the Service for personal and commercial use of third parties subject to these Terms without an obligation to provide you attribution or compensation.
            </p>
            <p class="mt-4">
              You may not upload, post or transmit any Content that:
            </p>
            <ul class="list-disc pl-4">
              <li>
                Infringes any third party’s copyrights or other intellectual property rights, contract rights or any other rights of any person;
              </li>
              <li>
                Contains any pornographic, racist, defamatory, libelous or otherwise immoral, vulgar or obscene content;
              </li>
              <li>
                Depicts unlawful or violent, hateful or threatening or otherwise inappropriate acts;
              </li>
              <li>
                Offends, defames, harasses or otherwise damages NAPPY or any third party;
              </li>
              <li>
                Violates any law, statute, or regulation.
              </li>
              <li>
                We reserve the right to remove any Content at any time if we believe it’s defective, of poor quality, or in violation of the aforementioned Terms.
              </li>
            </ul>
            <p class="mt-4">
              You represent and warrant that: (i) under copyright law the Content is owned by you or you have the right to use it and grant us the rights and license as provided in these Terms, and (ii) NAPPY will not need to obtain licenses from any third party or pay a compensation or royalties to any third party with respect to the Content; (iii) your Content does not infringe any third party rights (including in particular copyrights, neighboring rights, intellectual property rights, name rights, right of personality, rights of privacy, data rights or other property rights), and (iv) your Content complies with these Terms and all applicable laws.
            </p>
            <p class="mt-4">
              When you upload any Content to the Website you also authorize us under your copyrights to enforce any violations of the sublicense we grant in the Content to others. In other words, NAPPY is entitled to take appropriate measures to pursue the rights granted to us hereunder. You shall support us in the court or non-court assertion of the acquired rights, in particular by providing information, providing the necessary original documents and other documents, making or having made the necessary assignment of rights to NAPPY, as well as preparing any further declarations or documents which should be required or useful for the realization of the license granted by you to NAPPY.
            </p>
          </p>
          <p class="mt-4">
            5. <span class="ml-4">USER LICENSE & DONATIONS</span>
            <p class="mt-4">
              All photos posted on the Website are licensed under the Creative Commons Zero (CC0) license. That means you can download these photos, modify them, share them, distribute them, or use them for whatever you want for free. In fact, we encourage it. The more you use them, the more we’re helping improve the representation of black and brown people in media.
            </p>
            <p class="mt-4">
              You do not need permission nor do you need to give photo credit when using these photos, however, we strongly recommend it. Use the format below to give photo credit:
            </p>
            <p class="mt-4">
              <em>
                i.e. Photo by @username from
                <a href={Routes.home_index_path(@socket, :index)} class="underline">nappy.co</a>
                (replace @username with the photographer’s username found on the photo page).
              </em>
            </p>
            <p class="mt-4">
              You should refrain from reselling these photos, re-posting on other stock photo website/services, or using these photos to degrade or insult its subjects.
            </p>
            <p class="mt-4">
              Some of the Content made available for download on the Service is subject to and licensed under the Creative Commons Zero (CC0) license ("CC0 Content"). The CC0 Content on the Service is marked with the reference "CC0 License" next to the respective picture / content made available for download. This means that to the greatest extent permitted by applicable law, the authors of the of work have dedicated the work to the public domain by waiving all of his or her rights to the CC0 Content worldwide under copyright law, including all related and neighboring rights. Subject to the
              <a
                href="https://creativecommons.org/publicdomain/zero/1.0/legalcode"
                target="_blank"
                rel="noopener noreferer nofollow"
                class="underline"
              >
                CC0 License Terms
              </a>
              the CC0 Content can be used for all personal and commercial purposes without attributing the author/ content owner of the CC0 Content or Nappy.
            </p>
            <p class="mt-4">
              Be aware that the patent or trademark rights of any person, nor the rights that other persons may have in the CC0 Content or in how the CC0 Content is used, such as publicity or privacy rights, are not affected by CC0. Therefore, depending on the intended use of the CC0 Content (in particular commercial purposes), in the case of the depiction of identifiable people, logos, trademark or copyrightable work depicted in the CC0 Content, you therefore may still need the permission or consent from third parties.
            </p>
            <p class="mt-4">
              Furthermore, when using the CC0 Content, you may not imply endorsement of products and services by the author of the CC0-Content and/or any person, company or brand depicted in the CC0-Content.
            </p>
            <p class="mt-4">
              THE LICENSE GRANTED TO YOU UNDER THIS TERMS ALLOWS YOU TO MAKE USE OF THE SERVICE FOR FREE. HOWEVER, WE ENCOURAGE DONATIONS CHANNELED TO THE PHOTOGRAPHERS WHO UPLOAD THESE CONTENTS FOR YOUR USAGE. YOU CAN MAKE YOUR DONATIONS WITH THE USE OF PAYPAL.
            </p>
          </p>
          <p class="mt-4">
            6. <span class="ml-4">INTELLECTUAL PROPERTY; LICENSE TO USERS</span>
            <p class="mt-4">
              Subject to your compliance with these Terms, you may access and use the Website and Service. The Website and the Service are protected by copyright, trademark and/or other protective rights and are subject to copyright law and other protective laws ("Nappy Rights"). Nappy is the rightful owner or licensee of all rights to the Website and the Service. With the exception of the use of the Website and Service in accordance with these Terms, use of Nappy Rights is only permitted with the prior written consent of Nappy. Except for certain sponsored content (i.e. content from partners that you can buy from them by getting redirected to their website, hereinafter "Sponsored Content"), all Content made available for download on the Service can be used for free for personal and/or commercial purposes subject to some limitations as set out in these Terms. It is not required, but you can credit the photographer or owner of the Content or Nappy.
            </p>
          </p>
          <p class="mt-4">
            7. <span class="ml-4">YOUR ACCEPTANCE OF OUR PRIVACY POLICY</span>
            <p class="mt-4">
              By agreeing to the TOU, you agree to the terms of our Privacy Policy which is expressly incorporated herein. Before using this Site, please carefully review how we obtain your personal data.
            </p>
            <p class="mt-4">
              While providing our services we may collect the “Personal Information” which is defined as any information that identifies or can be used to identify, contact, or locate the person to whom such information pertains. Namely, we may collect:
            </p>
            <ul class="list-disc pl-4">
              <li>
                Identity information: such as the Name of the User
              </li>
              <li>
                Contact information: email address.
              </li>
              <li>
                User Submissions: We would also obtain information from you when you submit Content on the site. Such information would entail your user submissions, email address and a Link to your Instagram Profile.
              </li>
              <li>
                Any Other information you may provide to us when you fill out a form on our website.
              </li>
            </ul>
            <p class="mt-4">
              Therefore, we are committed to maintaining the trust and confidence of all visitors to our website. In particular, we want you to know that the website is not in the business of selling, renting or trading email lists with other companies and businesses for marketing purposes.
            </p>

            <p class="mt-4">
              We believe your business is no one else’s. Your Privacy is important to you and to us. So, we’ll protect the information you share with us. To protect your privacy, NAPPY follows different principles in accordance with worldwide practices for customer privacy and data protection.
            </p>

            <p class="mt-4">
              In accordance with effective regulations you have a significant number of rights related to your Personal Information, such as e.g.:
            </p>
            <ul class="list-disc pl-4">
              <li>
                Right to access. You have the right to request access to your personal data and may obtain from us the confirmation as to whether or not personal data concerning you is being processed. You are entitled to view, amend, or delete the personal information that we hold. Email your request to us at hi@nappy.co and we will work with you to remove any of your personal data we may have.
              </li>
              <li>
                Right to rectify your inaccurate Personal Information and to have incomplete personal data completed, including by means of providing a supplementary statement
              </li>
              <li>
                Right to erase your Personal Information. Please note that a request to erase your Personal Information will also terminate your account on the Site. We will automatically and without undue delay erase your Personal Information when it is no longer necessary in relation to the purposes for which it was collected or otherwise processed;
              </li>
              <li>
                Right to restrict processing of your Personal Information;
              </li>
              <li>
                Right to data portability. You may obtain from us the personal data concerning you and which you have provided to us and transmit it to another Personal Information Controller;
              </li>
              <li>
                Right to object to processing of Your Personal Information,
              </li>
              <li>
                Right to withdraw your consent to the usage of your Personal Information at any time
              </li>
              <li>
                Right to lodge a complaint. We take privacy concerns seriously. If you believe that we have not complied with this Privacy Policy with respect to your Personal Information, you may contact us at hi@nappy.co. We will investigate your complaint promptly and will reply you within 30 (thirty) calendar days.
              </li>
            </ul>
          </p>
          <p class="mt-4">
            8. <span class="ml-4">EXCLUSION OF LIABILITY FOR EXTERNAL LINKS</span>
            <p class="mt-4">
              The Website may provide links to external Internet sites. NAPPY hereby declares explicitly that it has no influence on the layout or content of the linked pages and dissociates itself expressly from all contents of all linked pages of third parties. NAPPY shall not be liable for the use or content of Internet sites that link to this site or which are linked from it.
            </p>
          </p>
          <p class="mt-4">
            9. <span class="ml-4">USER CONDUCT</span>
            <p class="mt-4">
              You agree that you will not violate any law, contract, intellectual property or other third party right or commit a tort, and that you are solely responsible for your conduct, while accessing or using the Website.
            </p>
            <p class="mt-4">
              You agree that you will abide by these Terms and will not: Engage in any harassing, threatening, intimidating, predatory or stalking conduct;
            </p>
            <p class="mt-4">
              You agree that you will not use or attempt to use another user’s account without authorization from such user and NAPPY.
            </p>
            <p class="mt-4">
              You agree that you will not use the Website in any manner that could interfere with, disrupt, negatively affect or inhibit other users from fully enjoying the Website or that could damage, disable, overburden or impair the functioning of the Website in any manner;
            </p>
            <p class="mt-4">
              You agree that you will not do anything that might discover source code or bypass or circumvent measures employed to prevent or limit access to any Content, area or code of the Website;
            </p>
            <p class="mt-4">
              You agree that you will not attempt to circumvent any content-filtering techniques we employ.
            </p>
            <p class="mt-4">
              You agree that you will not access any feature or area of the Website that you are not authorized to access.
            </p>
            <p class="mt-4">
              You agree that you will not develop any third-party applications that interact with the Website without our prior written consent.
            </p>
            <p class="mt-4">
              You agree not to use any robot, spider, crawler, scraper, script, browser extension, offline reader or other automated means or interface not authorized by us to access the Website, extract data or otherwise interfere with or modify the rendering of Website pages or functionality.
            </p>
            <p class="mt-4">
              You agree that you will not bypass or ignore instructions contained in the robots.txt file, that controls all automated access to the Website or Use the Website for any illegal or unauthorized purpose, or engage in, encourage or promote any activity that violates these Terms.
            </p>
          </p>
          <p class="mt-4">
            10. <span class="ml-4">DISCLAIMER OF WARRANTIES</span>
            <p class="mt-4">
              NAPPY IS PROVIDED TO YOU “AS IS”, WITHOUT WARRANTY OF ANY KIND. TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, WE DISCLAIM ALL WARRANTIES, INCLUDING, WITHOUT LIMITATION, ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT AND ANY WARRANTIES AND CONDITIONS ARISING OUT OF COURSE OF DEALING OR USAGE OF TRADE. WE DO NOT REPRESENT OR WARRANT THAT: (I) NAPPY WILL MEET YOUR REQUIREMENTS, WILL BE ERROR FREE OR THAT ANY ERRORS WILL BE CORRECTED; (II) THE OPERATION OF NAPPY WILL BE UNINTERRUPTED; OR (III) NAPPY IS OR WILL BE AVAILABLE WHERE YOU RESIDE OR IN ANY OTHER PARTICULAR LOCATION. YOUR ONLY RIGHT OR REMEDY WITH RESPECT TO ANY PROBLEMS OR DISSATISFACTION WITH NAPPY IS TO UNINSTALL AND CEASE USE OF ALL NAPPY PRODUCTS. Further and except as expressly provided herein, we are not obligated to maintain or support NAPPY, or to provide you with any updates, fix errors or any other features available therein. You acknowledge and agree that you are solely responsible for (and that we have no responsibility to you or to any third party) and assume all the responsibility and risk for your use of NAPPY and your breach of any of your representations and warranties herein contained, and for any loss or damage which we may suffer as a result of any such breach.
            </p>
          </p>
          <p class="mt-4">
            11. <span class="ml-4">LIMITATION OF LIABILITY</span>
            <p class="mt-4">
              TO THE EXTENT PERMITTED UNDER APPLICABLE LAW, UNDER NO CIRCUMSTANCES SHALL WE, OUR OFFICERS, DIRECTORS, EMPLOYEES, PARENTS, AFFILIATES, SUCCESSORS, ASSIGNS, OR LICENSORS BE LIABLE TO YOU OR ANY OTHER THIRD PARTY FOR ANY INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL, EXEMPLARY OR PUNITIVE DAMAGES OF ANY TYPE INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF GOODWILL, SERVICE INTERRUPTION, COMPUTER FAILURE OR MALFUNCTION, LOSS OF BUSINESS PROFITS, LOSS OF DATA OR BUSINESS INFORMATION, LOSS OF ADDITIONAL SOFTWARE OR COMPUTER CONFIGURATIONS OR COSTS OF PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES, DAMAGES ARISING IN CONNECTION WITH ANY USE OF NAPPY OR ANY AND ALL OTHER COMMERCIAL DAMAGES OR LOSSES, ARISING OUT OF OR IN CONNECTION WITH THESE TERMS OR THE INSTALLATION, UNINSTALLATION, USE OF OR INABILITY TO USE NAPPY UNDER ANY THEORY OF LIABILITY, INCLUDING BUT NOT LIMITED TO CONTRACT OR TORT (INCLUDING PRODUCTS LIABILITY, STRICT LIABILITY AND NEGLIGENCE), AND WHETHER OR NOT WE WERE OR SHOULD HAVE BEEN AWARE OR ADVISED OF THE POSSIBILITY OF SUCH DAMAGE AND NOTWITHSTANDING THE FAILURE OF ESSENTIAL PURPOSE OF ANY LIMITED REMEDY STATED HEREIN. NOTWITHSTANDING ANYTHING TO THE CONTRARY CONTAINED HEREIN, IN NO EVENT SHALL OUR TOTAL LIABILITY (INCLUDING OUR OFFICERS, DIRECTORS, EMPLOYEES, PARENTS, AND AFFILIATES) FOR ANY CLAIM ARISING OUT OF OR RELATED TO THESE TERMS, TO THE FULLEST EXTENT POSSIBLE UNDER APPLICABLE LAW, EXCEED $0.00 IF ANY, BY YOU FOR THE USE OF NAPPY.
            </p>
          </p>
          <p class="mt-4">
            12. <span class="ml-4">INDEMNITY</span>
            <p class="mt-4">
              You agree to defend, indemnify and hold us, our parent corporation, officers, directors, employees and agents, harmless from and against any and all claims, damages, obligations, losses, liabilities, costs and expenses (including but not limited to attorney's fees) arising from: (i) your access to or use of NAPPY; (ii) your violation of these Terms; or (iii) your violation of any third party right, including without limitation, any intellectual property right, or privacy right.
            </p>
          </p>
          <p class="mt-4">
            13. <span class="ml-4">GENERAL</span>
            <p class="mt-4">
              These Terms constitutes the entire understanding between the parties with respect to the matters referred to herein. The Section headings in these Terms are provided for convenience purpose only and have no legal or contractual significance. If any provision of these Terms is held to be unenforceable by a court of competent jurisdiction, such provision shall be enforced to the maximum extent permissible so as to affect the intent of the parties, and the remainder of these Terms shall continue in full force and effect. Our failure to enforce any rights or to take action against you in the event of any breach hereunder shall not be deemed a waiver of such rights or of subsequent actions in the event of future breaches. These Terms and any right granted herein may not be assigned by you without our prior written consent. The controlling language of these Terms is English. In the event of inconsistency or discrepancy between the English version and any other language version, the English language version shall prevail. Nothing in these Terms will be construed as creating a joint venture, partnership, employment or agency relationship between you and us, and you do not have any authority to create any obligation or make any representation on our behalf.
            </p>
          </p>
          <p class="mt-4">
            14. <span class="ml-4">GOVERNING LAW AND JURISDICTION</span>
            <p class="mt-4">
              This general terms and conditions in relation to the use of
              <a href={Routes.home_index_path(@socket, :index)} class="underline">www.nappy.co</a>
              is hereby governed by, and constructed and enforced in accordance with the laws of New York, US. The competent courts in New York, US, shall have the exclusive jurisdiction to resolve any dispute between you and NAPPY.
            </p>
          </p>
          <p class="mt-4">
            15. <span class="ml-4">Contact Us.</span>
            <p class="mt-4">
              If you have any questions (or comments) concerning these Terms, you are most welcomed to contact us at hi@nappy.co, and we will make an effort to reply within a reasonable time-frame.
            </p>
          </p>
        </div>
      </article>
    </div>
    """
  end
end
