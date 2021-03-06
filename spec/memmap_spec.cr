require "./spec_helper"

describe Memmap do
  it "maps a read-only file" do
    File.write("test.txt", "here are a bunch of bytes for you to eat")

    file = Memmap::MapFile.new("test.txt")
    file_string = String.new(file.value)
    file_string.should eq "here are a bunch of bytes for you to eat"

    File.delete("test.txt")
  end

  it "maps a file and shifts every byte up by 1" do
    File.write("test.txt", "here are a bunch of bytes again")

    file = Memmap::MapFile.new("test.txt", mode="r+")
    file.value.map! { |v| v + 1 }
    file.flush()
    file.close()

    File.read("test.txt").should eq "ifsf!bsf!b!cvodi!pg!czuft!bhbjo"
    File.delete("test.txt")
  end

  it "maps a file and appends to it by writing to a new file" do
    File.write("test.txt", "here are a bunch of bytes yet again")

    file = Memmap::MapFile.new("test.txt")
    appendix = Slice(UInt8).new(4, 33)
    file.write("test2.txt", appendix)

    File.read("test2.txt").should eq "here are a bunch of bytes yet again!!!!"
    File.delete("test2.txt")
  end
end
