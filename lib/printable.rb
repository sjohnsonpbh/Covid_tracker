module Printable
    module Format
        def text_to_integer(text)
            text.gsub(/[\s,]/, "").to_i
        end
    end
end