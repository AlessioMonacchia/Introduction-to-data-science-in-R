# CHAPTER 12 - PROBABILITY----
# 13.2 Monte Carlo Simulations for Categorical Data----
beads <- rep(c("red", "blue"), times = c(2, 3))

sample(beads, 1) # sample n random elements from a vector

B <- 10000
events <- replicate(B, sample(beads, 1)) # we repeat the random sampling 10000 times. An example of Monte Carlo Simulation!

tab <- table(events) # creates a table with the absolute number of occurrences of an event
tab

prop.table(tab) # creates the probability distribution table

set.seed(1995) # assures random functions returns always same results
events <- sample(beads, B, replace = T) # performs 10000 samplings with replacement
prop.table(table(events))

# 13.6 Combinations and Permutation----
suits <- c("Diamonds", "Clubs", "Hearths", "Spades")
numbers <- c("Ace", "Deuce", "Three", "Four", "Five", "Six", "Seven", "Height", "Nine", "Ten", "Jack", "Queen", "King")
deck <- expand.grid(number=numbers, suit = suits) # creates a vector of strings with all possible combinations of elements of two or more vectors
deck <- paste(deck$number, deck$suit) # creates strings by joining smaller strings

kings <- paste("King", suits)
mean(deck %in% kings) # calculate the proportion of kings in the deck

install.packages("gtools")
library(gtools)
permutations(3, 2)

all_phone_numbers <- permutations(10, 7, v = 0:9)
n <- nrow(all_phone_numbers)
index <- sample(n, 5)
all_phone_numbers[index,]


hands <- permutations(52, 2, v = deck) # computes all possible ways we can choose 2 cards when the order matters

first_card <- hands[,1] # gets all first cards
second_card <- hands[,2] # gets all second cards

kings <- paste("King", suits)
sum(first_card %in% kings) # returns number of times a king was the first card

sum(first_card%in%kings & second_card%in%kings) / sum(first_card%in%kings) # conditional probability of getting a king when first card was a king


combinations(3,2) # same as permutations but in this case the order DOES NOT matter

aces <- paste("Ace", suits)

facecard <- c("King", "Queen", "Jack", "Ten")
facecard <- expand.grid(number = facecard, suit = suits)
facecard <- paste(facecard$number, facecard$suit)

hands <- combinations(52, 2, v = deck)
mean(hands[,1] %in% aces & hands[,2] %in% facecard) # calculates the proportion/prob of getting a 21 in Blackjack = drawing a ace and a figure


hand <- sample(deck, 2)
hand

(hands[1] %in% aces & hands[2] %in% facecard) | (hands[2] %in% aces & hands[1] %in% facecard)

blackjack <- function(){
  hand <- sample(deck, 2)
  (hand[1] %in% aces & hand[2] %in% facecard) |
    (hand[2] %in% aces & hand[1] %in% facecard)
}

blackjack()

B <- 10000
results <- replicate(B, blackjack())
mean(results) # returns the mean of Ts that equals the proportion of natural 21s happened in the 10000 blackjack games simulated



# 13.7 Examples----
