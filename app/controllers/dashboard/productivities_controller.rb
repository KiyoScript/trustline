# app/controllers/dashboard/productivities_controller.rb
class Dashboard::ProductivitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @period = params[:period] || "month"

    @agents = case @period
    when "week"  then week_data
    when "month" then month_data
    when "quarter" then quarter_data
    else month_data
    end

    @top_producer = @agents.max_by { |a| a[:score] } if @agents.any?
  end

  private

  def month_data
    [
      { name: "Demo User",      score: 50, added: 6,  removed: 1, net: 5,  fwd: 6, calls: 4, proposals: 1, won: 1, activities: 10 },
      { name: "Taylor Brooks",  score: 25, added: 2,  removed: 0, net: 2,  fwd: 3, calls: 3, proposals: 1, won: 0, activities: 4  },
      { name: "Jordan Mitchell", score: 23, added: 2,  removed: 1, net: 1,  fwd: 3, calls: 1, proposals: 0, won: 1, activities: 4  },
      { name: "Cymon Trillana", score: 9,  added: 0,  removed: 0, net: 0,  fwd: 4, calls: 0, proposals: 0, won: 0, activities: 1  },
      { name: "Alex Rivera",    score: 3,  added: 1,  removed: 0, net: 1,  fwd: 1, calls: 0, proposals: 0, won: 0, activities: 1  },
      { name: "Casey Nguyen",   score: 1,  added: 1,  removed: 0, net: 1,  fwd: 0, calls: 0, proposals: 0, won: 0, activities: 1  },
      { name: "Ken Enecio",     score: 0,  added: 0,  removed: 3, net: -3, fwd: 0, calls: 0, proposals: 0, won: 0, activities: 0  }
    ]
  end

  def week_data
    [] # No data for this week yet
  end

  def quarter_data
    [
      { name: "Demo User",      score: 50, added: 6,  removed: 1, net: 5,  fwd: 6, calls: 4, proposals: 1, won: 1, activities: 10 },
      { name: "Taylor Brooks",  score: 25, added: 2,  removed: 0, net: 2,  fwd: 3, calls: 3, proposals: 1, won: 0, activities: 4  },
      { name: "Jordan Mitchell", score: 23, added: 2,  removed: 1, net: 1,  fwd: 3, calls: 1, proposals: 0, won: 1, activities: 4  },
      { name: "Cymon Trillana", score: 9,  added: 0,  removed: 0, net: 0,  fwd: 4, calls: 0, proposals: 0, won: 0, activities: 1  },
      { name: "Alex Rivera",    score: 3,  added: 1,  removed: 0, net: 1,  fwd: 1, calls: 0, proposals: 0, won: 0, activities: 1  },
      { name: "Casey Nguyen",   score: 1,  added: 1,  removed: 0, net: 1,  fwd: 0, calls: 0, proposals: 0, won: 0, activities: 1  },
      { name: "Ken Enecio",     score: 0,  added: 0,  removed: 3, net: -3, fwd: 0, calls: 0, proposals: 0, won: 0, activities: 0  }
    ]
  end
end
