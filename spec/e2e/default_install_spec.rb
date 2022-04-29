require 'spec_helper_e2e'

describe 'Default install' do
  def browser
    @browser ||= new_browser
  end

  before(:all) do
    upload_portal_config('empty.yml')
    update_ood_portal
    restart_apache
  end

  describe file(host_portal_config) do
    it { is_expected.to be_file }
    expected = File.expand_path("#{__dir__}/../../ood-portal-generator/spec/fixtures/ood-portal.conf.default")
    its(:content) { is_expected.to eq(File.read(expected)) }
  end

  describe 'default webpage' do
    it 'redirects from root'
      browser.goto '/'
      auth_docs = 'https://osc.github.io/ood-documentation/latest/authentication.html'

      expect(browser.url).to eq("#{ctr_base_url}/public/need_auth.html")
      expect(browser.heading(text: 'Welcome to Open OnDemand!').present?).to be true
      expect(browser.anchor(text: 'the authentication documentation', href: auth_docs).present?).to be true
      expect(browser.anchor(text: 'Go to Documentation', href: auth_docs).present?).to be true
    end
  end

end