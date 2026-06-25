import PhoneExtension.DataStructures.*
import PhoneExtension.Classes.*
import PhoneExtension.System.*

public static func SellStreetCredContactHash() -> Int32 = 59911090

//ugly but fast method to map dialog options
enum SellStreetCredMessages {
	MsgGreeting = 0,
	MsgInfo = 1,
	MsgComplaint = 2,
	MsgConfirmSmallTip = 3,
	MsgConfirmLargeTip = 4,
	MsgConcluded = 5,
	MsgStandby = 6,
	ReplyInfo = 7,
	ReplyComplaint = 8,
	ReplyWhatCorpoNonsense = 9,
	ReplySoundsPreem = 10,
	ReplyExplain = 11,
	ReplyAgree = 12,
	ReplySmallTip = 13,
	ReplyLargeTip = 14,
	ReplySmallTipConfirm = 15,
	ReplyLargeTipConfirm = 16,
	ReplyCancel = 17,
	ReplyNotEnoughCred = 18,
 	MAX = 19,
}

public class SellStreetCredPhoneEventsListener extends PhoneEventsListener {
	private let m_player: wref<PlayerPuppet>;
	private let m_messengerController: wref<MessengerDialogViewController>;
	private let m_messageTree: array<CustomMessageEntry>;
	private let m_typingDelay : Float = 2.0;
	
