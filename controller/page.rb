#--
# Copyright (c) 2008 Ryan Grove <ryan@wonko.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#   * Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#   * Neither the name of this project nor the names of its contributors may be
#     used to endorse or promote products derived from this software without
#     specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#++

class PageController < Ramaze::Controller
  engine :Erubis  
  helper :admin, :cache, :error, :partial
  layout '/layout'
  
  template_root Riposte::Config::CUSTOM_VIEW/:page,
                Riposte::DIR/:view/:page
  
  if Riposte::Config::ENABLE_CACHE
    cache :index, :ttl => 60, :key => lambda { check_auth }
  end
  
  def index(name = nil)
    error_404 unless name && @page = Page[:name => name.strip.downcase]
    @title = @page.title
  end

  def edit(id = nil)
    require_auth

    if @page = Page[id]
      @title       = "Edit page - #{@page.title}"
      @form_action = Rs(:edit, id)
      
      if request.post?
        @page.name  = request[:name]
        @page.title = request[:title]
        @page.body  = request[:body]
        
        if @page.valid? && request[:action] === 'Post'
          begin
            raise unless @page.save
          rescue => e
            @page_error = "There was an error saving your page: #{e}"
          else
            action_cache.clear
            redirect(Rs(@page.name))
          end
        end
      end
    else
      @title       = 'New page - Untitled'
      @page_error  = 'Invalid page id.'
      @form_action = Rs(:new)
    end
  end

  def new
    require_auth
    
    @title       = "New page - Untitled"
    @form_action = Rs(:new)
    
    if request.post?
      @page = Page.new(
        :name  => request[:name],
        :title => request[:title],
        :body  => request[:body]
      )
      
      if @page.valid? && request[:action] === 'Post'
        begin
          raise unless @page.save
        rescue => e
          @page_error = "There was an error saving your page: #{e}"
        else
          action_cache.clear
          redirect(Rs(@page.name))
        end
      end
      
      @title = "New page - #{@page.title}"
    end
  end
end
