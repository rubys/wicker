require_relative 'spec_helper'

feature "post model" do
  it "should parse a post" do
    mtime, post = Post.find '2014/12/12/twelve'
    expect(mtime.localtime.strftime('%H:%M:%S')).to eq('12:12:12')
    expect(post.title).to eq('Twelve')
    expect(post.slug).to eq('twelve')
    expect(post.link).to eq('2014/12/12/twelve')
    expect(post.excerpt).to eq("<p>twelve twelve twelve</p>\n")
    expect(post.icon).to include("'CIRCLED NUMBER TWELVE' (U+246B)-->")
    expect(post.icon).to include('viewBox="0 0 100 100"')
    expect(post.icon(0.4)).to include("width='40'")
    expect(post.body).to eq("<p>#{(%w(twelve)*12).join(' ')}</p>")
    expect(post.fragment).to be(nil)
  end

  it "should parse a comment" do
    mtime, post = Post.find '2014/12/12/twelve'
    comment = post.comments.max_by {|comment| comment.mtime}
    expect(comment.mtime.localtime.strftime('%H:%M:%S')).to eq('00:12:12')
    expect(comment.title).to eq('Twelve')
    expect(comment.slug).to eq('twelve')
    expect(comment.link).to eq('2014/12/13/twelve')
    expect(comment.excerpt).to be(nil)
    expect(comment.icon).to be(nil)
    expect(comment.body).to include("<p>twelve</p>")
    expect(comment.body).to match(/<a.*>nobody<\/a>/)
    expect(comment.fragment).to eq('c1418447532')
  end
end
