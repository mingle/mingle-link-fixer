require_relative '../../lib/mingle/page'
require_relative '../helpers/http_stub'

module Mingle
  describe Page do

    let(:page_xml) { File.read(File.join(__dir__, '..', 'data', 'page.xml')) }
    let(:pages_xml) { File.read(File.join(__dir__, '..', 'data', 'pages.xml')) }
    let(:page) do
      doc = Nokogiri::XML.parse(page_xml)
      Page.new({content: doc.xpath('./page/content').text, identifier: doc.xpath('./page/identifier').text, name: doc.xpath('./page/name').text })
    end

    context "content" do
      it "can be read" do
        expect(page.content).to start_with 'Cornhole'
      end

      it "extracts the html fragment when setting with a full HTML document" do
        page.content = %{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
          <html>
            <body>
              <p>[[Link text|#123/pomeranian.jpg]]</p>
            </body>
          </html>
        }
        expect(without_whitespace(page.content)).to eq %{<p>[[Link text|#123/pomeranian.jpg]]</p>}
      end
    end

    it "knows its identifier" do
      expect(page.identifier).to eq "Example_Page"
    end

    it "knows its name" do
      expect(page.name).to eq "Example Page"
    end

    it "can serialize itself to xml" do
      expect(page.to_xml.strip).to include("<?xml version=\"1.0\"?>\n<page>\n  <content>Cornhole authentic chambray, Williamsburg cred health goth ad consectetur accusamus. Artisan Williamsburg")
    end

    context "with stubbed api" do
      let(:http_client) { HttpStub.new }
      let(:api) { API.new(http_client) }

      before(:each) { Page.api = api }

      describe "#save!" do
        it "persists to mingle" do
          http_client.respond_to('/wiki/Example_Page.xml', with: page_xml)
          page.content = "I have been modified"
          page.save!
          reloaded_page = Page.find_by_identifier(page.identifier)
          expect(reloaded_page.content).to eq page.content
        end
      end

      it "can get all pages for project" do
        http_client.respond_to('/wiki.xml', with: pages_xml)
        pages = Page.all
        expect(pages.size).to eq 2
        expect(pages.first.class).to eq Page
        expect(pages.first.identifier).to eq "Example_Page"
        expect(pages.last.identifier).to eq "Example_Page_2"
      end

    end

    private
    def without_whitespace(string)
      string.gsub("\t", "").gsub("\n", "").strip
    end
  end
end
