# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Provisions the first admin from ENV vars, so credentials never land in source control.
# Usage: ADMIN_EMAIL=you@example.com ADMIN_PASSWORD=changeme bin/rails db:seed
if (email = ENV["ADMIN_EMAIL"]) && (password = ENV["ADMIN_PASSWORD"])
  admin = Admin.find_or_initialize_by(email: email)
  admin.password = password
  admin.save!
  puts "Admin account ready: #{email}"
else
  puts "Skipping admin seed — set ADMIN_EMAIL and ADMIN_PASSWORD to create/update one."
end

# Demo guides with placeholder images, just to preview the how-to layout.
# Safe to re-run — skips any guide that already exists.
def seed_guide(slug:, title:, description:, image_filename:, steps:)
  if Guide.exists?(slug: slug)
    puts "Skipping demo guide — '#{title}' already exists."
    return
  end

  image_path = Rails.root.join("app/assets/images/#{image_filename}")

  guide = Guide.new(
    title: title,
    description: description,
    published: true,
    steps_attributes: steps
  )

  guide.image.attach(io: File.open(image_path), filename: "#{slug}-cover.jpg", content_type: "image/jpeg")
  guide.save!

  guide.steps.each_with_index do |step, index|
    step.image.attach(io: File.open(image_path), filename: "step-#{index + 1}.jpg", content_type: "image/jpeg")
  end

  puts "Demo guide ready: #{title} (#{guide.steps.count} steps)"
end

seed_guide(
  slug: "how-to-boil-water",
  title: "How to Boil Water",
  description: "Boiling water is one of the most fundamental cooking skills. " \
    "Follow these steps to get a perfect rolling boil every time.",
  image_filename: "guide_placeholder.jpg",
  steps: [
    { title: "Fill a pot with water", content: "Choose a pot that fits how much water you need, and fill it about two-thirds full with a kitchen faucet or filtered water." },
    { title: "Place the pot on the stove", content: "Set the pot on a burner that matches its size and make sure it's centered for even heating." },
    { title: "Turn the heat to high", content: "Turn the dial to high heat. Covering the pot with a lid traps steam and helps it boil faster." },
    { title: "Wait for a rolling boil", content: "Watch for big, rapid bubbles breaking the surface continuously — that's a rolling boil, not just a simmer." },
    { title: "Turn off the heat", content: "Once it's boiling, turn off the burner (or reduce the heat) as needed for whatever you're cooking." }
  ]
)

seed_guide(
  slug: "how-to-fold-a-paper-crane",
  title: "How to Fold a Paper Crane",
  description: "The origami crane is a classic symbol of peace and good luck. " \
    "All you need is a single square sheet of paper and a few careful folds.",
  image_filename: "example.jpg",
  steps: [
    { title: "Start with a square sheet", content: "Place your paper color-side down on a flat surface, oriented like a diamond in front of you." },
    { title: "Fold the diagonals", content: "Fold the paper in half corner to corner, unfold, then fold corner to corner the other way and unfold, leaving an X-shaped crease." },
    { title: "Collapse into a square base", content: "Turn the paper color-side up and fold it in half to form a triangle, unfold, then fold in half the other way. Bring the sides together to collapse it into a smaller square." },
    { title: "Fold and unfold the kite shapes", content: "On the top layer, fold both outer edges in to meet the center line, then unfold to leave crease marks. Repeat on the back." },
    { title: "Petal fold to make the neck and tail", content: "Lift the bottom point up along the creases, using the crease marks to flatten the sides inward. Repeat on the back so you have two long points." },
    { title: "Shape the head and wings", content: "Fold one point's tip down to form the head, then gently pull the wings apart and curve them outward until the crane stands on its own." }
  ]
)

seed_guide(
  slug: "how-to-tie-a-bowline-knot",
  title: "How to Tie a Bowline Knot",
  description: "The bowline forms a secure loop that won't slip or bind under load, " \
    "yet unties easily even after being pulled tight. A must-know knot for sailing, climbing, or camping.",
  image_filename: "guide_placeholder.jpg",
  steps: [
    { title: "Make a small loop", content: "Form a small loop in the rope a short distance from the end — this becomes the 'rabbit hole' the working end passes through." },
    { title: "Bring the working end up through the loop", content: "Picture the working end as a rabbit coming up out of its hole, through the small loop from behind." },
    { title: "Wrap around the standing line", content: "The 'rabbit' goes around the standing part of the rope (the tree trunk), circling all the way around." },
    { title: "Send it back down the hole", content: "Feed the working end back down through the small loop it originally came out of, following the rabbit back into its hole." },
    { title: "Tighten the knot", content: "Hold the loop steady and pull the standing line and working end apart to cinch the knot snug." }
  ]
)

seed_guide(
  slug: "how-to-brew-pour-over-coffee",
  title: "How to Brew Pour-Over Coffee",
  description: "Pour-over brewing gives you full control over extraction for a clean, " \
    "flavorful cup. It just takes a filter, a kettle, and a little patience.",
  image_filename: "example.jpg",
  steps: [
    { title: "Rinse the filter", content: "Place a paper filter in the dripper and rinse it with hot water to remove papery taste and preheat the vessel." },
    { title: "Add ground coffee", content: "Add medium-fine ground coffee to the filter, roughly 1 gram of coffee for every 16 grams of water." },
    { title: "Bloom the grounds", content: "Pour just enough hot water (around 200°F) to saturate the grounds and let it sit for 30-45 seconds while it releases gas." },
    { title: "Pour in slow circles", content: "Continue pouring in slow, steady circles from the center outward, keeping the water level consistent." },
    { title: "Let it drain and serve", content: "Once all the water has passed through, remove the dripper and enjoy your coffee while it's hot." }
  ]
)

