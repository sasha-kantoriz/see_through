require 'rest-client'
require 'digest'
require 'time_difference'
require 'logger'
require_relative 'octokit_client'
require_relative 'main_controller'
require_relative 'config/config_reader'
require_relative 'slack_client'

class ActivityChecker
  def initialize
    @config_reader = Config_reader.new
    @conf = @config_reader.get_activity_checker_configuration
    @repos = @config_reader.get_repos
    @controller = MainController.new
    @client = OctokitClient.new
    @slack_client = SlackClient.new
    @logger = Logger.new('../see_through.log')
    @token = ENV['SEE_THROUGH_TOKEN']
  end

  def check_activity
    @logger.info('activity checker start')
    
    @config_reader.get_users_from_config_yml.each do |user|
      @controller.sync_user_with_config user
    end

    @repos.each do |repository|
      current_time = Time.now.utc
      repo = repository.repository_name
      prs = @client.get_all_github_pr(repo)
      prs.each do |pr|

        pr_labels = get_pr_labels(repo, pr[:number])

        has_label_for_ignoring = false
        pr_labels.each do |label|
          if @conf[:labels].include? label
            has_label_for_ignoring = true
            break
          end
        end
        if has_label_for_ignoring
          next
        end

        pr_github_diff_sha = get_pr_diff_sha(repo, pr)
        db_pr = @controller.get_pr_by_id(pr.number).first

        if !db_pr
          @controller.create_or_update_pr(pr, repo)
          db_pr = @controller.get_pr_by_id(pr.number).first
        end

        if !db_pr[:diff_sha]
          pr_diff_updated = pr.updated_at
        else
          pr_diff_updated = current_time
        end
        
        if !db_pr[:diff_sha] or db_pr[:diff_sha] != pr_github_diff_sha
          @controller.update_pr_diff_sha(db_pr.pr_id, pr_github_diff_sha, pr_diff_updated)
        else
          days_without_diff_update = TimeDifference.between(db_pr[:diff_updated], current_time).in_days.to_i
          if days_without_diff_update >= @conf[:timeout]
            pr_notificants = @conf[:recipients].to_set
            user = @controller.get_user_by_login(db_pr[:author])
            if user and user[:enable]
              pr_notificants << user[:slack_id]
            end
            pr_notificants.each do |receiver|
              create_slack_notification_on_outdated_pr(repo, db_pr, days_without_diff_update, receiver)
            end
          end
        end
      end
    end
    @logger.info('activity checker end')
  end

  def get_pr_diff_sha(repo, pr)  
    diff = RestClient.get("https://#{@token}:x-oauth-basic@api.github.com/repos/#{repo}/pulls/#{pr.number}.diff", 
                          {
                            :accept => 'application/vnd.github.diff'
                          })
    Digest::SHA1.hexdigest(diff.body)
  end

  def get_pr_labels(repo, number)
    pr_labels = CLIENT.issue(repo, number)[:labels]
    labels = pr_labels.map {|label| label[:name]}
    labels
  end

  def create_slack_notification_on_outdated_pr(repo, pr, days_without_update, recipient)
    attachments = [{
                       fallback: "Outdated Pull Request",
                       title: "##{pr.pr_id} - #{pr.title}",
                       title_link: "https://github.com/#{repo}/pull/#{pr.pr_id}/",
                       text: "This pull request hasn't been updated for #{days_without_update} days.",
                       mrkdwn_in: [
                           "text",
                           "pretext"]
                   }]
    @slack_client.send_message(attachments, recipient)
  end

end

ActivityChecker.new.check_activity
