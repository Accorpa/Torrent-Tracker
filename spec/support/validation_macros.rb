module ValidationMacros
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def it_should_require(*attributes)
      attributes.each do |attribute|
        it "should require the #{attribute} attribute" do
          self.described_class.new(@valid_attributes.with_indifferent_access.except(attribute)).should_not be_valid
        end
      end
    end
  end
end