seed_guide(
  slug: "how-to-change-a-bike-tire",
  title: "How to Change a Bike Tire",
  description: "A flat tire doesn't have to end your ride. With a spare tube and a few tools, " \
    "you can get back on the road in about ten minutes.",
  image_filename: "guide_placeholder.jpg",
  steps: [
    { title: "Remove the wheel", content: "Open the brake if needed, release the quick-release or axle nuts, and take the wheel off the frame or fork." },
    { title: "Deflate and remove the old tube", content: "Let out any remaining air, use tire levers to pry one side of the tire off the rim, and pull out the punctured tube." },
    { title: "Check the tire for debris", content: "Run a finger carefully along the inside of the tire to feel for the thorn, glass, or debris that caused the flat, and remove it." },
    { title: "Insert the new tube", content: "Partially inflate the new tube so it holds its shape, tuck it inside the tire, and seat the valve through the rim hole." },
    { title: "Reseat the tire and inflate", content: "Push the tire bead back onto the rim by hand, check that the tube isn't pinched anywhere, then inflate to the recommended pressure." },
    { title: "Reinstall the wheel", content: "Put the wheel back on the bike, close the quick-release or tighten the axle nuts, and reset the brake." }
  ]
)

seed_guide(
  slug: "how-to-do-a-handstand",
  title: "How to Do a Handstand",
  description: "A freestanding handstand builds incredible body awareness and shoulder strength. " \
    "Start against a wall and work your way up to balancing on your own.",
  image_filename: "example.jpg",
  steps: [
    { title: "Warm up your wrists and shoulders", content: "Do wrist circles, wrist stretches, and shoulder rolls to prepare your joints for bearing your full body weight." },
    { title: "Practice against a wall", content: "Face away from a wall, walk your feet up it until your body forms a straight line, and get comfortable being upside down." },
    { title: "Find your stacked alignment", content: "Press firmly through your fingertips, engage your core, and stack your shoulders, hips, and ankles in one vertical line." },
    { title: "Kick up with control", content: "Move to open floor and practice kicking up one leg at a time, using a soft, controlled kick rather than a jump." },
    { title: "Balance and hold", content: "Make small adjustments with your fingers to stay balanced, and focus on a fixed point on the floor to hold the position longer." }
  ]
)

# Demo blog posts with placeholder images, just to preview the blog layout.
# Safe to re-run — skips any post that already exists.
def seed_post(slug:, title:, body:, image_filename:)
  if Post.exists?(slug: slug)
    puts "Skipping demo post — '#{title}' already exists."
    return
  end

  image_path = Rails.root.join("app/assets/images/#{image_filename}")

  post = Post.new(title: title, body: body, published: true)
  post.image.attach(io: File.open(image_path), filename: "#{slug}-cover.jpg", content_type: "image/jpeg")
  post.save!

  puts "Demo post ready: #{title}"
end

seed_post(
  slug: "the-case-for-taking-the-long-way-home",
  title: "The Case for Taking the Long Way Home",
  body: "Every so often I skip the highway and take the back roads instead, even when it adds twenty " \
    "minutes to the drive. There's something about the extra time that resets my head in a way the " \
    "fast route never does.\n\n" \
    "It's not really about the scenery, though the scenery helps. It's that a longer drive forces a " \
    "kind of idle thinking you can't get anywhere else — no podcast, no phone, just the road and " \
    "whatever your brain wants to chew on. Half my best ideas this year showed up somewhere between " \
    "two stoplights I didn't need to hit.\n\n" \
    "So if you're ever debating the quick way versus the long way, and you're not actually in a hurry, " \
    "take the long way. You'll get where you're going eventually, and you might figure something out " \
    "along the way.",
  image_filename: "road.jpg"
)

seed_post(
  slug: "why-i-started-timing-my-coffee-instead-of-my-work",
  title: "Why I Started Timing My Coffee Instead of My Work",
  body: "I used to run a timer for focused work blocks — twenty-five minutes on, five off, the usual. " \
    "It worked fine, but it also made every break feel like it was borrowed time I owed back to the " \
    "timer. So I flipped it: now I only time the coffee.\n\n" \
    "The rule is simple. I make a cup, and however long it takes to drink it while it's actually hot, " \
    "that's my break. No phone, no scrolling, just the cup. When it's empty or lukewarm, I'm back at " \
    "the desk. It turns out that's usually somewhere between eight and twelve minutes, which is close " \
    "enough to what a 'real' break should be, except it doesn't feel like a countdown.\n\n" \
    "It's a small trick, but it changed how breaks feel. A timer measures how much time you're allowed. " \
    "A cup of coffee just tells you when it's done, and somehow that's easier to listen to.",
  image_filename: "gray.jpeg"
)

seed_post(
  slug: "a-short-defense-of-boring-weekends",
  title: "A Short Defense of Boring Weekends",
  body: "For a while I treated every free Saturday like it needed a plan — a hike, an event, a trip " \
    "somewhere, anything to make it count. Eventually I noticed the weekends I actually looked forward " \
    "to all week were the boring ones: laundry, a long lunch, nothing on the calendar.\n\n" \
    "There's a difference between a boring weekend and a wasted one, though it took me a while to see " \
    "it. A wasted weekend is one you don't remember choosing. A boring weekend is one where you " \
    "deliberately chose to do less, and that choice is doing a lot of the work — it's rest you picked " \
    "on purpose, not rest you defaulted into because you ran out of energy for anything else.\n\n" \
    "So now I try to leave at least one weekend a month completely unplanned, on purpose. It's not " \
    "laziness, it's maintenance. Everything else in life runs better after it.",
  image_filename: "road.jpg"
)