	public func Init(player: ref<PlayerPuppet>) -> Void {
		this.m_player = player;
		ArrayClear(this.m_messageTree);
		ArrayResize(this.m_messageTree, EnumInt(SellStreetCredMessages.MAX));
		// Messages
		this.m_messageTree[EnumInt(SellStreetCredMessages.MsgGreeting)].text = "Welcome to the Eye on the Ground instant messaging service, provided by INFOCOMP. Would you like to submit an intelligence report?\n\nReply INFO for more information.\nReply COMPLAINT to contact our complaints department.";
		this.m_messageTree[EnumInt(SellStreetCredMessages.MsgGreeting)].type = MessageViewType.Received;
		this.m_messageTree[EnumInt(SellStreetCredMessages.MsgInfo)].text = "Eye on the Ground is a revolutionary new public initative developed by the INFOCOMP corporation.\n\nWe are recruiting Night City citizens from all vocations and backgrounds to trade valuable information in return for INSTANT monetary compensation. As a resident of Megabuilding H10, you have been enrolled automatically.\n\nKnow about a deal going down that isn't corp-approved? A neighbour watching illicit XBDs? Mercenary friends involved in unsanctioned subcontracting?\n\nSimply contact this hotline, available 24/7, with any sensitive information you wish to divest.";
		this.m_messageTree[EnumInt(SellStreetCredMessages.MsgInfo)].type = MessageViewType.Received;
		this.m_messageTree[EnumInt(SellStreetCredMessages.MsgComplaint)].text = "[AUTHORIZATION ERROR]\n\nThe complaints helpline is only available for INFOCOMP employees and executive-level partners.\n\nFor any complaints or concerns, we remind you that INFOCOMP is not responsible for any damage to your reputation, property or person as a result of sharing information through this service.";
		this.m_messageTree[EnumInt(SellStreetCredMessages.MsgComplaint)].type = MessageViewType.Received;
		this.m_messageTree[EnumInt(SellStreetCredMessages.MsgConfirmSmallTip)].text = "The calculated compensation for this data is 5000§.\n\nReply PROCEED to confirm transaction.\n\nReply CANCEL to abort.";
		this.m_messageTree[EnumInt(SellStreetCredMessages.MsgConfirmSmallTip)].type = MessageViewType.Received;
		this.m_messageTree[EnumInt(SellStreetCredMessages.MsgConfirmLargeTip)].text = "The calculated compensation for this data is 25000§.\n\nReply PROCEED to confirm transaction.\n\nReply CANCEL to abort.";
		this.m_messageTree[EnumInt(SellStreetCredMessages.MsgConfirmLargeTip)].type = MessageViewType.Received;
		this.m_messageTree[EnumInt(SellStreetCredMessages.MsgConcluded)].text = "Thank you for your report. Funds will be transferred to your account momentarily.\n\nDon't forget - Secrets Hurt Citizens!";
		this.m_messageTree[EnumInt(SellStreetCredMessages.MsgConcluded)].type = MessageViewType.Received;
		this.m_messageTree[EnumInt(SellStreetCredMessages.MsgStandby)].text = "Would you like to submit an intelligence report?\n\nReply INFO for more information.\nReply COMPLAINT to contact our complaints department.";
		this.m_messageTree[EnumInt(SellStreetCredMessages.MsgStandby)].type = MessageViewType.Received;
		// Player replies
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyInfo)].text = "INFO";
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyInfo)].type = MessageViewType.Sent;
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyComplaint)].text = "COMPLAINT";
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyComplaint)].type = MessageViewType.Sent;
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyWhatCorpoNonsense)].text = "What kinda Corpo-rat nonsense is this?";
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyWhatCorpoNonsense)].type = MessageViewType.Sent;
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplySoundsPreem)].text = "Instant compensation? Sounds preem.";
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplySoundsPreem)].type = MessageViewType.Sent;
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyExplain)].text = "People aren't gonna be my biggest fan if I sell their secrets to a megacorp...";
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyExplain)].type = MessageViewType.Sent;
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyAgree)].text = "Sure, I'll trade dirt for eddies. Who cares about rep?";
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyAgree)].type = MessageViewType.Sent;
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplySmallTip)].text = "(-1 Street Cred level) I've got something for you.";
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplySmallTip)].type = MessageViewType.Sent;
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyLargeTip)].text = "(-5 Street Cred levels) I've got something BIG for you.";
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyLargeTip)].type = MessageViewType.Sent;
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplySmallTipConfirm)].text = "PROCEED";
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplySmallTipConfirm)].type = MessageViewType.Sent;
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyLargeTipConfirm)].text = "PROCEED";
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyLargeTipConfirm)].type = MessageViewType.Sent;
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyCancel)].text = "CANCEL";
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyCancel)].type = MessageViewType.Sent;
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyNotEnoughCred)].text = "Guess I should revisit this when I've got a little more street cred...";
		this.m_messageTree[EnumInt(SellStreetCredMessages.ReplyNotEnoughCred)].type = MessageViewType.Sent;
	}

	//contact unique identifier
	public func GetContactHash() -> Int32 = SellStreetCredContactHash();
	
	//contact localized name to display
	public func GetContactLocalizedName() -> String = "INFOCOMP: Eye on the Ground";
	
	public func GetContactData(isText: Bool) -> ref<ContactData> {		
		let contactData: ref<ContactData>;
		contactData = new ContactData();
		contactData.hash = this.GetContactHash();
		contactData.localizedName = this.GetContactLocalizedName();
		contactData.contactId = s"SellStreetCredSystem";
		contactData.id = s"SSCS";
		contactData.avatarID = t"PhoneAvatars.Avatar_Unknown";
		contactData.questRelated = false;
		contactData.isCallable = false;
		if isText { //for text messenger
			contactData.type = MessengerContactType.MultiThread;
			//preview line for text messenger - using greeting line text
			contactData.lastMesssagePreview = this.m_messageTree[EnumInt(SellStreetCredMessages.MsgGreeting)].text;
		} else { //for phone dialer
			contactData.type = MessengerContactType.Contact;
		};
		contactData.messagesCount = 1;
		contactData.unreadMessegeCount = 1;
		ArrayInsert(contactData.unreadMessages, 0, 1);
		contactData.hasMessages = true;
		contactData.playerIsLastSender = false;
		contactData.playerCanReply = true;
		
		return contactData;
	}
	
	public func ShowDialog(messengerController: wref<MessengerDialogViewController>) -> Bool {
		//save controller reference for dialog updates
		this.m_messengerController = messengerController;
		this.PushMessage(EnumInt(SellStreetCredMessages.MsgGreeting), false);
		//scrollbar position
		this.m_messengerController.m_scrollController.SetScrollPosition(1.00);
		return true;
	}

	// Reply Handlers:
	
	public func ActivateReply(messageID: Int32) -> Void {
		this.m_messengerController.ClearRepliesCustom(); //cleanup replies
		this.PushMessage(messageID, false); //last reply becomes last message
		//handle reply actions and build new messages and replies
		if messageID == EnumInt(SellStreetCredMessages.ReplyInfo) {
			this.PushMessage(EnumInt(SellStreetCredMessages.MsgInfo), false);
			return;
		};
		if messageID == EnumInt(SellStreetCredMessages.ReplyComplaint) {
			this.PushMessage(EnumInt(SellStreetCredMessages.MsgComplaint), false);
			return;
		};
		if messageID == EnumInt(SellStreetCredMessages.ReplySmallTip) {
			this.TryPushDelayedMessage(1.0, EnumInt(SellStreetCredMessages.MsgConfirmSmallTip));
			return;
		};
		if messageID == EnumInt(SellStreetCredMessages.ReplyLargeTip) {
			this.TryPushDelayedMessage(1.0, EnumInt(SellStreetCredMessages.MsgConfirmLargeTip));
			return;
		};
		if messageID == EnumInt(SellStreetCredMessages.ReplySmallTipConfirm) {
			this.TryPushDelayedMessage(2.0, EnumInt(SellStreetCredMessages.MsgConcluded));
			this.TransferFundsAndReduceStreetCred(5000, -1);
			return;
		};
		if messageID == EnumInt(SellStreetCredMessages.ReplyLargeTipConfirm) {
			this.TryPushDelayedMessage(2.0, EnumInt(SellStreetCredMessages.MsgConcluded));
			this.TransferFundsAndReduceStreetCred(25000, -5);
			return;
		};
		if 
			messageID == EnumInt(SellStreetCredMessages.ReplyCancel) ||
			messageID == EnumInt(SellStreetCredMessages.ReplyExplain) ||
			messageID == EnumInt(SellStreetCredMessages.ReplyAgree) ||
			messageID == EnumInt(SellStreetCredMessages.ReplyWhatCorpoNonsense) ||
			messageID == EnumInt(SellStreetCredMessages.ReplySoundsPreem)
		{
			this.PushMessage(EnumInt(SellStreetCredMessages.MsgStandby), false);
			return;
		};
	}

	private func TransferFundsAndReduceStreetCred(moneyAward: Int32, streetCredLevelAward: Int32) -> Void {
		let game = this.m_player.GetGame();

		// Award money
		let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(game);
		transactionSystem.GiveItem(this.m_player, MarketSystem.Money(), moneyAward);

		let playerData: ref<PlayerDevelopmentData> = PlayerDevelopmentSystem.GetData(this.m_player);

		// Reduce street cred
		if IsDefined (playerData) {
			let currentStreetCredLevel: Int32 = playerData.GetProficiencyLevel(gamedataProficiencyType.StreetCred);

			if currentStreetCredLevel > 1 {
				let blackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).Get(GetAllBlackboardDefs().UI_PlayerStats);

				if IsDefined (blackboard) {
					let currentStreetCredLevel: Int32 = playerData.GetProficiencyLevel(gamedataProficiencyType.StreetCred);
					let newStreetCredLevel: Int32 = Max(1, currentStreetCredLevel + streetCredLevelAward);

					let streetCredIndex = playerData.GetProficiencyIndexByType(gamedataProficiencyType.StreetCred);

					playerData.SetProficiencyStat(gamedataProficiencyType.StreetCred, newStreetCredLevel);

					if currentStreetCredLevel > 1 {
						playerData.m_proficiencies[streetCredIndex].currentLevel = newStreetCredLevel;
					} else {
						playerData.m_proficiencies[streetCredIndex].currentExp = playerData.m_startingExperience;
					};
					blackboard.SetInt(GetAllBlackboardDefs().UI_PlayerStats.StreetCredLevel, playerData.m_proficiencies[streetCredIndex].currentLevel, false);
					blackboard.SetInt(GetAllBlackboardDefs().UI_PlayerStats.StreetCredPoints, playerData.m_proficiencies[streetCredIndex].currentExp, false);
				};
			};
		};
	};
	
	// Inbox Handlers
	
	private func PushMessage(index: Int32, playSound: Bool) {
		this.m_messengerController.PushMessageCustom(this.m_messageTree[index].text, this.m_messageTree[index].type, this.GetContactLocalizedName(), playSound);
		if 
			index == EnumInt(SellStreetCredMessages.MsgGreeting) ||
			index == EnumInt(SellStreetCredMessages.MsgStandby)
		{
			let playerData: ref<PlayerDevelopmentData> = PlayerDevelopmentSystem.GetData(this.m_player);
			if IsDefined (playerData) {
			let currentStreetCredLevel: Int32 = playerData.GetProficiencyLevel(gamedataProficiencyType.StreetCred);
				if currentStreetCredLevel == 1 {
					this.PushReply(EnumInt(SellStreetCredMessages.ReplyNotEnoughCred), true);
				};
				if currentStreetCredLevel > 1 {
					this.PushReply(EnumInt(SellStreetCredMessages.ReplySmallTip), true);
				};
				if currentStreetCredLevel > 5 {
					this.PushReply(EnumInt(SellStreetCredMessages.ReplyLargeTip), true);
				};
			} else {
				this.PushReply(EnumInt(SellStreetCredMessages.ReplyNotEnoughCred), true);
			};
			this.PushReply(EnumInt(SellStreetCredMessages.ReplyInfo), true);
			this.PushReply(EnumInt(SellStreetCredMessages.ReplyComplaint), true);
			return;
		};
		if index == EnumInt(SellStreetCredMessages.MsgInfo) {
			this.PushReply(EnumInt(SellStreetCredMessages.ReplyWhatCorpoNonsense), true);
			this.PushReply(EnumInt(SellStreetCredMessages.ReplySoundsPreem), true);
			return;
		};
		if index == EnumInt(SellStreetCredMessages.MsgComplaint) {
			this.PushReply(EnumInt(SellStreetCredMessages.ReplyExplain), true);
			this.PushReply(EnumInt(SellStreetCredMessages.ReplyAgree), true);
			return;
		};
		if index == EnumInt(SellStreetCredMessages.MsgConfirmSmallTip) {
			this.PushReply(EnumInt(SellStreetCredMessages.ReplySmallTipConfirm), true);
			this.PushReply(EnumInt(SellStreetCredMessages.ReplyCancel), true);
			return;
		};
		if index == EnumInt(SellStreetCredMessages.MsgConfirmLargeTip) {
			this.PushReply(EnumInt(SellStreetCredMessages.ReplyLargeTipConfirm), true);
			this.PushReply(EnumInt(SellStreetCredMessages.ReplyCancel), true);
			return;
		};
	}
	
	private func PushReply(index: Int32, isSelected: Bool) {
		this.m_messengerController.PushReplyCustom(index, this.m_messageTree[index].text, this.m_messageTree[index].quest, isSelected, this.m_messengerController.m_hasFocus);
	}
	
	//delayed replies with typing animation
	
	private func TryPushDelayedMessage(delay: Float, messageID: Int32) -> Void {
		if !this.PushDelayedMessage(delay, messageID) {
			this.PushMessage(messageID, true);
		};
	}
	
	private func PushDelayedMessage(delay: Float, messageID: Int32) -> Bool {
		if IsDefined(this.m_messengerController.m_delaySystem) && this.m_typingDelay > 0.0 {
			this.m_messengerController.PlayDotsAnimationCustom(this.GetContactLocalizedName());
			this.AddTypingDelay(this.m_messengerController.m_delaySystem, delay, messageID);
			return true;
		} else {
			return false;
		};
	}
	
	private func OnDelayedTypingEnd(messageID: Int32) -> Void {
		this.m_messengerController.StopDotsAnimation();
		this.PushMessage(messageID, true);
	}
}

//add new contact to phone system on initialize

@addField(NewHudPhoneGameController)
private let m_sellStreetCredContact: ref<SellStreetCredPhoneEventsListener>;

@wrapMethod(NewHudPhoneGameController)
protected cb func OnInitialize() -> Bool {
	let ret: Bool = wrappedMethod();
	let syst = PhoneExtensionSystem.GetInstance(this.GetPlayerControlledObject());
	if !IsDefined(this.m_sellStreetCredContact) {
		this.m_sellStreetCredContact = new SellStreetCredPhoneEventsListener();
		this.m_sellStreetCredContact.Init(this.GetPlayerControlledObject() as PlayerPuppet);
	};
	syst.Register(this.m_sellStreetCredContact);
	return ret;
}

@wrapMethod(NewHudPhoneGameController)
protected cb func OnUninitialize() -> Bool {
	let ret: Bool = wrappedMethod();
	let syst = PhoneExtensionSystem.GetInstance(this.GetPlayerControlledObject());
	syst.Unregister(this.m_sellStreetCredContact);
	return ret;
}
