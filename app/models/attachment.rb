class Attachment < ApplicationRecord

  has_attached_file :media,
                    :url => "/attachments/:id/:style:basename.:extension",
                    :path => ":rails_root/public/attachments/:id/:style/:basename.:extension",
                    styles: lambda { |a| a.instance.check_file_type },
                    processors: lambda {
                        |a| a.is_powerpoint? ? [:ppt_thumbnail] : [:thumbnail]
                    }

  validates_attachment_content_type :media, :content_type => ["application/pdf", /\Aimage\/.*\Z/,
                                                                   "application/x-ole-storage",
                                                                   "application/vnd.ms-powerpoint",
                                                                   "application/vnd.openxmlformats-officedocument.presentationml.presentation"]

  def is_image?
    self.media_content_type =~ %r(image)
  end

  def is_powerpoint?
    self.media_file_name =~ %r{\.(pptx|ppt|potx|pot|ppsx|pps|pptm|potm|ppsm|ppam)$}i
  end

  def is_pdf?
    self.media_file_name =~ %r{\.(pdf)$}i
  end


  def check_file_type
    if self.is_image?
      {
          :preview => "500x500>"
      }
    elsif self.is_pdf?
      {
          :preview => ["500x500>", :jpeg]
      }
    elsif self.is_powerpoint?
      {
          :preview => ["500x500>", :jpeg]
      }
    else
      {}
    end
  end

end
