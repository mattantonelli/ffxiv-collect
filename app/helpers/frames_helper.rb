module FramesHelper
  def frame_contents_icon(frame)
    fa_icon(frame.portrait_only ? 'portrait' : 'image')
  end
end
