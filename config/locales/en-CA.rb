{
  :'en-CA' => {
    # Date and Time Formats
    :date => {
      :formats => {
        :default      => "%d/%m/%Y",
        :short        => "%e %b",
        :long         => "%e %B, %Y",
        :long_ordinal => lambda { |date| "#{date.day.ordinalize} %B, %Y" },
        :short_ordinal => lambda { |date| "#{date.day.ordinalize} %B" },
        :only_day     => "%e"
      },
      :day_names => Date::DAYNAMES,
      :abbr_day_names => Date::ABBR_DAYNAMES,
      :month_names => Date::MONTHNAMES,
      :abbr_month_names => Date::ABBR_MONTHNAMES,
      :order => [:year, :month, :day]
    },
    :time => {
      :formats => {
        :default      => "%a %b %d %H:%M:%S %Z %Y",
        :time         => "%H:%M",
        :short        => "%d %b %H:%M",
        :long         => "%d %B, %Y %H:%M",
        :long_ordinal => lambda { |time| "#{time.day.ordinalize} %B, %Y %H:%M" },
        :short_ordinal => lambda { |time| "#{time.day.ordinalize} %B" },
        :only_second  => "%S"
      },
      :datetime => {
        :formats => {
          :default => "%Y-%m-%dT%H:%M:%S%Z"
        }
      },
      :time_with_zone => {
        :formats => {
          :default => lambda { |time| "%Y-%m-%d %H:%M:%S #{time.formatted_offset(false, 'UTC')}" }
        }
      },
      :am => 'am',
      :pm => 'pm'
    },
    :datetime => {
      :distance_in_words => {
        :half_a_minute       => 'half a minute',
        :less_than_x_seconds => {:zero => 'less than a second', :one => 'less than a second', :other => 'less than %{count} seconds'},
        :x_seconds           => {:one => '1 second', :other => '%{count} seconds'},
        :less_than_x_minutes => {:zero => 'less than a minute', :one => 'less than a minute', :other => 'less than %{count} minutes'},
        :x_minutes           => {:one => "1 minute", :other => "%{count} minutes"},
        :about_x_hours       => {:one => 'about 1 hour', :other => 'about %{count} hours'},
        :x_days              => {:one => '1 day', :other => '%{count} days'},
        :about_x_months      => {:one => 'about 1 month', :other => 'about %{count} months'},
        :x_months            => {:one => '1 month', :other => '%{count} months'},
        :about_x_years       => {:one => 'about 1 year', :other => 'about %{count} years'},
        :over_x_years        => {:one => 'over 1 year', :other => 'over %{count} years'}
      }
    },
    :ministry => "Campus for Christ",
    :welcome_letter => %|
    <p>Congratulations!</p>

    <p>Dear Project Participant,</p>

    <p>You are embarking on an incredible adventure! You have accepted the challenge of helping reach the world for Christ by deciding to join other students on a Campus for Christ Summer Project. This could very well be one of the most exciting summers of your life!</p>

    <p>My name is Dorrie Block and I serve as the National Campus Director of Global Impact. Church history is filled with accounts of students taking the Gospel to domestic and foreign fields. You are now taking up the baton to run with passion in making a difference in our world by being Christ's ambassador. The Lord will bless you through your summer project experience and you will be a blessing to others.</p>

    <p>I know it was that way for me when I participated on my first summer mission project Rocky Mountain Project in Calgary, Alberta. This project was my first opportunity to trust God to provide the necessary funding for my participation. Seeing God provide then became the foundation for trusting him for many years as it relates to the financial provision for the ministry to which I've been called.</p>

    <p>As "Christ's ambassador" (2 Corinthians 5:20) you are in a unique position to invite others to partner financially in His cause. As you offer individuals the chance to underwrite your Summer Project expenses, you will be giving them the unparalleled opportunity of investing in eternity (Matthew 6:19-21).</p>

    <p>King David gave Israel such an opportunity when he challenged the people to underwrite the cost of building a temple for the Lord.</p>

    <p>Because David knew that all the world's wealth ultimately belonged to God, he boldly challenged others to channel their resources toward building a physical testimony to the Lord, a temple. As you raise funds for your Summer Project, you will be allowing God to channel the resources of His people toward building a human testimony, a witness for Christ.</p>

    <table style="margin: 5px 0 15px 0; width: 100%; border-top: solid 1px #f0f0e6; border-bottom: solid 1px #f0f0e6; padding: 5px 0;">
    <tr>
    <td style="width: 25%; text-align: center;">1. NAMESTORM</td>
    <td style="width: 25%; text-align: center;">2. WRITE</td>
    <td style="width: 25%; text-align: center;">3. CALL</td>
    <td style="width: 25%; text-align: center;">4. THANK</td>
    </tr>
    </table>

    <p>As you place your trust in God and carefully implement each of these four steps, you will see success!</p>

    <p>I cant even describe how excited I am for you, knowing that your summer will be life-changing. May the Lord bless and keep you as you trust him for things way outside your comfort zone.</p>

    <p>Let His Kingdom come,</p>

    <p>Dorrie Block<br/>
    National Campus Director of Global Impact<br/>
    Campus for Christ, Canada<br/>
    A Division of Power to Change</p>
|,
    :state => "Prov",
    :zip => "PC",
    :help_email => "For help please contact helpdesk@c4c.ca",
    :cheques_payable_to => "Power to Change Ministries",
    :check => "cheque",
    :activerecord => { :attributes => { :mpd_contact => { :zip => 'Postal Code' } } }
  },
}
