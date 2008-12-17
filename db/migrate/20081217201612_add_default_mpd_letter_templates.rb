class AddDefaultMpdLetterTemplates < ActiveRecord::Migration
  def self.up
    unless MpdLetterTemplate.find_by_pdf_preview_filename 'letter_template_1.pdf'
      MpdLetterTemplate.create :name => 'Single Picture Template',
                               :thumbnail_filename => 'letter_template_1.jpg',
                               :pdf_preview_filename => 'letter_template_1.pdf',
                               :description => '',
                               :number_of_images => '1'
    end

    unless MpdLetterTemplate.find_by_pdf_preview_filename 'letter_template_2.pdf'
      MpdLetterTemplate.create :name => 'Multiple Picture Template',
                               :thumbnail_filename => 'letter_template_2.jpg',
                               :pdf_preview_filename => 'letter_template_2.pdf',
                               :description => '',
                               :number_of_images => '2'
    end

  end

  def self.down
    t1 = MpdLetterTemplate.find_by_pdf_preview_filename 'letter_template_1.pdf'
    t1.destroy if t1

    t2 = MpdLetterTemplate.find_by_pdf_preview_filename 'letter_template_2.pdf'
    t2.destroy if t2
  end
end
