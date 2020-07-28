require 'spec_helper'
require 'pry'
describe Kristin do

  before(:all) do
    @one_page_pdf = file_path("one.pdf")
    @multi_page_pdf = file_path("multi.pdf")
    @no_pdf = file_path("image.png")
    @large_pdf = file_path("large.pdf")
    @target_path = "#{Dir::tmpdir}"
    @target_path[0] = ""
    @target_file = @target_path + "/output.html"
    @fast_opts = { process_outline: false, vdpi: 1, hdpi: 1, first_page: 1, last_page: 1 }
  end

  before(:each) do
    FileUtils.mkdir_p @target_path
  end

  after(:each) do
    FileUtils.rm_rf @target_path
  end

  describe "#convert" do
    describe "with no options" do
      it "should raise error if source file does not exists" do
        c = Kristin::Converter.new("nonsense.pdf", "nonsense.html")
        lambda { c.convert }.should raise_error(IOError)
      end

      it "should convert a one page pdf to one html file" do
        Kristin::Converter.new(@one_page_pdf, @target_file, @fast_opts).convert
        File.exists?(@target_file).should == true
      end

      it "should convert a multi page pdf to one html file" do
        Kristin::Converter.new(@multi_page_pdf, @target_file, @fast_opts).convert
        File.exists?(@target_file).should == true
      end

      it "should raise error if pdf is not a real pdf" do
        lambda { Kristin::Converter.new(@no_pdf, "nonsense.html").convert }.should raise_error(IOError)
      end

      it "should convert a pdf from an URL" do
        url = "http://kristin-test.s3.amazonaws.com/one.pdf"
        Kristin::Converter.new(url, @target_file, @fast_opts).convert
        File.exists?(@target_file).should == true
      end

      it "should raise an error if URL does not exist" do
        url = "http://kristin-test.s3.amazonaws.com/image.png"
        lambda { Kristin::Converter.new(url, @target_file).convert }.should raise_error(IOError)
      end

      it "should raise an error if URL file is not a real pdf" do
        url = "http://kristin-test.s3.amazonaws.com/image.png"
        lambda { Kristin::Converter.new(url, @target_file).convert }.should raise_error(IOError)
      end
    end

    describe "options" do
      it "should be possible to disable sidebar" do
        Kristin::Converter.new(@large_pdf, @target_file, { process_outline: false }).convert
        doc = Nokogiri::HTML(File.open(@target_file))
        el = doc.css("#sidebar").first
        el.children.first.text.strip.should be_empty
      end

      it "should be possible to specify first page" do
        Kristin::Converter.new(@multi_page_pdf, @target_file, { first_page: 2 }).convert
        doc = Nokogiri::HTML(File.open(@target_file))
        doc.css("#pf1").should be_empty
        doc.css("#pf2").should_not be_empty
      end

      it "should be possible to specify last page" do
        Kristin::Converter.new(@multi_page_pdf, @target_file, { last_page: 9 }).convert
        doc = Nokogiri::HTML(File.open(@target_file))
        doc.css("#pf1").should_not be_empty
        doc.css("#pf10").should be_empty
      end

      it "should be possible to specify hdpi and vdpi" do
        Kristin::Converter.new(@one_page_pdf, @target_file, { hdpi: 0, vdpi: 0 }).convert
        doc = IO.read(@target_file)
        doc.should include("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAACXBIWXMAAAAAAAAAAAHqZRakAAAADElEQVQI12M4dugAAASaAkndTfHQAAAAAElFTkSuQmCC")
      end

      it "should be possible to specify zoom ratio" do
        Kristin::Converter.new(@one_page_pdf, @target_file, { zoom: 2.0 }).convert
        doc = IO.read(@target_file)
        doc.should include("2.000000")
      end

      it "should be possible to specify fit_width and fit_height" do
        Kristin::Converter.new(@one_page_pdf, @target_file, { fit_width: 1024, fit_height: 1024 }).convert
        doc = IO.read(@target_file)
        doc.should include("1.293109")
      end

      it "should be possible to specify data_dir" do
        Kristin::Converter.new(@one_page_pdf, @target_file, { data_dir: 'spec/fixtures/data_dir' }).convert
        doc = IO.read(@target_file)
        doc.should include("DATA_DIR_WORKS")
      end

      it "should be possible to specify split_pages" do
        Kristin::Converter.new(@multi_page_pdf, @target_file, { split_pages: true }).convert
        doc = IO.read(@target_file)
        doc.should include("data-page-no=\"5\" data-page-url=\"multi5.page\"")
        (1..10).each { |num| FileUtils.rm "multi#{num}.page" }
      end
    end
  end

  describe ".convert" do
    it "should convert without options" do
      Kristin.convert(@one_page_pdf, @target_file)
      File.exists?(@target_file).should == true
    end

    it "should convert with options" do
      Kristin.convert(@one_page_pdf, @target_file, { hdpi: 1, vdpi: 1 })
      File.exists?(@target_file).should == true
    end
  end
end
