<div class="class=" w-full">
  <h1 class="text-4xl text-gray-900 mt-6">
    <%= @plant.name %>
  </h1>
</div>

<div class="border-t border-gray-200 mt-6">
  <dl>
    <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
      <dt class="text-sm font-medium text-gray-500">
        family
      </dt>
      <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
        <%= @plant.family.name %>
      </dd>
    </div>
  </dl>
  <dl>
    <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
      <dt class="text-sm font-medium text-gray-500">
        Pharmacopoeia
      </dt>
      <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
        <%= @plant.pharmacopoeia %>
      </dd>
    </div>
  </dl>
  <dl>
    <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
      <dt class="text-gray-500">
        Synonym
      </dt>
      <dd class="mt-1 text-gray-900 sm:mt-0 sm:col-span-2">
        <ul class="mt-3 ml-3">
          <%= turbo_frame_tag "name-synonym" do %>
              <!-- add a nes synonym name -->
              <% if @synonym.new_record? %>
                  <%= render "names/form-plant", name: Name.new, plant: @plant, category: "synonym" %>
              <% else %>
                  <%= turbo_frame_tag "name-#{@synonym.id}" do %>
                    <%= render partial: "names/name", locals: { plant: @plant, name: @synonym}%>
                  <% end %>
              <% end %>
            <% end %>
        </ul>
      </dd>
    </div>
  </dl>
  <dl>
    <!--
    <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
      <dt class="text-gray-500">
        Common names
      </dt>
      <dd class="mt-1 text-gray-900 sm:mt-0 sm:col-span-2">
            <%= render "names/form-plant", name: Name.new, plant: @plant, category: "common" %>
            <ul class="mt-3 ml-3">
              <%= turbo_frame_tag "name-common" do %>
                <% @commons.each do |common| %>
                  <%= render partial: "names/name", locals: { plant: @plant, name: common}%>
                <% end %>
              <% end %>
            </ul>
      </dd>
    </div>
  </dl>
  <dl>
    <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
      <dt class="text-sm font-medium text-gray-500">
        Sources
      </dt>
      <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
          <ul class="mt-3 ml-3">
            <% @plant.sources.each do |source| %>
              <li class="text-base ">
                <%= source.title %>
                <small class="text-gray-500">
                   (<% source.people.each do |person| %>
                    <%= person.full_name %>
                  <%end%>)
                </small>
              </li>
            <% end %>
          <ul>
      </dd>
    </div>
  </dl>
</div>
-->
