//
//  HandTests.m
//  GoFishModel
//
//  Created by Greg Tarsa on 1/24/14.
//  Copyright (c) 2014 Greg Tarsa. All rights reserved.
//

#import "Kiwi.h"
#import "FishCard.h"
#import "FishDeck.h"
#import "FishHand.h"

SPEC_BEGIN(HandTests)

describe(@"GoFish Model", ^{
    __block FishDeck *deck;
    __block FishHand *hand;
    __block FishCard *card;
    
    it(@".new: creates an empty hand",^{
        hand = [FishHand new];
        [[hand should] beKindOfClass:[FishHand class]];
    });
    
    it(@".numberOfCards: shows the size of the hand", ^{
        hand = [FishHand new];
        [[[hand numberOfCards] should] equal:@0];
    });
    
    context(@"Given a number of sample cards from NSString rank/suit names", ^{
        beforeEach(^{ // Occurs before each enclosed "it"
            deck = [FishDeck newWithCards];
            hand = [FishHand new];
        });
        
        it(@".receiveCard: receives one card into a hand", ^{
            card = [deck giveCard];
            [hand receiveCard:card];
            [[[hand numberOfCards] should] equal:@1];
            [[[deck numberOfCards] should] equal:@51];
        });
        
        it(@".receiveCards: can receive one card into a hand", ^{
            card = [deck giveCard];
            [hand receiveCards: [NSMutableArray arrayWithObjects:card, nil]];
            [[[hand numberOfCards] should] equal:@1];
            [[[deck numberOfCards] should] equal:@51];
        });
        
        it(@".receiveCards: also receives multiple cards into a hand", ^{
            int startingCount = [[hand numberOfCards] intValue];
            for (int i = 0; i < 7; i++) {
                card = [deck giveCard];
                [hand receiveCards: [NSMutableArray arrayWithObjects:card, nil]];
            }
            [[[hand numberOfCards] should] equal:theValue(startingCount + 7)];
        });
    });
    
    
    context(@"Given a hand of 4 of a kind (and 0 or more  other cards).", ^{
        beforeEach(^{
            deck = [FishDeck newWithCards];
            hand = [FishHand new];
            [hand receiveCards:[NSMutableArray arrayWithObjects:
                                [FishCard newWithRank:@"5" suit:@"C"],
                                [FishCard newWithRank:@"5" suit:@"H"],
                                [FishCard newWithRank:@"5" suit:@"S"],
                                [FishCard newWithRank:@"5" suit:@"D"],
                                [FishCard newWithRank:@"10" suit:@"H"],
                                [FishCard newWithRank:@"J" suit:@"H"],
                                [FishCard newWithRank:@"K" suit:@"H"],
                                nil]];
        });
        
        it(@".rankCount: returns the count for a given rank", ^{
            
            [[[hand rankCount:@"5"] should] equal:@4];
            [[[hand rankCount:@"J"] should] equal:@1];
            [[[hand rankCount:@"10"] should] equal:@1];
            [[[hand rankCount:@"A"] should] equal:@0];
        });
        
        it(@".gotBook: returns YES when is sees for of the target in the hand", ^{
            [[theValue([hand gotBook:@"5"]) should] equal:@(YES)];
        });
        
        it(@".giveMatchingCards: returns array of matched cards that are removed from hand", ^{
            NSMutableArray *cards = [hand giveMatchingCards:@"5"];
            [[theValue([cards count]) should] equal:@4];
        });
        
        it(@".giveMatchingCards: also removes the given cards from hand", ^{
            [[[hand rankCount:@"10"] should] equal:@1];
            NSMutableArray *cards = [hand giveMatchingCards:@"10"];
            [[theValue([cards count]) should] equal:@1];
            [[[hand rankCount:@"10"] should] equal:@0];
        });
    });
    
    context(@"given a hand of cards", ^{
        beforeEach(^{
            hand = [FishHand new];
            [hand receiveCards:[NSMutableArray arrayWithObjects:
                                [FishCard newWithRank:@"9" suit:@"C"],
                                [FishCard newWithRank:@"6" suit:@"H"],
                                [FishCard newWithRank:@"10" suit:@"H"],
                                [FishCard newWithRank:@"2" suit:@"H"],
                                nil]];
        });
        
        it(@".sort: sorts a hand", ^{
            [hand sort];
            [[[hand description] should] equal:@"[2-H 6-H 9-C 10-H]"];
        });
        
        it(@"description: returns a string representation of the card", ^{
            NSString *string = [hand description];
            [[string should] equal:@"[9-C 6-H 10-H 2-H]"];
        });
    }); // end context
    
});

SPEC_END
