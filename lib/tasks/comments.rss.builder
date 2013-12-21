xml.instruct! :xml, version: "1.0"
xml.rss :version => "2.0",
        "xmlns:content" => "http://purl.org/rss/1.0/modules/content/",
        "xmlns:dsq" => "http://www.disqus.com/",
        "xmlns:dc" => "http://purl.org/dc/elements/1.1/",
        "xmlns:wp" => "http://wordpress.org/export/1.0/" do
  xml.channel do
    @data.each do |article, comments|
      xml.item do
        xml.title article.disqus_title
        xml.link "http://#{domain}/artistas/#{article.disqus_identifier}"
        xml.tag!("content:encoded") do |t|
          t.cdata!(article.description)
        end
        xml.tag! "dsq:thread_identifier", article.disqus_identifier
        xml.tag! "wp:post_date_gmt", gmt(article.date + 19.hours)
        xml.tag! "wp:comment_status", "open"
        comments.each do |comment|
          xml.tag! "wp:comment" do
            xml.tag! "wp:comment_id", comment['com_ID']
            xml.tag! "wp:comment_author", comment['Name']
            xml.tag! "wp:comment_author_email", comment['Email']
            xml.tag! "wp:comment_date_gmt", gmt(comment['CommentaryDate'])
            xml.tag!("wp:comment_content") { |t| t.cdata!(comment['Text']) }
            xml.tag! "wp:comment_approved", comment['Status'] == 2 ? "1" : "0"
            xml.tag! "wp:comment_parent", "0"
          end
        end
      end
    end
  end
end
