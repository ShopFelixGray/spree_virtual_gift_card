module Spree
    module Stock
      module Splitter
        class VirtualGiftCard < Base
          def split(packages)
            split_packages = []
            packages.each do |package|
              split_packages += split_by_gift_card(package)
            end
            return_next split_packages
          end
  
          private
          def split_by_gift_card(package)
            gift_cards = Hash.new { |hash, key| hash[key] = [] }
            package.contents.each do |item|
                gift_cards[item.variant.gift_card?] << item
            end
            hash_to_packages(gift_cards)
          end
  
          def hash_to_packages(gift_cards)
            packages = []
            gift_cards.each do |id, contents|
              packages << build_package(contents)
            end
            packages
          end
        end
      end
    end
  end