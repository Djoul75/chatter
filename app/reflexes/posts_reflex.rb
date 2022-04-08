# frozen_string_literal: true

class PostsReflex < ApplicationReflex
  # include CableReady::Broadcaster
  def react
    post = Post.find(element.dataset[:id])
    emoji = element.dataset[:emoji]
    post_find = Reaction.find_by(post: post, user: current_user, emoji: emoji)
    if post_find
      post_find.destroy
    else
      reaction = Reaction.new
      reaction.post = post
      reaction.user = current_user
      reaction.emoji = emoji
      reaction.save!
    end
    cable_ready["timeline"].text_content(
      selector: "[id='post-#{post.id}-#{emoji}']",
      text: post.reactions.where(emoji: emoji).size
    ).broadcast
    # cable_ready["timeline"].text_content(
    #   selector: "post-#{post.id}-smile",
    #   text: post.reactions.where(emoji: emoji).size
    # ).broadcast
    # cable_ready.broadcast
  end
end
