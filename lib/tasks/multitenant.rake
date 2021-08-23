# frozen_string_literal: true

namespace :orgs do
  # WARNING: Do not execute this task on the server!!!!!
  # It is meant to be executed locally, in a developer's machine. After downloading the database and public/uploads to the local environment.
  #
  # Example:
  #
  # <code>
  # # in the server
  # pg_dump -h localhost -U postgres_username --no-owner database_name > tmp/20210211_codit-multitenant.sql
  # zip -r tmp/20210211_codit-multitenant_uploads.zip public/uploads
  #
  # # download the database and the attachments to your local project
  # scp codit@codit_multitenant_server.net:/path/to/decidim/app/current/tmp/20210211_codit-multitenant.sql tmp/20210211_codit-multitenant.sql
  # scp codit@codit_multitenant_server.net:/path/to/decidim/app/current/tmp/20210211_codit-multitenant_uploads.zip tmp/20210211_codit-multitenant_uploads.zip
  #
  # # unzip attachments locally
  # cd public
  # unzip ../tmp/20210211_codit-multitenant_uploads.zip
  #
  # # from your psql
  # postgres=# CREATE DATABASE "decidim_multitenant" WITH ENCODING='UTF8';
  # psql -U postgres_username decidim_multitenant < tmp/20210211_codit-multitenant.sql
  # </code>
  #
  # At this point you have all the contents from the server (from all organizations) in your local clone of the project.
  # Now, you can execute this tasks to remove all the contents from other organizations than the one you want to keep.
  #
  # WARNING: this script is incomplete. Resources are scarce and we've only taken into account the models that we needed.
  #
  # So the script should be reviewed when using it again.
  # A good way to review it is to dump your local database and `less` it searching for "/-- Data for Name". This will lead you to all the data for each table.
  # You then manually check table by table if the contents are right.
  # Special care must be taken with personal data.
  #
  desc "Clean all db contents (and attachments) except for the given organization"
  # Images and attachments are automatically removed when destroying its respective models.
  # Do not use `delete`. Use always `destroy` to be sure all attachments and associated models are destroyed in cascade.
  task :keep_only_org, [:org_id] => [:environment] do |_task, args|
    locale = I18n.locale.to_s
    puts "Showing info with locale: #{locale}"

    org_id = args.org_id
    puts "Saving Org ID: #{org_id}... cleaning all other organizations data"

    organizations_to_clean = Decidim::Organization.where.not(id: org_id)
    organizations_to_clean.each do |org|
      puts ">> Removing Org #{org.id} - #{org.host} - #{org.name}"
      # clean admin logs with delete_all to skip before_destroy callback
      Decidim::ActionLog.where(organization: org).delete_all
      Decidim::ContentBlock.where(organization: org).destroy_all
      Decidim::ContextualHelpSection.where(organization: org).destroy_all
      # clean static pages with delete_all to skip before_destroy callback
      Decidim::StaticPage.where(organization: org).delete_all
      Decidim::Metric.where(organization: org).delete_all

      # ParticipatoryProcesses
      processes_to_clean = Decidim::ParticipatoryProcess.where(organization: org).load
      puts "* Cleaning processes..."
      processes_to_clean.each do |process|
        # ParticipatoryProcessSteps have dependent: destroy
        # endorsements have dependent: destroy
        clean_space(process)
        Decidim::ParticipatoryProcessUserRole.where(participatory_process: process).destroy_all
        process.destroy!
      end
      Decidim::ParticipatoryProcessGroup.where(organization: org).each do |process_group|
        clean_resource_links(process_group)
        clean_resource_permissions(process_group)
        process_group.destroy!
      end

      # Assemblies
      assemblies_to_clean = Decidim::Assembly.where(organization: org).load
      puts "* Cleaning assemblies..."
      assemblies_to_clean.each do |assembly|
        clean_space(assembly)
        Decidim::AssemblyMember.where(assembly: assembly).destroy_all
        Decidim::AssemblyUserRole.where(assembly: assembly).destroy_all
        assembly.destroy!
      end
      Decidim::AssembliesType.where(organization: org).destroy_all
      Decidim::AssembliesSetting.where(organization: org).destroy_all

      # TODO: initiatives
      Decidim::InitiativesType.where(organization: org).destroy_all

      # Conferences
      conferences_to_clean = Decidim::Conference.where(organization: org).load
      puts "* Cleaning conferences..."
      conferences_to_clean.each do |conference|
        clean_space(conference)
        # dependent: :destroy: speakers, partners, conference_registrations, conference_invites, media_links, registration_types
        conference.registration_types.each do |registration_type|
          registration_type.conference_meetings.each do |meeting|
            destroy_meeting_resource(meeting)
          end
        end
        Decidim::ConferenceUserRole.where(conference: conference).destroy_all
        conference.destroy!
      end

      # Consultations
      consultations_to_clean = Decidim::Consultation.where(organization: org).load
      puts "* Cleaning consultations..."
      consultations_to_clean.each do |consultation|
        clean_resource_links(consultation)
        clean_resource_permissions(consultation)
        # dependent: :destroy: questions, votes, responses, response_groups, categories
        consultation.questions.each do |question|
          clean_space(question)
          clean_comments_from(question)
          clean_follows(question)
          question.destroy!
        end
        consultation.destroy!
      end

      puts "* Cleaning newsletters..."
      Decidim::Newsletter.where(organization: org).destroy_all

      puts "* Cleaning users..."
      org_users = Decidim::User.where(organization: org)
      Decidim::Authorization.where(user: org_users).destroy_all
      Decidim::ImpersonationLog.where(user: org_users).destroy_all
      clean_messages_and_conversations(org_users)
      Decidim::Notification.where(user: org_users).destroy_all
      Decidim::Gamification::BadgeScore.where(user: org_users).destroy_all
      org_users.destroy_all
      org_user_groups = Decidim::UserGroup.where(organization: org)
      clean_messages_and_conversations(org_user_groups)
      Decidim::Notification.where(user: org_user_groups).destroy_all
      Decidim::Gamification::BadgeScore.where(user: org_user_groups).destroy_all
      org_user_groups.destroy_all

      Decidim::Scope.where(organization: org).destroy_all
      Decidim::ScopeType.where(organization: org).destroy_all
      Decidim::Area.where(organization: org).destroy_all
      Decidim::AreaType.where(organization: org).destroy_all

      puts "* Cleaning verifications..."
      # irb(main):005:0> Decidim::Verifications::CsvDatum.count
      # => 0
      Decidim::Verifications::CsvEmail::CsvEmailDatum.where(organization: org).destroy_all
      Decidim::FileAuthorizationHandler::CensusDatum.where(organization: org).destroy_all
      # Term customizer
      puts "* Cleaning term customizer..."
      translation_sets = Decidim::TermCustomizer::Constraint.where(organization: org).collect(&:translation_set)
      translation_sets.flatten.each(&:destroy!) # constraints and translations are dependant: :destroy
      puts "* Remove Orphan comments"
      Decidim::Comments::Comment.find_each { |comment| comment.destroy! unless comment.author }

      begin
        org.destroy!
      rescue StandardError => e
        # byebug
        puts "Error message: #{e.message}"
        puts "Record errors: #{e&.record&.errors}"
        puts "Error backtrace: #{e.backtrace.join("\n")}"
      end
    end
    puts "Remove Orphan proposals"
    Decidim::Proposals::Proposal.find_each { |proposal| clean_proposal(proposal) unless proposal.component }
    Decidim::Proposals::ParticipatoryText.find_each { |text| text.destroy! unless text.component }
    puts "Remove Orphan budgets child models"
    Decidim::Budgets::Project.find_each { |project| clean_project(project) unless project.budget }
    Decidim::Budgets::Order.find_each { |order| order.destroy! unless order.budget }
    puts "Remove Orphan debates"
    Decidim::Debates::Debate.find_each { |debate| clean_debate(debate) unless debate.component }
    puts "Remove Orphan surveys"
    Decidim::Surveys::Survey.find_each { |survey| clean_survey(survey) unless survey.component }
    puts "Remove Orphan meetings"
    Decidim::Meetings::Meeting.find_each { |meeting| destroy_meeting_resource(meeting) unless meeting.component }
    puts "Remove Orphan follows"
    Decidim::Follow.find_each { |follow| follow.destroy! unless follow.user }

    puts "Remove Orphan attachments"
    Decidim::Attachment.find_each do |attachment|
      attachment.destroy! unless attachment.attached_to
    end
    puts "Remove PaperTrail versions"
    PaperTrail::Version.find_each do |version|
      version.destroy! unless version.item
    end
    puts "Remove DelayedJobs"
    Delayed::Job.destroy_all
    puts "Remove System Admins"
    Decidim::System::Admin.destroy_all
  end

  # rubocop: disable Metrics/CyclomaticComplexity
  def clean_space(space)
    puts "cleaning space: #{[space.id, space.class.name, space.title[I18n.locale.to_s]]}"
    Decidim::Category.where(participatory_space: space).destroy_all
    clean_resource_links(space)
    clean_resource_permissions(space)

    space.components.each do |component|
      puts "cleaning #{component.manifest_name} component: #{component.id} from organization #{component.organization.id}"
      case component.manifest_name
      when "surveys"
        clean_surveys(component)
      when "accountability"
        clean_accountability(component)
      when "pages"
        clean_pages(component)
      when "meetings"
        clean_meetings(component)
      when "debates"
        clean_debates(component)
      when "budgets"
        clean_budgets(component)
      when "proposals"
        clean_proposals(component)
      when "sortitions"
        clean_sortitions(component)
      else
        raise "Cleaning for #{component.manifest_name} components is not implemented!"
      end
    end
  end
  # rubocop: enable Metrics/CyclomaticComplexity

  def clean_accountability(component)
    statuses = Decidim::Accountability::Status.where(component: component)
    statuses.each do |status|
      status.results.each do |result|
        clean_resource_links(result)
        clean_resource_permissions(result)
        clean_comments_from(result)
        # decidim_accountability_timeline_entries are dependent: :destroy
        result.destroy!
      end
      status.destroy!
    end
    puts "destroying accountability component #{component.id}: #{component.destroy!}"
  end

  def clean_budgets(component)
    budgets = Decidim::Budgets::Budget.where(component: component)
    budgets.each do |budget|
      clean_budget(budget)
    end
    puts "destroying budgets component #{component.id}: #{component.destroy!}"
  end

  def clean_budget(budget)
    clean_resource_links(budget)
    clean_resource_permissions(budget)
    clean_comments_from(budget)
    clean_moderations_from(budget)
    clean_follows(budget)
    budget.projects.each do |project|
      clean_project(project)
    end
    # projects and orders are dependent: destroy
    budget.destroy!
  end

  def clean_project(project)
    clean_resource_links(project)
    clean_comments_from(project)
    project.destroy!
  end

  def clean_debates(component)
    debates = Decidim::Debates::Debate.where(component: component)
    debates.find_each { |debate| clean_debate(debate) }
    puts "destroying debates component #{component.id}: #{component.destroy!}"
  end

  def clean_debate(debate)
    clean_resource_links(debate)
    clean_resource_permissions(debate)
    clean_comments_from(debate)
    clean_moderations_from(debate)
    clean_follows(debate)
    debate.destroy!
  end

  def clean_meetings(component)
    meetings = Decidim::Meetings::Meeting.where(component: component)
    meetings.each do |meeting|
      destroy_meeting_resource(meeting)
    end
    puts "destroying meetings component #{component.id}: #{component.destroy!}"
  end

  def destroy_meeting_resource(meeting)
    clean_resource_links(meeting)
    clean_resource_permissions(meeting)
    clean_comments_from(meeting)
    clean_moderations_from(meeting)
    clean_follows(meeting)
    meeting.questionnaire&.destroy!
    # decidim_meetings_invites has dependent: destroy
    # decidim_meetings_agendas has dependent: destroy
    # decidim_meetings_agenda_items has dependent: destroy
    # decidim_meetings_minutes has dependent: destroy
    # decidim_meetings_registrations has dependent: destroy
    # decidim_meetings_services has dependent: destroy
    meeting.destroy!
  end

  def clean_pages(component)
    pages = Decidim::Pages::Page.where(component: component)
    pages.each do |page|
      clean_resource_links(page)
      clean_resource_permissions(page)
      page.destroy!
    end
    puts "destroying pages component #{component.id}: #{component.destroy!}"
  end

  def clean_proposals(component)
    Decidim::Proposals::ParticipatoryText.where(component: component).destroy_all

    collaborative_drafts = Decidim::Proposals::CollaborativeDraft.where(component: component)
    collaborative_drafts.each do |draft|
      # coauthorships has dependent: destroy
      # collaborator_requests has dependent: :destroy
      clean_comments_from(draft)
      clean_resource_links(draft)
      clean_resource_permissions(draft)
      clean_follows(draft)
      draft.destroy!
    end

    proposals = Decidim::Proposals::CollaborativeDraft.where(component: component)
    proposals.each { |proposal| clean_proposal(proposal) }

    puts "destroying proposals component #{component.id}: #{component.destroy!}"
  end

  def clean_proposal(proposal)
    # coauthorships has dependent: destroy
    # decidim_proposals_proposal_notes has dependent: destroy
    # decidim_proposals_proposal_votes  has dependent: destroy
    clean_comments_from(proposal)
    clean_resource_links(proposal)
    clean_resource_permissions(proposal)
    clean_moderations_from(proposal)
    clean_follows(proposal)
    Decidim::Proposals::ValuationAssignment.where(proposal: proposal).destroy_all
    proposal.destroy!
  end

  def clean_sortitions(component)
    sortitions = Decidim::Sortitions::Sortition.where(component: component)
    sortitions.each do |sortition|
      clean_comments_from(sortition)
      clean_resource_links(sortition)
      clean_resource_permissions(sortition)
      sortition.destroy!
    end
    puts "destroying sortitions component #{component.id}: #{component.destroy!}"
  end

  # decidim_forms_questionnaires -> dependant quesitons and answers destroy
  # decidim_forms_questions -> all dependant destroy
  # answers -> dependant AnswerChoice destroy
  def clean_surveys(component)
    surveys = Decidim::Surveys::Survey.where(component: component)
    surveys.each { |survey| clean_survey(survey) }
    puts "destroying surveys component #{component.id}: #{component.destroy!}"
  end

  def clean_survey(survey)
    questionnaire = Decidim::Forms::Questionnaire.find_by(questionnaire_for: survey)
    questionnaire.destroy!
    clean_resource_links(survey)
    clean_resource_permissions(survey)
    clean_follows(survey)
    survey.destroy!
  end

  def clean_comments_from(commentable)
    Decidim::Comments::Comment.where(root_commentable: commentable).find_each do |comment|
      clean_moderations_from(comment)
      comment.delete
    end
    # Decidim::Comments::Comment.where(commentable: commentable).find_each {|comment| clean_moderations_from(comment); comment.destroy!}
  end

  def clean_moderations_from(reportable)
    Decidim::Moderation.where(reportable: reportable).destroy_all
  end

  # clears both incoming and outgoing links
  def clean_resource_links(resource)
    # outgoing
    Decidim::ResourceLink.where(from: resource).destroy_all
    # incoming
    Decidim::ResourceLink.where(to: resource).destroy_all
  end

  def clean_resource_permissions(resource)
    Decidim::ResourcePermission.where(resource: resource).destroy_all
  end

  def clean_follows(followable)
    Decidim::Follow.where(followable: followable).destroy_all
  end

  # Accepts either a list of Decidim::User or Decidim::UserGroup
  # conversation.participations are depdendent: :destroy
  # message.receipts are depdendent: :destroy
  def clean_messages_and_conversations(org_user_base_entities)
    Decidim::Messaging::Message.where(sender: org_user_base_entities).find_each do |msg|
      msg.conversation&.destroy!
      msg.destroy
    end
  end
end
