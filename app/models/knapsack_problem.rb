class KnapsackProblem < ActiveRecord::Base
	serialize :items, Array # do this bc can't migrate an array as a model attribute, so we migrated as text, then serialized.
end
